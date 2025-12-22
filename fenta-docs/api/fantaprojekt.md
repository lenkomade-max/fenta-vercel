# FantaProjekt API

Внутренний рендер движок. Не публичный API.

## Общая информация

**Base URL:** `http://fantaprojekt:3123/api` (внутренняя сеть)
**Content-Type:** `application/json`
**Max payload:** 500MB (для base64 uploads)

---

## Endpoints

### POST /short-video
Создать видео.

**Request:**
```json
{
  "scenes": [
    {
      "text": "Текст для озвучки",
      "media": {...},
      "mediaDuration": 3,
      "effects": [...],
      "textOverlays": [...],
      "advancedTextOverlays": [...],
      "voiceInstructions": "Dramatic tone",
      "sceneDuration": 10
    }
  ],
  "config": {
    "voice": "af_heart",
    "voiceSpeed": 1.0,
    "music": "dark",
    "musicVolume": "medium",
    "orientation": "portrait",
    "captionPosition": "bottom",
    "captionBackgroundColor": "#0000FF",
    "paddingBack": 1500,
    "skipSubtitles": false,
    "skipVoiceover": false,
    "voiceInstructions": "News anchor tone"
  },
  "globalText": "Текст для всех сцен (один TTS call)"
}
```

**Response:**
```json
{
  "videoId": "abc123xyz"
}
```

---

### GET /short-video/:videoId/status
Статус рендера.

**Response:**
```json
{
  "status": "processing",
  "progress": 65,
  "currentStage": "rendering",
  "error": null
}
```

**Статусы:**
- `queued` — в очереди
- `processing` — обработка
- `ready` — готово
- `failed` — ошибка

---

### GET /short-video/:videoId
Скачать готовое видео (MP4).

**Response:** Binary MP4 file
**Headers:**
- `Content-Type: video/mp4`
- `Content-Disposition: inline; filename={videoId}.mp4`

---

### DELETE /short-video/:videoId
Удалить видео.

**Response:**
```json
{"success": true}
```

---

### GET /short-videos
Список всех видео.

**Response:**
```json
{
  "videos": [
    {
      "id": "abc123",
      "status": "ready",
      "createdAt": "2024-12-07T10:00:00Z"
    }
  ]
}
```

---

### GET /voices
Список доступных голосов.

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
    "openai_onyx", "openai_nova", "openai_shimmer",
    "openai_alloy_hd", "openai_echo_hd"
  ]
}
```

**Kokoro префиксы:**
- `af_` — American Female
- `am_` — American Male
- `bf_` — British Female
- `bm_` — British Male

---

### GET /music-tags
Музыкальные настроения.

**Response:**
```json
[
  "sad", "melancholic", "happy", "euphoric/high",
  "excited", "chill", "uneasy", "angry", "dark",
  "hopeful", "contemplative", "funny/quirky",
  "crime_anepic", "crime_darkhorror", "crime_disturbance",
  "crime_dronesystem", "crime_drone_system_stalker", "crime_new_report"
]
```

---

### GET /effects
Библиотека эффектов.

**Response:**
```json
{
  "effects": [
    {
      "id": "vhs_01",
      "fileName": "VHS_01_small.mp4",
      "staticEffectPath": "effects/VHS_01_small.mp4",
      "url": "/static/effects/VHS_01_small.mp4"
    }
  ]
}
```

---

### POST /effects
Загрузить эффект.

**Request:**
```json
{
  "filename": "my_effect.mp4",
  "data": "base64...",
  "mimeType": "video/mp4"
}
```

**Response:**
```json
{
  "fileName": "hash123.mp4",
  "staticEffectPath": "effects/hash123.mp4",
  "url": "/static/effects/hash123.mp4"
}
```

---

### DELETE /effects/:id
Удалить эффект.

---

## Типы данных

### MediaSource

#### Pexels (бесплатно)
```json
{
  "type": "pexels",
  "searchTerms": ["city", "night", "traffic"]
}
```

#### URL
```json
{
  "type": "url",
  "urls": [
    "https://example.com/video1.mp4",
    "https://example.com/image.jpg"
  ]
}
```

#### Files (base64)
```json
{
  "type": "files",
  "files": [
    {
      "filename": "clip.mp4",
      "data": "base64encodedstring...",
      "mimeType": "video/mp4"
    }
  ]
}
```

---

### Effects

#### Blend Effect (VHS, glitch)
```json
{
  "type": "blend",
  "staticEffectPath": "effects/VHS_01_small.mp4",
  "blendMode": "overlay",
  "opacity": 0.5,
  "duration": "full"
}
```

**Blend Modes:**
- `normal`, `addition`, `screen`, `multiply`
- `overlay`, `average`, `lighten`, `darken`, `hardlight`

#### Banner Overlay (Chromakey)
```json
{
  "type": "banner_overlay",
  "staticBannerPath": "effects/banner.mp4",
  "chromakey": {
    "color": "0x00FF00",
    "similarity": 0.4,
    "blend": 0.1
  },
  "position": {"x": 0, "y": 0},
  "duration": "full"
}
```

---

### TextOverlay

```json
{
  "text": "ЗАГОЛОВОК",
  "position": {
    "x": "center",
    "y": "top"
  },
  "style": {
    "fontSize": 48,
    "fontFamily": "Inter",
    "color": "#FFFFFF",
    "backgroundColor": "#000000CC",
    "padding": 10,
    "opacity": 1
  },
  "animation": "fadeIn",
  "timing": {"start": 0, "end": 5}
}
```

**Position:**
- Aliases: `"left"`, `"center"`, `"right"`, `"top"`, `"bottom"`
- Pixels: `540`
- Percent: `"50%"`

**Animations:**
- `fadeIn`, `slideIn`, `typewriter`, `bounce`, `pulse`, `none`

---

### AdvancedTextOverlay

Многоцветный текст с сегментами:

```json
{
  "segments": [
    {"text": "Breaking ", "style": {"color": "#FF0000"}},
    {"text": "News", "style": {"color": "#FFFFFF", "fontWeight": "bold"}}
  ],
  "position": {"x": "center", "y": "10%"},
  "baseStyle": {
    "fontSize": 56,
    "fontFamily": "Oswald",
    "backgroundColor": "rgba(0,0,0,0.8)",
    "padding": 20
  },
  "animation": "slideIn"
}
```

---

### RenderConfig

```json
{
  "voice": "af_heart",
  "voiceSpeed": 1.2,
  "music": "dark",
  "musicVolume": "medium",
  "orientation": "portrait",
  "captionPosition": "85%",
  "captionBackgroundColor": "#0000FF",
  "paddingBack": 1500,
  "skipSubtitles": false,
  "skipVoiceover": false,
  "voiceInstructions": "Speak dramatically"
}
```

**Voice Speed:** 1.0 - 1.5 (normal to fast)

**Music Volume:**
- `muted`, `low`, `medium`, `high`, `very_high`, `ultra`

**Orientation:**
- `portrait` (1080x1920)
- `landscape` (1920x1080)

**Caption Position:**
- `top`, `center`, `bottom`
- Pixels: `100`
- Percent: `"85%"`

---

## mediaDuration

Контроль длительности медиа:

```json
{
  "scenes": [{
    "media": {
      "type": "url",
      "urls": ["photo1.jpg", "photo2.jpg", "photo3.jpg"]
    },
    "mediaDuration": 2
  }]
}
```

**Логика:**
- 3 фото × 2 сек = 6 сек медиа
- Если озвучка 12 сек → фото зациклятся
- Если озвучка 4 сек → видео обрежется до 4 сек

---

## skipVoiceover режим

Для видео без озвучки:

```json
{
  "scenes": [{
    "media": {"type": "pexels", "searchTerms": ["nature"]},
    "sceneDuration": 30
  }],
  "config": {
    "skipVoiceover": true,
    "music": "chill"
  }
}
```

---

## Примеры

### Минимальный запрос
```json
{
  "scenes": [{
    "text": "Hello world",
    "searchTerms": ["ocean"]
  }],
  "config": {
    "voice": "af_heart"
  }
}
```

### С эффектами и overlays
```json
{
  "scenes": [{
    "text": "Epic moment",
    "media": {"type": "url", "urls": ["https://example.com/video.mp4"]},
    "effects": [{
      "type": "blend",
      "staticEffectPath": "effects/VHS_01.mp4",
      "blendMode": "addition",
      "opacity": 0.5
    }],
    "textOverlays": [{
      "text": "BREAKING",
      "position": {"x": "center", "y": "10%"},
      "animation": "slideIn"
    }]
  }],
  "config": {
    "voice": "am_onyx",
    "voiceSpeed": 1.3,
    "music": "dark",
    "orientation": "portrait"
  }
}
```
