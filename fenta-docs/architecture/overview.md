# Архитектура системы

## Три слоя

```
┌──────────────────────────────────────────────────────────┐
│                    fenta-web (SaaS)                      │
│              Next.js 15 + Supabase + Vercel              │
│                                                          │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────────┐ │
│  │Dashboard│  │ Create  │  │Workflow │  │   Montage   │ │
│  │         │  │  Page   │  │ Builder │  │   Editor    │ │
│  └─────────┘  └─────────┘  └─────────┘  └─────────────┘ │
│                                                          │
│  ┌─────────────────────────────────────────────────────┐│
│  │              Supabase (PostgreSQL + Auth)           ││
│  │         users, orgs, workflows, jobs, billing       ││
│  └─────────────────────────────────────────────────────┘│
└────────────────────────┬─────────────────────────────────┘
                         │
            ┌────────────┴────────────┐
            ▼                         ▼
┌───────────────────────┐  ┌─────────────────────────┐
│     FantaProjekt      │  │        KIE.ai           │
│    (Рендер движок)    │  │    (AI генерация)       │
│                       │  │                         │
│  • TTS (Kokoro 72+)   │  │  • Video: Veo, Sora,    │
│  • Subtitles (Whisper)│  │    Kling, Runway        │
│  • FFmpeg effects     │  │  • Image: GPT-4o, Flux  │
│  • Remotion render    │  │  • Voice: ElevenLabs    │
│                       │  │  • Music: Suno          │
│  Внутренний API       │  │  Внешний API            │
│  (автомасштабируемый) │  │  (кредитная система)    │
└───────────────────────┘  └─────────────────────────┘
```

## fenta-web

**Роль:** SaaS платформа, UI, бизнес-логика, биллинг

**Функции:**
- Авторизация через Supabase Auth
- Workflow Builder UI
- Шаблоны монтажа (Templates)
- Галерея ассетов
- Биллинг и квоты
- Очереди задач
- AI агент-помощник

**Развертывание:** Vercel (Edge Functions, Serverless)

---

## FantaProjekt

**Роль:** Рендер движок, сборка финального видео

**Функции:**
- Сборка видео по сценам
- TTS озвучка (Kokoro — 72+ голоса, OpenAI)
- Субтитры (Whisper ASR)
- Эффекты (blend modes, chromakey)
- Музыка с ducking
- Экспорт MP4 (9:16, 16:9, 1:1)

**API:** Внутренний REST API на порту 3123
**Масштабирование:** Автоматическое, новые серверы по нагрузке

---

## KIE.ai

**Роль:** Внешний AI провайдер для генерации контента

**Модели:**
- **Видео:** Veo 3.1, Sora 2, Kling 2.5, Runway Gen-3, Minimax, Hailuo, Wan 2.5
- **Изображения:** GPT-4o Image, Flux Kontext, Midjourney, Seedream V4
- **Голос:** ElevenLabs TTS
- **Музыка:** Suno V4/V5

**API:** `https://api.kie.ai`
**Биллинг:** Кредитная система (pass-through к пользователям)

---

## Принципы архитектуры

### 1. Separation of Concerns
- fenta-web: UI + бизнес-логика
- FantaProjekt: только рендер
- KIE.ai: только генерация

### 2. Async Processing
- Все тяжелые операции асинхронны
- Job queue с статусами
- Webhooks для уведомлений

### 3. Multi-tenancy
- Row Level Security в Supabase
- Org-based изоляция данных
- Квоты на уровне организации

### 4. Scalability
- Stateless API (Vercel Edge)
- Horizontal scaling (FantaProjekt)
- Queue-based processing
