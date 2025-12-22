# Интеграция — Supabase

## Обзор

Supabase — backend платформа для fenta-web. Предоставляет:
- PostgreSQL база данных
- Аутентификация
- Storage (файловое хранилище)
- Edge Functions
- Realtime subscriptions

---

## Компоненты

### 1. PostgreSQL Database

Основная база данных приложения.

**Особенности:**
- Row Level Security (RLS)
- Партиционирование таблиц
- Materialized Views
- Функции и триггеры

### 2. Supabase Auth

Управление пользователями и сессиями.

**Поддерживаемые методы:**
- Email/Password
- Magic Link
- OAuth (Google, GitHub, etc.)
- SSO (Enterprise)

### 3. Supabase Storage

Хранение медиа-файлов.

**Buckets:**
| Bucket | Назначение | Доступ |
|--------|------------|--------|
| `uploads` | Загрузки пользователей | Private |
| `renders` | Готовые видео | Private |
| `thumbnails` | Превью | Public |
| `effects` | Эффекты | Public |

### 4. Realtime

WebSocket подписки для обновлений в реальном времени.

**Используется для:**
- Статус job
- Прогресс рендера
- Уведомления

---

## Конфигурация

### Environment Variables

```env
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
```

### Client Setup

```typescript
// lib/supabase/client.ts
import { createBrowserClient } from '@supabase/ssr'

export function createClient() {
  return createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  )
}
```

### Server Setup

```typescript
// lib/supabase/server.ts
import { createServerClient } from '@supabase/ssr'
import { cookies } from 'next/headers'

export async function createClient() {
  const cookieStore = await cookies()

  return createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return cookieStore.getAll()
        },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value, options }) =>
            cookieStore.set(name, value, options)
          )
        },
      },
    }
  )
}
```

---

## Аутентификация

### Sign Up

```typescript
const { data, error } = await supabase.auth.signUp({
  email: 'user@example.com',
  password: 'password123',
  options: {
    data: {
      full_name: 'John Doe'
    }
  }
})
```

### Sign In

```typescript
const { data, error } = await supabase.auth.signInWithPassword({
  email: 'user@example.com',
  password: 'password123'
})
```

### OAuth

```typescript
const { data, error } = await supabase.auth.signInWithOAuth({
  provider: 'google',
  options: {
    redirectTo: 'https://app.fenta.com/auth/callback'
  }
})
```

### Get Session

```typescript
const { data: { session } } = await supabase.auth.getSession()
```

---

## Database Operations

### Select

```typescript
const { data, error } = await supabase
  .from('workflows')
  .select('*')
  .eq('org_id', orgId)
  .order('created_at', { ascending: false })
```

### Insert

```typescript
const { data, error } = await supabase
  .from('jobs')
  .insert({
    org_id: orgId,
    workflow_id: workflowId,
    config: jobConfig,
    status: 'queued'
  })
  .select()
  .single()
```

### Update

```typescript
const { data, error } = await supabase
  .from('jobs')
  .update({
    status: 'completed',
    progress: 100,
    completed_at: new Date().toISOString()
  })
  .eq('id', jobId)
```

### Delete

```typescript
const { error } = await supabase
  .from('assets')
  .delete()
  .eq('id', assetId)
```

---

## Storage Operations

### Upload

```typescript
const { data, error } = await supabase.storage
  .from('uploads')
  .upload(`${orgId}/${filename}`, file, {
    contentType: file.type,
    upsert: false
  })
```

### Download

```typescript
const { data, error } = await supabase.storage
  .from('renders')
  .download(`${jobId}/video.mp4`)
```

### Get Public URL

```typescript
const { data } = supabase.storage
  .from('thumbnails')
  .getPublicUrl(`${jobId}/thumb.jpg`)
```

### Create Signed URL

```typescript
const { data, error } = await supabase.storage
  .from('renders')
  .createSignedUrl(`${jobId}/video.mp4`, 3600) // 1 hour
```

---

## Realtime Subscriptions

### Subscribe to Job Updates

```typescript
const channel = supabase
  .channel('job-updates')
  .on(
    'postgres_changes',
    {
      event: 'UPDATE',
      schema: 'public',
      table: 'jobs',
      filter: `id=eq.${jobId}`
    },
    (payload) => {
      console.log('Job updated:', payload.new)
      setJobStatus(payload.new.status)
      setProgress(payload.new.progress)
    }
  )
  .subscribe()

// Cleanup
return () => {
  supabase.removeChannel(channel)
}
```

---

## Row Level Security

### Пример политик

```sql
-- Пользователи видят только свои организации
CREATE POLICY "Users see own org"
  ON workflows FOR SELECT
  USING (
    org_id IN (
      SELECT org_id FROM org_members
      WHERE user_id = auth.uid()
    )
  );

-- Editors могут создавать
CREATE POLICY "Editors can create"
  ON workflows FOR INSERT
  WITH CHECK (
    org_id IN (
      SELECT org_id FROM org_members
      WHERE user_id = auth.uid()
      AND role IN ('owner', 'admin', 'editor')
    )
  );
```

---

## Edge Functions

Serverless функции для:
- Webhook обработка
- Scheduled jobs
- Background processing

### Пример

```typescript
// supabase/functions/process-callback/index.ts
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

serve(async (req) => {
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  )

  const payload = await req.json()

  // Process callback...

  return new Response(JSON.stringify({ success: true }), {
    headers: { 'Content-Type': 'application/json' }
  })
})
```

---

## Best Practices

### 1. Используйте RLS

Всегда включайте Row Level Security для таблиц с пользовательскими данными.

### 2. Service Role только на сервере

Никогда не используйте service role key на клиенте.

### 3. Индексы

Создавайте индексы для часто используемых фильтров.

### 4. Realtime разумно

Подписывайтесь только на нужные данные, отписывайтесь при unmount.

### 5. Storage policies

Настройте bucket policies для контроля доступа к файлам.
