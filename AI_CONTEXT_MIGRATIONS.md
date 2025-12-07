# AI Context: Supabase Migrations for Fenta

## Task

Create high-quality PostgreSQL migrations for Supabase. User will add them via SQL Editor in Supabase Dashboard.

---

## Project Overview

**Fenta** — SaaS platform for automated short video creation (TikTok, Reels, Shorts).

**Tech Stack:**
- Supabase (PostgreSQL + Auth + Storage)
- Next.js 15 frontend
- External APIs: KIE.ai (AI generation), FantaProjekt (render engine)

---

## Requirements

### MUST DO:
1. **RLS (Row Level Security)** — Multi-tenancy via org_id isolation
2. **Indexes** — All foreign keys, status columns, JSONB with GIN
3. **Partial indexes** — WHERE deleted_at IS NULL for soft deletes
4. **Triggers** — Auto-create profile on user signup, update timestamps
5. **Functions** — Quota checking, usage tracking
6. **Partitioning** — usage_records by month

### Conventions:
- UUID primary keys with prefixes (user_, org_, wf_, job_, tmpl_, asset_)
- All tables have: created_at, updated_at (TIMESTAMPTZ DEFAULT NOW())
- Soft deletes via deleted_at for critical tables
- JSONB for flexible data: spec, graph, metadata, config

---

## Migration Order (8 files)

### 1. `00001_extensions.sql`
```sql
-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
```

### 2. `00002_users.sql`
Tables: profiles, orgs, org_members, api_keys, projects

**profiles** — extends auth.users:
- id UUID PRIMARY KEY REFERENCES auth.users(id)
- name, avatar_url, role (user/admin), status (active/suspended)
- metadata JSONB

**orgs** — organizations for multi-tenancy:
- id, name, slug (UNIQUE), owner_id
- plan (free/starter/pro/enterprise), billing_email, stripe_customer_id
- settings JSONB, deleted_at

**org_members** — user-org relationship:
- org_id, user_id, role (owner/admin/editor/viewer)
- UNIQUE(org_id, user_id)

**api_keys** — personal access tokens:
- user_id, org_id, name, key_hash, key_prefix
- scopes JSONB, expires_at, revoked_at

**projects** — group resources in org:
- org_id, name, description, settings JSONB

### 3. `00003_content.sql`
Tables: templates, workflows, workflow_versions, assets, asset_versions

**templates** — video montage templates:
- org_id, project_id, name, description
- aspect (9:16, 16:9, 1:1), resolution
- spec JSONB (tracks, overlays, placeholders, rules)
- is_public, thumbnail_url, usage_count

**workflows** — visual workflow graphs:
- org_id, project_id, name, status (draft/confirmed/production/archived)
- graph JSONB (nodes[], edges[])
- variables JSONB, run_count, last_run_at

**workflow_versions** — version history:
- workflow_id, version INTEGER, graph JSONB
- UNIQUE(workflow_id, version)

**assets** — media files:
- org_id, project_id, type (image/video/audio), source (upload/stock/kai)
- storage_path, url, thumbnail_url
- duration_seconds, width, height, fps
- metadata JSONB, status (processing/ready/failed)

### 4. `00004_jobs.sql`
Tables: jobs, job_logs, renders, schedules, webhooks, webhook_deliveries

**jobs** — render tasks:
- org_id, project_id, workflow_id, template_id
- status (queued/processing/completed/failed/cancelled), progress 0-100
- config JSONB, result JSONB, error JSONB
- cost_tokens, cost_render_seconds, cost_kai_credits, cost_total_usd
- queued_at, started_at, completed_at
- retry_count, parent_job_id

**job_logs** — execution logs:
- job_id, level (debug/info/warn/error), stage, message, data JSONB

**renders** — output artifacts:
- job_id, video_url, video_storage_path, thumbnail_url, srt_url
- duration_seconds, resolution, file_size_bytes, codec, bitrate_kbps, fps

**schedules** — workflow cron schedules:
- org_id, workflow_id, cron TEXT, timezone
- enabled, last_run_at, next_run_at, run_count

**webhooks** — notification config:
- org_id, url, events TEXT[], secret
- enabled

**webhook_deliveries** — delivery tracking:
- webhook_id, event, payload JSONB
- status (pending/success/failed), http_status, response_body
- attempts, next_retry_at

### 5. `00005_billing.sql`
Tables: usage_records (PARTITIONED), quota_limits, invoices, credit_packs, integrations, kai_generations

**usage_records** — detailed usage tracking (PARTITION BY RANGE created_at):
- org_id, user_id, job_id
- resource_type (llm_tokens/kai_credits/render_seconds/storage)
- llm_tokens_prompt, llm_tokens_output, llm_model
- kai_credits, kai_model
- render_seconds, render_profile
- storage_bytes
- cost_usd

Create partitions for current + next 3 months.

**quota_limits** — org usage limits:
- org_id UNIQUE
- tokens_limit, render_seconds_limit, kai_credits_limit, storage_bytes_limit (NULL = unlimited)
- tokens_used, render_seconds_used, kai_credits_used, storage_bytes_used
- allow_overage, overage_cap_usd
- reset_at

**invoices** — billing invoices:
- org_id, stripe_invoice_id, amount_usd
- status (draft/open/paid/void)
- period_start, period_end, line_items JSONB

**credit_packs** — prepaid credits:
- org_id, pack_type, credits_purchased, credits_remaining
- price_usd, stripe_payment_id, expires_at

**integrations** — external service connections:
- org_id, provider (kai/openai/pexels/stripe)
- status (active/expired/revoked)
- credentials JSONB (encrypted), config JSONB

**kai_generations** — AI generation tracking:
- org_id, job_id, type (image/video/edit/voice/music), model
- prompt, params JSONB
- status, result_asset_ids UUID[]
- credits_used, cost_usd, external_task_id

### 6. `00006_functions.sql`

**Trigger: handle_new_user()** — auto-create profile on auth.users INSERT

**Trigger: update_updated_at()** — auto-update updated_at column

**Trigger: update_quota_usage()** — update quota_limits on usage_records INSERT

**Function: check_quota(org_id, tokens, kai_credits, render_seconds)** — returns allowed boolean

**Materialized View: mv_daily_usage** — aggregated daily stats by org

### 7. `00007_rls_policies.sql`

Enable RLS on ALL tables.

**Pattern for org-scoped tables:**
```sql
CREATE POLICY "Org members can view"
  ON table_name FOR SELECT
  USING (org_id IN (SELECT org_id FROM org_members WHERE user_id = auth.uid()));
```

**Pattern for write access (editors+):**
```sql
CREATE POLICY "Editors can create"
  ON table_name FOR INSERT
  WITH CHECK (org_id IN (
    SELECT org_id FROM org_members
    WHERE user_id = auth.uid() AND role IN ('owner', 'admin', 'editor')
  ));
```

**Special cases:**
- profiles: user can only view/update own profile
- invoices: only owner/admin can view
- public templates: anyone can view where is_public = true

### 8. `00008_indexes.sql`

Create additional optimized indexes:

**Partial indexes:**
```sql
CREATE INDEX idx_workflows_active ON workflows(org_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_templates_public ON templates(is_public) WHERE is_public = true;
CREATE INDEX idx_api_keys_valid ON api_keys(key_hash) WHERE revoked_at IS NULL;
CREATE INDEX idx_schedules_enabled ON schedules(next_run_at) WHERE enabled = true;
CREATE INDEX idx_webhook_deliveries_pending ON webhook_deliveries(next_retry_at) WHERE status = 'pending';
CREATE INDEX idx_credit_packs_available ON credit_packs(org_id) WHERE credits_remaining > 0;
```

**GIN indexes for JSONB:**
```sql
CREATE INDEX idx_templates_spec ON templates USING gin(spec);
CREATE INDEX idx_workflows_graph ON workflows USING gin(graph);
CREATE INDEX idx_assets_metadata ON assets USING gin(metadata);
CREATE INDEX idx_jobs_config ON jobs USING gin(config);
```

**Composite indexes:**
```sql
CREATE INDEX idx_jobs_org_status ON jobs(org_id, status);
CREATE INDEX idx_usage_records_org_date ON usage_records(org_id, created_at);
```

---

## Documentation Location

Full database documentation: `/root/fenta-docs/database/`
- overview.md — conventions, entity diagram
- users.md — profiles, orgs, org_members, api_keys
- content.md — templates, workflows, assets
- jobs.md — jobs, renders, schedules, webhooks
- billing.md — usage_records, quota_limits, invoices

---

## Output Format

Create 8 SQL files in: `/root/fenta-vercel/supabase/migrations/`

Each file should have:
1. Header comment with description
2. Well-formatted SQL with comments
3. Proper order (CREATE TYPE before tables, etc.)

After completion, commit and push to GitHub.
