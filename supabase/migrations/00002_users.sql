-- ============================================================================
-- Migration: 00002_users.sql
-- Description: User profiles, organizations, memberships, API keys, projects
-- ============================================================================

-- ============================================================================
-- PROFILES - Extension of Supabase Auth users
-- ============================================================================

CREATE TABLE profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,

    -- Basic info
    name TEXT,
    avatar_url TEXT,

    -- Role and status
    role user_role NOT NULL DEFAULT 'user',
    status user_status NOT NULL DEFAULT 'active',

    -- Flexible metadata (preferences, onboarding state, etc.)
    metadata JSONB NOT NULL DEFAULT '{}',

    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Comments for documentation
COMMENT ON TABLE profiles IS 'Extended user profile data, linked to auth.users';
COMMENT ON COLUMN profiles.metadata IS 'Flexible JSON: onboarding state, preferences, theme, language';

-- Indexes
CREATE INDEX idx_profiles_status ON profiles(status);
CREATE INDEX idx_profiles_role ON profiles(role);
CREATE INDEX idx_profiles_created_at ON profiles(created_at DESC);

-- ============================================================================
-- ORGS - Organizations for multi-tenancy
-- ============================================================================

CREATE TABLE orgs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Basic info
    name TEXT NOT NULL,
    slug TEXT NOT NULL,
    owner_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE RESTRICT,

    -- Billing
    plan subscription_plan NOT NULL DEFAULT 'free',
    plan_started_at TIMESTAMPTZ,
    billing_email TEXT,
    stripe_customer_id TEXT,

    -- Settings (default aspect, quality, brand colors, default voice, etc.)
    settings JSONB NOT NULL DEFAULT '{}',

    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT orgs_slug_unique UNIQUE (slug),
    CONSTRAINT orgs_name_not_empty CHECK (char_length(name) >= 1),
    CONSTRAINT orgs_slug_valid CHECK (slug ~ '^[a-z0-9][a-z0-9-]*[a-z0-9]$' OR char_length(slug) = 1)
);

COMMENT ON TABLE orgs IS 'Organizations for multi-tenant data isolation';
COMMENT ON COLUMN orgs.slug IS 'URL-friendly unique identifier (lowercase, alphanumeric, hyphens)';
COMMENT ON COLUMN orgs.settings IS 'Org-level defaults: aspect ratio, quality, brand colors, voice preferences';

-- Indexes
CREATE INDEX idx_orgs_owner ON orgs(owner_id);
CREATE INDEX idx_orgs_plan ON orgs(plan);
CREATE INDEX idx_orgs_stripe_customer ON orgs(stripe_customer_id) WHERE stripe_customer_id IS NOT NULL;
CREATE INDEX idx_orgs_created_at ON orgs(created_at DESC);

-- Partial index for active orgs only
CREATE INDEX idx_orgs_slug_active ON orgs(slug) WHERE deleted_at IS NULL;

-- ============================================================================
-- ORG_MEMBERS - User-Organization relationship with roles
-- ============================================================================

CREATE TABLE org_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Relationship
    org_id UUID NOT NULL REFERENCES orgs(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,

    -- Role within organization
    role org_role NOT NULL,

    -- Invitation tracking
    invited_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    invited_at TIMESTAMPTZ,
    joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Constraints
    CONSTRAINT org_members_unique UNIQUE (org_id, user_id)
);

COMMENT ON TABLE org_members IS 'Maps users to organizations with specific roles';
COMMENT ON COLUMN org_members.role IS 'owner: full access + billing; admin: full access; editor: create/edit; viewer: read-only';

-- Indexes
CREATE INDEX idx_org_members_org ON org_members(org_id);
CREATE INDEX idx_org_members_user ON org_members(user_id);
CREATE INDEX idx_org_members_role ON org_members(role);
CREATE INDEX idx_org_members_invited_by ON org_members(invited_by) WHERE invited_by IS NOT NULL;

-- ============================================================================
-- API_KEYS - Personal Access Tokens for API authentication
-- ============================================================================

CREATE TABLE api_keys (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Ownership
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    org_id UUID REFERENCES orgs(id) ON DELETE CASCADE,

    -- Key identification
    name TEXT NOT NULL,
    key_hash TEXT NOT NULL,  -- bcrypt hash of the full key
    key_prefix TEXT NOT NULL, -- First 8 chars for identification (e.g., "fenta_k8...")

    -- Permissions (array of scope strings)
    scopes JSONB NOT NULL DEFAULT '[]',

    -- Lifecycle
    last_used_at TIMESTAMPTZ,
    expires_at TIMESTAMPTZ,
    revoked_at TIMESTAMPTZ,

    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Constraints
    CONSTRAINT api_keys_key_hash_unique UNIQUE (key_hash),
    CONSTRAINT api_keys_name_not_empty CHECK (char_length(name) >= 1),
    CONSTRAINT api_keys_prefix_valid CHECK (char_length(key_prefix) >= 4)
);

COMMENT ON TABLE api_keys IS 'Personal access tokens for API authentication';
COMMENT ON COLUMN api_keys.key_hash IS 'Bcrypt hash of the full API key';
COMMENT ON COLUMN api_keys.key_prefix IS 'First 8 characters for key identification in UI';
COMMENT ON COLUMN api_keys.scopes IS 'Array of permission scopes: workflows:read, jobs:execute, etc.';

-- Indexes
CREATE INDEX idx_api_keys_user ON api_keys(user_id);
CREATE INDEX idx_api_keys_org ON api_keys(org_id) WHERE org_id IS NOT NULL;
CREATE INDEX idx_api_keys_prefix ON api_keys(key_prefix);
CREATE INDEX idx_api_keys_expires_at ON api_keys(expires_at) WHERE expires_at IS NOT NULL;

-- Partial index for valid (non-revoked) keys only
CREATE INDEX idx_api_keys_valid ON api_keys(key_hash) WHERE revoked_at IS NULL;

-- ============================================================================
-- PROJECTS - Grouping resources within an organization
-- ============================================================================

CREATE TABLE projects (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Ownership
    org_id UUID NOT NULL REFERENCES orgs(id) ON DELETE CASCADE,

    -- Basic info
    name TEXT NOT NULL,
    description TEXT,

    -- Project-level settings
    settings JSONB NOT NULL DEFAULT '{}',

    -- Audit
    created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,

    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT projects_name_not_empty CHECK (char_length(name) >= 1)
);

COMMENT ON TABLE projects IS 'Logical grouping of workflows, templates, and assets within an org';
COMMENT ON COLUMN projects.settings IS 'Project-specific overrides for org settings';

-- Indexes
CREATE INDEX idx_projects_org ON projects(org_id);
CREATE INDEX idx_projects_created_by ON projects(created_by) WHERE created_by IS NOT NULL;
CREATE INDEX idx_projects_created_at ON projects(created_at DESC);

-- Partial index for active projects
CREATE INDEX idx_projects_active ON projects(org_id) WHERE deleted_at IS NULL;
