# fenta-web — Главный индекс документации

## О проекте

**fenta-web** — SaaS платформа для автоматического создания коротких видео (TikTok, Reels, Shorts).

### Компоненты системы

| Компонент | Описание | Технологии |
|-----------|----------|------------|
| **fenta-web** | SaaS фронтенд + API | Next.js 15, React 19, Supabase, Vercel, Tailwind |
| **FantaProjekt** | Рендер движок (внутренний) | Node.js, Remotion, FFmpeg, Kokoro TTS, Whisper |
| **KIE.ai** | AI генерация (внешний) | Veo, Sora, Kling, Runway, Flux, Suno, ElevenLabs |

---

## Быстрый старт

| Файл | Описание |
|------|----------|
| `GETTING_STARTED.md` | Создай первое видео за 5 минут |

---

## Структура документации

### 1. Архитектура (`architecture/`)

| Файл | Описание | Статус |
|------|----------|--------|
| `overview.md` | Общая архитектура системы | Готов |
| `stack.md` | Технологический стек с версиями | Готов |
| `data-flow.md` | Потоки данных и диаграммы | Готов |

### 2. API (`api/`)

| Файл | Описание | Статус |
|------|----------|--------|
| `openapi.yaml` | OpenAPI 3.0 спецификация fenta-web API | Готов |
| `fantaprojekt.md` | REST API рендер движка | Готов |
| `kie-ai-models.md` | Полный список моделей KIE.ai (21+) | Готов |

### 3. База данных (`database/`)

| Файл | Описание | Статус |
|------|----------|--------|
| `overview.md` | Обзор схемы Supabase | Готов |
| `users.md` | profiles, orgs, org_members, api_keys | Готов |
| `content.md` | templates, workflows, assets | Готов |
| `jobs.md` | jobs, renders, schedules, webhooks | Готов |
| `billing.md` | usage_records, quota_limits, invoices | Готов |

### 4. Workflows (`workflows/`)

| Файл | Описание | Статус |
|------|----------|--------|
| `overview.md` | Концепция и архитектура выполнения | Готов |
| `nodes-input.md` | Input.Upload, Input.Stock, Input.KAI.* | Готов |
| `nodes-script.md` | Script.Generate, Script.Transform | Готов |
| `nodes-audio.md` | Voice.TTS, Audio.Mix | Готов |
| `nodes-subtitle.md` | Subtitle.Auto, Subtitle.Style | Готов |
| `nodes-edit.md` | Edit.Timeline, Edit.Overlay, Edit.* | Готов |
| `nodes-output.md` | Output.Render, Output.Download, Schedule | Готов |
| `templates.md` | Шаблоны монтажа видео | Готов |

### 5. Биллинг (`billing/`)

| Файл | Описание | Статус |
|------|----------|--------|
| `overview.md` | Гибридная модель (подписка + токены) | Готов |
| `resources.md` | LLM tokens, KAI credits, Render seconds | Готов |
| `usage-tracking.md` | Отслеживание использования | Готов |
| `optimization.md` | Оптимизация расходов | Готов |

### 6. Интеграции (`integrations/`)

| Файл | Описание | Статус |
|------|----------|--------|
| `kie-ai.md` | Интеграция KIE.ai API | Готов |
| `pexels.md` | Бесплатный сток Pexels | Готов |
| `supabase.md` | Auth, Storage, Realtime | Готов |

### 7. Примеры (`examples/`)

| Файл | Описание | Статус |
|------|----------|--------|
| `workflow-json.md` | Примеры JSON workflows | Готов |
| `api-requests.md` | Примеры API запросов | Готов |
| `json-schemas.md` | JSON Schema для валидации данных | Готов |

---

## Быстрый старт для AI

### Понимание проекта

1. Прочитай `architecture/overview.md` — структура системы
2. Прочитай `architecture/stack.md` — используемые технологии
3. Прочитай `workflows/overview.md` — как работает визуальный конструктор

### Работа с API

1. `api/fantaprojekt.md` — внутренний рендер API
2. `api/kie-ai-models.md` — внешние AI модели
3. `examples/api-requests.md` — готовые примеры

### База данных

1. `database/overview.md` — общая структура
2. Выбери нужную область: users, content, jobs, billing

### Workflow Builder

1. `workflows/overview.md` — концепция
2. `workflows/nodes-*.md` — документация по категориям узлов
3. `examples/workflow-json.md` — готовые примеры

---

## Целевая аудитория

| Сегмент | JTBD |
|---------|------|
| Создатели контента | "Хочу выпускать 1-5 роликов в день без продакшна" |
| Маркетологи/агентства | "Хочу собрать конвейер и масштабировать по клиентам" |
| Солопренёры | "Хочу нажать 3 кнопки и получить ролик" |

---

## 60 ниш видео

Crime, True Crime, Mystery, Conspiracy, History, Science Facts, Space, Ocean, Animals, Nature, Psychology, Relationships, Dating, Self-Improvement, Motivation, Finance, Crypto, Investing, Tech News, AI Updates, Gaming, Movies, TV Shows, Celebrity, Music, Sports, Fitness, Health, Food, Cooking, Travel, Luxury, Cars, Real Estate, Art, Fashion, Beauty, DIY, Life Hacks, Parenting, Education, Language, Career, Entrepreneurship, Marketing, Social Media Tips, News, Politics, Weather, Weird News, Humor, Memes, Stories, Horror, ASMR, Satisfying, Oddly Satisfying, Animals Doing Things, Fails, Wins, Reviews, Unboxing

---

## Цели v1 (MVP)

1. Создание видео из шаблона за 3-5 шагов
2. Workflow Builder с 10-12 узлами
3. Интеграции: Upload, Pexels, KAI
4. Рендер: TTS + субтитры + монтаж
5. Расписания и пакетные прогонки
6. Токенный биллинг + подписка
7. AI агент-помощник в Workflow

## Откладываем на v2

- YouTube/TikTok автоаплоад
- Маркетплейс шаблонов
- Глубокие видео-эффекты
- Realtime коллаборация

---

## Статистика документации

| Категория | Файлов | Статус |
|-----------|--------|--------|
| Getting Started | 1 | Готово |
| Architecture | 3 | Готово |
| API | 3 | Готово |
| Database | 5 | Готово |
| Workflows | 8 | Готово |
| Billing | 4 | Готово |
| Integrations | 3 | Готово |
| Examples | 3 | Готово |
| **Итого** | **30** | **Готово** |
