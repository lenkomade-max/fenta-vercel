-- ============================================================================
-- Migration: 00007_rls_policies.sql
-- Description: Row Level Security policies for multi-tenancy
-- ============================================================================

-- ============================================================================
-- PROFILES - User can only access their own profile
-- ============================================================================

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own profile"
    ON profiles FOR SELECT
    USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
    ON profiles FOR UPDATE
    USING (auth.uid() = id)
    WITH CHECK (auth.uid() = id);

-- No INSERT policy - profiles are created by trigger
-- No DELETE policy - profiles are not deleted directly

-- ============================================================================
-- ORGS - Members can view, owners/admins can modify
-- ============================================================================

ALTER TABLE orgs ENABLE ROW LEVEL SECURITY;

-- Anyone can view orgs they are a member of
CREATE POLICY "Org members can view org"
    ON orgs FOR SELECT
    USING (
        id IN (SELECT org_id FROM org_members WHERE user_id = auth.uid())
    );

-- Only owners can create orgs (they become owner via org_members)
CREATE POLICY "Authenticated users can create orgs"
    ON orgs FOR INSERT
    WITH CHECK (
        auth.uid() = owner_id
    );

-- Owners and admins can update org
CREATE POLICY "Org admins can update org"
    ON orgs FOR UPDATE
    USING (
        id IN (
            SELECT org_id FROM org_members
            WHERE user_id = auth.uid() AND role IN ('owner', 'admin')
        )
    )
    WITH CHECK (
        id IN (
            SELECT org_id FROM org_members
            WHERE user_id = auth.uid() AND role IN ('owner', 'admin')
        )
    );

-- Only owner can delete (soft delete)
CREATE POLICY "Org owner can delete org"
    ON orgs FOR DELETE
    USING (
        id IN (
            SELECT org_id FROM org_members
            WHERE user_id = auth.uid() AND role = 'owner'
        )
    );

-- ============================================================================
-- ORG_MEMBERS - Members can view, admins can modify
-- ============================================================================

ALTER TABLE org_members ENABLE ROW LEVEL SECURITY;

-- Members can view other members in their orgs
CREATE POLICY "Members can view org members"
    ON org_members FOR SELECT
    USING (
        org_id IN (SELECT org_id FROM org_members WHERE user_id = auth.uid())
    );

-- Admins can add members
CREATE POLICY "Admins can add members"
    ON org_members FOR INSERT
    WITH CHECK (
        org_id IN (
            SELECT org_id FROM org_members
            WHERE user_id = auth.uid() AND role IN ('owner', 'admin')
        )
    );

-- Admins can update member roles (but not their own or owner's)
CREATE POLICY "Admins can update members"
    ON org_members FOR UPDATE
    USING (
        org_id IN (
            SELECT org_id FROM org_members
            WHERE user_id = auth.uid() AND role IN ('owner', 'admin')
        )
        AND user_id != auth.uid()  -- Can't modify self
        AND role != 'owner'  -- Can't modify owner
    )
    WITH CHECK (
        org_id IN (
            SELECT org_id FROM org_members
            WHERE user_id = auth.uid() AND role IN ('owner', 'admin')
        )
    );

-- Admins can remove members (except owner), members can leave
CREATE POLICY "Admins can remove members or self can leave"
    ON org_members FOR DELETE
    USING (
        (
            -- Admin removing someone else
            org_id IN (
                SELECT org_id FROM org_members
                WHERE user_id = auth.uid() AND role IN ('owner', 'admin')
            )
            AND role != 'owner'  -- Can't remove owner
        )
        OR
        (
            -- User leaving (except owner)
            user_id = auth.uid() AND role != 'owner'
        )
    );

-- ============================================================================
-- API_KEYS - Users manage their own keys
-- ============================================================================

ALTER TABLE api_keys ENABLE ROW LEVEL SECURITY;

-- Users can view their own API keys
CREATE POLICY "Users can view own API keys"
    ON api_keys FOR SELECT
    USING (user_id = auth.uid());

-- Users can create API keys for themselves
CREATE POLICY "Users can create own API keys"
    ON api_keys FOR INSERT
    WITH CHECK (
        user_id = auth.uid()
        AND (
            org_id IS NULL
            OR org_id IN (SELECT org_id FROM org_members WHERE user_id = auth.uid())
        )
    );

-- Users can update their own keys (e.g., revoke)
CREATE POLICY "Users can update own API keys"
    ON api_keys FOR UPDATE
    USING (user_id = auth.uid())
    WITH CHECK (user_id = auth.uid());

-- Users can delete their own keys
CREATE POLICY "Users can delete own API keys"
    ON api_keys FOR DELETE
    USING (user_id = auth.uid());

-- ============================================================================
-- PROJECTS - Org members can view, editors+ can modify
-- ============================================================================

ALTER TABLE projects ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Org members can view projects"
    ON projects FOR SELECT
    USING (
        org_id IN (SELECT org_id FROM org_members WHERE user_id = auth.uid())
    );

CREATE POLICY "Editors can create projects"
    ON projects FOR INSERT
    WITH CHECK (
        org_id IN (
            SELECT org_id FROM org_members
            WHERE user_id = auth.uid() AND role IN ('owner', 'admin', 'editor')
        )
    );

CREATE POLICY "Editors can update projects"
    ON projects FOR UPDATE
    USING (
        org_id IN (
            SELECT org_id FROM org_members
            WHERE user_id = auth.uid() AND role IN ('owner', 'admin', 'editor')
        )
    );

CREATE POLICY "Admins can delete projects"
    ON projects FOR DELETE
    USING (
        org_id IN (
            SELECT org_id FROM org_members
            WHERE user_id = auth.uid() AND role IN ('owner', 'admin')
        )
    );

-- ============================================================================
-- TEMPLATES - Org members can view (+ public), editors+ can modify
-- ============================================================================

ALTER TABLE templates ENABLE ROW LEVEL SECURITY;

-- Can view own org's templates OR public templates
CREATE POLICY "Org members can view templates"
    ON templates FOR SELECT
    USING (
        is_public = TRUE
        OR org_id IN (SELECT org_id FROM org_members WHERE user_id = auth.uid())
    );

CREATE POLICY "Editors can create templates"
    ON templates FOR INSERT
    WITH CHECK (
        org_id IN (
            SELECT org_id FROM org_members
            WHERE user_id = auth.uid() AND role IN ('owner', 'admin', 'editor')
        )
    );

CREATE POLICY "Editors can update templates"
    ON templates FOR UPDATE
    USING (
        org_id IN (
            SELECT org_id FROM org_members
            WHERE user_id = auth.uid() AND role IN ('owner', 'admin', 'editor')
        )
    );

CREATE POLICY "Admins can delete templates"
    ON templates FOR DELETE
    USING (
        org_id IN (
            SELECT org_id FROM org_members
            WHERE user_id = auth.uid() AND role IN ('owner', 'admin')
        )
    );

-- ============================================================================
-- WORKFLOWS - Org members can view, editors+ can modify
-- ============================================================================

ALTER TABLE workflows ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Org members can view workflows"
    ON workflows FOR SELECT
    USING (
        org_id IN (SELECT org_id FROM org_members WHERE user_id = auth.uid())
    );

CREATE POLICY "Editors can create workflows"
    ON workflows FOR INSERT
    WITH CHECK (
        org_id IN (
            SELECT org_id FROM org_members
            WHERE user_id = auth.uid() AND role IN ('owner', 'admin', 'editor')
        )
    );

CREATE POLICY "Editors can update workflows"
    ON workflows FOR UPDATE
    USING (
        org_id IN (
            SELECT org_id FROM org_members
            WHERE user_id = auth.uid() AND role IN ('owner', 'admin', 'editor')
        )
    );

CREATE POLICY "Admins can delete workflows"
    ON workflows FOR DELETE
    USING (
        org_id IN (
            SELECT org_id FROM org_members
            WHERE user_id = auth.uid() AND role IN ('owner', 'admin')
        )
    );

-- ============================================================================
-- WORKFLOW_VERSIONS - Same as workflows
-- ============================================================================

ALTER TABLE workflow_versions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Org members can view workflow versions"
    ON workflow_versions FOR SELECT
    USING (
        workflow_id IN (
            SELECT w.id FROM workflows w
            INNER JOIN org_members om ON w.org_id = om.org_id
            WHERE om.user_id = auth.uid()
        )
    );

CREATE POLICY "Editors can create workflow versions"
    ON workflow_versions FOR INSERT
    WITH CHECK (
        workflow_id IN (
            SELECT w.id FROM workflows w
            INNER JOIN org_members om ON w.org_id = om.org_id
            WHERE om.user_id = auth.uid() AND om.role IN ('owner', 'admin', 'editor')
        )
    );

-- Versions are immutable - no update/delete

-- ============================================================================
-- ASSETS - Org members can view, editors+ can modify
-- ============================================================================

ALTER TABLE assets ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Org members can view assets"
    ON assets FOR SELECT
    USING (
        org_id IN (SELECT org_id FROM org_members WHERE user_id = auth.uid())
    );

CREATE POLICY "Editors can create assets"
    ON assets FOR INSERT
    WITH CHECK (
        org_id IN (
            SELECT org_id FROM org_members
            WHERE user_id = auth.uid() AND role IN ('owner', 'admin', 'editor')
        )
    );

CREATE POLICY "Editors can update assets"
    ON assets FOR UPDATE
    USING (
        org_id IN (
            SELECT org_id FROM org_members
            WHERE user_id = auth.uid() AND role IN ('owner', 'admin', 'editor')
        )
    );

CREATE POLICY "Admins can delete assets"
    ON assets FOR DELETE
    USING (
        org_id IN (
            SELECT org_id FROM org_members
            WHERE user_id = auth.uid() AND role IN ('owner', 'admin')
        )
    );

-- ============================================================================
-- ASSET_VERSIONS - Same as assets
-- ============================================================================

ALTER TABLE asset_versions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Org members can view asset versions"
    ON asset_versions FOR SELECT
    USING (
        asset_id IN (
            SELECT a.id FROM assets a
            INNER JOIN org_members om ON a.org_id = om.org_id
            WHERE om.user_id = auth.uid()
        )
    );

CREATE POLICY "Editors can create asset versions"
    ON asset_versions FOR INSERT
    WITH CHECK (
        asset_id IN (
            SELECT a.id FROM assets a
            INNER JOIN org_members om ON a.org_id = om.org_id
            WHERE om.user_id = auth.uid() AND om.role IN ('owner', 'admin', 'editor')
        )
    );

-- ============================================================================
-- JOBS - Org members can view, editors+ can create
-- ============================================================================

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
            WHERE user_id = auth.uid() AND role IN ('owner', 'admin', 'editor')
        )
    );

-- Jobs can be updated (status changes) by system or editors
CREATE POLICY "Editors can update jobs"
    ON jobs FOR UPDATE
    USING (
        org_id IN (
            SELECT org_id FROM org_members
            WHERE user_id = auth.uid() AND role IN ('owner', 'admin', 'editor')
        )
    );

-- Jobs cannot be deleted (only cancelled via status update)

-- ============================================================================
-- JOB_LOGS - Same as jobs
-- ============================================================================

ALTER TABLE job_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Org members can view job logs"
    ON job_logs FOR SELECT
    USING (
        job_id IN (
            SELECT j.id FROM jobs j
            INNER JOIN org_members om ON j.org_id = om.org_id
            WHERE om.user_id = auth.uid()
        )
    );

-- Logs are created by system, not users

-- ============================================================================
-- RENDERS - Same as jobs
-- ============================================================================

ALTER TABLE renders ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Org members can view renders"
    ON renders FOR SELECT
    USING (
        job_id IN (
            SELECT j.id FROM jobs j
            INNER JOIN org_members om ON j.org_id = om.org_id
            WHERE om.user_id = auth.uid()
        )
    );

-- Renders are created by system, not users

-- ============================================================================
-- SCHEDULES - Org members can view, editors+ can modify
-- ============================================================================

ALTER TABLE schedules ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Org members can view schedules"
    ON schedules FOR SELECT
    USING (
        org_id IN (SELECT org_id FROM org_members WHERE user_id = auth.uid())
    );

CREATE POLICY "Editors can create schedules"
    ON schedules FOR INSERT
    WITH CHECK (
        org_id IN (
            SELECT org_id FROM org_members
            WHERE user_id = auth.uid() AND role IN ('owner', 'admin', 'editor')
        )
    );

CREATE POLICY "Editors can update schedules"
    ON schedules FOR UPDATE
    USING (
        org_id IN (
            SELECT org_id FROM org_members
            WHERE user_id = auth.uid() AND role IN ('owner', 'admin', 'editor')
        )
    );

CREATE POLICY "Admins can delete schedules"
    ON schedules FOR DELETE
    USING (
        org_id IN (
            SELECT org_id FROM org_members
            WHERE user_id = auth.uid() AND role IN ('owner', 'admin')
        )
    );

-- ============================================================================
-- WEBHOOKS - Only admins+ can manage
-- ============================================================================

ALTER TABLE webhooks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admins can view webhooks"
    ON webhooks FOR SELECT
    USING (
        org_id IN (
            SELECT org_id FROM org_members
            WHERE user_id = auth.uid() AND role IN ('owner', 'admin')
        )
    );

CREATE POLICY "Admins can create webhooks"
    ON webhooks FOR INSERT
    WITH CHECK (
        org_id IN (
            SELECT org_id FROM org_members
            WHERE user_id = auth.uid() AND role IN ('owner', 'admin')
        )
    );

CREATE POLICY "Admins can update webhooks"
    ON webhooks FOR UPDATE
    USING (
        org_id IN (
            SELECT org_id FROM org_members
            WHERE user_id = auth.uid() AND role IN ('owner', 'admin')
        )
    );

CREATE POLICY "Admins can delete webhooks"
    ON webhooks FOR DELETE
    USING (
        org_id IN (
            SELECT org_id FROM org_members
            WHERE user_id = auth.uid() AND role IN ('owner', 'admin')
        )
    );

-- ============================================================================
-- WEBHOOK_DELIVERIES - Same as webhooks
-- ============================================================================

ALTER TABLE webhook_deliveries ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admins can view webhook deliveries"
    ON webhook_deliveries FOR SELECT
    USING (
        webhook_id IN (
            SELECT w.id FROM webhooks w
            INNER JOIN org_members om ON w.org_id = om.org_id
            WHERE om.user_id = auth.uid() AND om.role IN ('owner', 'admin')
        )
    );

-- Deliveries are created/updated by system

-- ============================================================================
-- USAGE_RECORDS - Org members can view
-- ============================================================================

ALTER TABLE usage_records ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Org members can view usage"
    ON usage_records FOR SELECT
    USING (
        org_id IN (SELECT org_id FROM org_members WHERE user_id = auth.uid())
    );

-- Usage records are created by system

-- ============================================================================
-- QUOTA_LIMITS - Org members can view
-- ============================================================================

ALTER TABLE quota_limits ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Org members can view quotas"
    ON quota_limits FOR SELECT
    USING (
        org_id IN (SELECT org_id FROM org_members WHERE user_id = auth.uid())
    );

-- Quotas are managed by system

-- ============================================================================
-- INVOICES - Only owner/admin can view
-- ============================================================================

ALTER TABLE invoices ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admins can view invoices"
    ON invoices FOR SELECT
    USING (
        org_id IN (
            SELECT org_id FROM org_members
            WHERE user_id = auth.uid() AND role IN ('owner', 'admin')
        )
    );

-- Invoices are managed by system

-- ============================================================================
-- CREDIT_PACKS - Org members can view, admins can manage
-- ============================================================================

ALTER TABLE credit_packs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Org members can view credit packs"
    ON credit_packs FOR SELECT
    USING (
        org_id IN (SELECT org_id FROM org_members WHERE user_id = auth.uid())
    );

-- Credit packs are created via payment system

-- ============================================================================
-- INTEGRATIONS - Only admins can manage
-- ============================================================================

ALTER TABLE integrations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admins can view integrations"
    ON integrations FOR SELECT
    USING (
        org_id IN (
            SELECT org_id FROM org_members
            WHERE user_id = auth.uid() AND role IN ('owner', 'admin')
        )
    );

CREATE POLICY "Admins can create integrations"
    ON integrations FOR INSERT
    WITH CHECK (
        org_id IN (
            SELECT org_id FROM org_members
            WHERE user_id = auth.uid() AND role IN ('owner', 'admin')
        )
    );

CREATE POLICY "Admins can update integrations"
    ON integrations FOR UPDATE
    USING (
        org_id IN (
            SELECT org_id FROM org_members
            WHERE user_id = auth.uid() AND role IN ('owner', 'admin')
        )
    );

CREATE POLICY "Admins can delete integrations"
    ON integrations FOR DELETE
    USING (
        org_id IN (
            SELECT org_id FROM org_members
            WHERE user_id = auth.uid() AND role IN ('owner', 'admin')
        )
    );

-- ============================================================================
-- KAI_GENERATIONS - Org members can view
-- ============================================================================

ALTER TABLE kai_generations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Org members can view KAI generations"
    ON kai_generations FOR SELECT
    USING (
        org_id IN (SELECT org_id FROM org_members WHERE user_id = auth.uid())
    );

-- KAI generations are created by system
