# KIE.ai Video Generation API Documentation

Полная документация всех видео генеративных моделей, доступных через **KIE.ai** - единую API платформу для AI-генерации видео.

## Быстрый Старт

### Базовые Параметры

**Все видео модели используют общий паттерн:**

```bash
# 1. Создать задачу
POST https://api.kie.ai/api/v1/{service}/generate
Authorization: Bearer YOUR_API_KEY

# 2. Проверить статус
GET https://api.kie.ai/api/v1/{service}/record-info?taskId=...

# 3. Скачать видео (действительна 20 минут)
```

### Статус Коды
- `0` - Generating (идёт обработка)
- `1` - Success (готово)
- `2` - Failed (ошибка)

### Хранение
- **Видео хранятся**: 14 дней
- **Ссылка скачивания**: 20 минут

---

## Сравнение Моделей

| Модель | Создатель | T2V | I2V | V2V | Длительность | 1080p | Особенности |
|--------|-----------|-----|-----|-----|--------------|-------|-------------|
| **Veo 3.1** | Google DeepMind | ✅ | ✅ | — | 8-12s | ✅ | Cinematic, native vertical |
| **Sora 2** | OpenAI | ✅ | ✅ | — | 10-15s | ✅ | Native audio, smooth physics |
| **Kling 2.5 Turbo** | Kuaishou | ✅ | ✅ | — | 5-10s | ✅ | Realistic motion, avatar API |
| **Runway Gen-3** | Runway | ✅ | ✅ | — | 5-10s | ✅ | Fast, flexible aspect ratios |
| **Runway Aleph** | Runway | — | — | ✅ | variable | — | Professional V2V editing |
| **Minimax Hailuo 2.3** | MiniMax | ✅ | ✅ | — | 6-10s | ✅ | Advanced physics, stylization |
| **Hailuo 02** | MiniMax | ✅ | ✅ | — | 8-12s | ✅ | Cinematic, precise camera |
| **Wan 2.5** | Alibaba | ✅ | ✅ | ✅ | 5-10s | ✅ | Camera control, speech-to-video |
| **Seedance 1.0** | ByteDance | ✅ | ✅ | — | 6-10s | ✅ | Multi-shot, viral content |
| **Luma Modify** | Luma | — | — | ✅ | 10s max | — | Color grading, effects |

---

## По Категориям

### 🎬 Лучшие для Кинематических Видео
1. **Sora 2** - Native audio, smooth transitions
2. **Hailuo 02** - Cinematic quality, camera control
3. **Veo 3.1** - Professional motion, native 9:16

### ⚡ Быстрые Модели (Для Высоких Объёмов)
1. **Kling 2.5 Turbo** - 50 credits/5s, отличное качество
2. **Seedance 1.0 Pro Fast** - 3× быстрее, $0.044/s
3. **Runway Gen-3 Turbo** - 60-70 credits/5s

### 💎 Лучшее Качество
1. **Sora 2 Pro** - Native audio, 15s длины
2. **Veo 3.1** - Google's latest, 25% дешевле оригинала
3. **Hailuo 2.3** - Лучшая стилизация, micro-expressions

### 🎤 С Аудио
1. **Sora 2** - Синхронизированный диалог и звуки
2. **Wan 2.5** - Speech-to-video (S2V) режим
3. **Kling 2.6** - Native audio с lip-sync

### 🎨 Лучшая Стилизация
1. **Hailuo 2.3** - Anime, иллюстрации, ink painting
2. **Seedance 1.0** - Viral/trendy content стиль
3. **Runway Aleph** - Полный V2V контроль

### 📸 Avatar/Talking Head
1. **Kling Avatar API** - $0.04-0.08/s, lip-sync
2. **Kling 2.6** - Полные AI-говорящие видео

### 🎞️ Post-Production
1. **Runway Aleph** - Профессиональное V2V редактирование
2. **Luma Modify** - Color grading и effects

### 📱 Для TikTok/Shorts (9:16 Format)
1. **Veo 3.1** - Native 9:16, no cropping
2. **Seedance 1.0** - ByteDance origin (TikTok)
3. **Runway Gen-3** - Multiple aspect ratios

---

## Примеры Использования

### Text-to-Video (все генеративные модели)
```json
{
  "prompt": "A person running through a forest at sunset with dramatic lighting",
  "duration": 5,
  "resolution": "1080p",
  "aspectRatio": "16:9",
  "seed": 12345
}
```

### Image-to-Video
```json
{
  "imageUrl": "https://example.com/photo.jpg",
  "prompt": "The landscape slowly transforms with changing light",
  "duration": 8,
  "resolution": "1080p"
}
```

### Video-to-Video (Runway Aleph / Luma Modify)
```json
{
  "videoUrl": "https://example.com/video.mp4",
  "prompt": "Transform to cinematic golden hour with warm color grading",
  "model": "runway-aleph"
}
```

### Speech-to-Video (Wan 2.5 только)
```json
{
  "audioUrl": "https://example.com/speech.mp3",
  "prompt": "Professional news broadcast setting",
  "model": "wan/2-5-speech-to-video"
}
```

---

## Pricing Сравнение

| Модель | Cost/5s | Cost/10s | Best Price |
|--------|---------|----------|-----------|
| Seedance 1.0 Pro Fast | $0.22 | $0.44 | ✅ Лучший |
| Kling 2.5 Turbo | $0.25 | $0.50 | ✅ Хороший |
| Hailuo 2.3 Fast | $0.25 | $0.50 | ✅ Хороший |
| Wan 2.5 | $0.30 | $0.60 | Среднее |
| Hailuo 2.3 Standard | $0.35 | $0.70 | Среднее |
| Hailuo 02 | $0.30 | $0.60 | Среднее |
| Runway Gen-3 | $0.35 | $0.70+ | Среднее |
| Veo 3.1 Fast | $0.35 | $0.70 | Среднее |
| Sora 2 | $0.75 | $1.50 | Премиум |
| Veo 3.1 Quality | $0.40 | $0.80 | Премиум |

---

## Документация По Моделям

### Генеративные (Text-to-Video, Image-to-Video)
- **[Veo 3.1](./veo.md)** - Google DeepMind latest, native vertical video
- **[Sora 2](./sora.md)** - OpenAI model, native audio generation
- **[Kling](./kling.md)** - Kuaishou with avatar API
- **[Runway](./runway.md)** - Gen-3 Turbo + Aleph video-to-video
- **[Minimax](./minimax.md)** - Hailuo models with advanced styling
- **[Hailuo](./hailuo.md)** - MiniMax's cinematic model
- **[Wan 2.5](./wan.md)** - Alibaba with speech-to-video and camera control
- **[Seedance](./seedance.md)** - ByteDance model for viral content

### Post-Production (Video Enhancement & Editing)
- **[Luma Modify](./luma.md)** - Color grading, effects, upscaling

---

## Webhook Callbacks

Все модели поддерживают `callBackUrl` для асинхронных уведомлений:

```json
{
  "taskId": "service_abc123xyz",
  "status": 1,
  "videoUrl": "https://storage.kie.ai/videos/...",
  "duration": 10,
  "completedAt": "2025-12-07T10:30:00Z"
}
```

---

## Rate Limits & Quotas

Для всех сервисов:
- **Max concurrent tasks**: 10 per account
- **Max daily requests**: varies by account tier
- **Min interval**: 1 second between requests
- **Task storage**: 14 days

---

## Common Mistakes

❌ **НЕ ДЕЛАЙТЕ:**
- Забывайте скачать видео раньше 14-дневного удаления
- Используйте приватные URL (требуются публичные)
- Игнорируйте лимиты для 1080p + 10s (невозможно)
- Используйте другие языки для Luma (English only)

✅ **ДЕЛАЙТЕ:**
- Сохраняйте `taskId` сразу после создания
- Используйте webhooks для большого объёма
- Проверяйте баланс перед большими партиями
- Тестируйте с малых видео сначала

---

## API Key & Authentication

```bash
# Получить ключ
# 1. Регистрация: https://kie.ai
# 2. Dashboard → API Keys
# 3. Скопировать Bearer token

# Использование
curl -H "Authorization: Bearer YOUR_API_KEY" \
  https://api.kie.ai/api/v1/{service}/generate
```

---

## Troubleshooting

| Ошибка | Причина | Решение |
|--------|---------|----------|
| 402 Insufficient credits | Нет баланса | Пополнить аккаунт на KIE.ai |
| 429 Rate limited | Слишком много запросов | Ждать или купить premium tier |
| 1001 Invalid prompt | Prompt слишком короткий | Min 10-15 символов |
| 1002 Invalid image | Bad format/URL | Проверить JPEG/PNG/WebP, max 10MB |
| Task not found | Task ID неверный | Скопировать правильный ID из response |

---

## Дополнительные Ресурсы

- **KIE.ai Main**: https://kie.ai
- **API Docs**: https://docs.kie.ai/
- **Status Page**: https://status.kie.ai/
- **Support**: support@kie.ai

---

**Last Updated**: 2025-12-07
**Total Models**: 10 (8 generation + 2 post-production)
