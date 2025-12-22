# Edit Nodes — Сборка таймлайна

Edit узлы собирают видео из компонентов на таймлайне.

---

## Edit.Timeline

Сборка таймлайна видео на основе шаблона.

**Тип:** `Edit.Timeline`

**Параметры:**
```typescript
{
  templateId: string;           // ID шаблона для сборки

  // Переопределение настроек шаблона
  transitionStyle?: string;
  transitionDuration?: number;  // В секундах

  // Тайминг сцен
  autoTiming?: boolean;         // Авто-расчет длительности
  minSceneDuration?: number;
  maxSceneDuration?: number;

  // Плейсхолдеры
  placeholders?: {
    [key: string]: string;      // Имя плейсхолдера -> asset ID
  };
}
```

---

### Стили переходов

| Стиль | Описание |
|-------|----------|
| `cut` | Резкий переход (без эффекта) |
| `crossfade` | Плавное затухание |
| `fade_black` | Переход через черный |
| `fade_white` | Переход через белый |
| `slide_left` | Сдвиг влево |
| `slide_right` | Сдвиг вправо |
| `slide_up` | Сдвиг вверх |
| `slide_down` | Сдвиг вниз |
| `zoom_in` | Приближение |
| `zoom_out` | Отдаление |
| `wipe` | Шторка |
| `dissolve` | Растворение |

---

### Auto Timing

Автоматический расчет длительности сцен на основе:
- Длительности озвучки (если есть)
- Beats скрипта
- Ритма музыки

```json
{
  "autoTiming": true,
  "minSceneDuration": 1.2,
  "maxSceneDuration": 4.0
}
```

---

### Плейсхолдеры

Шаблоны могут содержать плейсхолдеры для кастомного контента:

```json
{
  "placeholders": {
    "logo": "asset_logo_123",
    "cover": "asset_cover_456",
    "music": "asset_music_789"
  }
}
```

**Типы плейсхолдеров:**
- `image` — Обязательное изображение
- `image_optional` — Опциональное изображение
- `video` — Обязательное видео
- `video_optional` — Опциональное видео
- `audio` — Обязательное аудио
- `audio_optional` — Опциональное аудио

---

### Входы

- `video` (video | array, required) — Видео клип(ы)
- `audio` (audio, optional) — Аудио дорожка
- `subtitles` (object, optional) — Данные субтитров
- `overlays` (array, optional) — Оверлей элементы

### Выходы

- `timeline` (object) — Полная спецификация таймлайна
- `duration` (number) — Общая длительность

---

### Структура timeline

```json
{
  "timeline": {
    "duration": 60.5,
    "resolution": {"width": 1080, "height": 1920},
    "fps": 30,
    "tracks": [
      {
        "id": "main_video",
        "type": "video",
        "z": 0,
        "clips": [
          {
            "assetId": "asset_video_1",
            "start": 0,
            "end": 10.5,
            "trim": {"in": 0, "out": 10.5},
            "transition": {"type": "crossfade", "duration": 0.3},
            "effects": []
          },
          {
            "assetId": "asset_video_2",
            "start": 10.2,
            "end": 25.0,
            "trim": {"in": 5, "out": 19.8},
            "transition": {"type": "crossfade", "duration": 0.3}
          }
        ]
      },
      {
        "id": "audio_track",
        "type": "audio",
        "z": 1,
        "clips": [
          {
            "assetId": "asset_voice",
            "start": 0,
            "end": 55.0,
            "volume": 1.0
          },
          {
            "assetId": "asset_music",
            "start": 0,
            "end": 60.5,
            "volume": 0.3,
            "ducking": true
          }
        ]
      },
      {
        "id": "subtitle_track",
        "type": "subtitle",
        "z": 10,
        "items": [...]
      },
      {
        "id": "overlay_track",
        "type": "overlay",
        "z": 20,
        "items": [...]
      }
    ]
  }
}
```

---

### Полный пример

```json
{
  "id": "assemble_timeline",
  "type": "Edit.Timeline",
  "params": {
    "templateId": "tmpl_shorts_v1",
    "transitionStyle": "crossfade",
    "transitionDuration": 0.3,
    "autoTiming": true,
    "minSceneDuration": 1.2,
    "maxSceneDuration": 4.0,
    "placeholders": {
      "logo": "asset_logo_123"
    }
  }
}
```

---

## Edit.Overlay

Добавление оверлеев на видео.

**Тип:** `Edit.Overlay`

**Параметры:**
```typescript
{
  overlays: [
    {
      type: 'text' | 'image' | 'video' | 'effect';
      content: any;             // Контент оверлея
      position: {
        x: number | string;     // 'left', 'center', 'right', px, '%'
        y: number | string;     // 'top', 'center', 'bottom', px, '%'
      };
      timing: {
        start: number;          // Начало в секундах
        end: number;            // Конец в секундах
      };
      animation?: string;
      style?: object;
    }
  ]
}
```

---

### Text Overlay

```json
{
  "type": "text",
  "content": "BREAKING NEWS",
  "position": {"x": "center", "y": "10%"},
  "timing": {"start": 0, "end": 5},
  "animation": "slideIn",
  "style": {
    "fontSize": 56,
    "fontFamily": "Oswald",
    "color": "#FFFFFF",
    "backgroundColor": "rgba(0,0,0,0.8)",
    "padding": 20
  }
}
```

---

### Image Overlay

```json
{
  "type": "image",
  "content": {"assetId": "asset_logo"},
  "position": {"x": "right", "y": "top"},
  "timing": {"start": 0, "end": -1},  // -1 = до конца
  "style": {
    "width": 100,
    "height": 100,
    "opacity": 0.8
  }
}
```

---

### Video Overlay (PiP)

Picture-in-Picture:

```json
{
  "type": "video",
  "content": {"assetId": "asset_pip_video"},
  "position": {"x": "10%", "y": "10%"},
  "timing": {"start": 5, "end": 15},
  "style": {
    "width": "30%",
    "height": "auto",
    "borderRadius": 10,
    "border": "2px solid white"
  }
}
```

---

### Effect Overlay (VHS, Glitch)

```json
{
  "type": "effect",
  "content": {
    "effectPath": "effects/VHS_01.mp4",
    "blendMode": "overlay",
    "opacity": 0.5
  },
  "timing": {"start": 0, "end": -1}
}
```

**Blend Modes:**
- `normal` — Обычное наложение
- `addition` — Сложение
- `screen` — Осветление
- `multiply` — Умножение
- `overlay` — Наложение
- `average` — Среднее
- `lighten` — Осветление (макс)
- `darken` — Затемнение (мин)
- `hardlight` — Жесткий свет

---

### Входы

- `timeline` (object, required) — Таймлайн для добавления оверлеев

### Выходы

- `timeline` (object) — Таймлайн с оверлеями

---

## Edit.Trim

Обрезка видео.

**Тип:** `Edit.Trim`

**Параметры:**
```typescript
{
  start?: number;               // Начало в секундах
  end?: number;                 // Конец в секундах
  duration?: number;            // Или длительность
}
```

### Входы

- `video` (video, required) — Видео для обрезки

### Выходы

- `video` (video) — Обрезанное видео

---

## Edit.Speed

Изменение скорости видео.

**Тип:** `Edit.Speed`

**Параметры:**
```typescript
{
  factor: number;               // Множитель скорости (0.25 - 4.0)
  preserveAudio?: boolean;      // Сохранить аудио (с изменением pitch)
  smoothMotion?: boolean;       // Интерполяция кадров для slow-mo
}
```

**Примеры:**
- `factor: 0.5` — Замедление в 2 раза
- `factor: 2.0` — Ускорение в 2 раза

### Входы

- `video` (video, required) — Видео

### Выходы

- `video` (video) — Видео с измененной скоростью

---

## Edit.Crop

Кадрирование видео.

**Тип:** `Edit.Crop`

**Параметры:**
```typescript
{
  aspect?: '9:16' | '16:9' | '1:1' | '4:5';
  region?: {                    // Или точный регион
    x: number;
    y: number;
    width: number;
    height: number;
  };
  gravity?: 'center' | 'top' | 'bottom' | 'left' | 'right';
}
```

### Входы

- `video` (video, required) — Видео

### Выходы

- `video` (video) — Кадрированное видео

---

## Edit.Filter

Применение цветовых фильтров.

**Тип:** `Edit.Filter`

**Параметры:**
```typescript
{
  preset?: string;              // Пресет фильтра
  // Или ручные настройки:
  brightness?: number;          // -1.0 to 1.0
  contrast?: number;            // -1.0 to 1.0
  saturation?: number;          // -1.0 to 1.0
  temperature?: number;         // Теплота (-1.0 cold to 1.0 warm)
  vignette?: number;            // 0.0 to 1.0
}
```

**Пресеты:**
| Пресет | Описание |
|--------|----------|
| `cinematic` | Кинематографичный вид |
| `vintage` | Винтажный |
| `noir` | Черно-белый с контрастом |
| `vibrant` | Яркие цвета |
| `muted` | Приглушенные цвета |
| `warm` | Теплые тона |
| `cold` | Холодные тона |
| `dramatic` | Высокий контраст |

### Входы

- `video` (video, required) — Видео

### Выходы

- `video` (video) — Видео с фильтром

---

## Edit.Concat

Соединение нескольких видео.

**Тип:** `Edit.Concat`

**Параметры:**
```typescript
{
  transition?: string;          // Переход между клипами
  transitionDuration?: number;
}
```

### Входы

- `videos` (array, required) — Массив видео

### Выходы

- `video` (video) — Объединенное видео

---

## Рекомендации по монтажу

### 1. Ритм и длительность сцен

| Стиль контента | Длительность сцены |
|----------------|-------------------|
| Быстрый (TikTok) | 0.5 - 2 сек |
| Динамичный | 1 - 3 сек |
| Умеренный | 2 - 5 сек |
| Медленный | 5 - 10 сек |

### 2. Правило 3 секунд

Меняйте что-то каждые 3 секунды:
- Новый кадр
- Новый текст
- Новый звуковой элемент
- Новый эффект

### 3. Переходы

| Переход | Использование |
|---------|---------------|
| Cut | Быстрый монтаж, action |
| Crossfade | Плавные переходы |
| Fade black | Смена темы, таймлапс |
| Slide | Энергичный контент |
| Zoom | Акцент на важном |

### 4. Оверлеи

- Не перегружайте экран
- Максимум 2-3 элемента одновременно
- Текст должен быть читаемым
- Логотип в углу, не на весь экран

### 5. Структура таймлайна

```
Z-INDEX:
┌──────────────────────────────────────┐
│ 30: Effects (VHS, glitch)            │
│ 20: Text overlays                    │
│ 15: Logo/watermark                   │
│ 10: Subtitles                        │
│  5: PiP video                        │
│  0: Main video                       │
└──────────────────────────────────────┘
```
