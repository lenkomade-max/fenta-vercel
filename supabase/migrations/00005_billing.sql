-- ============================================================================
-- Migration: 00005_billing.sql
-- Description: Usage tracking, quotas, invoices, credit packs, integrations, KAI generations
-- ============================================================================

-- ============================================================================
-- USAGE_RECORDS - Detailed usage tracking (PARTITIONED by month)
-- ============================================================================

CREATE TABLE usage_records (
    id UUID NOT NULL DEFAULT gen_random_uuid(),

    -- Ownership
    org_id UUID NOT NULL,  -- No FK due to partitioning; enforced at app level
    user_id UUID,
    job_id UUID,

    -- Resource type
    resource_type resource_type NOT NULL,

    -- LLM tokens (when resource_type = 'llm_tokens')
    llm_tokens_prompt INTEGER,
    llm_tokens_output INTEGER,
    llm_model TEXT,

    -- KAI credits (when resource_type = 'kai_credits')
    kai_credits INTEGER,
    kai_model TEXT,

    -- Render seconds (when resource_type = 'render_seconds')
    render_seconds DECIMAL(10, 2),
    render_profile TEXT,

    -- Storage (when resource_type = 'storage')
    storage_bytes BIGINT,

    -- Cost in USD
    cost_usd DECIMAL(10, 4) NOT NULL,

    -- Partition key
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Primary key includes partition column
    PRIMARY KEY (id, created_at),

    -- Constraints
    CONSTRAINT usage_records_cost_positive CHECK (cost_usd >= 0),
    CONSTRAINT usage_records_tokens_positive CHECK (
        llm_tokens_prompt IS NULL OR llm_tokens_prompt >= 0
    ),
    CONSTRAINT usage_records_kai_positive CHECK (
        kai_credits IS NULL OR kai_credits >= 0
    ),
    CONSTRAINT usage_records_render_positive CHECK (
        render_seconds IS NULL OR render_seconds >= 0
    ),
    CONSTRAINT usage_records_storage_positive CHECK (
        storage_bytes IS NULL OR storage_bytes >= 0
    )
) PARTITION BY RANGE (created_at);

COMMENT ON TABLE usage_records IS 'Detailed usage metering, partitioned by month for performance';
COMMENT ON COLUMN usage_records.resource_type IS 'Type of resource: llm_tokens, kai_credits, render_seconds, storage';

-- Create partitions for current and next 6 months
CREATE TABLE usage_records_2024_12 PARTITION OF usage_records
    FOR VALUES FROM ('2024-12-01') TO ('2025-01-01');

CREATE TABLE usage_records_2025_01 PARTITION OF usage_records
    FOR VALUES FROM ('2025-01-01') TO ('2025-02-01');

CREATE TABLE usage_records_2025_02 PARTITION OF usage_records
    FOR VALUES FROM ('2025-02-01') TO ('2025-03-01');

CREATE TABLE usage_records_2025_03 PARTITION OF usage_records
    FOR VALUES FROM ('2025-03-01') TO ('2025-04-01');

CREATE TABLE usage_records_2025_04 PARTITION OF usage_records
    FOR VALUES FROM ('2025-04-01') TO ('2025-05-01');

CREATE TABLE usage_records_2025_05 PARTITION OF usage_records
    FOR VALUES FROM ('2025-05-01') TO ('2025-06-01');

CREATE TABLE usage_records_2025_06 PARTITION OF usage_records
    FOR VALUES FROM ('2025-06-01') TO ('2025-07-01');

-- Indexes on partitioned table (automatically created on all partitions)
CREATE INDEX idx_usage_records_org_date ON usage_records(org_id, created_at DESC);
CREATE INDEX idx_usage_records_user ON usage_records(user_id) WHERE user_id IS NOT NULL;
CREATE INDEX idx_usage_records_job ON usage_records(job_id) WHERE job_id IS NOT NULL;
CREATE INDEX idx_usage_records_resource ON usage_records(resource_type);

-- ============================================================================
-- QUOTA_LIMITS - Organization usage limits and current usage
-- ============================================================================

CREATE TABLE quota_limits (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- One record per org
    org_id UUID NOT NULL REFERENCES orgs(id) ON DELETE CASCADE,

    -- Monthly limits (NULL = unlimited)
    tokens_limit INTEGER,
    render_seconds_limit INTEGER,
    kai_credits_limit INTEGER,
    storage_bytes_limit BIGINT,

    -- Current usage (reset monthly)
    tokens_used INTEGER NOT NULL DEFAULT 0,
    render_seconds_used DECIMAL(10, 2) NOT NULL DEFAULT 0,
    kai_credits_used INTEGER NOT NULL DEFAULT 0,
    storage_bytes_used BIGINT NOT NULL DEFAULT 0,

    -- Overage settings
    allow_overage BOOLEAN NOT NULL DEFAULT TRUE,
    overage_cap_usd DECIMAL(10, 2),  -- Maximum overage spend (NULL = no cap)

    -- Reset timestamp (beginning of next billing period)
    reset_at TIMESTAMPTZ NOT NULL,

    -- Timestamps
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Constraints
    CONSTRAINT quota_limits_org_unique UNIQUE (org_id),
    CONSTRAINT quota_limits_usage_positive CHECK (
        tokens_used >= 0 AND
        render_seconds_used >= 0 AND
        kai_credits_used >= 0 AND
        storage_bytes_used >= 0
    ),
    CONSTRAINT quota_limits_limits_positive CHECK (
        (tokens_limit IS NULL OR tokens_limit >= 0) AND
        (render_seconds_limit IS NULL OR render_seconds_limit >= 0) AND
        (kai_credits_limit IS NULL OR kai_credits_limit >= 0) AND
        (storage_bytes_limit IS NULL OR storage_bytes_limit >= 0)
    ),
    CONSTRAINT quota_limits_overage_cap_positive CHECK (
        overage_cap_usd IS NULL OR overage_cap_usd >= 0
    )
);

COMMENT ON TABLE quota_limits IS 'Per-org usage limits and current consumption';
COMMENT ON COLUMN quota_limits.reset_at IS 'When quotas reset (start of next billing period)';
COMMENT ON COLUMN quota_limits.allow_overage IS 'If true, allow usage beyond limits (billed as overage)';

-- Indexes
CREATE INDEX idx_quota_limits_org ON quota_limits(org_id);
CREATE INDEX idx_quota_limits_reset ON quota_limits(reset_at);

-- ============================================================================
-- INVOICES - Billing invoices
-- ============================================================================

CREATE TABLE invoices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Ownership
    org_id UUID NOT NULL REFERENCES orgs(id) ON DELETE CASCADE,

    -- Stripe reference
    stripe_invoice_id TEXT,

    -- Amount
    amount_usd DECIMAL(10, 2) NOT NULL,

    -- Status
    status invoice_status NOT NULL,

    -- Billing period
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,

    -- Line items breakdown
    line_items JSONB NOT NULL DEFAULT '[]',

    -- Payment tracking
    paid_at TIMESTAMPTZ,

    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Constraints
    CONSTRAINT invoices_stripe_unique UNIQUE (stripe_invoice_id),
    CONSTRAINT invoices_amount_positive CHECK (amount_usd >= 0),
    CONSTRAINT invoices_period_valid CHECK (period_start <= period_end)
);

COMMENT ON TABLE invoices IS 'Billing invoices synced from Stripe';
COMMENT ON COLUMN invoices.line_items IS 'Array of {description, quantity, unit_price, amount}';

-- Indexes
CREATE INDEX idx_invoices_org ON invoices(org_id);
CREATE INDEX idx_invoices_stripe ON invoices(stripe_invoice_id) WHERE stripe_invoice_id IS NOT NULL;
CREATE INDEX idx_invoices_status ON invoices(status);
CREATE INDEX idx_invoices_period ON invoices(period_start, period_end);
CREATE INDEX idx_invoices_created_at ON invoices(created_at DESC);

-- ============================================================================
-- CREDIT_PACKS - Prepaid credit packages
-- ============================================================================

CREATE TABLE credit_packs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Ownership
    org_id UUID NOT NULL REFERENCES orgs(id) ON DELETE CASCADE,

    -- Pack details
    pack_type credit_pack_type NOT NULL,
    credits_purchased INTEGER NOT NULL,
    credits_remaining INTEGER NOT NULL,
    price_usd DECIMAL(10, 2) NOT NULL,

    -- Stripe reference
    stripe_payment_id TEXT,

    -- Lifecycle
    purchased_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    expires_at TIMESTAMPTZ,  -- NULL = never expires

    -- Constraints
    CONSTRAINT credit_packs_credits_valid CHECK (
        credits_purchased > 0 AND
        credits_remaining >= 0 AND
        credits_remaining <= credits_purchased
    ),
    CONSTRAINT credit_packs_price_positive CHECK (price_usd > 0)
);

COMMENT ON TABLE credit_packs IS 'Prepaid KAI credit packages';
COMMENT ON COLUMN credit_packs.expires_at IS 'Expiration date (NULL = never)';

-- Indexes
CREATE INDEX idx_credit_packs_org ON credit_packs(org_id);
CREATE INDEX idx_credit_packs_expires ON credit_packs(expires_at) WHERE expires_at IS NOT NULL;
CREATE INDEX idx_credit_packs_purchased ON credit_packs(purchased_at DESC);

-- Partial index for available packs
CREATE INDEX idx_credit_packs_available ON credit_packs(org_id, purchased_at)
    WHERE credits_remaining > 0;

-- ============================================================================
-- INTEGRATIONS - External service connections
-- ============================================================================

CREATE TABLE integrations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Ownership
    org_id UUID NOT NULL REFERENCES orgs(id) ON DELETE CASCADE,

    -- Provider details
    provider integration_provider NOT NULL,
    status integration_status NOT NULL DEFAULT 'active',

    -- Credentials (encrypted at rest by Supabase)
    credentials JSONB NOT NULL,

    -- Provider-specific configuration
    config JSONB NOT NULL DEFAULT '{}',

    -- Lifecycle
    last_used_at TIMESTAMPTZ,
    expires_at TIMESTAMPTZ,

    -- Audit
    created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,

    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Constraints
    CONSTRAINT integrations_credentials_not_empty CHECK (credentials != '{}')
);

COMMENT ON TABLE integrations IS 'External service integrations (API keys, OAuth tokens)';
COMMENT ON COLUMN integrations.credentials IS 'Encrypted API keys or OAuth tokens';
COMMENT ON COLUMN integrations.config IS 'Provider-specific settings (default models, rate limits)';

-- Indexes
CREATE INDEX idx_integrations_org ON integrations(org_id);
CREATE INDEX idx_integrations_provider ON integrations(provider);
CREATE INDEX idx_integrations_status ON integrations(status);

-- Composite for finding active integrations
CREATE INDEX idx_integrations_org_provider ON integrations(org_id, provider)
    WHERE status = 'active';

-- ============================================================================
-- KAI_GENERATIONS - AI generation tracking
-- ============================================================================

CREATE TABLE kai_generations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Ownership
    org_id UUID NOT NULL REFERENCES orgs(id) ON DELETE CASCADE,
    job_id UUID REFERENCES jobs(id) ON DELETE SET NULL,

    -- Generation details
    type kai_generation_type NOT NULL,
    model TEXT NOT NULL,

    -- Input
    prompt TEXT NOT NULL,
    params JSONB NOT NULL DEFAULT '{}',

    -- Status
    status job_status NOT NULL DEFAULT 'queued',

    -- Results (asset IDs created by this generation)
    result_asset_ids UUID[],

    -- Cost
    credits_used INTEGER NOT NULL DEFAULT 0,
    cost_usd DECIMAL(10, 4) NOT NULL DEFAULT 0,

    -- External tracking (KIE.ai task ID)
    external_task_id TEXT,

    -- Audit
    created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,

    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    completed_at TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT kai_generations_prompt_not_empty CHECK (char_length(prompt) >= 1),
    CONSTRAINT kai_generations_model_not_empty CHECK (char_length(model) >= 1),
    CONSTRAINT kai_generations_credits_positive CHECK (credits_used >= 0),
    CONSTRAINT kai_generations_cost_positive CHECK (cost_usd >= 0)
);

COMMENT ON TABLE kai_generations IS 'Tracks all KIE.ai AI generations (images, videos, audio)';
COMMENT ON COLUMN kai_generations.external_task_id IS 'KIE.ai taskId for polling status';
COMMENT ON COLUMN kai_generations.result_asset_ids IS 'Array of asset IDs created by this generation';

-- Indexes
CREATE INDEX idx_kai_generations_org ON kai_generations(org_id);
CREATE INDEX idx_kai_generations_job ON kai_generations(job_id) WHERE job_id IS NOT NULL;
CREATE INDEX idx_kai_generations_type ON kai_generations(type);
CREATE INDEX idx_kai_generations_model ON kai_generations(model);
CREATE INDEX idx_kai_generations_status ON kai_generations(status);
CREATE INDEX idx_kai_generations_created_at ON kai_generations(created_at DESC);

-- For polling by external task ID
CREATE INDEX idx_kai_generations_external ON kai_generations(external_task_id)
    WHERE external_task_id IS NOT NULL;

-- Partial index for pending generations
CREATE INDEX idx_kai_generations_pending ON kai_generations(created_at)
    WHERE status IN ('queued', 'processing');
