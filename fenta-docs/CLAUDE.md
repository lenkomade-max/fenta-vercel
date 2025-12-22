# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is the **documentation repository** for the Fenta platform — a SaaS for automated short video creation (TikTok, Reels, Shorts). It contains technical documentation in Russian, not executable code.

## System Architecture

Fenta consists of three interconnected components:

1. **fenta-web** — SaaS frontend + API (Next.js 15, React 19, Supabase, Vercel)
   - Workflow Builder UI using React Flow
   - Authentication via Supabase Auth
   - Billing with hybrid subscription + token metering model

2. **FantaProjekt** — Internal render engine (Node.js, Remotion, FFmpeg)
   - REST API on port 3123
   - TTS via Kokoro.js (72+ voices)
   - Subtitles via Whisper
   - Auto-scaling based on load

3. **KIE.ai** — External AI provider (https://api.kie.ai)
   - Video generation: Veo, Sora, Kling, Runway, Minimax, Hailuo, Wan
   - Image generation: GPT-4o Image, Flux Kontext, Midjourney, Seedream
   - Voice: ElevenLabs TTS
   - Music: Suno V4/V5
   - Credit-based billing (pass-through to users)

## Documentation Structure

| Directory | Content |
|-----------|---------|
| `architecture/` | System overview, tech stack, data flow diagrams |
| `api/` | OpenAPI spec (`openapi.yaml`), FantaProjekt API, KIE.ai models |
| `database/` | Supabase PostgreSQL schema (users, content, jobs, billing) |
| `workflows/` | Workflow Builder nodes by category (Input, Script, Audio, Subtitle, Edit, Output) |
| `billing/` | Hybrid billing model, resources, usage tracking |
| `integrations/` | KIE.ai, Pexels, Supabase integrations |
| `examples/` | JSON workflow examples, API requests, schemas |

## Key Concepts

### Workflows
Node-based video production pipelines executed in topological order. Nodes have typed input/output ports (`text`, `image`, `video`, `audio`, `array`, `object`). Parallel execution for independent nodes.

### Jobs
Asynchronous render tasks with statuses: `queued` → `processing` → `completed`/`failed`. Realtime progress via Supabase subscriptions.

### Billing Resources
- **LLM tokens**: Script generation (prompt + completion)
- **KAI credits**: AI-generated media (pass-through from KIE.ai)
- **Render seconds**: FantaProjekt processing time
- **Storage**: Supabase Storage in GB

### Database Conventions
- UUID primary keys with prefixes (`user_`, `org_`, `wf_`, `job_`, `tmpl_`, `asset_`)
- Soft deletes via `deleted_at`
- JSONB for flexible data (`spec`, `graph`, `metadata`, `config`)
- Row Level Security for multi-tenancy

## Reading Order for New Contributors

1. `INDEX.md` — Full documentation index
2. `architecture/overview.md` — Three-layer architecture
3. `architecture/stack.md` — Tech stack with versions
4. `workflows/overview.md` — How workflows execute
5. `api/openapi.yaml` — API endpoints and schemas
