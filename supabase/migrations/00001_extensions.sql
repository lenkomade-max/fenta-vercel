-- ============================================================================
-- Migration: 00001_extensions.sql
-- Description: Enable required PostgreSQL extensions for Fenta platform
-- ============================================================================

-- UUID generation (uuid_generate_v4, gen_random_uuid already available)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Cryptographic functions (gen_random_bytes, crypt, gen_salt)
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Full-text search improvements (optional, for future use)
-- CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- ============================================================================
-- Custom Types (Enums for type safety and query optimization)
-- ============================================================================

-- User roles within the platform
CREATE TYPE user_role AS ENUM ('user', 'admin');

-- User account status
CREATE TYPE user_status AS ENUM ('active', 'suspended');

-- Organization membership roles
CREATE TYPE org_role AS ENUM ('owner', 'admin', 'editor', 'viewer');

-- Subscription plans
CREATE TYPE subscription_plan AS ENUM ('free', 'starter', 'pro', 'enterprise');

-- Workflow status lifecycle
CREATE TYPE workflow_status AS ENUM ('draft', 'confirmed', 'preview', 'production', 'archived');

-- Asset types
CREATE TYPE asset_type AS ENUM ('image', 'video', 'audio');

-- Asset sources
CREATE TYPE asset_source AS ENUM ('upload', 'stock', 'kai', 'generated');

-- Asset processing status
CREATE TYPE asset_status AS ENUM ('processing', 'ready', 'failed');

-- Job execution status
CREATE TYPE job_status AS ENUM ('queued', 'processing', 'completed', 'failed', 'cancelled');

-- Log levels
CREATE TYPE log_level AS ENUM ('debug', 'info', 'warn', 'error');

-- Job execution stages
CREATE TYPE job_stage AS ENUM ('ingest', 'script', 'tts', 'subtitle', 'edit', 'export');

-- Webhook delivery status
CREATE TYPE webhook_status AS ENUM ('pending', 'success', 'failed');

-- Invoice status
CREATE TYPE invoice_status AS ENUM ('draft', 'open', 'paid', 'void');

-- Usage resource types
CREATE TYPE resource_type AS ENUM ('llm_tokens', 'kai_credits', 'render_seconds', 'storage');

-- Integration providers
CREATE TYPE integration_provider AS ENUM ('kai', 'openai', 'pexels', 'stripe');

-- Integration status
CREATE TYPE integration_status AS ENUM ('active', 'expired', 'revoked');

-- KAI generation types
CREATE TYPE kai_generation_type AS ENUM ('image', 'video', 'edit', 'voice', 'music');

-- Credit pack sizes
CREATE TYPE credit_pack_type AS ENUM ('small', 'medium', 'large');

-- Video aspect ratios
CREATE TYPE aspect_ratio AS ENUM ('9:16', '16:9', '1:1', '4:5');

-- Storage providers
CREATE TYPE storage_provider AS ENUM ('supabase', 's3', 'r2');
