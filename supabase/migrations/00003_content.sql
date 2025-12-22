-- ============================================================================
-- Migration: 00003_content.sql
-- Description: Templates, workflows, workflow versions, assets, asset versions
-- ============================================================================

-- ============================================================================
-- TEMPLATES - Video montage templates with specification
-- ============================================================================

CREATE TABLE templates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Ownership (org_id nullable for system templates)
    org_id UUID REFERENCES orgs(id) ON DELETE CASCADE,
    project_id UUID REFERENCES projects(id) ON DELETE SET NULL,

    -- Basic info
    name TEXT NOT NULL,
    description TEXT,

    -- Video format settings
    aspect aspect_ratio NOT NULL,
    resolution TEXT NOT NULL,  -- "1080x1920", "1920x1080", etc.

    -- Template specification (tracks, overlays, placeholders, rules)
    spec JSONB NOT NULL,

    -- Visibility and stats
    is_public BOOLEAN NOT NULL DEFAULT FALSE,
    thumbnail_url TEXT,
    usage_count INTEGER NOT NULL DEFAULT 0,

    -- Audit
    created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,

    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT templates_name_not_empty CHECK (char_length(name) >= 1),
    CONSTRAINT templates_resolution_valid CHECK (resolution ~ '^\d+x\d+$'),
    CONSTRAINT templates_usage_count_positive CHECK (usage_count >= 0)
);

COMMENT ON TABLE templates IS 'Video montage templates defining structure, tracks, overlays, and rules';
COMMENT ON COLUMN templates.spec IS 'JSON: tracks[], overlays[], placeholders{}, rules{}, subtitle_style_presets[]';
COMMENT ON COLUMN templates.is_public IS 'If true, template is visible to all users (gallery)';

-- Indexes
CREATE INDEX idx_templates_org ON templates(org_id) WHERE org_id IS NOT NULL;
CREATE INDEX idx_templates_project ON templates(project_id) WHERE project_id IS NOT NULL;
CREATE INDEX idx_templates_aspect ON templates(aspect);
CREATE INDEX idx_templates_created_by ON templates(created_by) WHERE created_by IS NOT NULL;
CREATE INDEX idx_templates_created_at ON templates(created_at DESC);
CREATE INDEX idx_templates_usage_count ON templates(usage_count DESC);

-- Partial indexes
CREATE INDEX idx_templates_public ON templates(is_public, usage_count DESC) WHERE is_public = TRUE;
CREATE INDEX idx_templates_active ON templates(org_id) WHERE deleted_at IS NULL;

-- GIN index for JSONB spec queries
CREATE INDEX idx_templates_spec ON templates USING gin(spec);

-- ============================================================================
-- WORKFLOWS - Visual workflow graphs (node-based pipelines)
-- ============================================================================

CREATE TABLE workflows (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Ownership
    org_id UUID NOT NULL REFERENCES orgs(id) ON DELETE CASCADE,
    project_id UUID REFERENCES projects(id) ON DELETE SET NULL,

    -- Basic info
    name TEXT NOT NULL,
    description TEXT,

    -- Status lifecycle
    status workflow_status NOT NULL DEFAULT 'draft',

    -- Workflow graph (nodes[], edges[])
    graph JSONB NOT NULL,

    -- Variables for parameterization
    variables JSONB NOT NULL DEFAULT '{}',

    -- Execution stats
    run_count INTEGER NOT NULL DEFAULT 0,
    last_run_at TIMESTAMPTZ,

    -- Audit
    created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,

    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT workflows_name_not_empty CHECK (char_length(name) >= 1),
    CONSTRAINT workflows_run_count_positive CHECK (run_count >= 0)
);

COMMENT ON TABLE workflows IS 'Visual workflow graphs defining video production pipelines';
COMMENT ON COLUMN workflows.graph IS 'JSON: nodes[] (id, type, params, position), edges[] (id, from, to)';
COMMENT ON COLUMN workflows.variables IS 'Workflow-level variables for parameterization';
COMMENT ON COLUMN workflows.status IS 'draft -> confirmed -> preview -> production; archived for soft delete';

-- Indexes
CREATE INDEX idx_workflows_org ON workflows(org_id);
CREATE INDEX idx_workflows_project ON workflows(project_id) WHERE project_id IS NOT NULL;
CREATE INDEX idx_workflows_status ON workflows(status);
CREATE INDEX idx_workflows_created_by ON workflows(created_by) WHERE created_by IS NOT NULL;
CREATE INDEX idx_workflows_created_at ON workflows(created_at DESC);
CREATE INDEX idx_workflows_last_run ON workflows(last_run_at DESC) WHERE last_run_at IS NOT NULL;

-- Partial index for active workflows
CREATE INDEX idx_workflows_active ON workflows(org_id, status) WHERE deleted_at IS NULL;

-- GIN index for JSONB graph queries
CREATE INDEX idx_workflows_graph ON workflows USING gin(graph);

-- ============================================================================
-- WORKFLOW_VERSIONS - Version history for workflows
-- ============================================================================

CREATE TABLE workflow_versions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Parent workflow
    workflow_id UUID NOT NULL REFERENCES workflows(id) ON DELETE CASCADE,

    -- Version number (1, 2, 3, ...)
    version INTEGER NOT NULL,

    -- Snapshot of graph and variables at this version
    graph JSONB NOT NULL,
    variables JSONB NOT NULL DEFAULT '{}',

    -- Optional changelog
    changelog TEXT,

    -- Audit
    created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,

    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Constraints
    CONSTRAINT workflow_versions_unique UNIQUE (workflow_id, version),
    CONSTRAINT workflow_versions_version_positive CHECK (version >= 1)
);

COMMENT ON TABLE workflow_versions IS 'Immutable version history for workflow graphs';
COMMENT ON COLUMN workflow_versions.version IS 'Sequential version number starting from 1';

-- Indexes
CREATE INDEX idx_workflow_versions_workflow ON workflow_versions(workflow_id);
CREATE INDEX idx_workflow_versions_created_at ON workflow_versions(created_at DESC);

-- ============================================================================
-- ASSETS - Media files (images, videos, audio)
-- ============================================================================

CREATE TABLE assets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Ownership
    org_id UUID NOT NULL REFERENCES orgs(id) ON DELETE CASCADE,
    project_id UUID REFERENCES projects(id) ON DELETE SET NULL,

    -- Type and source
    type asset_type NOT NULL,
    source asset_source NOT NULL,

    -- Storage location
    storage_provider storage_provider NOT NULL DEFAULT 'supabase',
    storage_path TEXT NOT NULL,
    url TEXT,
    thumbnail_url TEXT,

    -- File info
    filename TEXT,
    content_type TEXT,
    size_bytes BIGINT,

    -- Media-specific properties
    duration_seconds DECIMAL(10, 2),  -- for video/audio
    width INTEGER,  -- for image/video
    height INTEGER, -- for image/video
    fps DECIMAL(5, 2),  -- for video

    -- Flexible metadata (source_url, provider_id, generation_params, tags, colors)
    metadata JSONB NOT NULL DEFAULT '{}',

    -- Processing status
    status asset_status NOT NULL DEFAULT 'processing',

    -- Audit
    created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,

    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT assets_storage_path_not_empty CHECK (char_length(storage_path) >= 1),
    CONSTRAINT assets_size_positive CHECK (size_bytes IS NULL OR size_bytes >= 0),
    CONSTRAINT assets_duration_positive CHECK (duration_seconds IS NULL OR duration_seconds >= 0),
    CONSTRAINT assets_dimensions_positive CHECK (
        (width IS NULL OR width > 0) AND
        (height IS NULL OR height > 0)
    ),
    CONSTRAINT assets_fps_positive CHECK (fps IS NULL OR fps > 0)
);

COMMENT ON TABLE assets IS 'Media files: images, videos, audio from uploads, stock, or AI generation';
COMMENT ON COLUMN assets.metadata IS 'JSON: source_url, provider_id, generation_params, tags[], extracted_colors[]';
COMMENT ON COLUMN assets.source IS 'upload: user uploaded; stock: Pexels/etc; kai: KIE.ai generated; generated: FantaProjekt';

-- Indexes
CREATE INDEX idx_assets_org ON assets(org_id);
CREATE INDEX idx_assets_project ON assets(project_id) WHERE project_id IS NOT NULL;
CREATE INDEX idx_assets_type ON assets(type);
CREATE INDEX idx_assets_source ON assets(source);
CREATE INDEX idx_assets_status ON assets(status);
CREATE INDEX idx_assets_created_by ON assets(created_by) WHERE created_by IS NOT NULL;
CREATE INDEX idx_assets_created_at ON assets(created_at DESC);
CREATE INDEX idx_assets_content_type ON assets(content_type) WHERE content_type IS NOT NULL;

-- Partial index for ready assets
CREATE INDEX idx_assets_ready ON assets(org_id, type) WHERE status = 'ready' AND deleted_at IS NULL;

-- GIN index for JSONB metadata queries
CREATE INDEX idx_assets_metadata ON assets USING gin(metadata);

-- ============================================================================
-- ASSET_VERSIONS - Version history for assets (edits)
-- ============================================================================

CREATE TABLE asset_versions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Parent asset
    asset_id UUID NOT NULL REFERENCES assets(id) ON DELETE CASCADE,

    -- Version number
    version INTEGER NOT NULL,

    -- Storage for this version
    storage_path TEXT NOT NULL,
    url TEXT,

    -- Version-specific metadata (edit operations applied, etc.)
    metadata JSONB NOT NULL DEFAULT '{}',

    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Constraints
    CONSTRAINT asset_versions_unique UNIQUE (asset_id, version),
    CONSTRAINT asset_versions_version_positive CHECK (version >= 1),
    CONSTRAINT asset_versions_storage_path_not_empty CHECK (char_length(storage_path) >= 1)
);

COMMENT ON TABLE asset_versions IS 'Version history for asset edits';

-- Indexes
CREATE INDEX idx_asset_versions_asset ON asset_versions(asset_id);
CREATE INDEX idx_asset_versions_created_at ON asset_versions(created_at DESC);
