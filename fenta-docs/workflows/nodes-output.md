# Output Nodes — Рендер и экспорт

Output узлы финализируют видео и доставляют результат.

---

## Output.Render

Рендер финального видео через FantaProjekt.

**Тип:** `Output.Render`

**Параметры:**
```typescript
{
  profile: '9x16_1080p' | '16x9_1080p' | '1x1_1080p' | '9x16_720p';

  // Настройки качества
  bitrate?: number;             // Битрейт видео в kbps
  fps?: number;                 // FPS (default: 30)
  codec?: 'h264' | 'h265';      // Видеокодек

  // Настройки аудио
  audioBitrate?: number;        // Битрейт аудио в kbps (default: 192)
  audioSampleRate?: number;     // Sample rate (default: 48000)

  // Опции экспорта
  format?: 'mp4' | 'mov';       // Формат
  preset?: 'fast' | 'balanced' | 'quality';  // Пресет кодирования
}
```

---

### Профили рендера

| Профиль | Разрешение | Соотношение | Использование |
|---------|------------|-------------|---------------|
| `9x16_1080p` | 1080x1920 | 9:16 | TikTok, Reels, Shorts |
| `16x9_1080p` | 1920x1080 | 16:9 | YouTube, Twitter |
| `1x1_1080p` | 1080x1080 | 1:1 | Instagram Feed |
| `9x16_720p` | 720x1280 | 9:16 | Budget option |

---

### Кодеки

| Кодек | Плюсы | Минусы |
|-------|-------|--------|
| `h264` | Максимальная совместимость | Больший размер файла |
| `h265` | Меньший размер файла | Хуже поддержка |

**Рекомендации:**
- Для широкой совместимости: `h264`
- Для хранения: `h265`

---

### Пресеты кодирования

| Пресет | Время рендера | Качество | Размер файла |
|--------|--------------|----------|--------------|
| `fast` | Быстро | Хорошее | Больше |
| `balanced` | Средне | Отличное | Средний |
| `quality` | Долго | Максимальное | Оптимальный |

---

### Рекомендуемые настройки по платформам

#### TikTok
```json
{
  "profile": "9x16_1080p",
  "fps": 30,
  "codec": "h264",
  "bitrate": 6000,
  "audioBitrate": 192
}
```

#### YouTube Shorts
```json
{
  "profile": "9x16_1080p",
  "fps": 30,
  "codec": "h264",
  "bitrate": 8000,
  "audioBitrate": 256
}
```

#### Instagram Reels
```json
{
  "profile": "9x16_1080p",
  "fps": 30,
  "codec": "h264",
  "bitrate": 5000,
  "audioBitrate": 192
}
```

#### YouTube (стандарт)
```json
{
  "profile": "16x9_1080p",
  "fps": 30,
  "codec": "h264",
  "bitrate": 10000,
  "audioBitrate": 320
}
```

---

### Входы

- `timeline` (object, required) — Таймлайн от Edit.Timeline

### Выходы

- `renderJobId` (text) — ID задачи рендера в FantaProjekt

---

### Стоимость

Зависит от длительности и качества:

| Профиль | Стоимость/секунда |
|---------|------------------|
| 720p | ~0.02 USD |
| 1080p | ~0.03 USD |

**Пример:**
- 60 секунд @ 1080p = ~1.80 USD

---

### Полный пример

```json
{
  "id": "render_final",
  "type": "Output.Render",
  "params": {
    "profile": "9x16_1080p",
    "fps": 30,
    "codec": "h264",
    "bitrate": 6000,
    "audioBitrate": 192,
    "preset": "balanced",
    "format": "mp4"
  }
}
```

---

## Output.Download

Подготовка видео для скачивания.

**Тип:** `Output.Download`

**Параметры:**
```typescript
{
  generateThumbnail?: boolean;  // Генерировать превью (default: true)
  thumbnailTime?: number;       // Время для превью в секундах (default: 0)
  includeSrt?: boolean;         // Включить SRT файл (default: true)
  expiresIn?: number;           // Время жизни URL в секундах (default: 3600)
}
```

---

### Входы

- `renderJobId` (text, required) — ID задачи рендера

### Выходы

- `videoUrl` (text) — Presigned URL для скачивания видео
- `thumbnailUrl` (text) — URL превью
- `srtUrl` (text) — URL файла субтитров (если есть)
- `metadata` (object) — Метаданные видео

**Структура metadata:**
```json
{
  "duration": 60.5,
  "resolution": "1080x1920",
  "fileSize": 25000000,
  "codec": "h264",
  "bitrate": 6000,
  "fps": 30,
  "format": "mp4",
  "createdAt": "2024-12-07T10:00:00Z"
}
```

---

### Стоимость

Бесплатно (применяются отдельные расходы на хранение)

---

### Полный пример

```json
{
  "id": "prepare_download",
  "type": "Output.Download",
  "params": {
    "generateThumbnail": true,
    "thumbnailTime": 1.0,
    "includeSrt": true,
    "expiresIn": 7200
  }
}
```

---

## Output.Publish

Публикация видео на платформы (будущий функционал).

**Тип:** `Output.Publish`

**Параметры:**
```typescript
{
  platforms: ('tiktok' | 'youtube' | 'instagram')[];
  scheduling?: {
    publishAt?: string;         // ISO 8601 datetime
    timezone?: string;
  };
  metadata: {
    title?: string;
    description?: string;
    tags?: string[];
    visibility?: 'public' | 'private' | 'unlisted';
  };
}
```

**Статус:** В разработке

---

## Output.Webhook

Отправка уведомления после завершения.

**Тип:** `Output.Webhook`

**Параметры:**
```typescript
{
  url: string;                  // Webhook URL
  events: ('completed' | 'failed')[];
  includeMetadata?: boolean;    // Включить метаданные
  headers?: Record<string, string>;  // Дополнительные заголовки
}
```

---

### Payload webhook

```json
{
  "event": "job.completed",
  "timestamp": "2024-12-07T10:05:00Z",
  "data": {
    "jobId": "job_abc123",
    "workflowId": "wf_xyz789",
    "videoUrl": "https://...",
    "thumbnailUrl": "https://...",
    "metadata": {
      "duration": 60.5,
      "resolution": "1080x1920"
    }
  },
  "signature": "sha256=..."
}
```

---

### Входы

- `renderJobId` (text, required) — ID задачи рендера

### Выходы

- `delivered` (boolean) — Статус доставки

---

## Schedule.Cron

Запуск workflow по расписанию.

**Тип:** `Schedule.Cron`

**Параметры:**
```typescript
{
  cron: string;                 // Cron выражение
  timezone?: string;            // Часовой пояс (default: 'UTC')
  enabled?: boolean;            // Включено/выключено (default: true)
  maxRuns?: number;             // Макс. количество запусков
  runUntil?: string;            // Конечная дата (ISO 8601)
}
```

---

### Cron выражения

```
┌───────────── минута (0 - 59)
│ ┌───────────── час (0 - 23)
│ │ ┌───────────── день месяца (1 - 31)
│ │ │ ┌───────────── месяц (1 - 12)
│ │ │ │ ┌───────────── день недели (0 - 6) (0 = воскресенье)
│ │ │ │ │
* * * * *
```

**Примеры:**

| Cron | Описание |
|------|----------|
| `0 10 * * *` | Ежедневно в 10:00 |
| `0 */6 * * *` | Каждые 6 часов |
| `0 9 * * 1` | Каждый понедельник в 9:00 |
| `0 0 1 * *` | Первый день каждого месяца |
| `0 9,18 * * *` | В 9:00 и 18:00 каждый день |
| `*/30 * * * *` | Каждые 30 минут |
| `0 12 * * 1-5` | В 12:00 по будням |

---

### Входы

Нет (конфигурация на уровне workflow)

### Выходы

Нет (триггерит выполнение workflow)

---

### Полный пример

```json
{
  "id": "daily_schedule",
  "type": "Schedule.Cron",
  "params": {
    "cron": "0 10 * * *",
    "timezone": "America/New_York",
    "enabled": true,
    "maxRuns": 30
  }
}
```

---

## Рекомендации по выводу

### 1. Выбор качества

| Цель | Профиль | Пресет |
|------|---------|--------|
| Быстрый тест | 720p | fast |
| Публикация | 1080p | balanced |
| Архив | 1080p | quality |

### 2. Размер файла

Примерные размеры для 60 секунд:

| Профиль | Bitrate | Размер |
|---------|---------|--------|
| 720p @ 3Mbps | 3000 | ~22 MB |
| 1080p @ 6Mbps | 6000 | ~45 MB |
| 1080p @ 10Mbps | 10000 | ~75 MB |

### 3. Время рендера

| Длительность | Время рендера |
|--------------|---------------|
| 15 сек | 30-60 сек |
| 30 сек | 1-2 мин |
| 60 сек | 2-4 мин |

### 4. Хранение файлов

- Download URLs истекают через указанное время
- Файлы хранятся 14 дней
- Для длительного хранения — скачивайте файлы

### 5. Webhooks

- Используйте HTTPS URLs
- Проверяйте signature для безопасности
- Реализуйте retry логику на своей стороне
- Обрабатывайте события асинхронно
