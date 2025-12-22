# Fenta Web - System Architecture

## Overview

Fenta Web is a SaaS platform for generating and editing viral short-form videos using AI, stock footage, and custom assets. The system consists of a Next.js frontend (fenta-web) and a closed backend rendering engine (FantaProjekt) with auto-scaling capabilities.

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         CLIENT LAYER                            │
├─────────────────────────────────────────────────────────────────┤
│  - Next.js 14 (App Router)                                      │
│  - React 18 + TypeScript                                        │
│  - TailwindCSS + shadcn/ui                                      │
│  - React Flow (Workflow Builder)                                │
│  - Zustand (State Management)                                   │
└─────────────────────────────────────────────────────────────────┘
                              ↕
┌─────────────────────────────────────────────────────────────────┐
│                          API LAYER                              │
├─────────────────────────────────────────────────────────────────┤
│  - REST API (Express/Fastify)                                   │
│  - JWT Authentication                                            │
│  - Rate Limiting                                                │
│  - Request Validation (Zod)                                     │
│  - OpenAPI 3.0 Specification                                    │
└─────────────────────────────────────────────────────────────────┘
                              ↕
┌─────────────────────────────────────────────────────────────────┐
│                      APPLICATION LAYER                          │
├─────────────────────────────────────────────────────────────────┤
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │   Workflow   │  │   Template   │  │   Job        │         │
│  │   Service    │  │   Service    │  │   Service    │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │   Asset      │  │   Schedule   │  │   Billing    │         │
│  │   Service    │  │   Service    │  │   Service    │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
│  ┌──────────────┐  ┌──────────────┐                           │
│  │   AI Agent   │  │   Webhook    │                           │
│  │   Service    │  │   Service    │                           │
│  └──────────────┘  └──────────────┘                           │
└─────────────────────────────────────────────────────────────────┘
                              ↕
┌─────────────────────────────────────────────────────────────────┐
│                    INTEGRATION LAYER                            │
├─────────────────────────────────────────────────────────────────┤
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │  KAI (KEI)   │  │  OpenRouter  │  │   Pexels     │         │
│  │  Image/Video │  │  / OpenAI    │  │   Stock API  │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │  Kokoro TTS  │  │  FantaProjekt│  │  S3 Storage  │         │
│  │              │  │  Render API  │  │              │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
└─────────────────────────────────────────────────────────────────┘
                              ↕
┌─────────────────────────────────────────────────────────────────┐
│                      DATA LAYER                                 │
├─────────────────────────────────────────────────────────────────┤
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │  PostgreSQL  │  │    Redis     │  │  S3/Object   │         │
│  │  (Primary)   │  │   (Cache)    │  │   Storage    │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
└─────────────────────────────────────────────────────────────────┘
                              ↕
┌─────────────────────────────────────────────────────────────────┐
│                    BACKGROUND JOBS                              │
├─────────────────────────────────────────────────────────────────┤
│  - BullMQ (Job Queue)                                           │
│  - Cron Scheduler (node-cron)                                   │
│  - Webhook Delivery Worker                                      │
│  - Asset Processing Worker                                      │
│  - Render Status Polling Worker                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Core Components

### 1. Frontend (fenta-web)

**Technology Stack:**
- Next.js 14 with App Router
- React 18 + TypeScript
- TailwindCSS + shadcn/ui components
- React Flow for workflow graph visualization
- Zustand for state management
- React Query for server state
- Zod for validation

**Key Pages:**
- `/dashboard` - Quick start and recent renders
- `/create` - Unified image/video generation interface
- `/workflows` - Visual workflow builder with node graph
- `/workflows/[id]` - Workflow editor with AI chat assistant
- `/templates` - Montage template editor
- `/assets` - Asset library and stock search
- `/schedules` - Cron schedule management
- `/renders` - Job history and status
- `/billing` - Usage and quota management
- `/settings` - API keys and integrations

**State Management:**
- Global store: User, organizations, current project
- Workflow store: Nodes, edges, selected node, history (undo/redo)
- Asset store: Uploads, generations, stock results
- Job store: Active jobs, status updates (SSE)

### 2. Backend API

**Technology Stack:**
- Node.js + Express/Fastify
- TypeScript
- Prisma ORM
- PostgreSQL
- Redis (caching, sessions, queue)
- BullMQ (job processing)
- AWS SDK (S3)

**Authentication:**
- JWT tokens (access + refresh)
- Personal Access Tokens (PAT) for API access
- Role-Based Access Control (RBAC): Owner, Admin, Editor, Viewer

**API Design Principles:**
- RESTful endpoints
- Consistent error responses
- Request/response validation
- Rate limiting per endpoint
- Pagination for list endpoints
- Filtering and sorting support
- Presigned URLs for asset operations

### 3. FantaProjekt Render Engine

**Closed Backend System:**
- Internal API for render job submission
- Auto-scaling render workers
- GPU-accelerated video processing
- Multi-stage rendering pipeline
- Priority queue system

**Render Pipeline:**

```
1. Ingest
   - Validate sources (duration, fps, codec, loudness)
   - Download/fetch assets
   - Calculate total duration

2. Script/LLM
   - Generate or transform script
   - Cache by prompt hash
   - Support for "strong" and "weak" LLM models

3. TTS/ASR
   - Text-to-speech synthesis (streaming or offline)
   - Automatic Speech Recognition for existing audio
   - Multi-language support

4. Subtitle Alignment
   - Phrase-based alignment
   - Karaoke-style word timing
   - Style application from template

5. Edit Engine
   - Assemble timeline based on template
   - Apply cuts, transitions, overlays
   - Respect safe zones
   - Audio ducking and mixing

6. Export
   - Encode to target profile (720p/1080p)
   - Generate artifacts (mp4, srt, thumbnail)
   - Upload to S3

7. Delivery
   - Generate presigned URLs
   - Fire webhooks
   - Update job status
```

**Observability:**
- End-to-end job_id tracking
- Stage-level timing metrics
- Error logging with context
- Retry mechanism with exponential backoff
- Dead Letter Queue (DLQ) for failed jobs

### 4. AI Integration Layer

**KAI (KEI) - Image/Video Generation:**
- Image models: Flux Pro, DALL-E 3
- Video models: Sora, VEO, Minimax, BIO3, C-DANCE
- Edit operations: inpainting, outpainting, style transfer
- Credit mapping and cost tracking

**OpenRouter/OpenAI - LLM Functions:**
- Script generation with genre templates
- Script transformation (translation, compression, adaptation)
- Prompt optimization for image/video generation
- Anti-repetition logic
- Chat agent capabilities

**Stock Integration:**
- Pexels API for free stock footage
- Search with query parameters
- No cost to user tokens
- Download tracking and caching

### 5. Database Architecture

**PostgreSQL as Primary Database:**
- ACID compliance for transactions
- JSON/JSONB support for flexible schemas
- Full-text search capabilities
- Partitioning for large tables (usage_records)
- Read replicas for scaling

**Redis for:**
- Session storage
- Rate limiting counters
- Job queue (BullMQ)
- Cache layer (frequently accessed data)
- Real-time pub/sub (job updates)

**S3/Object Storage:**
- User-uploaded assets
- Generated images/videos
- Render outputs
- Template previews
- Lifecycle policies for old assets

## Data Flow Diagrams

### Workflow Execution Flow

```
User submits workflow
         ↓
API validates workflow graph
         ↓
Calculate cost estimate
         ↓
User confirms
         ↓
Create Job record (status: queued)
         ↓
Enqueue to BullMQ
         ↓
Worker picks up job
         ↓
Execute nodes in topological order
         ↓
For each node:
  - Fetch inputs from previous nodes
  - Execute node logic
  - Store outputs
  - Update progress
         ↓
All nodes complete
         ↓
Submit to FantaProjekt for final render
         ↓
Poll render status
         ↓
Render complete
         ↓
Update job with artifacts
         ↓
Fire webhooks
         ↓
Mark job as completed
```

### Asset Upload Flow

```
User initiates upload
         ↓
POST /assets/init
  - Generate unique asset_id
  - Create presigned S3 upload URL
  - Return URL to client
         ↓
Client uploads directly to S3
         ↓
POST /assets/complete
  - Validate upload success
  - Extract metadata (duration, resolution, codec)
  - Generate thumbnail
  - Create Asset record
  - Return asset details
```

### AI Generation Flow

```
User submits generation request
         ↓
Validate parameters and quota
         ↓
Calculate estimated cost
         ↓
Create Generation record
         ↓
Call KAI API
         ↓
Poll generation status (async)
         ↓
Generation complete
         ↓
Download result to S3
         ↓
Create Asset record
         ↓
Update Usage record
         ↓
Notify user (webhook or SSE)
```

## Security Architecture

### Authentication & Authorization

**JWT Strategy:**
- Access token: 15 minutes expiry
- Refresh token: 7 days expiry
- HTTP-only cookies for web clients
- Bearer tokens for API clients

**Personal Access Tokens (PAT):**
- Long-lived tokens for integrations
- Scope-based permissions
- Can be revoked at any time
- Track last used timestamp

**RBAC Roles:**
- Owner: Full access, billing, delete organization
- Admin: Manage users, workflows, templates
- Editor: Create/edit workflows, run jobs
- Viewer: Read-only access

### Data Protection

**Encryption:**
- TLS 1.3 for all API traffic
- At-rest encryption for database (PostgreSQL native encryption)
- Encrypted S3 buckets (SSE-S3)
- Secrets stored in AWS Secrets Manager / HashiCorp Vault

**Presigned URLs:**
- Time-limited access to assets (1 hour default)
- IP restriction for sensitive operations
- CloudFront signed URLs for public assets

**API Security:**
- Rate limiting (per IP, per user, per endpoint)
- Request size limits
- SQL injection prevention (Prisma ORM)
- XSS protection (input sanitization)
- CSRF tokens for state-changing operations

## Scalability Considerations

### Horizontal Scaling

**Application Servers:**
- Stateless API servers
- Load balancer (ALB/NLB)
- Auto-scaling based on CPU/memory
- Session stored in Redis (not in-memory)

**Background Workers:**
- Multiple worker processes
- Job distribution via BullMQ
- Priority queues for urgent jobs
- Concurrency limits per worker

**Database:**
- Read replicas for heavy read operations
- Connection pooling (PgBouncer)
- Partition large tables by date
- Indexes on frequently queried columns

### Caching Strategy

**Multi-layer Cache:**
1. Client-side (React Query)
2. CDN (CloudFront for static assets)
3. API cache (Redis)
4. Database query cache

**Cache Invalidation:**
- Time-based expiry (TTL)
- Event-based invalidation (on update/delete)
- Manual purge endpoints

### Performance Optimization

**Database:**
- Prepared statements
- Batch inserts/updates
- Selective column fetching
- N+1 query prevention (DataLoader pattern)

**API:**
- Response compression (gzip/brotli)
- Pagination with cursor-based navigation
- GraphQL for complex nested queries (future)
- HTTP/2 for multiplexing

**Frontend:**
- Code splitting (Next.js automatic)
- Image optimization (next/image)
- Lazy loading for heavy components
- Virtual scrolling for long lists

## Monitoring & Observability

### Logging

**Structured Logging:**
- JSON format for machine parsing
- Request ID for tracing
- User ID and organization ID
- Timestamp, level, message, context

**Log Levels:**
- ERROR: Application errors, exceptions
- WARN: Deprecated usage, quota warnings
- INFO: Request logs, job status changes
- DEBUG: Detailed execution flow (dev only)

**Log Storage:**
- CloudWatch Logs / ELK Stack
- Retention: 30 days for INFO, 90 days for ERROR
- Log aggregation across multiple servers

### Metrics

**Application Metrics:**
- Request rate (RPS)
- Response time (p50, p95, p99)
- Error rate (4xx, 5xx)
- Active users
- Concurrent jobs

**Business Metrics:**
- Workflows created per day
- Jobs executed per day
- Token consumption
- Revenue (MRR, churn)

**Infrastructure Metrics:**
- CPU/Memory usage
- Database connections
- Queue depth
- S3 storage size

### Alerting

**Alert Rules:**
- Error rate > 5% for 5 minutes
- Response time p95 > 2 seconds
- Queue depth > 1000 jobs
- Database connection pool exhausted
- S3 upload failures
- Render engine downtime

**Alert Channels:**
- PagerDuty for critical alerts
- Slack for warnings
- Email for daily digests

## Disaster Recovery

### Backup Strategy

**Database Backups:**
- Automated daily backups (RDS automated backups)
- Point-in-time recovery (PITR) enabled
- Cross-region replication for critical data
- Retention: 7 days for daily, 30 days for weekly

**Asset Backups:**
- S3 versioning enabled
- Cross-region replication for critical buckets
- Lifecycle policies to archive old versions

**Configuration Backups:**
- Infrastructure as Code (Terraform)
- Environment variables in Secrets Manager
- Git repository for all code

### Failover Plan

**Database Failover:**
- Automated failover to read replica (< 2 minutes)
- DNS update to new primary
- Application restart to clear connection pool

**Application Failover:**
- Multi-AZ deployment
- Health checks on load balancer
- Automatic instance replacement

**Render Engine Failover:**
- Queue jobs in BullMQ (persistent)
- Retry failed jobs with exponential backoff
- Manual intervention for persistent failures

## Development & Deployment

### Environment Strategy

**Environments:**
1. Local Development (Docker Compose)
2. Staging (mirrors production)
3. Production (multi-region)

**Environment Variables:**
- DATABASE_URL
- REDIS_URL
- S3_BUCKET_NAME
- JWT_SECRET
- KAI_API_KEY
- OPENAI_API_KEY
- PEXELS_API_KEY
- FANTA_PROJEKT_API_URL

### CI/CD Pipeline

```
Git Push
   ↓
GitHub Actions triggered
   ↓
Run tests (unit, integration)
   ↓
Build Docker image
   ↓
Push to ECR
   ↓
Deploy to staging (automatic)
   ↓
Run E2E tests
   ↓
Manual approval for production
   ↓
Deploy to production (blue-green)
   ↓
Health check
   ↓
Switch traffic
```

### Testing Strategy

**Unit Tests:**
- Service layer logic
- Utility functions
- Component rendering

**Integration Tests:**
- API endpoint testing
- Database operations
- External API mocking

**E2E Tests:**
- Critical user flows
- Workflow creation and execution
- Payment and billing

**Performance Tests:**
- Load testing (k6)
- Stress testing render pipeline
- Database query performance

## Future Enhancements (v2+)

1. **Multi-user Collaboration**
   - Real-time workflow editing (CRDT/OT)
   - Comments and annotations
   - Version control for workflows

2. **Template Marketplace**
   - User-submitted templates
   - Rating and reviews
   - Revenue sharing model

3. **Advanced Publishing**
   - Direct upload to YouTube, TikTok, Instagram
   - Scheduling and auto-posting
   - Analytics integration

4. **Enhanced Video Effects**
   - Advanced compositing
   - Motion tracking
   - 3D effects and particles

5. **Mobile App**
   - iOS and Android native apps
   - Simplified workflow creation
   - Push notifications for job completion

6. **GraphQL API**
   - Flexible queries
   - Real-time subscriptions
   - Better frontend performance

7. **Enterprise Features**
   - SSO (SAML, OAuth)
   - Custom domain branding
   - Dedicated infrastructure
   - SLA guarantees
