# Технологический стек

## Frontend

| Технология | Версия | Назначение |
|------------|--------|------------|
| **Next.js** | 15 | React framework, App Router |
| **React** | 19 | UI библиотека |
| **TypeScript** | 5+ | Типизация |
| **Tailwind CSS** | 3.4+ | Стилизация |
| **Shadcn/ui** | latest | UI компоненты |
| **React Flow** | 11+ | Workflow Builder (ноды) |
| **Zustand** | 4+ | State management |
| **TanStack Query** | 5+ | Data fetching |
| **Framer Motion** | 11+ | Анимации |

---

## Backend

| Технология | Версия | Назначение |
|------------|--------|------------|
| **Supabase** | latest | PostgreSQL + Auth + Storage |
| **Vercel** | - | Hosting, Edge Functions |
| **Supabase Realtime** | - | Live updates |

---

## FantaProjekt (Render Engine)

| Технология | Версия | Назначение |
|------------|--------|------------|
| **Node.js** | 18+ | Runtime |
| **TypeScript** | 5+ | Типизация |
| **Remotion** | 4.0.286 | Программный рендер видео |
| **FFmpeg** | latest | Видео/аудио обработка |
| **Kokoro.js** | 1.2.0 | TTS (72+ голоса) |
| **Whisper CPP** | latest | Speech-to-text (субтитры) |
| **Express** | 4.18+ | REST API |
| **Pino** | 9+ | Логирование |

---

## Внешние API

| Сервис | Назначение |
|--------|------------|
| **KIE.ai** | AI генерация (видео, фото, голос, музыка) |
| **Pexels** | Бесплатные стоковые медиа |
| **Stripe** | Платежи и подписки |

---

## DevOps

| Технология | Назначение |
|------------|------------|
| **Vercel** | CI/CD, Preview deploys |
| **Docker** | Контейнеризация FantaProjekt |
| **GitHub Actions** | Автоматизация |

---

## Структура монорепо

```
fenta-web/
├── apps/
│   └── web/                 # Next.js приложение
│       ├── app/             # App Router pages
│       ├── components/      # React компоненты
│       ├── lib/             # Утилиты
│       └── styles/          # CSS
│
├── packages/
│   ├── ui/                  # Shared UI компоненты
│   ├── database/            # Supabase клиент, типы
│   └── config/              # Shared конфиги
│
├── supabase/
│   ├── migrations/          # SQL миграции
│   └── functions/           # Edge Functions
│
└── docs/                    # Документация
```

---

## Ключевые библиотеки

### UI
```json
{
  "@radix-ui/react-*": "UI primitives",
  "class-variance-authority": "Variant styles",
  "clsx": "Classname utils",
  "lucide-react": "Icons"
}
```

### Data
```json
{
  "@supabase/supabase-js": "Supabase client",
  "@supabase/ssr": "Server-side auth",
  "zod": "Schema validation"
}
```

### Workflow
```json
{
  "reactflow": "Node-based editor",
  "@xyflow/react": "React Flow v12"
}
```
