-- ============================================================================
-- Migration: 00008_indexes.sql
-- Description: Additional optimized indexes for query performance
-- ============================================================================

-- ============================================================================
-- COMPOSITE INDEXES FOR COMMON QUERY PATTERNS
-- ============================================================================

-- Dashboard: Recent jobs by org with status filter
CREATE INDEX IF NOT EXISTS idx_jobs_org_status_created
    ON jobs(org_id, status, created_at DESC);

-- Dashboard: Active workflows list
CREATE INDEX IF NOT EXISTS idx_workflows_org_status_updated
    ON workflows(org_id, status, updated_at DESC)
    WHERE deleted_at IS NULL;

-- Dashboard: Recent assets by type
CREATE INDEX IF NOT EXISTS idx_assets_org_type_created
    ON assets(org_id, type, created_at DESC)
    WHERE status = 'ready' AND deleted_at IS NULL;

-- Dashboard: Template gallery sorted by popularity
CREATE INDEX IF NOT EXISTS idx_templates_public_usage
    ON templates(usage_count DESC, created_at DESC)
    WHERE is_public = TRUE AND deleted_at IS NULL;

-- ============================================================================
-- PARTIAL INDEXES FOR COMMON FILTERS
-- ============================================================================

-- Active jobs only (queued or processing)
CREATE INDEX IF NOT EXISTS idx_jobs_active
    ON jobs(org_id, queued_at)
    WHERE status IN ('queued', 'processing');

-- Failed jobs for retry logic
CREATE INDEX IF NOT EXISTS idx_jobs_failed_retryable
    ON jobs(retry_count, created_at)
    WHERE status = 'failed' AND retry_count < 3;

-- Active schedules due for execution
CREATE INDEX IF NOT EXISTS idx_schedules_due
    ON schedules(next_run_at)
    WHERE enabled = TRUE AND next_run_at IS NOT NULL;

-- Valid (non-expired, non-revoked) API keys
CREATE INDEX IF NOT EXISTS idx_api_keys_active
    ON api_keys(key_hash)
    WHERE revoked_at IS NULL AND (expires_at IS NULL OR expires_at > NOW());

-- Credit packs with remaining credits
CREATE INDEX IF NOT EXISTS idx_credit_packs_active
    ON credit_packs(org_id, purchased_at DESC)
    WHERE credits_remaining > 0 AND (expires_at IS NULL OR expires_at > NOW());

-- Pending webhook deliveries for retry processor
CREATE INDEX IF NOT EXISTS idx_webhook_deliveries_retry
    ON webhook_deliveries(next_retry_at)
    WHERE status = 'pending' AND attempts < 5;

-- Active integrations by provider
CREATE INDEX IF NOT EXISTS idx_integrations_active_provider
    ON integrations(org_id, provider)
    WHERE status = 'active';

-- Pending KAI generations for polling
CREATE INDEX IF NOT EXISTS idx_kai_generations_polling
    ON kai_generations(external_task_id, created_at)
    WHERE status IN ('queued', 'processing') AND external_task_id IS NOT NULL;

-- ============================================================================
-- GIN INDEXES FOR JSONB SEARCH (if not already created)
-- ============================================================================

-- Template spec search (e.g., find templates with specific track types)
CREATE INDEX IF NOT EXISTS idx_templates_spec_gin
    ON templates USING gin(spec jsonb_path_ops);

-- Workflow graph search (e.g., find workflows using specific node types)
CREATE INDEX IF NOT EXISTS idx_workflows_graph_gin
    ON workflows USING gin(graph jsonb_path_ops);

-- Asset metadata search (e.g., find assets by tags)
CREATE INDEX IF NOT EXISTS idx_assets_metadata_gin
    ON assets USING gin(metadata jsonb_path_ops);

-- Job config search (e.g., find jobs with specific sources)
CREATE INDEX IF NOT EXISTS idx_jobs_config_gin
    ON jobs USING gin(config jsonb_path_ops);

-- Profile metadata search
CREATE INDEX IF NOT EXISTS idx_profiles_metadata_gin
    ON profiles USING gin(metadata jsonb_path_ops);

-- Org settings search
CREATE INDEX IF NOT EXISTS idx_orgs_settings_gin
    ON orgs USING gin(settings jsonb_path_ops);

-- ============================================================================
-- INDEXES FOR FOREIGN KEY JOINS
-- ============================================================================

-- These improve JOIN performance on foreign keys not covered by existing indexes

-- Job to workflow join (for workflow run history)
CREATE INDEX IF NOT EXISTS idx_jobs_workflow_created
    ON jobs(workflow_id, created_at DESC)
    WHERE workflow_id IS NOT NULL;

-- Job to template join (for template usage history)
CREATE INDEX IF NOT EXISTS idx_jobs_template_created
    ON jobs(template_id, created_at DESC)
    WHERE template_id IS NOT NULL;

-- Assets by project (for project asset gallery)
CREATE INDEX IF NOT EXISTS idx_assets_project_type
    ON assets(project_id, type, created_at DESC)
    WHERE project_id IS NOT NULL AND deleted_at IS NULL;

-- Workflows by project
CREATE INDEX IF NOT EXISTS idx_workflows_project_status
    ON workflows(project_id, status)
    WHERE project_id IS NOT NULL AND deleted_at IS NULL;

-- Templates by project
CREATE INDEX IF NOT EXISTS idx_templates_project_created
    ON templates(project_id, created_at DESC)
    WHERE project_id IS NOT NULL AND deleted_at IS NULL;

-- ============================================================================
-- INDEXES FOR BILLING AND ANALYTICS
-- ============================================================================

-- Usage records by date range (for billing reports)
-- Note: Partitioned table, index exists on parent and propagates to partitions
CREATE INDEX IF NOT EXISTS idx_usage_records_org_resource_date
    ON usage_records(org_id, resource_type, created_at DESC);

-- Invoices by org and status (for payment follow-up)
CREATE INDEX IF NOT EXISTS idx_invoices_org_status_created
    ON invoices(org_id, status, created_at DESC);

-- KAI generations cost tracking
CREATE INDEX IF NOT EXISTS idx_kai_generations_org_created
    ON kai_generations(org_id, created_at DESC);

-- ============================================================================
-- INDEXES FOR SEARCH FUNCTIONALITY
-- ============================================================================

-- Full-text search on workflow names (if pg_trgm extension enabled)
-- CREATE INDEX IF NOT EXISTS idx_workflows_name_trgm
--     ON workflows USING gin(name gin_trgm_ops);

-- Full-text search on template names
-- CREATE INDEX IF NOT EXISTS idx_templates_name_trgm
--     ON templates USING gin(name gin_trgm_ops);

-- Full-text search on asset filenames
-- CREATE INDEX IF NOT EXISTS idx_assets_filename_trgm
--     ON assets USING gin(filename gin_trgm_ops);

-- ============================================================================
-- COVERING INDEXES FOR COMMON QUERIES
-- ============================================================================

-- Org member lookup with role (avoids table lookup for simple permission checks)
CREATE INDEX IF NOT EXISTS idx_org_members_user_org_role
    ON org_members(user_id, org_id) INCLUDE (role);

-- Job status with progress (for dashboard cards)
CREATE INDEX IF NOT EXISTS idx_jobs_org_recent
    ON jobs(org_id, created_at DESC) INCLUDE (status, progress);

-- ============================================================================
-- UNIQUE CONSTRAINTS AS INDEXES
-- ============================================================================

-- Ensure unique slug per org for projects (if needed)
-- CREATE UNIQUE INDEX IF NOT EXISTS idx_projects_org_slug
--     ON projects(org_id, lower(name))
--     WHERE deleted_at IS NULL;

-- ============================================================================
-- MAINTENANCE NOTES
-- ============================================================================

/*
Index Maintenance Commands:

-- Check index usage statistics
SELECT
    schemaname,
    relname,
    indexrelname,
    idx_scan,
    idx_tup_read,
    idx_tup_fetch
FROM pg_stat_user_indexes
WHERE schemaname = 'public'
ORDER BY idx_scan DESC;

-- Find unused indexes (candidates for removal)
SELECT
    schemaname || '.' || relname AS table,
    indexrelname AS index,
    pg_size_pretty(pg_relation_size(i.indexrelid)) AS index_size,
    idx_scan as index_scans
FROM pg_stat_user_indexes ui
JOIN pg_index i ON ui.indexrelid = i.indexrelid
WHERE NOT indisunique
    AND idx_scan < 50
    AND pg_relation_size(relid) > 5 * pg_relation_size(i.indexrelid)
ORDER BY pg_relation_size(i.indexrelid) DESC;

-- Reindex bloated indexes (run during low traffic)
-- REINDEX INDEX CONCURRENTLY idx_jobs_org_status_created;

-- Analyze tables after bulk operations
-- ANALYZE jobs;
-- ANALYZE usage_records;
*/
