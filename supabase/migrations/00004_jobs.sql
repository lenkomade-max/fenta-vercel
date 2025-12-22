-- ============================================================================
-- Migration: 00004_jobs.sql
-- Description: Jobs, job logs, renders, schedules, webhooks, webhook deliveries
-- ============================================================================

-- ============================================================================
-- JOBS - Render tasks (video production jobs)
-- ============================================================================

CREATE TABLE jobs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Ownership
    org_id UUID NOT NULL REFERENCES orgs(id) ON DELETE CASCADE,
    project_id UUID REFERENCES projects(id) ON DELETE SET NULL,

    -- Source references
    workflow_id UUID REFERENCES workflows(id) ON DELETE SET NULL,
    template_id UUID REFERENCES templates(id) ON DELETE SET NULL,

    -- Status and progress
    status job_status NOT NULL DEFAULT 'queued',
    progress INTEGER NOT NULL DEFAULT 0,  -- 0-100

    -- Configuration (sources, script, tts, subtitles, output, budget)
    config JSONB NOT NULL,

    -- Results (video_url, thumbnail_url, srt_url, duration, resolution, file_size)
    result JSONB,

    -- Error info (code, message, stage, retryable, details)
    error JSONB,

    -- Cost tracking (accumulated during execution)
    cost_tokens INTEGER NOT NULL DEFAULT 0,
    cost_render_seconds DECIMAL(10, 2) NOT NULL DEFAULT 0,
    cost_kai_credits INTEGER NOT NULL DEFAULT 0,
    cost_total_usd DECIMAL(10, 4) NOT NULL DEFAULT 0,

    -- Timing
    queued_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    started_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,

    -- Retry handling
    retry_count INTEGER NOT NULL DEFAULT 0,
    max_retries INTEGER NOT NULL DEFAULT 3,
    parent_job_id UUID REFERENCES jobs(id) ON DELETE SET NULL,

    -- Audit
    created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,

    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Constraints
    CONSTRAINT jobs_progress_range CHECK (progress >= 0 AND progress <= 100),
    CONSTRAINT jobs_retry_count_positive CHECK (retry_count >= 0),
    CONSTRAINT jobs_costs_positive CHECK (
        cost_tokens >= 0 AND
        cost_render_seconds >= 0 AND
        cost_kai_credits >= 0 AND
        cost_total_usd >= 0
    )
);

COMMENT ON TABLE jobs IS 'Video render tasks with status tracking and cost accounting';
COMMENT ON COLUMN jobs.config IS 'JSON: sources[], script{}, tts{}, subtitles{}, output{}, budget{}';
COMMENT ON COLUMN jobs.result IS 'JSON: video_url, thumbnail_url, srt_url, duration, resolution, file_size';
COMMENT ON COLUMN jobs.error IS 'JSON: code, message, stage, retryable, details{}';

-- Indexes
CREATE INDEX idx_jobs_org ON jobs(org_id);
CREATE INDEX idx_jobs_project ON jobs(project_id) WHERE project_id IS NOT NULL;
CREATE INDEX idx_jobs_workflow ON jobs(workflow_id) WHERE workflow_id IS NOT NULL;
CREATE INDEX idx_jobs_template ON jobs(template_id) WHERE template_id IS NOT NULL;
CREATE INDEX idx_jobs_status ON jobs(status);
CREATE INDEX idx_jobs_created_by ON jobs(created_by) WHERE created_by IS NOT NULL;
CREATE INDEX idx_jobs_created_at ON jobs(created_at DESC);
CREATE INDEX idx_jobs_queued_at ON jobs(queued_at DESC);
CREATE INDEX idx_jobs_parent ON jobs(parent_job_id) WHERE parent_job_id IS NOT NULL;

-- Composite indexes for common queries
CREATE INDEX idx_jobs_org_status ON jobs(org_id, status);
CREATE INDEX idx_jobs_org_created ON jobs(org_id, created_at DESC);

-- Partial indexes for queue processing
CREATE INDEX idx_jobs_queued ON jobs(queued_at) WHERE status = 'queued';
CREATE INDEX idx_jobs_processing ON jobs(started_at) WHERE status = 'processing';

-- GIN index for JSONB config queries
CREATE INDEX idx_jobs_config ON jobs USING gin(config);

-- ============================================================================
-- JOB_LOGS - Detailed execution logs
-- ============================================================================

CREATE TABLE job_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Parent job
    job_id UUID NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,

    -- Log entry
    level log_level NOT NULL,
    stage job_stage,
    message TEXT NOT NULL,
    data JSONB,

    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE job_logs IS 'Detailed execution logs for debugging and monitoring';
COMMENT ON COLUMN job_logs.stage IS 'Execution stage: ingest, script, tts, subtitle, edit, export';
COMMENT ON COLUMN job_logs.data IS 'Additional structured data for the log entry';

-- Indexes
CREATE INDEX idx_job_logs_job ON job_logs(job_id);
CREATE INDEX idx_job_logs_level ON job_logs(level);
CREATE INDEX idx_job_logs_stage ON job_logs(stage) WHERE stage IS NOT NULL;
CREATE INDEX idx_job_logs_created_at ON job_logs(created_at DESC);

-- Composite for filtering by job and level
CREATE INDEX idx_job_logs_job_level ON job_logs(job_id, level);

-- ============================================================================
-- RENDERS - Output artifacts (final video files)
-- ============================================================================

CREATE TABLE renders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Parent job
    job_id UUID NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,

    -- Output files
    video_url TEXT NOT NULL,
    video_storage_path TEXT NOT NULL,
    thumbnail_url TEXT,
    srt_url TEXT,

    -- Video properties
    duration_seconds DECIMAL(10, 2),
    resolution TEXT,  -- "1080x1920"
    file_size_bytes BIGINT,
    codec TEXT,  -- "h264", "h265"
    bitrate_kbps INTEGER,
    fps DECIMAL(5, 2),

    -- Additional metadata
    metadata JSONB NOT NULL DEFAULT '{}',

    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Constraints
    CONSTRAINT renders_video_url_not_empty CHECK (char_length(video_url) >= 1),
    CONSTRAINT renders_storage_path_not_empty CHECK (char_length(video_storage_path) >= 1),
    CONSTRAINT renders_duration_positive CHECK (duration_seconds IS NULL OR duration_seconds >= 0),
    CONSTRAINT renders_file_size_positive CHECK (file_size_bytes IS NULL OR file_size_bytes >= 0),
    CONSTRAINT renders_bitrate_positive CHECK (bitrate_kbps IS NULL OR bitrate_kbps > 0),
    CONSTRAINT renders_fps_positive CHECK (fps IS NULL OR fps > 0)
);

COMMENT ON TABLE renders IS 'Final render output artifacts (video files, subtitles, thumbnails)';

-- Indexes
CREATE INDEX idx_renders_job ON renders(job_id);
CREATE INDEX idx_renders_created_at ON renders(created_at DESC);

-- ============================================================================
-- SCHEDULES - Cron schedules for automated workflow execution
-- ============================================================================

CREATE TABLE schedules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Ownership
    org_id UUID NOT NULL REFERENCES orgs(id) ON DELETE CASCADE,
    workflow_id UUID NOT NULL REFERENCES workflows(id) ON DELETE CASCADE,

    -- Cron configuration
    cron TEXT NOT NULL,  -- "0 10 * * *" (daily at 10:00)
    timezone TEXT NOT NULL DEFAULT 'UTC',

    -- State
    enabled BOOLEAN NOT NULL DEFAULT TRUE,

    -- Execution tracking
    last_run_at TIMESTAMPTZ,
    next_run_at TIMESTAMPTZ,
    run_count INTEGER NOT NULL DEFAULT 0,

    -- Audit
    created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,

    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Constraints
    CONSTRAINT schedules_cron_not_empty CHECK (char_length(cron) >= 5),
    CONSTRAINT schedules_timezone_not_empty CHECK (char_length(timezone) >= 1),
    CONSTRAINT schedules_run_count_positive CHECK (run_count >= 0)
);

COMMENT ON TABLE schedules IS 'Cron schedules for automated workflow execution';
COMMENT ON COLUMN schedules.cron IS 'Standard cron expression: minute hour day month weekday';
COMMENT ON COLUMN schedules.timezone IS 'IANA timezone (e.g., UTC, America/New_York)';

-- Indexes
CREATE INDEX idx_schedules_org ON schedules(org_id);
CREATE INDEX idx_schedules_workflow ON schedules(workflow_id);
CREATE INDEX idx_schedules_created_at ON schedules(created_at DESC);

-- Partial index for scheduler to find due jobs
CREATE INDEX idx_schedules_enabled ON schedules(next_run_at) WHERE enabled = TRUE;

-- ============================================================================
-- WEBHOOKS - Webhook configurations for notifications
-- ============================================================================

CREATE TABLE webhooks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Ownership
    org_id UUID NOT NULL REFERENCES orgs(id) ON DELETE CASCADE,

    -- Configuration
    url TEXT NOT NULL,
    events TEXT[] NOT NULL,  -- ["job.completed", "job.failed"]
    secret TEXT NOT NULL,  -- For HMAC signature verification

    -- State
    enabled BOOLEAN NOT NULL DEFAULT TRUE,

    -- Audit
    created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,

    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Constraints
    CONSTRAINT webhooks_url_valid CHECK (url ~ '^https?://'),
    CONSTRAINT webhooks_events_not_empty CHECK (array_length(events, 1) > 0),
    CONSTRAINT webhooks_secret_not_empty CHECK (char_length(secret) >= 16)
);

COMMENT ON TABLE webhooks IS 'Webhook endpoints for event notifications';
COMMENT ON COLUMN webhooks.events IS 'Array of events to subscribe: job.started, job.completed, job.failed, quota.warning, etc.';
COMMENT ON COLUMN webhooks.secret IS 'Shared secret for HMAC-SHA256 signature verification';

-- Indexes
CREATE INDEX idx_webhooks_org ON webhooks(org_id);
CREATE INDEX idx_webhooks_enabled ON webhooks(org_id) WHERE enabled = TRUE;
CREATE INDEX idx_webhooks_events ON webhooks USING gin(events);

-- ============================================================================
-- WEBHOOK_DELIVERIES - Delivery tracking for webhooks
-- ============================================================================

CREATE TABLE webhook_deliveries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Parent webhook
    webhook_id UUID NOT NULL REFERENCES webhooks(id) ON DELETE CASCADE,

    -- Payload
    event TEXT NOT NULL,
    payload JSONB NOT NULL,

    -- Delivery status
    status webhook_status NOT NULL DEFAULT 'pending',

    -- HTTP response
    http_status INTEGER,
    response_body TEXT,

    -- Retry handling
    attempts INTEGER NOT NULL DEFAULT 0,
    max_attempts INTEGER NOT NULL DEFAULT 5,
    last_attempt_at TIMESTAMPTZ,
    next_retry_at TIMESTAMPTZ,

    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Constraints
    CONSTRAINT webhook_deliveries_attempts_positive CHECK (attempts >= 0),
    CONSTRAINT webhook_deliveries_http_status_valid CHECK (
        http_status IS NULL OR (http_status >= 100 AND http_status < 600)
    )
);

COMMENT ON TABLE webhook_deliveries IS 'Tracks individual webhook delivery attempts';
COMMENT ON COLUMN webhook_deliveries.attempts IS 'Number of delivery attempts made';
COMMENT ON COLUMN webhook_deliveries.next_retry_at IS 'When to retry (exponential backoff)';

-- Indexes
CREATE INDEX idx_webhook_deliveries_webhook ON webhook_deliveries(webhook_id);
CREATE INDEX idx_webhook_deliveries_status ON webhook_deliveries(status);
CREATE INDEX idx_webhook_deliveries_created_at ON webhook_deliveries(created_at DESC);

-- Partial index for retry processing
CREATE INDEX idx_webhook_deliveries_pending ON webhook_deliveries(next_retry_at)
    WHERE status = 'pending' AND next_retry_at IS NOT NULL;
