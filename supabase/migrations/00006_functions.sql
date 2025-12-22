-- ============================================================================
-- Migration: 00006_functions.sql
-- Description: Triggers, functions, and materialized views
-- ============================================================================

-- ============================================================================
-- TRIGGER: Auto-create profile on user signup
-- ============================================================================

CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
    INSERT INTO profiles (id, name, role, status, metadata)
    VALUES (
        NEW.id,
        COALESCE(NEW.raw_user_meta_data->>'name', NEW.raw_user_meta_data->>'full_name'),
        'user',
        'active',
        COALESCE(
            jsonb_build_object(
                'avatar_url', NEW.raw_user_meta_data->>'avatar_url',
                'provider', NEW.raw_app_meta_data->>'provider'
            ),
            '{}'::jsonb
        )
    );
    RETURN NEW;
EXCEPTION
    WHEN unique_violation THEN
        -- Profile already exists, ignore
        RETURN NEW;
END;
$$;

COMMENT ON FUNCTION handle_new_user() IS 'Auto-creates profile when user signs up via Supabase Auth';

-- Attach trigger to auth.users
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION handle_new_user();

-- ============================================================================
-- TRIGGER: Auto-update updated_at timestamp
-- ============================================================================

CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;

COMMENT ON FUNCTION update_updated_at() IS 'Updates updated_at column on row modification';

-- Apply to all tables with updated_at
CREATE TRIGGER set_updated_at BEFORE UPDATE ON profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER set_updated_at BEFORE UPDATE ON orgs
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER set_updated_at BEFORE UPDATE ON projects
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER set_updated_at BEFORE UPDATE ON templates
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER set_updated_at BEFORE UPDATE ON workflows
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER set_updated_at BEFORE UPDATE ON assets
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER set_updated_at BEFORE UPDATE ON jobs
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER set_updated_at BEFORE UPDATE ON schedules
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER set_updated_at BEFORE UPDATE ON webhooks
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER set_updated_at BEFORE UPDATE ON quota_limits
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER set_updated_at BEFORE UPDATE ON integrations
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ============================================================================
-- TRIGGER: Update quota usage on usage_records INSERT
-- ============================================================================

CREATE OR REPLACE FUNCTION update_quota_usage()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    UPDATE quota_limits
    SET
        tokens_used = tokens_used + COALESCE(NEW.llm_tokens_prompt, 0) + COALESCE(NEW.llm_tokens_output, 0),
        kai_credits_used = kai_credits_used + COALESCE(NEW.kai_credits, 0),
        render_seconds_used = render_seconds_used + COALESCE(NEW.render_seconds, 0),
        storage_bytes_used = storage_bytes_used + COALESCE(NEW.storage_bytes, 0)
    WHERE org_id = NEW.org_id;

    RETURN NEW;
END;
$$;

COMMENT ON FUNCTION update_quota_usage() IS 'Updates quota_limits counters when usage is recorded';

-- Note: For partitioned tables, triggers must be created on each partition
-- This is handled automatically when using CREATE TRIGGER on the parent table in PostgreSQL 13+

CREATE TRIGGER trigger_update_quota
    AFTER INSERT ON usage_records
    FOR EACH ROW
    EXECUTE FUNCTION update_quota_usage();

-- ============================================================================
-- FUNCTION: Check quota before job execution
-- ============================================================================

CREATE OR REPLACE FUNCTION check_quota(
    p_org_id UUID,
    p_tokens INTEGER DEFAULT 0,
    p_kai_credits INTEGER DEFAULT 0,
    p_render_seconds DECIMAL DEFAULT 0,
    p_storage_bytes BIGINT DEFAULT 0
)
RETURNS TABLE (
    allowed BOOLEAN,
    tokens_ok BOOLEAN,
    kai_ok BOOLEAN,
    render_ok BOOLEAN,
    storage_ok BOOLEAN,
    tokens_remaining INTEGER,
    kai_remaining INTEGER,
    render_remaining DECIMAL,
    storage_remaining BIGINT
)
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
AS $$
DECLARE
    v_quota quota_limits%ROWTYPE;
BEGIN
    -- Get current quota limits
    SELECT * INTO v_quota FROM quota_limits WHERE org_id = p_org_id;

    -- If no quota record exists, allow everything (treat as unlimited)
    IF NOT FOUND THEN
        RETURN QUERY SELECT
            TRUE::BOOLEAN,
            TRUE::BOOLEAN,
            TRUE::BOOLEAN,
            TRUE::BOOLEAN,
            TRUE::BOOLEAN,
            NULL::INTEGER,
            NULL::INTEGER,
            NULL::DECIMAL,
            NULL::BIGINT;
        RETURN;
    END IF;

    -- Calculate remaining quotas
    tokens_remaining := CASE
        WHEN v_quota.tokens_limit IS NULL THEN NULL
        ELSE GREATEST(0, v_quota.tokens_limit - v_quota.tokens_used)
    END;

    kai_remaining := CASE
        WHEN v_quota.kai_credits_limit IS NULL THEN NULL
        ELSE GREATEST(0, v_quota.kai_credits_limit - v_quota.kai_credits_used)
    END;

    render_remaining := CASE
        WHEN v_quota.render_seconds_limit IS NULL THEN NULL
        ELSE GREATEST(0, v_quota.render_seconds_limit - v_quota.render_seconds_used)
    END;

    storage_remaining := CASE
        WHEN v_quota.storage_bytes_limit IS NULL THEN NULL
        ELSE GREATEST(0, v_quota.storage_bytes_limit - v_quota.storage_bytes_used)
    END;

    -- Check if each resource is within limits (or unlimited, or overage allowed)
    tokens_ok := v_quota.tokens_limit IS NULL
        OR (v_quota.tokens_used + p_tokens <= v_quota.tokens_limit)
        OR v_quota.allow_overage;

    kai_ok := v_quota.kai_credits_limit IS NULL
        OR (v_quota.kai_credits_used + p_kai_credits <= v_quota.kai_credits_limit)
        OR v_quota.allow_overage;

    render_ok := v_quota.render_seconds_limit IS NULL
        OR (v_quota.render_seconds_used + p_render_seconds <= v_quota.render_seconds_limit)
        OR v_quota.allow_overage;

    storage_ok := v_quota.storage_bytes_limit IS NULL
        OR (v_quota.storage_bytes_used + p_storage_bytes <= v_quota.storage_bytes_limit)
        OR v_quota.allow_overage;

    allowed := tokens_ok AND kai_ok AND render_ok AND storage_ok;

    RETURN QUERY SELECT
        allowed,
        tokens_ok,
        kai_ok,
        render_ok,
        storage_ok,
        tokens_remaining,
        kai_remaining,
        render_remaining,
        storage_remaining;
END;
$$;

COMMENT ON FUNCTION check_quota IS 'Checks if org has sufficient quota for requested resources';

-- ============================================================================
-- FUNCTION: Initialize quota for new org
-- ============================================================================

CREATE OR REPLACE FUNCTION initialize_org_quota(
    p_org_id UUID,
    p_plan subscription_plan DEFAULT 'free'
)
RETURNS quota_limits
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_quota quota_limits;
    v_reset_at TIMESTAMPTZ;
BEGIN
    -- Calculate reset_at as first day of next month
    v_reset_at := date_trunc('month', NOW()) + INTERVAL '1 month';

    -- Insert quota based on plan
    INSERT INTO quota_limits (
        org_id,
        tokens_limit,
        render_seconds_limit,
        kai_credits_limit,
        storage_bytes_limit,
        allow_overage,
        reset_at
    )
    VALUES (
        p_org_id,
        CASE p_plan
            WHEN 'free' THEN 100000
            WHEN 'starter' THEN 1000000
            WHEN 'pro' THEN 5000000
            WHEN 'enterprise' THEN NULL  -- unlimited
        END,
        CASE p_plan
            WHEN 'free' THEN 300
            WHEN 'starter' THEN 3600
            WHEN 'pro' THEN 10800
            WHEN 'enterprise' THEN NULL  -- unlimited
        END,
        CASE p_plan
            WHEN 'free' THEN 50
            WHEN 'starter' THEN 500
            WHEN 'pro' THEN 2000
            WHEN 'enterprise' THEN NULL  -- unlimited
        END,
        CASE p_plan
            WHEN 'free' THEN 5368709120  -- 5 GB
            WHEN 'starter' THEN 53687091200  -- 50 GB
            WHEN 'pro' THEN 214748364800  -- 200 GB
            WHEN 'enterprise' THEN NULL  -- unlimited
        END,
        CASE p_plan
            WHEN 'free' THEN FALSE
            ELSE TRUE
        END,
        v_reset_at
    )
    RETURNING * INTO v_quota;

    RETURN v_quota;
END;
$$;

COMMENT ON FUNCTION initialize_org_quota IS 'Creates quota_limits record for new org based on subscription plan';

-- ============================================================================
-- FUNCTION: Reset monthly quotas
-- ============================================================================

CREATE OR REPLACE FUNCTION reset_monthly_quotas()
RETURNS INTEGER
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_count INTEGER;
BEGIN
    WITH updated AS (
        UPDATE quota_limits
        SET
            tokens_used = 0,
            render_seconds_used = 0,
            kai_credits_used = 0,
            -- Note: storage_bytes_used is NOT reset (it's cumulative)
            reset_at = date_trunc('month', NOW()) + INTERVAL '1 month',
            updated_at = NOW()
        WHERE reset_at <= NOW()
        RETURNING 1
    )
    SELECT COUNT(*) INTO v_count FROM updated;

    RETURN v_count;
END;
$$;

COMMENT ON FUNCTION reset_monthly_quotas IS 'Resets usage counters for orgs whose billing period has ended (called by cron)';

-- ============================================================================
-- FUNCTION: Get org member role
-- ============================================================================

CREATE OR REPLACE FUNCTION get_org_member_role(p_user_id UUID, p_org_id UUID)
RETURNS org_role
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
    SELECT role FROM org_members
    WHERE user_id = p_user_id AND org_id = p_org_id
    LIMIT 1;
$$;

COMMENT ON FUNCTION get_org_member_role IS 'Returns user role within an organization (for RLS policies)';

-- ============================================================================
-- FUNCTION: Check if user is org member
-- ============================================================================

CREATE OR REPLACE FUNCTION is_org_member(p_user_id UUID, p_org_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
    SELECT EXISTS (
        SELECT 1 FROM org_members
        WHERE user_id = p_user_id AND org_id = p_org_id
    );
$$;

COMMENT ON FUNCTION is_org_member IS 'Checks if user is a member of the organization';

-- ============================================================================
-- FUNCTION: Get user org IDs
-- ============================================================================

CREATE OR REPLACE FUNCTION get_user_org_ids(p_user_id UUID)
RETURNS SETOF UUID
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
    SELECT org_id FROM org_members WHERE user_id = p_user_id;
$$;

COMMENT ON FUNCTION get_user_org_ids IS 'Returns all org IDs that user belongs to (for RLS)';

-- ============================================================================
-- MATERIALIZED VIEW: Daily usage aggregation
-- ============================================================================

CREATE MATERIALIZED VIEW mv_daily_usage AS
SELECT
    org_id,
    DATE(created_at) AS date,

    -- Token aggregates
    SUM(CASE
        WHEN resource_type = 'llm_tokens'
        THEN COALESCE(llm_tokens_prompt, 0) + COALESCE(llm_tokens_output, 0)
        ELSE 0
    END)::INTEGER AS total_tokens,

    SUM(CASE
        WHEN resource_type = 'llm_tokens'
        THEN COALESCE(llm_tokens_prompt, 0)
        ELSE 0
    END)::INTEGER AS prompt_tokens,

    SUM(CASE
        WHEN resource_type = 'llm_tokens'
        THEN COALESCE(llm_tokens_output, 0)
        ELSE 0
    END)::INTEGER AS output_tokens,

    -- KAI credits aggregate
    SUM(CASE
        WHEN resource_type = 'kai_credits'
        THEN COALESCE(kai_credits, 0)
        ELSE 0
    END)::INTEGER AS total_kai_credits,

    -- Render seconds aggregate
    SUM(CASE
        WHEN resource_type = 'render_seconds'
        THEN COALESCE(render_seconds, 0)
        ELSE 0
    END)::DECIMAL(12, 2) AS total_render_seconds,

    -- Storage delta (can be positive or negative)
    SUM(CASE
        WHEN resource_type = 'storage'
        THEN COALESCE(storage_bytes, 0)
        ELSE 0
    END)::BIGINT AS storage_delta_bytes,

    -- Cost aggregate
    SUM(cost_usd)::DECIMAL(12, 4) AS total_cost_usd,

    -- Job count
    COUNT(DISTINCT job_id)::INTEGER AS job_count,

    -- Record count
    COUNT(*)::INTEGER AS record_count

FROM usage_records
GROUP BY org_id, DATE(created_at);

COMMENT ON MATERIALIZED VIEW mv_daily_usage IS 'Aggregated daily usage statistics per org';

-- Unique index for CONCURRENTLY refresh
CREATE UNIQUE INDEX idx_mv_daily_usage_pk ON mv_daily_usage(org_id, date);

-- Additional indexes for queries
CREATE INDEX idx_mv_daily_usage_date ON mv_daily_usage(date DESC);
CREATE INDEX idx_mv_daily_usage_cost ON mv_daily_usage(total_cost_usd DESC);

-- ============================================================================
-- FUNCTION: Refresh daily usage view
-- ============================================================================

CREATE OR REPLACE FUNCTION refresh_daily_usage()
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY mv_daily_usage;
END;
$$;

COMMENT ON FUNCTION refresh_daily_usage IS 'Refreshes mv_daily_usage materialized view (call hourly via cron)';

-- ============================================================================
-- FUNCTION: Increment template usage count
-- ============================================================================

CREATE OR REPLACE FUNCTION increment_template_usage(p_template_id UUID)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    UPDATE templates
    SET usage_count = usage_count + 1
    WHERE id = p_template_id;
END;
$$;

COMMENT ON FUNCTION increment_template_usage IS 'Increments template usage counter when used in a job';

-- ============================================================================
-- FUNCTION: Increment workflow run count
-- ============================================================================

CREATE OR REPLACE FUNCTION increment_workflow_run(p_workflow_id UUID)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    UPDATE workflows
    SET
        run_count = run_count + 1,
        last_run_at = NOW()
    WHERE id = p_workflow_id;
END;
$$;

COMMENT ON FUNCTION increment_workflow_run IS 'Increments workflow run counter and updates last_run_at';

-- ============================================================================
-- FUNCTION: Create workflow version
-- ============================================================================

CREATE OR REPLACE FUNCTION create_workflow_version(
    p_workflow_id UUID,
    p_user_id UUID DEFAULT NULL,
    p_changelog TEXT DEFAULT NULL
)
RETURNS workflow_versions
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_workflow workflows;
    v_version INTEGER;
    v_result workflow_versions;
BEGIN
    -- Get current workflow
    SELECT * INTO v_workflow FROM workflows WHERE id = p_workflow_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Workflow not found: %', p_workflow_id;
    END IF;

    -- Get next version number
    SELECT COALESCE(MAX(version), 0) + 1 INTO v_version
    FROM workflow_versions
    WHERE workflow_id = p_workflow_id;

    -- Create version
    INSERT INTO workflow_versions (workflow_id, version, graph, variables, changelog, created_by)
    VALUES (p_workflow_id, v_version, v_workflow.graph, v_workflow.variables, p_changelog, p_user_id)
    RETURNING * INTO v_result;

    RETURN v_result;
END;
$$;

COMMENT ON FUNCTION create_workflow_version IS 'Creates a new version snapshot of a workflow';
