# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

**Current year: 2025**

## STRICT RULES (MUST FOLLOW)
** 0.1 Говори на рус с  пользователем, всегда коротко, понятным без сложных терминов максимум, если пользвотель тебя реско остоновил чтото спросил обсьсни ему логику если он просит тебя об этом или по ситуации покажи ему всю кариту ситуации, предложи решения и варианты если это требует ситуация
** 1500 символов на ответ, если ситуации требует больше только в этом случает можешь этот лимит превышать в исключениех*

1. Проект для **ENGLISH ONLY** — All UI text, labels, buttons, messages in English. Target market: USA.

2. **UI ONLY via Tailwind CSS + shadcn/ui** — Never write custom CSS. All styles via Tailwind classes. All components via shadcn/ui. This speeds up development 3-5x.

3. **Dark theme by default** — Dark theme by default. `className="dark"` on html.

4. **TypeScript strict** — Always strict typing, no `any`.

---

## Project Overview

**fenta-web** — SaaS платформа для автоматического создания коротких видео (TikTok, Reels, Shorts).

## Tech Stack

| Technology | Purpose |
|------------|---------|
| Next.js 15 | App Router, React 19 |
| TypeScript | Strict typing |
| Tailwind CSS | Styling (NO custom CSS) |
| shadcn/ui | UI components |
| Supabase | Auth, Database, Storage |
| Zustand | State management |
| TanStack Query | Data fetching |
| React Flow | Workflow Builder |

## Project Structure

```
src/
├── app/              # Next.js App Router
│   ├── (auth)/       # Auth pages (login, register)
│   ├── (dashboard)/  # Protected dashboard pages
│   └── api/          # API routes
├── components/
│   ├── ui/           # shadcn/ui components
│   ├── layout/       # Layout components
│   └── features/     # Feature-specific components
├── lib/
│   ├── supabase/     # Supabase client
│   ├── api/          # API clients (KIE.ai, FantaProjekt)
│   └── utils/        # Utilities
├── stores/           # Zustand stores
└── types/            # TypeScript types
```

## Commands

```bash
npm run dev      # Development server
npm run build    # Production build
npm run lint     # ESLint
```

## Documentation

- Project docs: `/root/fenta-docs/`
- Fanta API (video): `/root/Fantapro-Tapla-ver`
- **AI Models pricing:** `/root/fenta-docs/api/openrouter/openrouter-top20-models-20251207.md` — ALWAYS check this file for actual AI model prices. NEVER make up prices!

## Architecture

### Path Alias
`@/*` → `./src/*`

### Providers Stack (src/components/providers.tsx)
- ThemeProvider (next-themes) — dark by default
- QueryClientProvider (TanStack Query) — staleTime: 60s
- Toaster (sonner) — bottom-right notifications

### Route Groups
- `(dashboard)/*` — protected pages with AppSidebar layout
- `(auth)/*` — auth pages (planned)

### Supabase Migrations
Located: `supabase/migrations/00001-00008`
Extensions → Users → Content → Jobs → Billing → Functions → RLS → Indexes

---

## Database Rules (Supabase Migrations)

When creating SQL migrations, ALWAYS follow:

1. **RLS (Row Level Security)** — Enable on ALL tables. Isolate by org_id.
2. **Indexes** — Create for: all FKs, status columns, created_at DESC
3. **Partial indexes** — Use `WHERE deleted_at IS NULL` for soft deletes
4. **GIN indexes** — For all JSONB columns (spec, graph, metadata, config)
5. **Triggers** — Auto-update `updated_at`, auto-create profile on signup
6. **Partitioning** — `usage_records` table by month (PARTITION BY RANGE)
7. **Conventions:**
   - UUID PKs with prefixes: user_, org_, wf_, job_, tmpl_, asset_
   - All tables: created_at, updated_at TIMESTAMPTZ DEFAULT NOW()
   - Soft deletes via deleted_at for critical tables
   - JSONB for flexible data

**Migration context file:** `/root/AI_CONTEXT_MIGRATIONS.md`
**Database docs:** `/root/fenta-docs/database/`
