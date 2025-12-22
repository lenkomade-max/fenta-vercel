# База данных — Users & Organizations

## profiles

Расширение Supabase Auth users.

```sql
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT,
  avatar_url TEXT,
  role TEXT DEFAULT 'user', -- user, admin
  status TEXT DEFAULT 'active', -- active, suspended
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Индексы
CREATE INDEX idx_profiles_status ON profiles(status);

-- Триггер для автосоздания профиля
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO profiles (id, name)
  VALUES (NEW.id, NEW.raw_user_meta_data->>'name');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();
```

**Пример:**
```json
{
  "id": "uuid",
  "name": "John Doe",
  "avatar_url": "https://...",
  "role": "user",
  "metadata": {
    "onboarding_completed": true,
    "preferences": {
      "theme": "dark",
      "language": "ru"
    }
  }
}
```

---

## orgs

Организации для мультитенанси.

```sql
CREATE TABLE orgs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  owner_id UUID NOT NULL REFERENCES auth.users(id),

  -- Billing
  plan TEXT DEFAULT 'free', -- free, starter, pro, enterprise
  plan_started_at TIMESTAMPTZ,
  billing_email TEXT,
  stripe_customer_id TEXT,

  -- Settings
  settings JSONB DEFAULT '{}',

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  deleted_at TIMESTAMPTZ
);

-- Индексы
CREATE INDEX idx_orgs_owner ON orgs(owner_id);
CREATE INDEX idx_orgs_slug ON orgs(slug) WHERE deleted_at IS NULL;
CREATE INDEX idx_orgs_plan ON orgs(plan);
```

**Пример:**
```json
{
  "id": "org_xyz789",
  "name": "Acme Studios",
  "slug": "acme-studios",
  "owner_id": "user_abc123",
  "plan": "pro",
  "settings": {
    "default_aspect": "9:16",
    "default_quality": "1080p",
    "brand_colors": ["#FF6B6B", "#4ECDC4"],
    "default_voice": "af_heart"
  }
}
```

---

## org_members

Связь пользователей с организациями.

```sql
CREATE TABLE org_members (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID NOT NULL REFERENCES orgs(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  role TEXT NOT NULL, -- owner, admin, editor, viewer
  invited_by UUID REFERENCES auth.users(id),
  joined_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(org_id, user_id)
);

-- Индексы
CREATE INDEX idx_org_members_org ON org_members(org_id);
CREATE INDEX idx_org_members_user ON org_members(user_id);
CREATE INDEX idx_org_members_role ON org_members(role);
```

**Роли:**
| Role | Permissions |
|------|-------------|
| `owner` | Всё + удаление org + биллинг |
| `admin` | Всё кроме биллинга |
| `editor` | Создание/редактирование контента |
| `viewer` | Только просмотр |

---

## api_keys

Personal Access Tokens для API.

```sql
CREATE TABLE api_keys (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  org_id UUID REFERENCES orgs(id) ON DELETE CASCADE,

  name TEXT NOT NULL,
  key_hash TEXT UNIQUE NOT NULL, -- bcrypt hash
  key_prefix TEXT NOT NULL, -- первые 8 символов для идентификации

  scopes JSONB DEFAULT '[]', -- ["workflows:read", "jobs:execute"]

  last_used_at TIMESTAMPTZ,
  expires_at TIMESTAMPTZ,
  revoked_at TIMESTAMPTZ,

  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Индексы
CREATE INDEX idx_api_keys_user ON api_keys(user_id);
CREATE INDEX idx_api_keys_org ON api_keys(org_id);
CREATE INDEX idx_api_keys_hash ON api_keys(key_hash) WHERE revoked_at IS NULL;
```

**Scopes:**
- `workflows:read` — чтение workflows
- `workflows:write` — создание/редактирование workflows
- `jobs:read` — чтение jobs
- `jobs:execute` — запуск jobs
- `assets:read` — чтение assets
- `assets:write` — загрузка assets
- `billing:read` — чтение биллинга

---

## projects

Группировка ресурсов внутри организации.

```sql
CREATE TABLE projects (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID NOT NULL REFERENCES orgs(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  settings JSONB DEFAULT '{}',
  created_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  deleted_at TIMESTAMPTZ
);

-- Индексы
CREATE INDEX idx_projects_org ON projects(org_id);
```

---

## RLS Policies

```sql
-- profiles: пользователь видит только свой профиль
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own profile"
  ON profiles FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  USING (auth.uid() = id);

-- orgs: только члены видят организацию
ALTER TABLE orgs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Org members can view org"
  ON orgs FOR SELECT
  USING (
    id IN (
      SELECT org_id FROM org_members
      WHERE user_id = auth.uid()
    )
  );

-- org_members: видят членов своей организации
ALTER TABLE org_members ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Members can view org members"
  ON org_members FOR SELECT
  USING (
    org_id IN (
      SELECT org_id FROM org_members
      WHERE user_id = auth.uid()
    )
  );
```
