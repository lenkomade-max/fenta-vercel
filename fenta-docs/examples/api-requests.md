# Примеры — API Requests

## FantaProjekt API

### Создание видео

```bash
curl -X POST http://fantaprojekt:3123/api/short-video \
  -H "Content-Type: application/json" \
  -d '{
    "scenes": [
      {
        "text": "Breaking news from the city tonight. Here are the key facts you need to know.",
        "media": {
          "type": "pexels",
          "searchTerms": ["city", "night", "news"]
        },
        "mediaDuration": 3,
        "textOverlays": [
          {
            "text": "BREAKING",
            "position": {"x": "center", "y": "10%"},
            "style": {
              "fontSize": 56,
              "fontFamily": "Oswald",
              "color": "#FFFFFF",
              "backgroundColor": "#FF0000"
            },
            "animation": "slideIn",
            "timing": {"start": 0, "end": 3}
          }
        ]
      }
    ],
    "config": {
      "voice": "am_onyx",
      "voiceSpeed": 1.05,
      "music": "crime_new_report",
      "musicVolume": "medium",
      "orientation": "portrait",
      "captionPosition": "85%"
    }
  }'
```

**Response:**
```json
{
  "videoId": "abc123xyz"
}
```

---

### Проверка статуса

```bash
curl http://fantaprojekt:3123/api/short-video/abc123xyz/status
```

**Response:**
```json
{
  "status": "processing",
  "progress": 65,
  "currentStage": "rendering",
  "error": null
}
```

---

### Скачивание видео

```bash
curl -O http://fantaprojekt:3123/api/short-video/abc123xyz
```

---

### Список голосов

```bash
curl http://fantaprojekt:3123/api/voices
```

**Response:**
```json
{
  "kokoro": [
    "af_heart", "af_alloy", "af_bella", "af_jessica",
    "am_adam", "am_echo", "am_onyx", "am_michael",
    "bf_emma", "bf_lily", "bm_george", "bm_daniel"
  ],
  "openai": [
    "openai_alloy", "openai_echo", "openai_fable",
    "openai_onyx", "openai_nova", "openai_shimmer"
  ]
}
```

---

### Список музыкальных тегов

```bash
curl http://fantaprojekt:3123/api/music-tags
```

**Response:**
```json
[
  "sad", "melancholic", "happy", "euphoric/high",
  "excited", "chill", "uneasy", "angry", "dark",
  "hopeful", "contemplative", "funny/quirky",
  "crime_anepic", "crime_darkhorror", "crime_new_report"
]
```

---

## KIE.ai API

### Генерация видео (Veo 3.1)

```bash
curl -X POST https://api.kie.ai/api/v1/veo/generate \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Cinematic aerial shot of a futuristic city at sunset, neon lights, flying vehicles",
    "model": "veo3.1",
    "aspectRatio": "9:16",
    "duration": 10,
    "callBackUrl": "https://your-webhook.com/callback"
  }'
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

---

### Проверка статуса генерации

```bash
curl "https://api.kie.ai/api/v1/veo/record-info?taskId=task_abc123" \
  -H "Authorization: Bearer YOUR_API_KEY"
```

**Response:**
```json
{
  "code": 200,
  "data": {
    "taskId": "task_abc123",
    "status": 1,
    "progress": 1.0,
    "resultUrls": ["https://cdn.kie.ai/result/video.mp4"]
  }
}
```

**Статусы:**
- `0` — generating
- `1` — success
- `2` — failed

---

### Генерация изображения (Flux)

```bash
curl -X POST https://api.kie.ai/api/v1/flux/generate \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "A beautiful sunset over mountains, photorealistic, 4k",
    "model": "flux-pro",
    "width": 1024,
    "height": 1024,
    "seed": 42
  }'
```

---

### Генерация музыки (Suno)

```bash
curl -X POST https://api.kie.ai/api/v1/suno/generate \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Dark ambient electronic music, suspenseful, cinematic",
    "model": "suno-v4.5",
    "duration": 60,
    "instrumental": true
  }'
```

---

### Проверка баланса

```bash
curl https://api.kie.ai/api/v1/account/credits \
  -H "Authorization: Bearer YOUR_API_KEY"
```

**Response:**
```json
{
  "code": 200,
  "data": {
    "credits": 1500,
    "usedCredits": 500
  }
}
```

---

## fenta-web API

### Создание workflow

```bash
curl -X POST https://api.fenta.app/v1/workflows \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "My News Workflow",
    "description": "Generates daily news videos",
    "projectId": "proj_abc123",
    "graph": {
      "nodes": [...],
      "edges": [...]
    },
    "variables": {
      "topic": "technology"
    }
  }'
```

---

### Запуск workflow

```bash
curl -X POST https://api.fenta.app/v1/workflows/wf_abc123/run \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "mode": "production",
    "variables": {
      "topic": "AI breakthrough"
    }
  }'
```

---

### Оценка стоимости

```bash
curl -X POST https://api.fenta.app/v1/workflows/wf_abc123/estimate \
  -H "Authorization: Bearer YOUR_TOKEN"
```

**Response:**
```json
{
  "estimated": {
    "tokens": 5000,
    "renderSeconds": 45.0,
    "kaiCredits": 120,
    "totalUsd": 0.87,
    "duration": "2-5 minutes"
  },
  "breakdown": [
    {"node": "script", "type": "Script.Generate", "cost": 0.02},
    {"node": "voice", "type": "Voice.TTS", "cost": 0.05},
    {"node": "render", "type": "Output.Render", "cost": 0.40}
  ]
}
```

---

### Получение статуса job

```bash
curl https://api.fenta.app/v1/jobs/job_xyz789 \
  -H "Authorization: Bearer YOUR_TOKEN"
```

**Response:**
```json
{
  "id": "job_xyz789",
  "status": "processing",
  "progress": 65,
  "currentNode": "render",
  "completedNodes": ["stock", "script", "voice", "subs", "timeline"],
  "cost": {
    "tokens": 800,
    "renderSeconds": 0,
    "kaiCredits": 0,
    "totalUsd": 0.02
  },
  "createdAt": "2025-01-15T10:00:00Z",
  "updatedAt": "2025-01-15T10:02:30Z"
}
```

---

### Получение квоты

```bash
curl https://api.fenta.app/v1/usage/quota \
  -H "Authorization: Bearer YOUR_TOKEN"
```

---

### Статистика использования

```bash
curl "https://api.fenta.app/v1/usage?startDate=2025-01-01&endDate=2025-01-31&groupBy=day" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

---

### Покупка Credit Pack

```bash
curl -X POST https://api.fenta.app/v1/billing/credit-packs \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "packSize": "medium",
    "paymentMethodId": "pm_abc123"
  }'
```

---

## Webhook Payload Examples

### Job Completed

```json
{
  "event": "job.completed",
  "timestamp": "2025-01-15T10:05:00Z",
  "data": {
    "jobId": "job_abc123",
    "workflowId": "wf_xyz789",
    "videoUrl": "https://storage.fenta.app/videos/abc123.mp4",
    "thumbnailUrl": "https://storage.fenta.app/thumbs/abc123.jpg",
    "srtUrl": "https://storage.fenta.app/subs/abc123.srt",
    "metadata": {
      "duration": 60.5,
      "resolution": "1080x1920",
      "fileSize": 25000000
    },
    "cost": {
      "tokens": 1500,
      "renderSeconds": 90,
      "kaiCredits": 0,
      "totalUsd": 1.38
    }
  },
  "signature": "sha256=abc123..."
}
```

### Job Failed

```json
{
  "event": "job.failed",
  "timestamp": "2025-01-15T10:05:00Z",
  "data": {
    "jobId": "job_abc123",
    "workflowId": "wf_xyz789",
    "error": {
      "code": "RENDER_FAILED",
      "message": "FFmpeg encoding error",
      "stage": "export",
      "retryable": true
    }
  },
  "signature": "sha256=abc123..."
}
```

### Quota Warning

```json
{
  "event": "quota.warning",
  "timestamp": "2025-01-15T10:00:00Z",
  "data": {
    "orgId": "org_abc123",
    "resource": "kai_credits",
    "used": 1800,
    "limit": 2000,
    "percentage": 90
  },
  "signature": "sha256=abc123..."
}
```
