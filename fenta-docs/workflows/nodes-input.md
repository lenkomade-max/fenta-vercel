# Input Nodes — Получение исходных материалов

Input узлы — точки входа для медиа-контента в workflow.

---

## Input.Upload

Загрузка пользовательских ассетов из хранилища.

**Тип:** `Input.Upload`

**Параметры:**
```typescript
{
  assetIds: string[];  // Массив ID ассетов для загрузки
}
```

**Входы:** Нет

**Выходы:**
- `assets` (array) — Массив объектов ассетов с URL

**Стоимость:** Бесплатно (ассеты уже загружены)

**Пример:**
```json
{
  "id": "n1",
  "type": "Input.Upload",
  "params": {
    "assetIds": ["asset_abc123", "asset_xyz789"]
  }
}
```

**Структура выходных данных:**
```json
{
  "assets": [
    {
      "id": "asset_abc123",
      "type": "video",
      "url": "https://storage.../clip.mp4",
      "duration": 15.5,
      "width": 1080,
      "height": 1920
    }
  ]
}
```

---

## Input.Stock

Поиск и загрузка стокового контента с Pexels.

**Тип:** `Input.Stock`

**Параметры:**
```typescript
{
  provider: 'pexels';                              // Провайдер (пока только Pexels)
  query: string;                                   // Поисковый запрос
  type?: 'image' | 'video';                        // Тип (default: 'video')
  count?: number;                                  // Количество результатов (1-10)
  orientation?: 'portrait' | 'landscape' | 'square';
  minDuration?: number;                            // Мин. длительность (video)
  maxDuration?: number;                            // Макс. длительность (video)
}
```

**Входы:** Нет

**Выходы:**
- `assets` (array) — Массив стоковых ассетов

**Стоимость:** Бесплатно (Pexels — бесплатный сток)

**Пример:**
```json
{
  "id": "stock_broll",
  "type": "Input.Stock",
  "params": {
    "provider": "pexels",
    "query": "storm city night rain",
    "type": "video",
    "count": 5,
    "orientation": "portrait",
    "minDuration": 5,
    "maxDuration": 15
  }
}
```

**Рекомендации по запросам:**
- Используйте 2-4 ключевых слова
- Добавляйте настроение: "dramatic", "calm", "energetic"
- Указывайте время суток: "night", "sunset", "morning"
- Добавляйте стиль: "cinematic", "aerial", "close-up"

---

## Input.KAI.GenerateImage

Генерация изображений через KAI модели.

**Тип:** `Input.KAI.GenerateImage`

**Параметры:**
```typescript
{
  prompt: string;               // Промпт для генерации
  model?: string;               // Модель (default: 'flux-pro')
  width?: number;               // Ширина (default: 1024)
  height?: number;              // Высота (default: 1024)
  seed?: number;                // Seed для воспроизводимости
  variations?: number;          // Количество вариантов (1-4)
  style?: string;               // Стиль-пресет
}
```

**Доступные модели:**

| Модель | Описание | Credits |
|--------|----------|---------|
| `flux-pro` | Black Forest Labs, высокое качество | 8 |
| `flux-kontext` | Контекстно-зависимая генерация | 8 |
| `gpt4o-image` | OpenAI, точный текст на изображениях | 10 |
| `midjourney` | Художественный стиль | 12 |
| `seedream-v4` | ByteDance, быстрая генерация | 8 |
| `qwen-image` | Alibaba, ускоренная генерация | 6 |
| `ghibli` | Стилизация под Studio Ghibli | 10 |

**Входы:**
- `prompt` (text, optional) — переопределить/дополнить промпт

**Выходы:**
- `images` (array) — Сгенерированные изображения

**Стоимость:** 6-12 credits (зависит от модели)

**Пример:**
```json
{
  "id": "gen_thumbnail",
  "type": "Input.KAI.GenerateImage",
  "params": {
    "prompt": "A futuristic city at sunset, cyberpunk style, neon lights, dramatic atmosphere",
    "model": "flux-pro",
    "width": 1024,
    "height": 1024,
    "variations": 3,
    "seed": 42
  }
}
```

**Советы по промптам:**
- Описывайте конкретные детали
- Указывайте стиль и атмосферу
- Добавляйте технические параметры: "4k", "cinematic lighting"
- Используйте негативные промпты: "no text, no watermark"

---

## Input.KAI.GenerateVideo

Генерация видео через AI модели.

**Тип:** `Input.KAI.GenerateVideo`

**Параметры:**
```typescript
{
  prompt: string;                                  // Промпт
  model: 'sora' | 'veo3' | 'veo3.1-fast' | 'kling-2.1-pro' |
         'kling-2.5-turbo' | 'runway-gen3' | 'minimax' |
         'hailuo' | 'wan2.5' | 'seedance';
  duration?: number;                               // Длительность в секундах
  aspect?: '9:16' | '16:9' | '1:1';               // Соотношение сторон
  seed?: number;                                   // Seed
  fps?: number;                                    // FPS (default: 24)
}
```

**Лимиты моделей:**

| Модель | Макс. длительность | Разрешение | Credits |
|--------|-------------------|------------|---------|
| Sora 2 | 10-15 сек | 1080p | ~100 |
| Veo 3.1 | 8-12 сек | 1080p | ~80 |
| Kling 2.1 Pro | 5-10 сек | 720-1080p | 50-70 |
| Runway Gen-3 | 5-10 сек | 720-1080p | 60-80 |
| Minimax | 6-10 сек | 1080p | 50 |
| Hailuo 02 | 8-12 сек | 1080p | 60 |
| Wan 2.5 | 8-12 сек | 1080p | 60 |
| Seedance | 8-10 сек | 1080p | 55 |

**Входы:**
- `prompt` (text, optional) — переопределить промпт
- `image` (image, optional) — для image-to-video

**Выходы:**
- `video` (video) — Сгенерированный клип

**Стоимость:** 50-100 credits (зависит от модели и длительности)

**Пример:**
```json
{
  "id": "gen_intro",
  "type": "Input.KAI.GenerateVideo",
  "params": {
    "prompt": "A cat walking through a neon-lit alley at night, rain falling, cinematic",
    "model": "sora",
    "duration": 10,
    "aspect": "9:16",
    "fps": 24
  }
}
```

---

## Input.KAI.EditVideo

AI редактирование существующего видео.

**Тип:** `Input.KAI.EditVideo`

**Параметры:**
```typescript
{
  prompt: string;               // Инструкция для редактирования
  model?: string;               // Модель (runway-aleph, luma-modify)
  strength?: number;            // Сила редактирования (0.0 - 1.0)
}
```

**Режимы редактирования:**

| Режим | Описание |
|-------|----------|
| Style transfer | Изменение стиля видео |
| Object edit | Добавление/удаление объектов |
| Weather change | Изменение погоды |
| Time of day | Изменение времени суток |

**Входы:**
- `video` (video, required) — Исходное видео

**Выходы:**
- `video` (video) — Отредактированное видео

**Стоимость:** ~50-70 credits

**Пример:**
```json
{
  "id": "edit_weather",
  "type": "Input.KAI.EditVideo",
  "params": {
    "prompt": "Make it rain heavily, add dramatic lightning",
    "strength": 0.7
  }
}
```

---

## Input.KAI.GenerateMusic

Генерация музыки через Suno.

**Тип:** `Input.KAI.GenerateMusic`

**Параметры:**
```typescript
{
  prompt?: string;              // Описание музыки
  lyrics?: string;              // Текст песни (для вокала)
  style?: string;               // Музыкальный стиль
  duration?: number;            // Длительность (до 480 сек)
  instrumental?: boolean;       // Без вокала
  model?: 'suno-v4' | 'suno-v4.5' | 'suno-v5';
}
```

**Входы:** Нет

**Выходы:**
- `audio` (audio) — Сгенерированная музыка
- `metadata` (object) — Метаданные трека

**Стоимость:** 20-30 credits

**Пример:**
```json
{
  "id": "gen_music",
  "type": "Input.KAI.GenerateMusic",
  "params": {
    "style": "dark ambient electronic",
    "duration": 60,
    "instrumental": true,
    "model": "suno-v4.5"
  }
}
```

---

## Input.KAI.GenerateVoice

Генерация голоса через ElevenLabs.

**Тип:** `Input.KAI.GenerateVoice`

**Параметры:**
```typescript
{
  engine: 'elevenlabs';
  voice: string;                // ID голоса
  speed?: number;               // Скорость (0.5-2.0)
  emotion?: string;             // Эмоция
}
```

**Входы:**
- `script` (text, required) — Текст для озвучки

**Выходы:**
- `audio` (audio) — Сгенерированный голос

**Стоимость:** 5-10 credits/минута

**Пример:**
```json
{
  "id": "elevenlabs_voice",
  "type": "Input.KAI.GenerateVoice",
  "params": {
    "engine": "elevenlabs",
    "voice": "rachel",
    "speed": 1.0,
    "emotion": "dramatic"
  }
}
```

---

## Input.URL

Загрузка медиа по прямой ссылке.

**Тип:** `Input.URL`

**Параметры:**
```typescript
{
  urls: string[];               // Массив URL
  validateType?: boolean;       // Проверять тип файла
}
```

**Входы:** Нет

**Выходы:**
- `assets` (array) — Загруженные ассеты

**Стоимость:** Бесплатно

**Пример:**
```json
{
  "id": "external_video",
  "type": "Input.URL",
  "params": {
    "urls": [
      "https://example.com/video1.mp4",
      "https://example.com/image.jpg"
    ],
    "validateType": true
  }
}
```

**Поддерживаемые форматы:**
- Video: mp4, mov, webm
- Image: jpg, png, webp, gif
- Audio: mp3, wav, m4a

---

## Таблица сравнения Input узлов

| Узел | Источник | Стоимость | Время | Качество |
|------|----------|-----------|-------|----------|
| Input.Upload | Пользователь | Бесплатно | Мгновенно | Зависит от загрузки |
| Input.Stock | Pexels | Бесплатно | 1-3 сек | Высокое (HD) |
| Input.URL | Внешний URL | Бесплатно | 1-10 сек | Зависит от источника |
| Input.KAI.GenerateImage | AI | 6-12 credits | 10-30 сек | Высокое |
| Input.KAI.GenerateVideo | AI | 50-100 credits | 2-5 мин | Высокое |
| Input.KAI.EditVideo | AI | 50-70 credits | 1-3 мин | Высокое |
| Input.KAI.GenerateMusic | Suno | 20-30 credits | 30-60 сек | Высокое |

---

## Рекомендации

### Выбор источника контента

```
Нужен контент быстро и бесплатно?
  └── Input.Stock (Pexels)

Есть свой контент?
  └── Input.Upload

Нужен уникальный контент?
  └── Input.KAI.GenerateImage / GenerateVideo

Нужно модифицировать видео?
  └── Input.KAI.EditVideo
```

### Комбинирование источников

Можно комбинировать разные Input узлы для создания сложного контента:

```json
{
  "nodes": [
    {"id": "n1", "type": "Input.Stock", "params": {"query": "city"}},
    {"id": "n2", "type": "Input.KAI.GenerateImage", "params": {"prompt": "logo"}},
    {"id": "n3", "type": "Input.Upload", "params": {"assetIds": ["custom_clip"]}}
  ],
  "edges": [
    {"from": "n1", "to": "n4"},
    {"from": "n2", "to": "n4"},
    {"from": "n3", "to": "n4"}
  ]
}
```
