# Getting Started — Быстрый старт

Создайте первое видео за 5 минут.

---

## Шаг 1: Регистрация

### Через Web UI

1. Перейдите на https://app.fenta.com
2. Нажмите "Sign Up"
3. Войдите через Google или Email

### Через API

```bash
curl -X POST https://api.fenta.com/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "you@example.com",
    "password": "SecurePassword123!",
    "name": "Your Name"
  }'
```

**Response:**
```json
{
  "user": {
    "id": "user_abc123",
    "email": "you@example.com",
    "name": "Your Name"
  },
  "session": {
    "access_token": "eyJhbGciOiJIUzI1NiIs...",
    "refresh_token": "..."
  }
}
```

Сохраните `access_token` — он нужен для всех API запросов.

---

## Шаг 2: Создание первого видео

### Вариант A: Через Workflow Builder (рекомендуется)

1. Перейдите в `/workflows`
2. Нажмите "Create Workflow"
3. Добавьте узлы:
   - `Input.Stock` → поиск видео на Pexels
   - `Script.Generate` → генерация текста
   - `Voice.TTS` → озвучка
   - `Subtitle.Auto` → субтитры
   - `Edit.Timeline` → сборка
   - `Output.Render` → рендер
4. Соедините узлы
5. Нажмите "Run"

### Вариант B: Через API (прямой job)

```bash
curl -X POST https://api.fenta.com/v1/jobs \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "template_id": "tmpl_shorts_v1",
    "sources": [
      {
        "type": "stock",
        "provider": "pexels",
        "query": "sunset beach ocean",
        "count": 3
      }
    ],
    "script": {
      "lang": "en",
      "text": "Discover the beauty of nature. Stunning sunsets await you."
    },
    "tts": {
      "engine": "kokoro",
      "voice": "af_heart",
      "speed": 1.0
    },
    "subtitles": {
      "style": "karaoke_bounce"
    },
    "output": {
      "profile": "9x16_1080p"
    }
  }'
```

**Response:**
```json
{
  "id": "job_abc123",
  "status": "queued",
  "progress": 0,
  "created_at": "2025-01-15T14:20:00Z"
}
```

---

## Шаг 3: Проверка статуса

### Polling

```bash
curl https://api.fenta.com/v1/jobs/job_abc123 \
  -H "Authorization: Bearer YOUR_TOKEN"
```

**Response (в процессе):**
```json
{
  "id": "job_abc123",
  "status": "processing",
  "progress": 65,
  "currentStage": "rendering"
}
```

**Response (готово):**
```json
{
  "id": "job_abc123",
  "status": "completed",
  "progress": 100,
  "result": {
    "video_url": "https://storage.fenta.com/renders/job_abc123.mp4",
    "thumbnail_url": "https://storage.fenta.com/thumbs/job_abc123.jpg",
    "srt_url": "https://storage.fenta.com/subs/job_abc123.srt",
    "duration": 15.5
  },
  "cost": {
    "tokens": 500,
    "render_seconds": 23,
    "kai_credits": 0,
    "total_usd": 0.35
  }
}
```

### Через Webhook

Настройте webhook для получения уведомлений:

```bash
curl -X POST https://api.fenta.com/v1/webhooks \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://your-site.com/webhook",
    "events": ["job.completed", "job.failed"]
  }'
```

---

## Шаг 4: Скачивание видео

```bash
# Прямая ссылка из result.video_url
curl -O "https://storage.fenta.com/renders/job_abc123.mp4"
```

Или в Web UI: Dashboard → Recent Renders → Download

---

## Примеры use cases

### 1. News Video (30 сек)

```json
{
  "sources": [
    {"type": "stock", "provider": "pexels", "query": "breaking news city"}
  ],
  "script": {
    "generate": true,
    "genre": "news",
    "prompt": "Breaking news about technology breakthrough",
    "duration": 30
  },
  "tts": {
    "engine": "kokoro",
    "voice": "am_michael",
    "speed": 1.05
  },
  "music": "crime_new_report",
  "output": {"profile": "9x16_1080p"}
}
```

### 2. Crime Story (60 сек)

```json
{
  "sources": [
    {"type": "stock", "provider": "pexels", "query": "dark mystery crime"}
  ],
  "script": {
    "generate": true,
    "genre": "crime",
    "prompt": "True crime story about mysterious disappearance",
    "duration": 60
  },
  "tts": {
    "engine": "kokoro",
    "voice": "am_onyx",
    "speed": 1.02,
    "voiceInstructions": "Speak dramatically with suspenseful pauses"
  },
  "music": "crime_darkhorror",
  "effects": [
    {
      "type": "blend",
      "staticEffectPath": "effects/VHS_01.mp4",
      "blendMode": "overlay",
      "opacity": 0.4
    }
  ],
  "output": {"profile": "9x16_1080p"}
}
```

### 3. AI Generated Video

```json
{
  "sources": [
    {
      "type": "kai",
      "model": "sora",
      "prompt": "Futuristic city at night with flying cars",
      "duration": 10
    }
  ],
  "script": {
    "lang": "en",
    "text": "Welcome to the future. This is what 2050 looks like."
  },
  "tts": {"engine": "kokoro", "voice": "af_alloy"},
  "output": {"profile": "9x16_1080p"}
}
```

---

## Полезные endpoints

| Endpoint | Описание |
|----------|----------|
| `GET /v1/templates` | Список шаблонов |
| `GET /v1/voices` | Доступные голоса |
| `GET /v1/music-tags` | Музыкальные теги |
| `GET /v1/effects` | Библиотека эффектов |
| `GET /v1/usage/quota` | Текущая квота |
| `POST /v1/workflows/{id}/estimate` | Оценка стоимости |

---

## Лимиты Free tier

| Ресурс | Лимит |
|--------|-------|
| LLM токены | 100,000/мес |
| KAI кредиты | 50/мес |
| Render seconds | 300/мес (5 мин) |
| Storage | 5 GB |
| Workflows | 3 |
| Jobs | 10/мес |

Для снятия лимитов — upgrade на Starter ($29/мес) или Pro ($99/мес).

---

## Частые ошибки

### 401 Unauthorized

```json
{"error": "Invalid or expired token"}
```
**Решение:** Обновите токен через `/v1/auth/refresh`

### 402 Quota Exceeded

```json
{"error": "Monthly quota exceeded", "resource": "render_seconds"}
```
**Решение:** Дождитесь сброса квоты или upgrade плана

### 400 Invalid Parameters

```json
{"error": "Validation failed", "details": {"voice": "Unknown voice ID"}}
```
**Решение:** Проверьте параметры через `/v1/voices`

---

## Следующие шаги

1. **Изучите Workflow Builder** → `workflows/overview.md`
2. **Создайте свой шаблон** → `workflows/templates.md`
3. **Настройте расписание** → `Schedule.Cron` узел
4. **Оптимизируйте расходы** → `billing/optimization.md`
5. **Интегрируйте API** → `api/openapi.yaml`

---

## Поддержка

- **Docs:** https://docs.fenta.com
- **Email:** support@fenta.com
- **Discord:** https://discord.gg/fenta
