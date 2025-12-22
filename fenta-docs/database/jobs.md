# База данных — Jobs, Renders, Schedules

## jobs

Задачи рендера видео.

```sql
CREATE TABLE jobs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID NOT NULL REFERENCES orgs(id) ON DELETE CASCADE,
  project_id UUID REFERENCES projects(id) ON DELETE SET NULL,
  workflow_id UUID REFERENCES workflows(id) ON DELETE SET NULL,
  template_id UUID REFERENCES templates(id) ON DELETE SET NULL,

  -- Status
  status TEXT DEFAULT 'queued', -- queued, processing, completed, failed, cancelled
  progress INTEGER DEFAULT 0, -- 0-100

  -- Configuration
  config JSONB NOT NULL,

  -- Results
  result JSONB,

  -- Error info
  error JSONB,

  -- Cost tracking
  cost_tokens INTEGER DEFAULT 0,
  cost_render_seconds DECIMAL(10, 2) DEFAULT 0,
  cost_kai_credits INTEGER DEFAULT 0,
  cost_total_usd DECIMAL(10, 4) DEFAULT 0,

  -- Timing
  queued_at TIMESTAMPTZ DEFAULT NOW(),
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,

  -- Retry
  retry_count INTEGER DEFAULT 0,
  parent_job_id UUID REFERENCES jobs(id),

  created_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Индексы
CREATE INDEX idx_jobs_org ON jobs(org_id);
CREATE INDEX idx_jobs_project ON jobs(project_id);
CREATE INDEX idx_jobs_workflow ON jobs(workflow_id);
CREATE INDEX idx_jobs_status ON jobs(status);
CREATE INDEX idx_jobs_created_at ON jobs(created_at DESC);
CREATE INDEX idx_jobs_created_by ON jobs(created_by);
```

**Структура config:**
```json
{
  "sources": [
    {"type": "upload", "uri": "assets/clip.mp4"},
    {"type": "stock", "provider": "pexels", "query": "city night"}
  ],
  "script": {
    "lang": "en",
    "text": "A bizarre event shocked downtown tonight..."
  },
  "tts": {
    "engine": "kokoro",
    "voice": "alloy_en",
    "speed": 1.0
  },
  "subtitles": {
    "style": "karaoke_bounce"
  },
  "output": {
    "profile": "9x16_1080p"
  },
  "budget": {
    "max_cost_usd": 0.50,
    "max_tokens": 10000
  }
}
```

**Структура result:**
```json
{
  "video_url": "https://storage.../video.mp4",
  "thumbnail_url": "https://storage.../thumb.jpg",
  "srt_url": "https://storage.../subs.srt",
  "duration": 60.5,
  "resolution": "1080x1920",
  "file_size": 25000000
}
```

**Структура error:**
```json
{
  "code": "RENDER_FAILED",
  "message": "FFmpeg encoding error",
  "stage": "export",
  "retryable": true,
  "details": {...}
}
```

---

## job_logs

Детальные логи выполнения job.

```sql
CREATE TABLE job_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  job_id UUID NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,

  level TEXT NOT NULL, -- debug, info, warn, error
  stage TEXT, -- ingest, script, tts, subtitle, edit, export
  message TEXT NOT NULL,
  data JSONB,

  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Индексы
CREATE INDEX idx_job_logs_job ON job_logs(job_id);
CREATE INDEX idx_job_logs_level ON job_logs(level);
CREATE INDEX idx_job_logs_created_at ON job_logs(created_at);
```

**Пример:**
```json
{
  "level": "info",
  "stage": "tts",
  "message": "Voice synthesis completed",
  "data": {
    "duration": 45.2,
    "voice": "alloy_en",
    "characters": 850
  }
}
```

---

## renders

Финальные артефакты рендера.

```sql
CREATE TABLE renders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  job_id UUID NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,

  -- Output files
  video_url TEXT NOT NULL,
  video_storage_path TEXT NOT NULL,
  thumbnail_url TEXT,
  srt_url TEXT,

  -- Video properties
  duration_seconds DECIMAL(10, 2),
  resolution TEXT,
  file_size_bytes BIGINT,
  codec TEXT,
  bitrate_kbps INTEGER,
  fps DECIMAL(5, 2),

  metadata JSONB DEFAULT '{}',

  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Индексы
CREATE INDEX idx_renders_job ON renders(job_id);
```

---

## schedules

Расписания запуска workflows.

```sql
CREATE TABLE schedules (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID NOT NULL REFERENCES orgs(id) ON DELETE CASCADE,
  workflow_id UUID NOT NULL REFERENCES workflows(id) ON DELETE CASCADE,

  -- Cron expression
  cron TEXT NOT NULL, -- "0 10 * * *"
  timezone TEXT DEFAULT 'UTC',

  enabled BOOLEAN DEFAULT true,

  -- Tracking
  last_run_at TIMESTAMPTZ,
  next_run_at TIMESTAMPTZ,
  run_count INTEGER DEFAULT 0,

  created_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Индексы
CREATE INDEX idx_schedules_org ON schedules(org_id);
CREATE INDEX idx_schedules_workflow ON schedules(workflow_id);
CREATE INDEX idx_schedules_next_run ON schedules(next_run_at) WHERE enabled = true;
```

**Примеры cron:**
| Cron | Описание |
|------|----------|
| `0 10 * * *` | Ежедневно в 10:00 |
| `0 */6 * * *` | Каждые 6 часов |
| `0 9 * * 1` | Каждый понедельник в 9:00 |
| `0 0 1 * *` | Первый день месяца |

---

## webhooks

Конфигурация webhooks для уведомлений.

```sql
CREATE TABLE webhooks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID NOT NULL REFERENCES orgs(id) ON DELETE CASCADE,

  url TEXT NOT NULL,
  events TEXT[] NOT NULL, -- ["job.completed", "job.failed"]
  secret TEXT NOT NULL, -- для HMAC подписи

  enabled BOOLEAN DEFAULT true,

  created_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Индексы
CREATE INDEX idx_webhooks_org ON webhooks(org_id);
```

**События:**
- `job.started`
- `job.completed`
- `job.failed`
- `workflow.run.started`
- `workflow.run.finished`
- `quota.warning`
- `quota.exceeded`

---

## webhook_deliveries

Отслеживание доставки webhooks.

```sql
CREATE TABLE webhook_deliveries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  webhook_id UUID NOT NULL REFERENCES webhooks(id) ON DELETE CASCADE,

  event TEXT NOT NULL,
  payload JSONB NOT NULL,

  status TEXT DEFAULT 'pending', -- pending, success, failed

  -- HTTP response
  http_status INTEGER,
  response_body TEXT,

  -- Retries
  attempts INTEGER DEFAULT 0,
  last_attempt_at TIMESTAMPTZ,
  next_retry_at TIMESTAMPTZ,

  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Индексы
CREATE INDEX idx_webhook_deliveries_webhook ON webhook_deliveries(webhook_id);
CREATE INDEX idx_webhook_deliveries_status ON webhook_deliveries(status);
CREATE INDEX idx_webhook_deliveries_next_retry ON webhook_deliveries(next_retry_at)
  WHERE status = 'pending';
```

---

## RLS Policies

```sql
ALTER TABLE jobs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Org members can view jobs"
  ON jobs FOR SELECT
  USING (
    org_id IN (SELECT org_id FROM org_members WHERE user_id = auth.uid())
  );

CREATE POLICY "Editors can create jobs"
  ON jobs FOR INSERT
  WITH CHECK (
    org_id IN (
      SELECT org_id FROM org_members
      WHERE user_id = auth.uid()
      AND role IN ('owner', 'admin', 'editor')
    )
  );

ALTER TABLE schedules ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Org members can view schedules"
  ON schedules FOR SELECT
  USING (
    org_id IN (SELECT org_id FROM org_members WHERE user_id = auth.uid())
  );
```
