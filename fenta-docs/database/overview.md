# База данных — Обзор

## Supabase PostgreSQL

**Почему Supabase:**
- Managed PostgreSQL
- Built-in Auth
- Storage для медиа
- Realtime subscriptions
- Row Level Security
- Edge Functions

---

## Соглашения

### Primary Keys
UUID с префиксом для читаемости:
- `user_abc123`
- `org_xyz789`
- `wf_def456`
- `tmpl_ghi012`
- `job_jkl345`
- `asset_mno678`

### Timestamps
Все таблицы содержат:
- `created_at TIMESTAMPTZ DEFAULT NOW()`
- `updated_at TIMESTAMPTZ DEFAULT NOW()`

### Soft Deletes
Критические таблицы используют `deleted_at` вместо физического удаления.

### JSONB
Для гибких/динамических данных:
- `spec` — спецификация template
- `graph` — граф workflow
- `metadata` — дополнительные данные
- `config` — конфигурация job

---

## Схема сущностей

```
┌─────────────────────────────────────────────────────────────┐
│                         users                               │
│                    (via Supabase Auth)                      │
└────────────────────────────┬────────────────────────────────┘
                             │
              ┌──────────────┼──────────────┐
              ▼              ▼              ▼
        ┌──────────┐   ┌──────────┐   ┌──────────┐
        │   orgs   │   │ api_keys │   │ profiles │
        └────┬─────┘   └──────────┘   └──────────┘
             │
   ┌─────────┼─────────┬─────────┬─────────┐
   ▼         ▼         ▼         ▼         ▼
┌──────┐ ┌──────┐ ┌────────┐ ┌──────┐ ┌────────────┐
│projects│templates│workflows│assets│ │integrations│
└──┬───┘ └──┬───┘ └───┬────┘ └──┬──┘ └────────────┘
   │        │         │         │
   │        │    ┌────┴────┐    │
   │        │    ▼         ▼    │
   │        │ ┌──────┐ ┌──────┐ │
   │        │ │nodes │ │edges │ │
   │        │ └──────┘ └──────┘ │
   │        │         │         │
   └────────┴─────────┼─────────┘
                      ▼
              ┌──────────────┐
              │     jobs     │
              └──────┬───────┘
                     │
        ┌────────────┼────────────┐
        ▼            ▼            ▼
  ┌──────────┐ ┌──────────┐ ┌──────────┐
  │ renders  │ │ job_logs │ │schedules │
  └──────────┘ └──────────┘ └──────────┘
```

---

## Группы таблиц

### 1. Users & Orgs
Пользователи, организации, роли, API ключи.
→ `database/users.md`

### 2. Content
Шаблоны, workflows, ассеты.
→ `database/content.md`

### 3. Jobs & Renders
Задачи рендера, результаты, расписания.
→ `database/jobs.md`

### 4. Billing
Использование, квоты, счета.
→ `database/billing.md`

---

## Индексы

### Стандартные
- Все foreign keys
- `status` колонки
- `created_at` для сортировки

### Partial
```sql
-- Только активные записи
CREATE INDEX idx_workflows_active ON workflows(org_id)
  WHERE deleted_at IS NULL;
```

### GIN для JSONB
```sql
CREATE INDEX idx_workflows_graph ON workflows USING gin(graph);
CREATE INDEX idx_templates_spec ON templates USING gin(spec);
```

---

## Partitioning

Большие таблицы партиционируются по дате:

```sql
-- usage_records партиционируется по месяцам
CREATE TABLE usage_records (
  ...
) PARTITION BY RANGE (created_at);

CREATE TABLE usage_records_2024_01 PARTITION OF usage_records
  FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');
```

Партиционируемые таблицы:
- `usage_records` — ежемесячно
- `audit_logs` — ежемесячно
- `job_logs` — опционально

---

## Миграции

Supabase CLI для миграций:

```bash
# Создать миграцию
supabase migration new add_feature_name

# Применить локально
supabase db reset

# Применить на продакшн
supabase db push
```
