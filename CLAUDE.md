# CLAUDE.md

## STRICT RULES (MUST FOLLOW)

1. **ENGLISH ONLY** — All UI text, labels, buttons, messages in English. Target market: USA.

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

Full documentation: `/root/fenta-docs/`
