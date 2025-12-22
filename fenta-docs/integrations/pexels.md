# Интеграция — Pexels

## Обзор

Pexels — бесплатный сток фото и видео. Интегрирован через Input.Stock узел.

**Base URL:** `https://api.pexels.com`
**Auth:** `Authorization: YOUR_API_KEY`
**Docs:** https://www.pexels.com/api/documentation/

---

## Особенности

- **Бесплатно** — не потребляет KAI кредиты
- **Высокое качество** — HD/4K контент
- **Большая библиотека** — миллионы фото/видео
- **Без водяных знаков**
- **Коммерческое использование** разрешено

---

## API Endpoints

### Поиск видео

```http
GET /videos/search?query={query}&per_page={count}&orientation={orientation}
Authorization: YOUR_API_KEY
```

**Параметры:**
| Параметр | Описание |
|----------|----------|
| `query` | Поисковый запрос |
| `per_page` | Количество (1-80) |
| `orientation` | `portrait`, `landscape`, `square` |
| `size` | `large`, `medium`, `small` |
| `min_duration` | Минимальная длительность (сек) |
| `max_duration` | Максимальная длительность (сек) |

### Поиск фото

```http
GET /v1/search?query={query}&per_page={count}&orientation={orientation}
Authorization: YOUR_API_KEY
```

---

## Использование в Workflow

### Input.Stock узел

```json
{
  "id": "stock_video",
  "type": "Input.Stock",
  "params": {
    "provider": "pexels",
    "query": "city night traffic",
    "type": "video",
    "count": 5,
    "orientation": "portrait",
    "minDuration": 5,
    "maxDuration": 15
  }
}
```

### Рекомендации по запросам

**Хорошие запросы:**
- `city night rain traffic` — конкретные ключевые слова
- `woman working laptop office` — описание сцены
- `nature forest sunlight morning` — настроение + место

**Плохие запросы:**
- `video` — слишком общий
- `cool stuff` — неконкретный
- `asdfgh` — бессмысленный

### Советы по поиску

1. **Используйте 2-4 ключевых слова**
2. **Добавляйте настроение**: dramatic, calm, energetic
3. **Указывайте время суток**: night, sunset, morning
4. **Добавляйте стиль**: cinematic, aerial, close-up
5. **Указывайте цвета**: blue, neon, dark

---

## Интеграция в FantaProjekt

### MediaSource type: pexels

```json
{
  "media": {
    "type": "pexels",
    "searchTerms": ["city", "night", "traffic"]
  }
}
```

### Внутренняя обработка

```typescript
async function fetchPexelsVideos(searchTerms: string[], count: number) {
  const query = searchTerms.join(' ');

  const response = await fetch(
    `https://api.pexels.com/videos/search?query=${query}&per_page=${count}&orientation=portrait`,
    {
      headers: {
        Authorization: process.env.PEXELS_API_KEY
      }
    }
  );

  const data = await response.json();

  return data.videos.map(video => ({
    id: `pexels_${video.id}`,
    url: video.video_files.find(f => f.quality === 'hd')?.link,
    duration: video.duration,
    width: video.width,
    height: video.height
  }));
}
```

---

## Качество видео

Pexels предоставляет несколько версий:

| Quality | Разрешение | Использование |
|---------|------------|---------------|
| `hd` | 1920x1080 | Основное |
| `sd` | 640x360 | Preview |
| `uhd` | 3840x2160 | 4K рендер |

---

## Rate Limits

| Параметр | Значение |
|----------|----------|
| Requests/hour | 200 |
| Requests/month | 20,000 |

При превышении — HTTP 429.

---

## Атрибуция

По лицензии Pexels атрибуция **не обязательна**, но рекомендуется.

Рекомендуемый формат:
```
Video by [Photographer] from Pexels
```

---

## Альтернативные стоки (будущее)

| Сток | Статус | Стоимость |
|------|--------|-----------|
| Pexels | Интегрирован | Бесплатно |
| Pixabay | Планируется | Бесплатно |
| Unsplash | Планируется | Бесплатно |
| Shutterstock | Планируется | Платно |
| Getty | Планируется | Платно |
