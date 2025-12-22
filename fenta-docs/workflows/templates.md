# Templates — Шаблоны монтажа

Шаблоны определяют структуру и стиль финального видео.

---

## Концепция шаблонов

Шаблон = предопределенная структура видео:
- Расположение треков (видео, аудио, субтитры, оверлеи)
- Стили субтитров
- Оверлеи (текст, логотипы)
- Правила нарезки
- Плейсхолдеры для кастомного контента

---

## Структура шаблона

```json
{
  "id": "tmpl_shorts_v1",
  "name": "TikTok Shorts V1",
  "description": "Оптимизирован для TikTok/Reels/Shorts",

  "aspect": "9:16",
  "resolution": "1080x1920",

  "spec": {
    "tracks": [...],
    "overlays": [...],
    "placeholders": {...},
    "rules": {...},
    "subtitle_style_presets": [...]
  }
}
```

---

## Tracks (Дорожки)

### Типы дорожек

| Тип | Описание | Z-index |
|-----|----------|---------|
| `video` | Основное видео | 0 |
| `audio` | Аудио (голос, музыка) | n/a |
| `subtitle` | Субтитры | 10 |
| `overlay` | Текст, логотипы, эффекты | 20+ |

### Пример конфигурации

```json
{
  "tracks": [
    {
      "type": "video",
      "id": "main",
      "z": 0
    },
    {
      "type": "audio",
      "id": "voice",
      "z": 1
    },
    {
      "type": "audio",
      "id": "music",
      "z": 2,
      "config": {
        "volume": 0.3,
        "ducking": true
      }
    },
    {
      "type": "subtitle",
      "id": "subs",
      "z": 10,
      "style": {
        "font": "Inter",
        "size": 44,
        "shadow": true,
        "bg": "box",
        "position": "bottom",
        "margin": 120
      }
    },
    {
      "type": "overlay",
      "id": "top_text",
      "z": 20
    },
    {
      "type": "overlay",
      "id": "logo",
      "z": 25
    }
  ]
}
```

---

## Overlays (Оверлеи)

### Текстовый оверлей

```json
{
  "track": "top_text",
  "from": 0,
  "to": 3,
  "content": {
    "type": "text",
    "text": "BREAKING STORY",
    "pos": "top",
    "anim": "slide-down",
    "style": {
      "fontSize": 56,
      "fontFamily": "Oswald",
      "color": "#FFFFFF",
      "backgroundColor": "#FF0000",
      "padding": 15
    }
  }
}
```

### Изображение (логотип)

```json
{
  "track": "logo",
  "from": 0,
  "to": -1,
  "content": {
    "type": "image",
    "placeholder": "logo",
    "pos": {
      "x": "right",
      "y": "top",
      "margin": 20
    },
    "size": {
      "width": 80,
      "height": 80
    },
    "opacity": 0.8
  }
}
```

### Анимированный эффект

```json
{
  "track": "effect",
  "from": 0,
  "to": -1,
  "content": {
    "type": "video",
    "effectPath": "effects/VHS_overlay.mp4",
    "blendMode": "overlay",
    "opacity": 0.3,
    "loop": true
  }
}
```

---

## Placeholders (Плейсхолдеры)

Плейсхолдеры позволяют пользователям вставлять свой контент:

```json
{
  "placeholders": {
    "cover": {
      "type": "image",
      "required": true,
      "description": "Обложка видео",
      "aspectRatio": "9:16"
    },
    "logo": {
      "type": "image",
      "required": false,
      "description": "Логотип канала",
      "maxSize": "100x100"
    },
    "music": {
      "type": "audio",
      "required": false,
      "description": "Фоновая музыка",
      "maxDuration": 180
    },
    "intro_clip": {
      "type": "video",
      "required": false,
      "description": "Интро",
      "maxDuration": 5
    }
  }
}
```

---

## Rules (Правила нарезки)

```json
{
  "rules": {
    "cuts": "auto_by_beats_or_speech",
    "min_scene": 1.2,
    "max_scene": 4.0,
    "transitions": {
      "default": "crossfade",
      "duration": 0.3
    },
    "pacing": {
      "intro": "slow",
      "middle": "dynamic",
      "outro": "slow"
    }
  }
}
```

### Режимы нарезки

| Режим | Описание |
|-------|----------|
| `auto_by_beats_or_speech` | Автоматически по ритму музыки или речи |
| `by_script_beats` | По сюжетным точкам скрипта |
| `by_audio_silence` | По паузам в аудио |
| `fixed_duration` | Фиксированная длительность сцен |
| `manual` | Ручная разметка |

---

## Subtitle Style Presets

```json
{
  "subtitle_style_presets": [
    {
      "id": "karaoke_bounce",
      "name": "Караоке с анимацией",
      "config": {
        "font": "Inter",
        "fontSize": 48,
        "fontWeight": "bold",
        "color": "#FFFFFF",
        "backgroundColor": "#000000CC",
        "position": "85%",
        "animation": "bounce",
        "karaoke": true
      }
    },
    {
      "id": "clean_box",
      "name": "Чистый бокс",
      "config": {
        "font": "Inter",
        "fontSize": 44,
        "color": "#FFFFFF",
        "backgroundColor": "#000000B3",
        "position": "bottom",
        "padding": 15,
        "borderRadius": 8
      }
    },
    {
      "id": "news_ticker",
      "name": "Новостная строка",
      "config": {
        "font": "Roboto",
        "fontSize": 36,
        "color": "#FFFFFF",
        "backgroundColor": "#CC0000",
        "position": "bottom",
        "animation": "ticker"
      }
    }
  ]
}
```

---

## Пример полного шаблона

### Crime Story Template

```json
{
  "id": "tmpl_crime_v1",
  "name": "Crime Story",
  "description": "Шаблон для криминальных историй",
  "aspect": "9:16",
  "resolution": "1080x1920",

  "spec": {
    "tracks": [
      {"type": "video", "id": "main", "z": 0},
      {"type": "overlay", "id": "vhs", "z": 5},
      {"type": "subtitle", "id": "subs", "z": 10},
      {"type": "overlay", "id": "breaking", "z": 20},
      {"type": "overlay", "id": "logo", "z": 25}
    ],

    "overlays": [
      {
        "track": "vhs",
        "from": 0,
        "to": -1,
        "content": {
          "type": "video",
          "effectPath": "effects/VHS_01.mp4",
          "blendMode": "overlay",
          "opacity": 0.4,
          "loop": true
        }
      },
      {
        "track": "breaking",
        "from": 0,
        "to": 3,
        "content": {
          "type": "text",
          "text": "BREAKING",
          "pos": {"x": "center", "y": "10%"},
          "anim": "slide-in",
          "style": {
            "fontSize": 64,
            "fontFamily": "Bebas Neue",
            "color": "#FFFFFF",
            "backgroundColor": "#FF0000",
            "padding": 20
          }
        }
      },
      {
        "track": "logo",
        "from": 0,
        "to": -1,
        "content": {
          "type": "image",
          "placeholder": "logo",
          "pos": {"x": "right", "y": "top", "margin": 20},
          "size": {"width": 80},
          "opacity": 0.8
        }
      }
    ],

    "placeholders": {
      "logo": {
        "type": "image",
        "required": false,
        "description": "Логотип канала"
      },
      "music": {
        "type": "audio",
        "required": false,
        "description": "Фоновая музыка",
        "default": "crime_dark"
      }
    },

    "rules": {
      "cuts": "auto_by_beats_or_speech",
      "min_scene": 1.5,
      "max_scene": 3.5,
      "transitions": {
        "default": "crossfade",
        "duration": 0.4
      }
    },

    "subtitle_style_presets": ["karaoke_bounce", "bold_shadow"]
  }
}
```

---

## Шаблоны по жанрам

### News Template

```json
{
  "id": "tmpl_news_v1",
  "name": "Breaking News",
  "aspect": "9:16",
  "spec": {
    "tracks": [
      {"type": "video", "id": "main", "z": 0},
      {"type": "subtitle", "id": "subs", "z": 10},
      {"type": "overlay", "id": "headline", "z": 20},
      {"type": "overlay", "id": "ticker", "z": 25}
    ],
    "overlays": [
      {
        "track": "headline",
        "from": 0,
        "to": 5,
        "content": {
          "type": "text",
          "text": "{{headline}}",
          "pos": "top",
          "style": {"fontSize": 48, "backgroundColor": "#CC0000"}
        }
      }
    ],
    "placeholders": {
      "headline": {"type": "text", "required": true}
    }
  }
}
```

### Comedy Template

```json
{
  "id": "tmpl_comedy_v1",
  "name": "Comedy/Meme",
  "aspect": "9:16",
  "spec": {
    "tracks": [
      {"type": "video", "id": "main", "z": 0},
      {"type": "subtitle", "id": "subs", "z": 10}
    ],
    "rules": {
      "cuts": "by_audio_silence",
      "min_scene": 0.8,
      "max_scene": 2.5,
      "transitions": {"default": "cut"}
    },
    "subtitle_style_presets": ["karaoke_bounce"]
  }
}
```

### Explainer Template

```json
{
  "id": "tmpl_explainer_v1",
  "name": "Explainer",
  "aspect": "9:16",
  "spec": {
    "tracks": [
      {"type": "video", "id": "main", "z": 0},
      {"type": "subtitle", "id": "subs", "z": 10},
      {"type": "overlay", "id": "steps", "z": 20}
    ],
    "overlays": [
      {
        "track": "steps",
        "trigger": "script_beat",
        "content": {
          "type": "counter",
          "style": {"fontSize": 72, "fontWeight": "bold"}
        }
      }
    ],
    "rules": {
      "cuts": "by_script_beats",
      "min_scene": 2.0,
      "max_scene": 5.0
    }
  }
}
```

---

## Создание шаблона

### 1. Базовая структура

```sql
INSERT INTO templates (
  org_id, name, description, aspect, resolution, spec
) VALUES (
  'org_123',
  'My Template',
  'Custom template for my channel',
  '9:16',
  '1080x1920',
  '{"tracks": [...], "overlays": [...], "rules": {...}}'
);
```

### 2. Публикация шаблона

```sql
UPDATE templates
SET is_public = true
WHERE id = 'tmpl_123';
```

### 3. Использование в workflow

```json
{
  "id": "n4",
  "type": "Edit.Timeline",
  "params": {
    "templateId": "tmpl_123",
    "placeholders": {
      "logo": "asset_logo_456"
    }
  }
}
```

---

## Рекомендации

### 1. Структура шаблона

- Держите шаблоны модульными
- Используйте плейсхолдеры для кастомизации
- Предоставляйте несколько пресетов субтитров

### 2. Совместимость

- Тестируйте на разных соотношениях сторон
- Учитывайте safe zones платформ
- Проверяйте читаемость на мобильных

### 3. Производительность

- Оптимизируйте эффекты
- Используйте предварительно обработанные оверлеи
- Минимизируйте количество треков

### 4. Версионирование

- Создавайте новые версии, не изменяйте старые
- Храните историю изменений
- Тестируйте перед публикацией
