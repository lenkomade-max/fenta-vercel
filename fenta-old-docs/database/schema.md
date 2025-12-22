# Database Schema Documentation

## Overview

The Fenta Web application uses PostgreSQL as the primary relational database. The schema is designed to support multi-tenancy, complex workflow graphs, asset management, and detailed billing tracking.

## Database Conventions

- **Primary Keys**: UUID v4 format with prefix (e.g., `user_abc123`, `wf_xyz789`)
- **Timestamps**: All tables include `created_at` and `updated_at` columns
- **Soft Deletes**: Critical tables use `deleted_at` for soft deletion
- **JSONB**: Used for flexible/dynamic data (workflow graphs, template specs, metadata)
- **Indexes**: Applied to foreign keys, frequently queried columns, and JSON paths
- **Constraints**: Foreign keys with CASCADE/SET NULL based on relationship

## Entity Relationship Diagram

```
┌─────────────┐
│    users    │
└──────┬──────┘
       │
       ├─────────────────┬──────────────────┐
       ↓                 ↓                  ↓
┌─────────────┐   ┌─────────────┐   ┌─────────────┐
│    orgs     │   │  api_keys   │   │   sessions  │
└──────┬──────┘   └─────────────┘   └─────────────┘
       │
       ├──────────┬──────────┬──────────┬──────────┐
       ↓          ↓          ↓          ↓          ↓
┌─────────────┐ ┌──────────┐ ┌─────────┐ ┌─────────┐
│  projects   │ │templates │ │workflows│ │ assets  │
└──────┬──────┘ └─────┬────┘ └────┬────┘ └────┬────┘
       │              │           │           │
       ↓              ↓           ↓           ↓
┌─────────────┐ ┌──────────┐ ┌─────────┐ ┌──────────────┐
│    jobs     │ │ schedules│ │  nodes  │ │asset_versions│
└──────┬──────┘ └──────────┘ └─────────┘ └──────────────┘
       │
       ├─────────┬─────────┬─────────┐
       ↓         ↓         ↓         ↓
┌──────────┐ ┌────────┐ ┌────────┐ ┌────────┐
│  renders │ │ webhooks│ │usage_  │ │audit_  │
│          │ │         │ │records │ │logs    │
└──────────┘ └────────┘ └────────┘ └────────┘
```

## Core Tables

### users

Stores user account information.

```sql
CREATE TABLE users (
  id VARCHAR(255) PRIMARY KEY DEFAULT concat('user_', gen_random_uuid()),
  email VARCHAR(255) UNIQUE NOT NULL,
  email_verified_at TIMESTAMP,
  password_hash VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  avatar_url TEXT,
  role VARCHAR(50) DEFAULT 'user', -- user, admin
  status VARCHAR(50) DEFAULT 'active', -- active, suspended, deleted
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  deleted_at TIMESTAMP
);

CREATE INDEX idx_users_email ON users(email) WHERE deleted_at IS NULL;
CREATE INDEX idx_users_status ON users(status);
CREATE INDEX idx_users_created_at ON users(created_at);
```

**Sample Record:**
```json
{
  "id": "user_abc123",
  "email": "john@example.com",
  "name": "John Doe",
  "role": "user",
  "status": "active",
  "metadata": {
    "onboarding_completed": true,
    "preferences": {
      "theme": "dark",
      "notifications": true
    }
  }
}
```

### orgs (organizations)

Multi-tenancy organization structure.

```sql
CREATE TABLE orgs (
  id VARCHAR(255) PRIMARY KEY DEFAULT concat('org_', gen_random_uuid()),
  name VARCHAR(255) NOT NULL,
  slug VARCHAR(255) UNIQUE NOT NULL,
  owner_id VARCHAR(255) NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  plan VARCHAR(50) DEFAULT 'free', -- free, starter, pro, enterprise
  plan_started_at TIMESTAMP,
  billing_email VARCHAR(255),
  billing_customer_id VARCHAR(255), -- Stripe customer ID
  settings JSONB DEFAULT '{}',
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  deleted_at TIMESTAMP
);

CREATE INDEX idx_orgs_owner ON orgs(owner_id);
CREATE INDEX idx_orgs_slug ON orgs(slug) WHERE deleted_at IS NULL;
CREATE INDEX idx_orgs_plan ON orgs(plan);
```

**Sample Record:**
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
    "brand_colors": ["#FF6B6B", "#4ECDC4"]
  }
}
```

### org_members

Maps users to organizations with roles.

```sql
CREATE TABLE org_members (
  id VARCHAR(255) PRIMARY KEY DEFAULT concat('member_', gen_random_uuid()),
  org_id VARCHAR(255) NOT NULL REFERENCES orgs(id) ON DELETE CASCADE,
  user_id VARCHAR(255) NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  role VARCHAR(50) NOT NULL, -- owner, admin, editor, viewer
  invited_by VARCHAR(255) REFERENCES users(id),
  joined_at TIMESTAMP DEFAULT NOW(),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(org_id, user_id)
);

CREATE INDEX idx_org_members_org ON org_members(org_id);
CREATE INDEX idx_org_members_user ON org_members(user_id);
CREATE INDEX idx_org_members_role ON org_members(role);
```

### projects

Projects within organizations for resource grouping.

```sql
CREATE TABLE projects (
  id VARCHAR(255) PRIMARY KEY DEFAULT concat('proj_', gen_random_uuid()),
  org_id VARCHAR(255) NOT NULL REFERENCES orgs(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  settings JSONB DEFAULT '{}',
  created_by VARCHAR(255) REFERENCES users(id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  deleted_at TIMESTAMP
);

CREATE INDEX idx_projects_org ON projects(org_id);
CREATE INDEX idx_projects_created_by ON projects(created_by);
```

### api_keys

Personal Access Tokens for API authentication.

```sql
CREATE TABLE api_keys (
  id VARCHAR(255) PRIMARY KEY DEFAULT concat('key_', gen_random_uuid()),
  user_id VARCHAR(255) NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  org_id VARCHAR(255) REFERENCES orgs(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  key_hash VARCHAR(255) UNIQUE NOT NULL, -- bcrypt hash of the key
  key_prefix VARCHAR(20) NOT NULL, -- First 8 chars for identification
  scopes JSONB DEFAULT '[]', -- ["workflows:read", "workflows:write", "jobs:execute"]
  last_used_at TIMESTAMP,
  expires_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW(),
  revoked_at TIMESTAMP
);

CREATE INDEX idx_api_keys_user ON api_keys(user_id);
CREATE INDEX idx_api_keys_org ON api_keys(org_id);
CREATE INDEX idx_api_keys_hash ON api_keys(key_hash) WHERE revoked_at IS NULL;
```

## Template & Workflow Tables

### templates

Video montage templates defining visual layout and rules.

```sql
CREATE TABLE templates (
  id VARCHAR(255) PRIMARY KEY DEFAULT concat('tmpl_', gen_random_uuid()),
  org_id VARCHAR(255) REFERENCES orgs(id) ON DELETE CASCADE,
  project_id VARCHAR(255) REFERENCES projects(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  aspect VARCHAR(10) NOT NULL, -- "9:16", "16:9", "1:1", "4:5"
  resolution VARCHAR(20) NOT NULL, -- "1080x1920", "1920x1080"
  is_public BOOLEAN DEFAULT false,
  thumbnail_url TEXT,

  -- Template specification (JSONB)
  spec JSONB NOT NULL,
  /* Structure:
  {
    "tracks": [
      {"type": "video", "id": "main", "z": 0},
      {"type": "subtitle", "id": "subs", "z": 10, "style": {...}},
      {"type": "overlay", "id": "top_text", "z": 20}
    ],
    "overlays": [
      {"track": "top_text", "from": 0, "to": 3, "content": {...}}
    ],
    "placeholders": {
      "cover": "image",
      "logo": "image_optional"
    },
    "rules": {
      "cuts": "auto_by_beats_or_speech",
      "min_scene": 1.2,
      "max_scene": 4.0
    },
    "subtitle_style_presets": ["karaoke_bounce", "clean_box"]
  }
  */

  usage_count INTEGER DEFAULT 0,
  created_by VARCHAR(255) REFERENCES users(id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  deleted_at TIMESTAMP
);

CREATE INDEX idx_templates_org ON templates(org_id);
CREATE INDEX idx_templates_project ON templates(project_id);
CREATE INDEX idx_templates_aspect ON templates(aspect);
CREATE INDEX idx_templates_public ON templates(is_public) WHERE is_public = true;
CREATE INDEX idx_templates_spec ON templates USING gin(spec);
```

**Sample Template Spec:**
```json
{
  "id": "tmpl_shorts_v1",
  "name": "Shorts Clean Bold",
  "aspect": "9:16",
  "resolution": "1080x1920",
  "spec": {
    "tracks": [
      {"type": "video", "id": "main", "z": 0},
      {
        "type": "subtitle",
        "id": "subs",
        "z": 10,
        "style": {
          "font": "Inter",
          "size": 44,
          "shadow": true,
          "bg": "box",
          "position": "bottom",
          "margin": 120
        }
      },
      {"type": "overlay", "id": "top_text", "z": 20}
    ],
    "overlays": [
      {
        "track": "top_text",
        "from": 0,
        "to": 3,
        "content": {
          "type": "text",
          "text": "BREAKING STORY",
          "pos": "top",
          "anim": "slide-down"
        }
      }
    ],
    "placeholders": {
      "cover": "image",
      "logo": "image_optional",
      "music": "audio_optional"
    },
    "rules": {
      "cuts": "auto_by_beats_or_speech",
      "min_scene": 1.2,
      "max_scene": 4.0
    },
    "subtitle_style_presets": ["karaoke_bounce", "clean_box"]
  }
}
```

### workflows

Visual workflow graphs for video production.

```sql
CREATE TABLE workflows (
  id VARCHAR(255) PRIMARY KEY DEFAULT concat('wf_', gen_random_uuid()),
  org_id VARCHAR(255) NOT NULL REFERENCES orgs(id) ON DELETE CASCADE,
  project_id VARCHAR(255) REFERENCES projects(id) ON DELETE SET NULL,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  status VARCHAR(50) DEFAULT 'draft', -- draft, confirmed, preview, production, archived

  -- Workflow graph (JSONB)
  graph JSONB NOT NULL,
  /* Structure:
  {
    "nodes": [
      {
        "id": "n1",
        "type": "Input.Stock",
        "params": {"provider": "pexels", "query": "city night"},
        "position": {"x": 100, "y": 100}
      }
    ],
    "edges": [
      {"id": "e1", "from": "n1", "to": "n2", "fromPort": "output", "toPort": "input"}
    ]
  }
  */

  variables JSONB DEFAULT '{}', -- Workflow-level variables

  run_count INTEGER DEFAULT 0,
  last_run_at TIMESTAMP,

  created_by VARCHAR(255) REFERENCES users(id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  deleted_at TIMESTAMP
);

CREATE INDEX idx_workflows_org ON workflows(org_id);
CREATE INDEX idx_workflows_project ON workflows(project_id);
CREATE INDEX idx_workflows_status ON workflows(status);
CREATE INDEX idx_workflows_graph ON workflows USING gin(graph);
```

**Sample Workflow Graph:**
```json
{
  "id": "wf_daily_news_01",
  "name": "Daily News Shorts",
  "graph": {
    "nodes": [
      {
        "id": "n1",
        "type": "Input.Stock",
        "params": {
          "provider": "pexels",
          "query": "breaking news city"
        },
        "position": {"x": 100, "y": 100}
      },
      {
        "id": "n2",
        "type": "Script.Generate",
        "params": {
          "genre": "news",
          "lang": "en",
          "prompt": "30s punchy headline + 3 beats"
        },
        "position": {"x": 100, "y": 250}
      },
      {
        "id": "n3",
        "type": "Voice.TTS",
        "params": {
          "voice": "alloy_en",
          "speed": 1.02
        },
        "position": {"x": 100, "y": 400}
      },
      {
        "id": "n4",
        "type": "Subtitle.Auto",
        "params": {
          "style": "clean_box"
        },
        "position": {"x": 300, "y": 400}
      },
      {
        "id": "n5",
        "type": "Edit.Timeline",
        "params": {
          "template_id": "tmpl_shorts_v1"
        },
        "position": {"x": 500, "y": 300}
      },
      {
        "id": "n6",
        "type": "Output.Render",
        "params": {
          "profile": "9x16_1080p"
        },
        "position": {"x": 700, "y": 300}
      }
    ],
    "edges": [
      {"id": "e1", "from": "n1", "to": "n5"},
      {"id": "e2", "from": "n2", "to": "n3"},
      {"id": "e3", "from": "n3", "to": "n4"},
      {"id": "e4", "from": "n4", "to": "n5"},
      {"id": "e5", "from": "n5", "to": "n6"}
    ]
  }
}
```

### workflow_versions

Version history for workflows.

```sql
CREATE TABLE workflow_versions (
  id VARCHAR(255) PRIMARY KEY DEFAULT concat('ver_', gen_random_uuid()),
  workflow_id VARCHAR(255) NOT NULL REFERENCES workflows(id) ON DELETE CASCADE,
  version INTEGER NOT NULL,
  graph JSONB NOT NULL,
  variables JSONB DEFAULT '{}',
  created_by VARCHAR(255) REFERENCES users(id),
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(workflow_id, version)
);

CREATE INDEX idx_workflow_versions_workflow ON workflow_versions(workflow_id);
```

## Asset Management Tables

### assets

All user assets (uploads, stock, AI generations).

```sql
CREATE TABLE assets (
  id VARCHAR(255) PRIMARY KEY DEFAULT concat('asset_', gen_random_uuid()),
  org_id VARCHAR(255) NOT NULL REFERENCES orgs(id) ON DELETE CASCADE,
  project_id VARCHAR(255) REFERENCES projects(id) ON DELETE SET NULL,

  type VARCHAR(50) NOT NULL, -- image, video, audio
  source VARCHAR(50) NOT NULL, -- upload, stock, kai, generated

  -- Storage
  storage_provider VARCHAR(50) DEFAULT 's3', -- s3, cloudflare-r2
  storage_key TEXT NOT NULL,
  storage_bucket VARCHAR(255),
  url TEXT,
  thumbnail_url TEXT,

  -- Metadata
  filename VARCHAR(255),
  content_type VARCHAR(100),
  size_bytes BIGINT,
  duration_seconds DECIMAL(10, 2), -- for video/audio
  width INTEGER, -- for image/video
  height INTEGER,
  fps DECIMAL(5, 2), -- for video
  codec VARCHAR(50),

  metadata JSONB DEFAULT '{}',
  /* Additional metadata:
  {
    "source_url": "https://pexels.com/...",
    "provider_id": "pexels_12345",
    "generation_params": {...},
    "tags": ["nature", "forest"],
    "extracted_colors": ["#FF6B6B", "#4ECDC4"]
  }
  */

  status VARCHAR(50) DEFAULT 'processing', -- processing, ready, failed

  created_by VARCHAR(255) REFERENCES users(id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  deleted_at TIMESTAMP
);

CREATE INDEX idx_assets_org ON assets(org_id);
CREATE INDEX idx_assets_project ON assets(project_id);
CREATE INDEX idx_assets_type ON assets(type);
CREATE INDEX idx_assets_source ON assets(source);
CREATE INDEX idx_assets_status ON assets(status);
CREATE INDEX idx_assets_metadata ON assets USING gin(metadata);
```

### asset_versions

Version history for assets (e.g., edited versions).

```sql
CREATE TABLE asset_versions (
  id VARCHAR(255) PRIMARY KEY DEFAULT concat('aver_', gen_random_uuid()),
  asset_id VARCHAR(255) NOT NULL REFERENCES assets(id) ON DELETE CASCADE,
  version INTEGER NOT NULL,
  storage_key TEXT NOT NULL,
  url TEXT,
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(asset_id, version)
);

CREATE INDEX idx_asset_versions_asset ON asset_versions(asset_id);
```

## Job & Render Tables

### jobs

Render jobs (from workflows or direct API).

```sql
CREATE TABLE jobs (
  id VARCHAR(255) PRIMARY KEY DEFAULT concat('job_', gen_random_uuid()),
  org_id VARCHAR(255) NOT NULL REFERENCES orgs(id) ON DELETE CASCADE,
  project_id VARCHAR(255) REFERENCES projects(id) ON DELETE SET NULL,
  workflow_id VARCHAR(255) REFERENCES workflows(id) ON DELETE SET NULL,
  template_id VARCHAR(255) REFERENCES templates(id) ON DELETE SET NULL,

  status VARCHAR(50) DEFAULT 'queued', -- queued, processing, completed, failed, cancelled
  progress INTEGER DEFAULT 0, -- 0-100

  -- Job configuration
  config JSONB NOT NULL,
  /* Structure:
  {
    "sources": [...],
    "script": {...},
    "tts": {...},
    "subtitles": {...},
    "output": {...}
  }
  */

  -- Results
  result JSONB,
  /* Structure:
  {
    "video_url": "https://...",
    "thumbnail_url": "https://...",
    "srt_url": "https://...",
    "duration": 60.5
  }
  */

  -- Error information
  error JSONB,

  -- Cost tracking
  cost_tokens INTEGER DEFAULT 0,
  cost_render_seconds DECIMAL(10, 2) DEFAULT 0,
  cost_kai_credits INTEGER DEFAULT 0,
  cost_total_usd DECIMAL(10, 4) DEFAULT 0,

  -- Timing
  queued_at TIMESTAMP DEFAULT NOW(),
  started_at TIMESTAMP,
  completed_at TIMESTAMP,

  -- Retry tracking
  retry_count INTEGER DEFAULT 0,
  parent_job_id VARCHAR(255) REFERENCES jobs(id),

  created_by VARCHAR(255) REFERENCES users(id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_jobs_org ON jobs(org_id);
CREATE INDEX idx_jobs_project ON jobs(project_id);
CREATE INDEX idx_jobs_workflow ON jobs(workflow_id);
CREATE INDEX idx_jobs_status ON jobs(status);
CREATE INDEX idx_jobs_created_at ON jobs(created_at DESC);
CREATE INDEX idx_jobs_created_by ON jobs(created_by);
```

### job_logs

Detailed execution logs for debugging.

```sql
CREATE TABLE job_logs (
  id VARCHAR(255) PRIMARY KEY DEFAULT concat('log_', gen_random_uuid()),
  job_id VARCHAR(255) NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,
  level VARCHAR(20) NOT NULL, -- debug, info, warn, error
  stage VARCHAR(100), -- ingest, script, tts, subtitle, edit, export
  message TEXT NOT NULL,
  data JSONB,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_job_logs_job ON job_logs(job_id);
CREATE INDEX idx_job_logs_level ON job_logs(level);
CREATE INDEX idx_job_logs_created_at ON job_logs(created_at);
```

### renders

Final render artifacts.

```sql
CREATE TABLE renders (
  id VARCHAR(255) PRIMARY KEY DEFAULT concat('render_', gen_random_uuid()),
  job_id VARCHAR(255) NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,

  -- Output files
  video_url TEXT NOT NULL,
  thumbnail_url TEXT,
  srt_url TEXT,

  -- Video properties
  duration_seconds DECIMAL(10, 2),
  resolution VARCHAR(20),
  file_size_bytes BIGINT,
  codec VARCHAR(50),
  bitrate_kbps INTEGER,

  metadata JSONB DEFAULT '{}',

  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_renders_job ON renders(job_id);
```

## Scheduling Tables

### schedules

Cron-based workflow scheduling.

```sql
CREATE TABLE schedules (
  id VARCHAR(255) PRIMARY KEY DEFAULT concat('sched_', gen_random_uuid()),
  org_id VARCHAR(255) NOT NULL REFERENCES orgs(id) ON DELETE CASCADE,
  workflow_id VARCHAR(255) NOT NULL REFERENCES workflows(id) ON DELETE CASCADE,

  cron VARCHAR(255) NOT NULL, -- Cron expression: "0 10 * * *"
  timezone VARCHAR(100) DEFAULT 'UTC',

  enabled BOOLEAN DEFAULT true,

  last_run_at TIMESTAMP,
  next_run_at TIMESTAMP,

  run_count INTEGER DEFAULT 0,

  created_by VARCHAR(255) REFERENCES users(id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_schedules_org ON schedules(org_id);
CREATE INDEX idx_schedules_workflow ON schedules(workflow_id);
CREATE INDEX idx_schedules_next_run ON schedules(next_run_at) WHERE enabled = true;
```

## Integration Tables

### integrations

External service integration credentials.

```sql
CREATE TABLE integrations (
  id VARCHAR(255) PRIMARY KEY DEFAULT concat('int_', gen_random_uuid()),
  org_id VARCHAR(255) NOT NULL REFERENCES orgs(id) ON DELETE CASCADE,

  provider VARCHAR(100) NOT NULL, -- kai, openai, pexels, youtube, tiktok
  status VARCHAR(50) DEFAULT 'active', -- active, expired, revoked

  credentials JSONB NOT NULL, -- Encrypted API keys and tokens
  config JSONB DEFAULT '{}',

  last_used_at TIMESTAMP,
  expires_at TIMESTAMP,

  created_by VARCHAR(255) REFERENCES users(id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_integrations_org ON integrations(org_id);
CREATE INDEX idx_integrations_provider ON integrations(provider);
```

### kai_generations

Track KAI generation requests and costs.

```sql
CREATE TABLE kai_generations (
  id VARCHAR(255) PRIMARY KEY DEFAULT concat('gen_', gen_random_uuid()),
  org_id VARCHAR(255) NOT NULL REFERENCES orgs(id) ON DELETE CASCADE,
  job_id VARCHAR(255) REFERENCES jobs(id) ON DELETE SET NULL,

  type VARCHAR(50) NOT NULL, -- image, video, edit
  model VARCHAR(100), -- flux-pro, sora, veo, minimax, bio3

  prompt TEXT NOT NULL,
  params JSONB DEFAULT '{}',

  status VARCHAR(50) DEFAULT 'queued', -- queued, processing, completed, failed

  -- Results
  result_asset_ids TEXT[], -- Array of asset IDs

  -- Cost
  credits_used INTEGER DEFAULT 0,
  cost_usd DECIMAL(10, 4) DEFAULT 0,

  -- External tracking
  external_id VARCHAR(255), -- Provider's generation ID

  created_by VARCHAR(255) REFERENCES users(id),
  created_at TIMESTAMP DEFAULT NOW(),
  completed_at TIMESTAMP
);

CREATE INDEX idx_kai_generations_org ON kai_generations(org_id);
CREATE INDEX idx_kai_generations_job ON kai_generations(job_id);
CREATE INDEX idx_kai_generations_status ON kai_generations(status);
CREATE INDEX idx_kai_generations_external ON kai_generations(external_id);
```

## Billing & Usage Tables

### usage_records

Detailed usage tracking for billing (partitioned by month).

```sql
CREATE TABLE usage_records (
  id VARCHAR(255) PRIMARY KEY DEFAULT concat('usage_', gen_random_uuid()),
  org_id VARCHAR(255) NOT NULL REFERENCES orgs(id) ON DELETE CASCADE,
  user_id VARCHAR(255) REFERENCES users(id),
  job_id VARCHAR(255) REFERENCES jobs(id) ON DELETE SET NULL,

  resource_type VARCHAR(50) NOT NULL, -- llm_tokens, kai_credits, render_seconds, storage

  -- LLM specific
  llm_tokens_prompt INTEGER,
  llm_tokens_output INTEGER,
  llm_model VARCHAR(100),

  -- KAI specific
  kai_credits INTEGER,
  kai_model VARCHAR(100),

  -- Render specific
  render_seconds DECIMAL(10, 2),
  render_profile VARCHAR(50),

  -- Storage specific
  storage_bytes BIGINT,

  -- Cost
  cost_usd DECIMAL(10, 4) NOT NULL,

  created_at TIMESTAMP DEFAULT NOW()
) PARTITION BY RANGE (created_at);

-- Create monthly partitions
CREATE TABLE usage_records_2024_01 PARTITION OF usage_records
  FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');

CREATE INDEX idx_usage_records_org ON usage_records(org_id, created_at);
CREATE INDEX idx_usage_records_user ON usage_records(user_id);
CREATE INDEX idx_usage_records_job ON usage_records(job_id);
CREATE INDEX idx_usage_records_resource ON usage_records(resource_type);
```

### quota_limits

Organization-level quota limits.

```sql
CREATE TABLE quota_limits (
  id VARCHAR(255) PRIMARY KEY DEFAULT concat('quota_', gen_random_uuid()),
  org_id VARCHAR(255) UNIQUE NOT NULL REFERENCES orgs(id) ON DELETE CASCADE,

  -- Monthly limits
  tokens_limit INTEGER,
  render_seconds_limit INTEGER,
  kai_credits_limit INTEGER,
  storage_bytes_limit BIGINT,

  -- Current usage (reset monthly)
  tokens_used INTEGER DEFAULT 0,
  render_seconds_used DECIMAL(10, 2) DEFAULT 0,
  kai_credits_used INTEGER DEFAULT 0,
  storage_bytes_used BIGINT DEFAULT 0,

  reset_at TIMESTAMP NOT NULL,

  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_quota_limits_org ON quota_limits(org_id);
```

### invoices

Billing invoices (Stripe integration).

```sql
CREATE TABLE invoices (
  id VARCHAR(255) PRIMARY KEY DEFAULT concat('inv_', gen_random_uuid()),
  org_id VARCHAR(255) NOT NULL REFERENCES orgs(id) ON DELETE CASCADE,

  stripe_invoice_id VARCHAR(255) UNIQUE,

  amount_usd DECIMAL(10, 2) NOT NULL,
  status VARCHAR(50) NOT NULL, -- draft, open, paid, void

  period_start DATE NOT NULL,
  period_end DATE NOT NULL,

  line_items JSONB DEFAULT '[]',

  paid_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_invoices_org ON invoices(org_id);
CREATE INDEX idx_invoices_stripe ON invoices(stripe_invoice_id);
CREATE INDEX idx_invoices_period ON invoices(period_start, period_end);
```

## Webhook & Notification Tables

### webhooks

Webhook endpoint configuration.

```sql
CREATE TABLE webhooks (
  id VARCHAR(255) PRIMARY KEY DEFAULT concat('hook_', gen_random_uuid()),
  org_id VARCHAR(255) NOT NULL REFERENCES orgs(id) ON DELETE CASCADE,

  url TEXT NOT NULL,
  events TEXT[] NOT NULL, -- ["render.succeeded", "render.failed", "workflow.run.finished"]

  secret VARCHAR(255) NOT NULL, -- For HMAC signature

  enabled BOOLEAN DEFAULT true,

  created_by VARCHAR(255) REFERENCES users(id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_webhooks_org ON webhooks(org_id);
```

### webhook_deliveries

Webhook delivery tracking and retry logic.

```sql
CREATE TABLE webhook_deliveries (
  id VARCHAR(255) PRIMARY KEY DEFAULT concat('delivery_', gen_random_uuid()),
  webhook_id VARCHAR(255) NOT NULL REFERENCES webhooks(id) ON DELETE CASCADE,

  event VARCHAR(100) NOT NULL,
  payload JSONB NOT NULL,

  status VARCHAR(50) DEFAULT 'pending', -- pending, success, failed

  -- HTTP response
  http_status INTEGER,
  response_body TEXT,

  attempts INTEGER DEFAULT 0,
  last_attempt_at TIMESTAMP,
  next_retry_at TIMESTAMP,

  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_webhook_deliveries_webhook ON webhook_deliveries(webhook_id);
CREATE INDEX idx_webhook_deliveries_status ON webhook_deliveries(status);
CREATE INDEX idx_webhook_deliveries_next_retry ON webhook_deliveries(next_retry_at)
  WHERE status = 'pending';
```

## Audit & Logging Tables

### audit_logs

Audit trail for sensitive operations.

```sql
CREATE TABLE audit_logs (
  id VARCHAR(255) PRIMARY KEY DEFAULT concat('audit_', gen_random_uuid()),
  org_id VARCHAR(255) REFERENCES orgs(id) ON DELETE SET NULL,
  user_id VARCHAR(255) REFERENCES users(id) ON DELETE SET NULL,

  action VARCHAR(100) NOT NULL, -- create, update, delete, execute
  resource_type VARCHAR(100) NOT NULL, -- workflow, template, job, user
  resource_id VARCHAR(255),

  ip_address INET,
  user_agent TEXT,

  changes JSONB, -- Before/after state
  metadata JSONB DEFAULT '{}',

  created_at TIMESTAMP DEFAULT NOW()
) PARTITION BY RANGE (created_at);

-- Monthly partitions
CREATE TABLE audit_logs_2024_01 PARTITION OF audit_logs
  FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');

CREATE INDEX idx_audit_logs_org ON audit_logs(org_id, created_at);
CREATE INDEX idx_audit_logs_user ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_resource ON audit_logs(resource_type, resource_id);
```

## Materialized Views

### mv_daily_usage

Aggregated daily usage statistics.

```sql
CREATE MATERIALIZED VIEW mv_daily_usage AS
SELECT
  org_id,
  DATE(created_at) as date,
  SUM(CASE WHEN resource_type = 'llm_tokens' THEN llm_tokens_prompt + llm_tokens_output ELSE 0 END) as total_tokens,
  SUM(CASE WHEN resource_type = 'kai_credits' THEN kai_credits ELSE 0 END) as total_kai_credits,
  SUM(CASE WHEN resource_type = 'render_seconds' THEN render_seconds ELSE 0 END) as total_render_seconds,
  SUM(cost_usd) as total_cost_usd
FROM usage_records
GROUP BY org_id, DATE(created_at);

CREATE UNIQUE INDEX idx_mv_daily_usage ON mv_daily_usage(org_id, date);

-- Refresh daily
REFRESH MATERIALIZED VIEW CONCURRENTLY mv_daily_usage;
```

## Database Migrations

We use Prisma Migrate for schema management:

```bash
# Create new migration
npx prisma migrate dev --name add_feature_name

# Apply migrations to production
npx prisma migrate deploy

# Reset database (dev only)
npx prisma migrate reset
```

## Performance Optimization

### Key Indexes

1. **Foreign Keys**: All foreign key columns are indexed
2. **Frequently Queried**: Status, created_at, type columns
3. **JSONB**: GIN indexes on JSONB columns for fast queries
4. **Composite**: (org_id, created_at) for org-scoped queries
5. **Partial**: Indexes with WHERE clause for active/non-deleted records

### Partitioning Strategy

Large tables are partitioned by date:
- `usage_records`: Monthly partitions
- `audit_logs`: Monthly partitions
- `webhook_deliveries`: Optional (if high volume)

### Query Optimization

1. **Avoid N+1**: Use JOIN or batch queries
2. **Limit Results**: Always use LIMIT in list queries
3. **Covering Indexes**: Include necessary columns in indexes
4. **Analyze Plans**: Use EXPLAIN ANALYZE for slow queries

## Backup & Recovery

### Automated Backups

- Full backup: Daily at 2 AM UTC
- Point-in-time recovery: Enabled (WAL archiving)
- Retention: 7 daily + 4 weekly + 12 monthly
- Cross-region replication for disaster recovery

### Restore Procedures

```sql
-- Restore to specific point in time
pg_restore --dbname=fenta_web --clean backup_file.dump

-- Restore specific table
pg_restore --dbname=fenta_web --table=workflows backup_file.dump
```

## Security Considerations

1. **Encryption at Rest**: PostgreSQL native encryption
2. **Row-Level Security**: For multi-tenant isolation
3. **Encrypted Columns**: Credentials in integrations table
4. **No PII in Logs**: Sanitize sensitive data before logging
5. **Audit Trail**: All modifications logged in audit_logs
