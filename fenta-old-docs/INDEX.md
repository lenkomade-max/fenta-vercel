# Fenta Web - Documentation Index

Complete technical documentation for the Fenta Web SaaS platform.

## Overview Documents

- **[README](./README.md)** - Main documentation entry point with quick start guide
- **[Getting Started Guide](./GETTING_STARTED.md)** - 5-minute quick start tutorial
- **[This Index](./INDEX.md)** - Complete documentation map

---

## Architecture Documentation

### System Design

- **[System Overview](./architecture/system-overview.md)**
  - High-level architecture diagram
  - Technology stack
  - Component breakdown (frontend, API, integrations, database)
  - Data flow diagrams
  - Security architecture
  - Scalability considerations
  - Monitoring and observability
  - Disaster recovery plan
  - Development and deployment workflow

---

## API Documentation

### REST API

- **[OpenAPI 3.0 Specification](./api/openapi.yaml)**
  - Complete REST API specification
  - All endpoints with request/response schemas
  - Authentication methods
  - Error codes and handling
  - Rate limiting
  - Pagination
  - Can be imported into:
    - Postman
    - Insomnia
    - Swagger UI
    - OpenAPI Generator

### Endpoints by Category

**Authentication**
- `POST /v1/auth/register` - Register new user
- `POST /v1/auth/login` - User login
- `POST /v1/auth/refresh` - Refresh access token

**Templates**
- `GET /v1/templates` - List all templates
- `POST /v1/templates` - Create template
- `GET /v1/templates/{id}` - Get template details
- `PATCH /v1/templates/{id}` - Update template
- `DELETE /v1/templates/{id}` - Delete template

**Workflows**
- `GET /v1/workflows` - List all workflows
- `POST /v1/workflows` - Create workflow
- `GET /v1/workflows/{id}` - Get workflow details
- `PATCH /v1/workflows/{id}` - Update workflow
- `DELETE /v1/workflows/{id}` - Delete workflow
- `POST /v1/workflows/{id}/run` - Execute workflow
- `POST /v1/workflows/{id}/estimate` - Estimate cost

**Jobs**
- `GET /v1/jobs` - List all jobs
- `POST /v1/jobs` - Create direct render job
- `GET /v1/jobs/{id}` - Get job status
- `POST /v1/jobs/{id}/cancel` - Cancel job
- `POST /v1/jobs/{id}/retry` - Retry failed job

**Assets**
- `GET /v1/assets` - List all assets
- `POST /v1/assets/init` - Initialize upload
- `POST /v1/assets/complete` - Complete upload
- `GET /v1/assets/stock/search` - Search stock assets
- `GET /v1/assets/{id}` - Get asset details
- `DELETE /v1/assets/{id}` - Delete asset

**KAI Integration**
- `POST /v1/kai/generate-image` - Generate image
- `POST /v1/kai/generate-video` - Generate video
- `POST /v1/kai/edit-video` - Edit video
- `GET /v1/kai/generations/{id}` - Get generation status

**Schedules**
- `GET /v1/schedules` - List all schedules
- `POST /v1/schedules` - Create schedule
- `GET /v1/schedules/{id}` - Get schedule details
- `PATCH /v1/schedules/{id}` - Update schedule
- `DELETE /v1/schedules/{id}` - Delete schedule

**Usage & Billing**
- `GET /v1/usage` - Get usage statistics
- `GET /v1/usage/quota` - Get quota information

**Webhooks**
- `GET /v1/webhooks` - List webhooks
- `POST /v1/webhooks` - Create webhook
- `GET /v1/webhooks/{id}` - Get webhook details
- `PATCH /v1/webhooks/{id}` - Update webhook
- `DELETE /v1/webhooks/{id}` - Delete webhook
- `GET /v1/webhooks/{id}/deliveries` - Get delivery history

---

## Database Documentation

### Schema Reference

- **[Database Schema](./database/schema.md)**
  - Complete PostgreSQL schema
  - All tables with columns, types, constraints
  - Foreign key relationships
  - Indexes and performance optimization
  - Partitioning strategy
  - Materialized views
  - Backup and recovery procedures

### Table Categories

**Core Tables**
- `users` - User accounts
- `orgs` - Organizations (multi-tenancy)
- `org_members` - User-organization mappings with roles
- `projects` - Projects within organizations
- `api_keys` - Personal Access Tokens

**Content Tables**
- `templates` - Video montage templates
- `workflows` - Workflow graphs
- `workflow_versions` - Workflow version history
- `assets` - Media assets (uploads, stock, AI generations)
- `asset_versions` - Asset version history

**Execution Tables**
- `jobs` - Render jobs
- `job_logs` - Execution logs per job
- `renders` - Final render artifacts
- `schedules` - Cron-based schedules

**Integration Tables**
- `integrations` - External service credentials
- `kai_generations` - KAI generation tracking

**Billing Tables**
- `usage_records` - Usage tracking (partitioned by month)
- `quota_limits` - Organization quota limits
- `invoices` - Stripe invoices

**System Tables**
- `webhooks` - Webhook configurations
- `webhook_deliveries` - Webhook delivery tracking
- `audit_logs` - Audit trail (partitioned by month)

---

## Workflow Documentation

### Node Reference

- **[Node Reference](./workflows/node-reference.md)**
  - Complete reference for all 14 node types
  - Node parameters, inputs, outputs
  - Cost per node type
  - Usage examples
  - Error handling
  - Best practices

### Node Categories

**Input Nodes (5)**
- `Input.Upload` - Load user uploads
- `Input.Stock` - Fetch from Pexels
- `Input.KAI.GenerateImage` - AI image generation
- `Input.KAI.GenerateVideo` - AI video generation
- `Input.KAI.EditVideo` - AI video editing

**Script Nodes (2)**
- `Script.Generate` - Generate scripts with LLM
- `Script.Transform` - Transform scripts (translate, compress, adapt)

**Audio Nodes (2)**
- `Voice.TTS` - Text-to-speech synthesis
- `Audio.Mix` - Mix voice and music with ducking

**Subtitle Nodes (1)**
- `Subtitle.Auto` - Auto-generate subtitles

**Edit Nodes (1)**
- `Edit.Timeline` - Assemble timeline using template

**Output Nodes (2)**
- `Output.Render` - Final video rendering
- `Output.Download` - Make available for download

**Scheduling Nodes (1)**
- `Schedule.Cron` - Execute on schedule

---

## Billing Documentation

### Billing System

- **[Billing System](./billing/billing-system.md)**
  - Subscription tiers (Free, Starter, Pro, Enterprise)
  - Resource units (tokens, KAI credits, render seconds, storage)
  - Usage tracking and metering
  - Cost estimation API
  - Invoicing and payment
  - Quota management
  - Cost optimization strategies
  - Usage analytics
  - Alerts and notifications
  - Fair use policy

### Pricing Tables

**Subscription Tiers**
| Tier | Price | Tokens | KAI Credits | Render Seconds | Storage |
|------|-------|--------|-------------|----------------|---------|
| Free | $0 | 100K | 50 | 300 | 5 GB |
| Starter | $29 | 1M | 500 | 3,600 | 50 GB |
| Pro | $99 | 5M | 2,000 | 10,800 | 200 GB |
| Enterprise | Custom | Custom | Custom | Custom | Unlimited |

**Overage Rates**
| Resource | Starter | Pro |
|----------|---------|-----|
| LLM Tokens (per 100K) | $0.10 | $0.08 |
| KAI Credits (each) | $0.05 | $0.04 |
| Render Seconds | $0.02 | $0.015 |
| Storage (per GB) | $0.10 | $0.08 |

---

## Examples & Code Samples

### API Examples

- **[API Examples](./examples/api-examples.md)**
  - Authentication examples
  - Template CRUD operations
  - Workflow creation and execution
  - Direct job submission
  - Asset upload flow
  - Stock asset search
  - KAI image/video generation
  - Schedule management
  - Usage and billing queries
  - Webhook setup and verification
  - Error handling patterns
  - Retry strategies

### JSON Schemas

- **[JSON Schemas](./examples/json-schemas.md)**
  - Template schema with validation rules
  - Workflow schema with node/edge definitions
  - Job schema with config and result
  - Asset schema with metadata
  - Render schema
  - Usage record schema
  - Webhook payload schema

### Sample Workflows

**Daily News Shorts**
```
Stock Footage → Timeline → Render → Download
     ↑              ↑
Script → TTS → Subtitles
```

**AI Story with Generated Clips**
```
Script → TTS → Subtitles → Timeline → Render
                              ↑
AI Clip 1 ────────────────────┤
AI Clip 2 ────────────────────┤
AI Clip 3 ────────────────────┘
```

**Product Review**
```
Upload → Timeline → Render → Download
          ↑
Script → TTS → Subtitles
```

---

## Integration Guides

### External Services

**KAI (KEI) Integration**
- Image generation (Flux Pro, DALL-E 3, SD)
- Video generation (Sora, VEO, Minimax, BIO3, C-DANCE)
- Video editing (inpainting, style transfer)
- Credit system and cost tracking

**Stock Integration**
- Pexels free stock footage
- Search by query, orientation, duration
- Automatic caching
- No cost to user quota

**LLM Integration**
- OpenRouter / OpenAI
- Script generation with genre templates
- Script transformations
- AI chat assistant

**Stripe Integration**
- Subscription management
- Usage-based billing
- Webhook event handling
- Invoice generation

### Webhook Integration

**Supported Events**
- `render.succeeded` - Job completed successfully
- `render.failed` - Job failed
- `workflow.run.started` - Workflow execution started
- `workflow.run.finished` - Workflow execution finished
- `job.completed` - Job completed
- `job.failed` - Job failed

**Signature Verification**
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

## Security Documentation

### Authentication Methods

- JWT tokens (access + refresh)
- Personal Access Tokens (PAT)
- API key authentication
- OAuth 2.0 (Enterprise)
- SSO/SAML (Enterprise)

### Authorization

**RBAC Roles**
- Owner: Full access
- Admin: Manage users and resources
- Editor: Create and execute
- Viewer: Read-only

**Scoped Permissions**
- `workflows:read` / `workflows:write`
- `jobs:execute`
- `assets:upload`
- `billing:view`

### Data Security

- TLS 1.3 for transport
- Database encryption at rest
- Encrypted S3 buckets
- Presigned URLs (time-limited)
- Secrets management (AWS Secrets Manager)
- Audit logging

---

## Operational Documentation

### Monitoring

**Application Metrics**
- Request rate (RPS)
- Response time (p50, p95, p99)
- Error rate (4xx, 5xx)
- Active users
- Concurrent jobs

**Business Metrics**
- Workflows created per day
- Jobs executed per day
- Token consumption
- Revenue (MRR, churn)

**Infrastructure Metrics**
- CPU/Memory usage
- Database connections
- Queue depth
- S3 storage size

### Logging

**Structured Logs**
- Request ID for tracing
- User/Org context
- Timestamp, level, message
- Error stack traces
- 30-day retention (INFO)
- 90-day retention (ERROR)

### Alerting

**Critical Alerts**
- Error rate > 5% for 5 min
- Response time p95 > 2s
- DB connection pool exhausted
- Render engine down

**Channels**
- PagerDuty (critical)
- Slack (warnings)
- Email (digest)

---

## Development Documentation

### Local Development

**Prerequisites**
- Node.js 18+
- PostgreSQL 14+
- Redis 6+
- Docker & Docker Compose

**Setup**
```bash
git clone https://github.com/yourorg/fenta-web.git
cd fenta-web
npm install
cp .env.example .env
docker-compose up -d
npx prisma migrate dev
npm run dev
```

### Testing

**Test Types**
- Unit tests (80%+ coverage)
- Integration tests (API, DB)
- E2E tests (critical flows)

**Commands**
```bash
npm test              # Run all tests
npm run test:unit     # Unit tests only
npm run test:int      # Integration tests
npm run test:e2e      # E2E tests
npm run test:coverage # Coverage report
```

### CI/CD

**Pipeline**
```
Push → Tests → Build → Deploy Staging → E2E → Approve → Production
```

**Tools**
- GitHub Actions
- Docker
- AWS ECR/ECS
- Terraform

---

## API Client Libraries

### JavaScript/TypeScript

```bash
npm install @fentaweb/sdk
```

```javascript
import { FentaWeb } from '@fentaweb/sdk';

const client = new FentaWeb({ apiKey: 'YOUR_KEY' });
const job = await client.jobs.create({...});
```

### Python

```bash
pip install fentaweb
```

```python
from fentaweb import FentaWeb

client = FentaWeb(api_key='YOUR_KEY')
job = client.jobs.create({...})
```

### Go

```bash
go get github.com/fentaweb/sdk-go
```

```go
import "github.com/fentaweb/sdk-go"

client := fentaweb.NewClient("YOUR_KEY")
job, err := client.Jobs.Create(...)
```

---

## FAQ & Troubleshooting

### Common Questions

**Q: How do I estimate costs before rendering?**
```bash
POST /v1/workflows/{id}/estimate
```

**Q: Can I set budget limits?**
```json
{
  "budget": {
    "max_cost_usd": 1.00,
    "max_tokens": 10000
  }
}
```

**Q: What happens if I exceed quota?**
- Free tier: Jobs pause until reset
- Paid tiers: Automatic overage billing

**Q: How do I optimize costs?**
1. Use free stock footage (Pexels)
2. Choose budget LLM models (GPT-3.5 vs GPT-4)
3. Render at 720p instead of 1080p
4. Reuse cached AI generations

### Common Errors

**401 Unauthorized**
- Invalid or expired token
- Missing `Authorization` header

**429 Rate Limited**
- Exceeded 100 req/min
- Check `Retry-After` header

**QUOTA_EXCEEDED**
- Monthly quota reached
- Upgrade plan or wait for reset

---

## Support & Community

### Documentation

- **Main Docs**: This repository
- **User Guide**: https://docs.fentaweb.com
- **API Reference**: [OpenAPI Spec](./api/openapi.yaml)
- **Video Tutorials**: https://youtube.com/@fentaweb

### Community

- **Discord**: https://discord.gg/fentaweb
- **GitHub Issues**: https://github.com/yourorg/fenta-web/issues
- **Stack Overflow**: Tag `fenta-web`
- **Twitter**: @fentaweb

### Commercial Support

- **Email**: support@fentaweb.com
- **Priority Support**: Pro and Enterprise tiers
- **SLA**: Enterprise tier only
- **Phone Support**: Enterprise tier only

---

## Roadmap

### v1 (MVP) - Completed
- Templates and direct jobs
- Basic workflow builder
- Upload, Pexels, KAI integration
- TTS and subtitles
- Token billing
- Webhooks

### v2 (Current)
- Full workflow builder (15+ nodes)
- Scheduling
- AI chat assistant
- Enhanced analytics

### v3 (Future)
- Publishing connectors (YouTube, TikTok)
- Multi-user collaboration
- Template marketplace
- Mobile apps
- GraphQL API

---

## Changelog

See [CHANGELOG.md](./CHANGELOG.md) for version history.

---

## License

Proprietary - All rights reserved

---

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for contribution guidelines.

---

**Last Updated**: 2024-01-15
**Documentation Version**: 1.0.0
**API Version**: v1
