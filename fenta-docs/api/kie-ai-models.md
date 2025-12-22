# KIE.ai — Полный список моделей

## Общая информация

**Base URL:** `https://api.kie.ai`
**Auth:** `Authorization: Bearer API_KEY`
**Docs:** https://docs.kie.ai

---

## VIDEO GENERATION

### Veo 3.1 (Google)
Профессиональное качество видео с синхронизацией аудио.

| Параметр | Значение |
|----------|----------|
| Endpoint | `POST /api/v1/veo/generate` |
| Длительность | 8-12 секунд |
| Разрешение | до 1080p |
| Aspect | 16:9, 9:16, 1:1 |
| Время генерации | 2-5 минут |
| Credits | ~80 |

**Варианты:**
- `veo3` — стандартное качество
- `veo3.1-fast` — быстрая генерация

---

### Sora 2 (OpenAI)
Мощная модель для сложных сцен.

| Параметр | Значение |
|----------|----------|
| Endpoint | `POST /api/v1/sora/generate` |
| Длительность | 10-15 секунд |
| Разрешение | 1080p |
| Aspect | 16:9, 9:16, 1:1 |
| Credits | ~100 |

---

### Kling (ByteDance)
Китайская модель с хорошей детализацией.

| Параметр | Значение |
|----------|----------|
| Варианты | `kling-2.1-pro`, `kling-2.5-turbo` |
| Длительность | 5-10 секунд |
| Разрешение | 720p-1080p |
| Credits | 50-70 |

---

### Runway Gen-3 Alpha
Text-to-video и image-to-video.

| Параметр | Значение |
|----------|----------|
| Endpoint | `POST /api/v1/runway/generate` |
| Длительность | 5-10 секунд |
| Качество | 720p HD, 1080p (только 5 сек) |
| Aspect | 16:9, 9:16, 1:1, 4:3, 3:4 |
| Credits | 60-80 |

---

### Runway Aleph
Video-to-video трансформация и стилизация.

| Параметр | Значение |
|----------|----------|
| Режимы | style transfer, object removal |
| Credits | 50-70 |

---

### Minimax / Hailuo
Китайские модели для быстрой генерации.

| Model | Длительность | Credits |
|-------|--------------|---------|
| Minimax | 6-10 сек | 50 |
| Hailuo 02 | 8-12 сек | 60 |

---

### Wan 2.5 (Alibaba)
High-quality text-to-video и image-to-video.

| Параметр | Значение |
|----------|----------|
| Длительность | 8-12 секунд |
| Credits | 60 |

---

### Seedance (ByteDance)
Unified interface для text-to-video и image-to-video.

| Параметр | Значение |
|----------|----------|
| Длительность | 8-10 секунд |
| Credits | 55 |

---

### Luma Modify
Модификация существующих видео.

| Режимы | Описание |
|--------|----------|
| Style transfer | Изменение стиля |
| Object edit | Добавление/удаление объектов |

---

## IMAGE GENERATION

### GPT-4o Image (OpenAI)
Высокое качество с точным текстом.

| Параметр | Значение |
|----------|----------|
| Endpoint | `POST /api/v1/gpt4o-image/generate` |
| Размеры | 1:1, 3:2, 2:3 |
| Форматы | .jpg, .png, .webp |
| Режимы | txt2img, img2img, inpaint |
| Variants | 1, 2, 4 |
| Credits | 10 |

**Особенности:**
- Точный рендеринг текста
- До 5 входных изображений
- Mask для inpaint (черный = изменить)
- Документация: [gpt4o-image.md](./api/kie-image/gpt4o-image.md)

---

### Flux Kontext (Black Forest Labs)
Контекстно-зависимая генерация и редактирование.

| Параметр | Значение |
|----------|----------|
| Endpoint | `POST /api/v1/flux/kontext/generate` |
| Варианты | flux-kontext-pro, flux-kontext-max |
| Aspect Ratios | 16:9, 1:1, 9:16, 21:9, 4:3 и др. |
| Режимы | txt2img, img2img (editing) |
| Credits | 8-12 |

**Особенности:**
- Pro - быстрая обработка, стандартное качество
- Max - максимальное качество, сложные сцены
- Поддержка перевода на английский
- Документация: [flux.md](./api/kie-image/flux.md)

---

### Midjourney
Художественный стиль, аниме и реалистичные изображения.

| Параметр | Значение |
|----------|----------|
| Endpoint | `POST /api/v1/mj/generate` |
| Версии | v7, 6.1, Niji6 |
| Режимы | mj_txt2img, mj_img2img, mj_video |
| Скорость | Relax, Fast, Turbo |
| Aspect Ratios | 16:9, 1:1, 9:16, 4:3 и др. |
| Credits | 25 |
| Выход | 4 изображения на задачу |

**Особенности:**
- stylization (0-1000)
- weirdness (0-3000)
- Документация: [midjourney.md](./api/kie-image/midjourney.md)

---

### Seedream V4 (ByteDance)
Быстрая генерация с высоким разрешением (до 4K).

| Параметр | Значение |
|----------|----------|
| Endpoint | `POST /api/v1/seedream/generate` |
| Разрешение | 1K, 2K, 4K (до 4096×3072) |
| Размеры | square, portrait, landscape (9 вариантов) |
| Режимы | txt2img, img2img (editing) |
| Credits | 3.5 |
| Язык | Китайский и английский |

**Особенности:**
- Самый доступный по цене
- Поддержка бинарного контроля текста
- Документация: [seedream.md](./api/kie-image/seedream.md)

---

### Nano Banana (Google - Gemini 2.5 Flash)
Быстрое и точное редактирование изображений.

| Параметр | Значение |
|----------|----------|
| Endpoint | `POST /api/v1/nano-banana/generate` |
| Варианты | google/nano-banana, google/nano-banana-edit, google/nano-banana-pro |
| Режимы | txt2img, img2img (editing) |
| Credits | 4 (standard), 6-8 (pro) |

**Особенности:**
- Gemini 2.5 Flash (стандарт) - быстро и экономно
- Gemini 3 Pro (pro версия) - высокое качество
- Сохранение консистентности персонажа
- До 5 входных изображений
- Документация: [nano-banana.md](./api/kie-image/nano-banana.md)

---

### Qwen Image (Alibaba)
Мощная генерация с поддержкой китайского языка.

| Параметр | Значение |
|----------|----------|
| Endpoint | `POST /api/v1/qwen/generate` |
| Разрешение | 1K, 2K, 4K |
| Размеры | square, portrait, landscape (7 вариантов) |
| Ускорение | none, regular, high |
| Credits | 6-8 |
| Язык | Китайский и английский |

**Особенности:**
- Детальное отрисовка текста
- guidance_scale контроль (1-20)
- reproducible с seed
- Документация: [qwen.md](./api/kie-image/qwen.md)

---

### Ghibli Style
Стилизация под Studio Ghibli (через GPT-4o или Flux).

| Параметр | Значение |
|----------|----------|
| Базис | GPT-4o Image или Flux Kontext |
| Метод | Prompt engineering + style keywords |
| Credits | 8-12 (зависит от базовой модели) |

**Способ использования:**
- Используй ключевые слова: "Studio Ghibli style", "Hayao Miyazaki"
- Лучше всего через Flux Kontext Pro/Max
- Документация: [ghibli-style.md](./api/kie-image/ghibli-style.md)

---

### Recraft V3 - Upscale & Background Removal
Специализированные утилиты для обработки изображений.

#### Upscale (2x / 4x)
| Параметр | Значение |
|----------|----------|
| Endpoint | `POST /api/v1/recraft/upscale` |
| Масштаб | 2x, 4x |
| Credits | 2-4 |

#### Background Removal
| Параметр | Значение |
|----------|----------|
| Endpoint | `POST /api/v1/recraft/remove-background` |
| Выход | PNG с прозрачностью |
| Credits | 1-2 |

**Особенности:**
- Удаление фона без потери качества
- Upscaling с подавлением шума
- Профессиональные результаты
- Документация: [recraft.md](./api/kie-image/recraft.md)

---

## AUDIO / VOICE

### ElevenLabs
Студийное качество TTS.

| Параметр | Значение |
|----------|----------|
| Режимы | text-to-speech, sound effects |
| Языки | 29+ |
| Credits | 5-10 / минута |

**Голоса:**
- Премиум voices
- Voice cloning (Enterprise)
- Sound effects generation

---

## MUSIC

### Suno
Генерация музыки с вокалом.

| Параметр | Значение |
|----------|----------|
| Версии | V4, V4.5, V5 |
| Длительность | до 8 минут |
| Режимы | с текстом, instrumental |

**Функции:**
- Custom lyrics
- Style selection
- Music extension
- Vocal separation
- MIDI generation
- WAV conversion
- Music video creation
- Album cover generation

| Операция | Credits |
|----------|---------|
| Song generation | 20-30 |
| Extension | 15 |
| Vocal separation | 5 |

---

## UTILITY APIs

### File Upload
Загрузка файлов для использования в генерации.

| Метод | Описание |
|-------|----------|
| Base64 | `POST /api/v1/files/upload-base64` |
| Stream | `POST /api/v1/files/upload-stream` |
| URL | `POST /api/v1/files/upload-url` |

---

### Common API
Служебные endpoints.

| Endpoint | Описание |
|----------|----------|
| `GET /api/v1/account/credits` | Баланс кредитов |
| `POST /api/v1/files/download-url` | Получить URL для скачивания |

---

## Общий паттерн API

### Создание задачи
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

---

### Проверка статуса
```http
GET /api/v1/{service}/record-info?taskId={taskId}
```

**Response:**
```json
{
  "code": 200,
  "data": {
    "taskId": "task_abc123",
    "status": 0,  // 0=generating, 1=success, 2=failed
    "progress": 0.65,
    "resultUrls": ["https://..."]
  }
}
```

---

### Callback (Webhook)
KIE.ai отправляет POST на callBackUrl:
```json
{
  "code": 200,
  "data": {
    "taskId": "task_abc123",
    "resultUrls": ["https://..."]
  }
}
```

---

## Retention & Limits

| Параметр | Значение |
|----------|----------|
| Хранение файлов | 14 дней |
| Download URL validity | 20 минут |
| Max concurrent tasks | зависит от плана |
