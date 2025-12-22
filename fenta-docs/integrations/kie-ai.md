# Интеграция — KIE.ai

## Обзор

KIE.ai — внешний API для AI генерации контента. Предоставляет доступ к 21+ модели.

**Base URL:** `https://api.kie.ai`
**Auth:** `Authorization: Bearer API_KEY`
**Docs:** https://docs.kie.ai

---

## Доступные модели

### Video Generation

| Модель | Endpoint | Длительность | Credits |
|--------|----------|--------------|---------|
| Veo 3.1 | `/api/v1/veo/generate` | 8-12 сек | ~80 |
| Veo 3.1 Fast | `/api/v1/veo/generate` | 8-12 сек | ~70 |
| Sora 2 | `/api/v1/sora/generate` | 10-15 сек | ~100 |
| Kling 2.1 Pro | `/api/v1/kling/generate` | 5-10 сек | 50-70 |
| Kling 2.5 Turbo | `/api/v1/kling/generate` | 5-10 сек | 50 |
| Runway Gen-3 | `/api/v1/runway/generate` | 5-10 сек | 60-80 |
| Runway Aleph | `/api/v1/runway/generate` | - | 50-70 |
| Minimax | `/api/v1/minimax/generate` | 6-10 сек | 50 |
| Hailuo 02 | `/api/v1/hailuo/generate` | 8-12 сек | 60 |
| Wan 2.5 | `/api/v1/wan/generate` | 8-12 сек | 60 |
| Seedance | `/api/v1/seedance/generate` | 8-10 сек | 55 |
| Luma Modify | `/api/v1/luma/modify` | - | 50-70 |

### Image Generation

| Модель | Endpoint | Credits |
|--------|----------|---------|
| GPT-4o Image | `/api/v1/gpt4o-image/generate` | 10 |
| Flux Pro | `/api/v1/flux/generate` | 8 |
| Flux Kontext | `/api/v1/flux/generate` | 8 |
| Midjourney | `/api/v1/midjourney/generate` | 12 |
| Seedream V4 | `/api/v1/seedream/generate` | 8 |
| Qwen Image | `/api/v1/qwen/generate` | 6-8 |
| Ghibli AI | `/api/v1/ghibli/generate` | 10 |
| Recraft BG Removal | `/api/v1/recraft/remove-bg` | 2 |

### Audio

| Модель | Endpoint | Credits |
|--------|----------|---------|
| ElevenLabs TTS | `/api/v1/elevenlabs/tts` | 5-10/мин |
| ElevenLabs SFX | `/api/v1/elevenlabs/sfx` | 5-10 |

### Music

| Модель | Endpoint | Credits |
|--------|----------|---------|
| Suno V4 | `/api/v1/suno/generate` | 20-30 |
| Suno V4.5 | `/api/v1/suno/generate` | 20-30 |
| Suno V5 | `/api/v1/suno/generate` | 25-35 |

---

## Паттерн использования

### 1. Создание задачи

```http
POST /api/v1/{service}/generate
Content-Type: application/json
Authorization: Bearer API_KEY

{
  "prompt": "описание",
  "model": "model_name",
  "aspectRatio": "16:9",
  "callBackUrl": "https://your-webhook.com/callback"
}
```

**Response:**
```json
{
  "code": 200,
  "data": {
    "taskId": "task_abc123"
  }
}
```

### 2. Проверка статуса

```http
GET /api/v1/{service}/record-info?taskId={taskId}
```

**Response:**
```json
{
  "code": 200,
  "data": {
    "taskId": "task_abc123",
    "status": 0,
    "progress": 0.65,
    "resultUrls": []
  }
}
```

**Статусы:**
- `0` — generating
- `1` — success
- `2` — failed

### 3. Callback (Webhook)

KIE.ai отправляет POST на callBackUrl:

```json
{
  "code": 200,
  "data": {
    "taskId": "task_abc123",
    "resultUrls": ["https://cdn.kie.ai/result.mp4"]
  }
}
```

---

## Примеры запросов

### Генерация видео (Sora)

```bash
curl -X POST https://api.kie.ai/api/v1/sora/generate \
  -H "Authorization: Bearer $KIE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "A cat walking through a neon-lit alley at night",
    "model": "sora-2",
    "duration": 10,
    "aspectRatio": "9:16"
  }'
```

### Генерация изображения (Flux)

```bash
curl -X POST https://api.kie.ai/api/v1/flux/generate \
  -H "Authorization: Bearer $KIE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Cyberpunk city at sunset, neon lights",
    "model": "flux-pro",
    "width": 1024,
    "height": 1024
  }'
```

### Генерация музыки (Suno)

```bash
curl -X POST https://api.kie.ai/api/v1/suno/generate \
  -H "Authorization: Bearer $KIE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Dark ambient electronic, cinematic",
    "model": "suno-v4.5",
    "duration": 60,
    "instrumental": true
  }'
```

---

## Интеграция в fenta-web

### Конфигурация

```typescript
// integrations table
{
  provider: 'kai',
  credentials: {
    apiKey: 'encrypted_key_here'
  },
  config: {
    defaultVideoModel: 'veo3.1',
    defaultImageModel: 'flux-pro',
    callbackBaseUrl: 'https://api.fenta.app/webhooks/kai'
  }
}
```

### Обработчик callback

```typescript
// /webhooks/kai endpoint
async function handleKaiCallback(payload: KaiCallback) {
  const { taskId, resultUrls, code } = payload.data;

  // Найти генерацию по external_task_id
  const generation = await db.kai_generations
    .findOne({ external_task_id: taskId });

  if (code === 200 && resultUrls.length > 0) {
    // Создать ассеты из результатов
    const assets = await createAssetsFromUrls(resultUrls);

    // Обновить генерацию
    await db.kai_generations.update(generation.id, {
      status: 'completed',
      result_asset_ids: assets.map(a => a.id),
      completed_at: new Date()
    });

    // Продолжить workflow
    await continueWorkflow(generation.job_id);
  } else {
    await db.kai_generations.update(generation.id, {
      status: 'failed'
    });
  }
}
```

---

## Лимиты и retention

| Параметр | Значение |
|----------|----------|
| Хранение файлов | 14 дней |
| Download URL validity | 20 минут |
| Max concurrent tasks | Зависит от плана |

---

## Обработка ошибок

| Код | Описание | Действие |
|-----|----------|----------|
| 400 | Bad request | Проверить параметры |
| 401 | Unauthorized | Проверить API key |
| 402 | Insufficient credits | Пополнить баланс |
| 429 | Rate limit | Retry с backoff |
| 500 | Server error | Retry |
