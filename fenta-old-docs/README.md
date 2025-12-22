# Fenta Web - Technical Documentation

## Overview

**Fenta Web** is a SaaS platform for generating and editing viral short-form videos using AI, stock footage, and custom assets. The platform combines a visual workflow builder, template-based montage system, AI-powered content generation, and automated rendering.

**Target Users:**
- Content creators and influencers
- Marketing agencies and SMBs
- Solo entrepreneurs
- Production studios

**Key Features:**
- Visual workflow builder with 12+ node types
- AI-generated scripts, voiceovers, and subtitles
- KAI integration for image/video generation (Sora, VEO, Minimax, BIO3, etc.)
- Stock footage integration (Pexels)
- Template-based video montage
- Automated scheduling (cron-based)
- Token-based billing with subscription tiers
- Built-in AI assistant for workflow creation

---

## Documentation Structure

### 1. Architecture Documentation

- **[System Overview](./architecture/system-overview.md)** - High-level architecture, components, data flow, scalability, security

### 2. API Documentation

- **[OpenAPI Specification](./api/openapi.yaml)** - Complete REST API specification in OpenAPI 3.0 format
- **[API Examples](./examples/api-examples.md)** - Real-world usage examples with curl commands

### 3. Database Documentation

- **[Database Schema](./database/schema.md)** - Complete PostgreSQL schema with tables, indexes, relationships, partitioning

### 4. Workflow Documentation

- **[Node Reference](./workflows/node-reference.md)** - Complete reference for all workflow nodes with parameters, inputs/outputs, costs

### 5. Billing Documentation

- **[Billing System](./billing/billing-system.md)** - Subscription tiers, usage tracking, quota management, cost estimation

### 6. Examples & Schemas

- **[JSON Schemas](./examples/json-schemas.md)** - Complete JSON schemas for all entities (templates, workflows, jobs, assets)
- **[API Examples](./examples/api-examples.md)** - Code examples in multiple languages

---

## Quick Start

### Prerequisites

- Node.js 18+
- PostgreSQL 14+
- Redis 6+
- AWS account (for S3 storage)
- API keys for:
  - KAI (KEI) for image/video generation
  - OpenRouter/OpenAI for LLM features
  - Pexels for stock footage
  - Stripe for billing

### Installation

```bash
# Clone repository
git clone https://github.com/yourorg/fenta-web.git
cd fenta-web

# Install dependencies
npm install

# Set up environment variables
cp .env.example .env
# Edit .env with your configuration

# Run database migrations
npx prisma migrate deploy

# Start development server
npm run dev
```

### Environment Variables

```bash
# Database
DATABASE_URL=postgresql://user:password@localhost:5432/fenta_web
REDIS_URL=redis://localhost:6379

# AWS
AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key
S3_BUCKET_NAME=fenta-web-assets

# Authentication
JWT_SECRET=your_jwt_secret
JWT_EXPIRES_IN=15m
REFRESH_TOKEN_EXPIRES_IN=7d

# External APIs
KAI_API_KEY=your_kai_api_key
KAI_API_URL=https://api.kai.com/v1
OPENAI_API_KEY=your_openai_key
PEXELS_API_KEY=your_pexels_key

# Render Engine
FANTA_PROJEKT_API_URL=https://render-api.internal.com
FANTA_PROJEKT_API_KEY=your_render_api_key

# Stripe
STRIPE_SECRET_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...

# Application
APP_URL=http://localhost:3000
API_URL=http://localhost:3000/api/v1
```

---

## Core Concepts

### 1. Templates

Templates define the visual structure of videos:
- Track layout (video, subtitles, overlays, audio)
- Subtitle styling and positioning
- Overlay elements (logos, text, shapes)
- Editing rules (scene duration, transitions)
- Placeholders for dynamic content

**Use Case:** Create once, reuse for consistent branding across all videos.

### 2. Workflows

Workflows are visual graphs that define the video production pipeline:
- **Nodes**: Operations (generate script, fetch stock, render video)
- **Edges**: Data flow between nodes
- **Execution**: Topological order based on dependencies

**Use Case:** Automate complex video production processes with multiple steps.

### 3. Jobs

Jobs are individual render tasks:
- Can be created from workflows or directly via API
- Track status (queued, processing, completed, failed)
- Measure cost (tokens, render seconds, KAI credits)
- Store results (video URL, thumbnail, SRT)

**Use Case:** Execute video rendering with full cost tracking.

### 4. Assets

Assets are all media files used in production:
- User uploads (images, videos, audio)
- Stock footage (Pexels)
- AI generations (KAI images/videos)
- Render outputs

**Use Case:** Centralized media library with versioning and metadata.

### 5. Schedules

Schedules enable automated workflow execution:
- Cron-based timing
- Timezone support
- Enable/disable toggling
- Run history tracking

**Use Case:** Daily/weekly content production without manual intervention.

---

## API Overview

### Base URL

```
Production: https://api.fentaweb.com/v1
Staging: https://staging-api.fentaweb.com/v1
```

### Authentication

All API requests require authentication via JWT token or Personal Access Token (PAT):

```bash
curl -H "Authorization: Bearer YOUR_TOKEN" \
  https://api.fentaweb.com/v1/workflows
```

### Key Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/auth/login` | POST | User authentication |
| `/templates` | GET/POST | Manage montage templates |
| `/workflows` | GET/POST | Manage workflows |
| `/workflows/{id}/run` | POST | Execute workflow |
| `/workflows/{id}/estimate` | POST | Estimate cost before execution |
| `/jobs` | GET/POST | Direct render jobs |
| `/jobs/{id}` | GET | Get job status |
| `/assets/init` | POST | Initialize file upload |
| `/assets/complete` | POST | Complete file upload |
| `/assets/stock/search` | GET | Search stock footage |
| `/kai/generate-image` | POST | Generate images via KAI |
| `/kai/generate-video` | POST | Generate videos via KAI |
| `/schedules` | GET/POST | Manage schedules |
| `/usage` | GET | Get usage statistics |
| `/usage/quota` | GET | Get quota information |
| `/webhooks` | GET/POST | Manage webhooks |

**Full API Documentation:** See [OpenAPI Specification](./api/openapi.yaml)

---

## Workflow Builder

### Node Types

**Input Nodes:**
- `Input.Upload` - Load user-uploaded assets
- `Input.Stock` - Fetch stock footage (Pexels)
- `Input.KAI.GenerateImage` - Generate images via AI
- `Input.KAI.GenerateVideo` - Generate video clips via AI
- `Input.KAI.EditVideo` - Edit existing videos via AI

**Script Nodes:**
- `Script.Generate` - Generate scripts using LLM
- `Script.Transform` - Transform scripts (translate, compress, adapt)

**Audio Nodes:**
- `Voice.TTS` - Text-to-speech synthesis
- `Audio.Mix` - Mix voice and music with ducking

**Subtitle Nodes:**
- `Subtitle.Auto` - Generate subtitles from audio or script

**Edit Nodes:**
- `Edit.Timeline` - Assemble video timeline using template

**Output Nodes:**
- `Output.Render` - Final video rendering
- `Output.Download` - Make video available for download

**Scheduling:**
- `Schedule.Cron` - Execute workflow on schedule

**Full Node Documentation:** See [Node Reference](./workflows/node-reference.md)

### Example Workflow

Simple workflow for daily news shorts:

```
Stock Footage → \
                  → Timeline → Render → Download
Script → TTS → Subtitles → /
```

**Detailed Example:** See [API Examples](./examples/api-examples.md#create-workflow---daily-news-shorts)

---

## Billing System

### Subscription Tiers

| Tier | Price/Month | Tokens | KAI Credits | Render Seconds | Storage |
|------|-------------|--------|-------------|----------------|---------|
| **Free** | $0 | 100K | 50 | 300 (5 min) | 5 GB |
| **Starter** | $29 | 1M | 500 | 3,600 (1 hr) | 50 GB |
| **Pro** | $99 | 5M | 2,000 | 10,800 (3 hr) | 200 GB |
| **Enterprise** | Custom | Custom | Custom | Custom | Unlimited |

### Resource Units

**LLM Tokens:**
- Script generation, transformations, AI agent interactions
- Pricing: $0.08-$0.10 per 100K tokens (overage)

**KAI Credits:**
- Image generation: 4-10 credits per image
- Video generation: 40-100 credits per clip (model-dependent)
- Pricing: $0.04-$0.05 per credit (overage)

**Render Seconds:**
- Based on output duration × quality multiplier
- 1080p: 1.5x multiplier (60s video = 90 render seconds)
- Pricing: $0.015-$0.02 per second (overage)

**Storage:**
- User uploads, AI generations, render outputs
- Pricing: $0.08-$0.10 per GB/month (overage)

**Full Billing Documentation:** See [Billing System](./billing/billing-system.md)

---

## Cost Estimation

Before executing any workflow or job, estimate the cost:

```bash
POST /v1/workflows/{id}/estimate
```

**Response includes:**
- Total estimated cost in USD
- Breakdown by resource type
- Estimated execution duration
- Quota availability check

**Budget Controls:**
- Set max cost limits per job
- Pause execution if budget exceeded
- Overage alerts at 80%, 90%, 100%

---

## Database Schema

### Core Tables

- `users` - User accounts
- `orgs` - Organizations (multi-tenancy)
- `org_members` - User-organization mappings
- `projects` - Projects within organizations
- `templates` - Montage templates
- `workflows` - Workflow graphs
- `jobs` - Render jobs
- `assets` - Media assets
- `schedules` - Cron schedules
- `usage_records` - Billing tracking (partitioned)
- `webhooks` - Webhook configurations
- `audit_logs` - Audit trail (partitioned)

### Key Features

- UUID primary keys with prefixes (`user_abc123`)
- JSONB columns for flexible data (graphs, specs, metadata)
- Partitioning for large tables (usage, audit logs)
- Soft deletes for critical tables
- Comprehensive indexes for performance
- Foreign key constraints with CASCADE/SET NULL

**Full Schema Documentation:** See [Database Schema](./database/schema.md)

---

## Integration Guide

### KAI (KEI) Integration

Generate images and videos using state-of-the-art AI models:

**Supported Models:**
- **Images:** Flux Pro, DALL-E 3, Stable Diffusion
- **Videos:** Sora, VEO, Minimax, BIO3, C-DANCE

**Usage:**

```bash
# Generate image
POST /v1/kai/generate-image
{
  "prompt": "A futuristic city at sunset",
  "model": "flux-pro",
  "width": 1024,
  "height": 1024,
  "variations": 3
}

# Generate video
POST /v1/kai/generate-video
{
  "prompt": "A cat walking through a neon alley",
  "model": "sora",
  "duration": 10,
  "aspect": "9:16"
}
```

### Stock Integration

Search and use free stock footage from Pexels:

```bash
GET /v1/assets/stock/search?query=sunset+beach&type=video&limit=10
```

**Features:**
- No cost to user quota
- High-quality HD/4K videos
- Automatic caching
- Download tracking

### Webhook Integration

Receive real-time notifications for events:

**Supported Events:**
- `render.succeeded`
- `render.failed`
- `workflow.run.started`
- `workflow.run.finished`
- `job.completed`
- `job.failed`

**Setup:**

```bash
POST /v1/webhooks
{
  "url": "https://myapp.com/webhooks/fenta",
  "events": ["render.succeeded", "render.failed"]
}
```

**Signature Verification:**

```python
import hmac
import hashlib

def verify_webhook(payload, signature, secret):
    expected = hmac.new(
        secret.encode('utf-8'),
        payload.encode('utf-8'),
        hashlib.sha256
    ).hexdigest()
    return hmac.compare_digest(expected, signature)
```

---

## Security

### Authentication

- JWT tokens (15-minute expiry)
- Refresh tokens (7-day expiry)
- Personal Access Tokens (PAT) for API access
- Scoped permissions

### Authorization

**RBAC Roles:**
- **Owner**: Full access, billing, delete organization
- **Admin**: Manage users, workflows, templates
- **Editor**: Create/edit workflows, run jobs
- **Viewer**: Read-only access

### Data Protection

- TLS 1.3 for all API traffic
- Database encryption at rest
- Encrypted S3 buckets (SSE-S3)
- Presigned URLs for asset access (time-limited)
- Secrets in AWS Secrets Manager

### Rate Limiting

- 100 requests per minute per user
- 1000 requests per hour per user
- 429 status code when exceeded
- `Retry-After` header provided

---

## Monitoring & Observability

### Logging

**Structured JSON logs with:**
- Request ID for tracing
- User ID and organization ID
- Timestamp, level, message, context
- 30-day retention (INFO), 90-day retention (ERROR)

### Metrics

**Application Metrics:**
- Request rate (RPS)
- Response time (p50, p95, p99)
- Error rate (4xx, 5xx)
- Active users, concurrent jobs

**Business Metrics:**
- Workflows created per day
- Jobs executed per day
- Token consumption
- Revenue (MRR, churn)

### Alerting

**Critical Alerts:**
- Error rate > 5% for 5 minutes
- Response time p95 > 2 seconds
- Database connection pool exhausted
- Render engine downtime

**Channels:**
- PagerDuty (critical)
- Slack (warnings)
- Email (daily digest)

---

## Development

### Local Development

```bash
# Start database
docker-compose up -d postgres redis

# Run migrations
npx prisma migrate dev

# Start dev server
npm run dev

# Run tests
npm test

# Run linter
npm run lint
```

### Testing

**Test Levels:**
- Unit tests: Service logic, utilities, components
- Integration tests: API endpoints, database operations
- E2E tests: Critical user flows

**Coverage Target:** 80%+

### CI/CD Pipeline

```
Git Push → Tests → Build → Deploy Staging → E2E Tests → Manual Approval → Deploy Production
```

**Tools:**
- GitHub Actions for CI/CD
- Docker for containerization
- AWS ECR for image registry
- AWS ECS/Fargate for deployment

---

## Roadmap

### v1 (MVP) - Completed

- Templates and jobs
- Basic workflow builder (10 nodes)
- Upload, Pexels, basic KAI integration
- TTS and subtitles
- Render 9:16 1080p
- Token billing and quota
- Webhooks

### v2 (Current Development)

- Full workflow builder (15+ nodes)
- Scheduling and automation
- AI chat assistant
- Enhanced logging and analytics
- Template marketplace (read-only)

### v3 (Future)

- Publishing connectors (YouTube, TikTok, Instagram)
- Multi-user collaboration (real-time)
- Template marketplace (user submissions)
- Advanced video effects
- Mobile app (iOS, Android)
- GraphQL API

---

## Support

### Documentation

- Technical Documentation: This repository
- API Reference: [OpenAPI Specification](./api/openapi.yaml)
- User Guide: https://docs.fentaweb.com

### Community

- Discord: https://discord.gg/fentaweb
- GitHub Issues: https://github.com/yourorg/fenta-web/issues
- Stack Overflow: Tag `fenta-web`

### Commercial Support

- Email: support@fentaweb.com
- Priority support: Pro and Enterprise tiers
- SLA guarantees: Enterprise tier only

---

## License

Proprietary - All rights reserved

---

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines.

---

## Changelog

See [CHANGELOG.md](./CHANGELOG.md) for version history.
