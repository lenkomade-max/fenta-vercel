# Subtitle Nodes — Автоматические субтитры

Subtitle узлы создают и стилизуют субтитры для видео.

---

## Subtitle.Auto

Автоматическая генерация субтитров из аудио или текста.

**Тип:** `Subtitle.Auto`

**Параметры:**
```typescript
{
  source: 'audio' | 'script';   // Источник: ASR или скрипт
  style: string;                // Пресет стиля
  lang?: string;                // Код языка

  // Настройки стиля
  font?: string;
  fontSize?: number;
  fontColor?: string;
  backgroundColor?: string;
  position?: 'top' | 'center' | 'bottom';
  maxCharsPerLine?: number;
  maxLines?: number;

  // Тайминг
  karaoke?: boolean;            // Word-by-word highlighting
  minDuration?: number;         // Мин. длительность субтитра (сек)
  maxDuration?: number;         // Макс. длительность субтитра (сек)
}
```

---

### Пресеты стилей

#### karaoke_bounce

Слово за словом с bounce анимацией. Популярный TikTok стиль.

```json
{
  "style": "karaoke_bounce",
  "font": "Inter",
  "fontSize": 48,
  "fontColor": "#FFFFFF",
  "backgroundColor": "#000000CC",
  "karaoke": true
}
```

**Визуализация:**
```
┌─────────────────────────────────────┐
│                                     │
│                                     │
│                                     │
│                                     │
│   ┌─────────────────────────────┐   │
│   │ Breaking NEWS from the city │   │
│   │          ^^^^               │   │
│   │     (активное слово)        │   │
│   └─────────────────────────────┘   │
└─────────────────────────────────────┘
```

---

#### clean_box

Простой бокс с фоном, центрированный текст.

```json
{
  "style": "clean_box",
  "font": "Inter",
  "fontSize": 44,
  "fontColor": "#FFFFFF",
  "backgroundColor": "#000000B3",
  "position": "bottom"
}
```

---

#### neon_glow

Текст со свечением.

```json
{
  "style": "neon_glow",
  "font": "Oswald",
  "fontSize": 52,
  "fontColor": "#00FF00",
  "textShadow": "0 0 20px #00FF00"
}
```

---

#### minimal

Минималистичный стиль без фона.

```json
{
  "style": "minimal",
  "font": "Inter",
  "fontSize": 40,
  "fontColor": "#FFFFFF",
  "textShadow": "2px 2px 4px #000000",
  "position": "bottom"
}
```

---

#### bold_shadow

Жирный текст с сильной тенью.

```json
{
  "style": "bold_shadow",
  "font": "Impact",
  "fontSize": 56,
  "fontColor": "#FFFFFF",
  "fontWeight": "bold",
  "textShadow": "3px 3px 6px #000000"
}
```

---

#### news_ticker

Стиль новостной бегущей строки.

```json
{
  "style": "news_ticker",
  "font": "Roboto",
  "fontSize": 36,
  "fontColor": "#FFFFFF",
  "backgroundColor": "#CC0000",
  "position": "bottom",
  "animation": "ticker"
}
```

---

### Доступные шрифты

| Шрифт | Стиль | Использование |
|-------|-------|---------------|
| `Inter` | Sans-serif, современный | Универсальный |
| `Oswald` | Sans-serif, bold | Заголовки |
| `Roboto` | Sans-serif, чистый | Новости |
| `Montserrat` | Sans-serif, элегантный | Lifestyle |
| `Poppins` | Sans-serif, округлый | Friendly |
| `Bebas Neue` | Sans-serif, all-caps | Dramatic |
| `Impact` | Sans-serif, heavy | Memes |
| `Playfair Display` | Serif, elegant | Premium |

---

### Анимации

| Анимация | Описание |
|----------|----------|
| `fadeIn` | Плавное появление |
| `slideIn` | Выезд сбоку |
| `typewriter` | Печатающийся текст |
| `bounce` | Прыгающие слова |
| `pulse` | Пульсация |
| `none` | Без анимации |
| `ticker` | Бегущая строка |

---

### Входы

- `audio` (audio, required if source='audio') — Аудио для ASR
- `script` (text, required if source='script') — Текст скрипта

### Выходы

- `subtitles` (object) — Данные субтитров с таймингами
- `srt` (text) — Субтитры в SRT формате

**Структура subtitles:**
```json
{
  "subtitles": [
    {
      "index": 1,
      "start": 0.0,
      "end": 2.5,
      "text": "Breaking news from the city",
      "words": [
        {"word": "Breaking", "start": 0.0, "end": 0.5},
        {"word": "news", "start": 0.6, "end": 1.0},
        {"word": "from", "start": 1.1, "end": 1.3},
        {"word": "the", "start": 1.4, "end": 1.5},
        {"word": "city", "start": 1.6, "end": 2.5}
      ]
    },
    {
      "index": 2,
      "start": 2.6,
      "end": 5.0,
      "text": "Here's what happened",
      "words": [...]
    }
  ]
}
```

**SRT формат:**
```srt
1
00:00:00,000 --> 00:00:02,500
Breaking news from the city

2
00:00:02,600 --> 00:00:05,000
Here's what happened
```

---

### Стоимость

- **source='audio'** (ASR): ~0.006 USD/минута
- **source='script'**: Бесплатно (только обработка)

---

### Полный пример

```json
{
  "id": "generate_subs",
  "type": "Subtitle.Auto",
  "params": {
    "source": "audio",
    "style": "karaoke_bounce",
    "lang": "en",
    "font": "Inter",
    "fontSize": 48,
    "fontColor": "#FFFFFF",
    "backgroundColor": "#000000CC",
    "position": "bottom",
    "karaoke": true,
    "maxCharsPerLine": 40,
    "maxLines": 2,
    "minDuration": 0.5,
    "maxDuration": 4.0
  }
}
```

---

## Subtitle.Style

Изменение стиля существующих субтитров.

**Тип:** `Subtitle.Style`

**Параметры:**
```typescript
{
  style?: string;               // Новый пресет
  font?: string;
  fontSize?: number;
  fontColor?: string;
  backgroundColor?: string;
  position?: 'top' | 'center' | 'bottom' | number | string;
  animation?: string;
  karaoke?: boolean;
}
```

### Позиционирование

```typescript
position:
  | 'top'      // Верх экрана
  | 'center'   // Центр
  | 'bottom'   // Низ экрана
  | 100        // 100 пикселей от верха
  | '85%'      // 85% от верха
```

### Входы

- `subtitles` (object, required) — Исходные субтитры

### Выходы

- `subtitles` (object) — Стилизованные субтитры

---

## Subtitle.Edit

Ручное редактирование субтитров.

**Тип:** `Subtitle.Edit`

**Параметры:**
```typescript
{
  edits: [
    {
      index: number;            // Индекс субтитра
      action: 'update' | 'delete' | 'split' | 'merge';
      text?: string;            // Новый текст (для update)
      splitAt?: number;         // Время разделения (для split)
      mergeWith?: number;       // Индекс для слияния (для merge)
    }
  ]
}
```

### Входы

- `subtitles` (object, required) — Исходные субтитры

### Выходы

- `subtitles` (object) — Отредактированные субтитры

---

## Subtitle.Translate

Перевод субтитров на другой язык.

**Тип:** `Subtitle.Translate`

**Параметры:**
```typescript
{
  targetLang: string;           // Целевой язык
  keepOriginal?: boolean;       // Сохранить оригинал (двуязычные)
  originalPosition?: 'top' | 'bottom';  // Позиция оригинала
}
```

### Двуязычные субтитры

```json
{
  "targetLang": "es",
  "keepOriginal": true,
  "originalPosition": "top"
}
```

Результат:
```
┌─────────────────────────────────┐
│   Breaking news from the city   │ ← оригинал (мелкий шрифт)
│                                 │
│   Noticias de última hora       │ ← перевод (основной шрифт)
└─────────────────────────────────┘
```

### Входы

- `subtitles` (object, required) — Субтитры для перевода

### Выходы

- `subtitles` (object) — Переведенные субтитры

---

## Рекомендации по субтитрам

### 1. Читаемость

| Параметр | Рекомендация |
|----------|-------------|
| Размер шрифта | 40-56px для мобильных |
| Символов в строке | 35-45 максимум |
| Строк | 2 максимум |
| Контраст | Белый текст + темный фон/тень |

### 2. Тайминг

| Параметр | Значение |
|----------|----------|
| Мин. длительность | 0.5-1 секунда |
| Макс. длительность | 3-4 секунды |
| Предварительное появление | 0.1-0.2 секунды до звука |

### 3. Позиционирование по платформам

| Платформа | Позиция | Причина |
|-----------|---------|---------|
| TikTok | 75-85% | Над UI элементами |
| Instagram Reels | 75-85% | Над UI элементами |
| YouTube Shorts | 80-90% | Меньше UI внизу |
| YouTube | center/bottom | Стандартное видео |

### 4. Стили по жанрам

| Жанр | Рекомендуемый стиль |
|------|---------------------|
| News | clean_box или news_ticker |
| Crime | bold_shadow, dark colors |
| Comedy | karaoke_bounce |
| Explainer | minimal |
| Lifestyle | clean_box, pastel colors |

### 5. Анимации по скорости

| Скорость видео | Анимация |
|---------------|----------|
| Быстрый (TikTok) | bounce, slideIn |
| Средний | fadeIn, typewriter |
| Медленный | fadeIn, none |

### 6. Цветовые комбинации

| Комбинация | Использование |
|------------|---------------|
| Белый на черном | Универсальный |
| Желтый на черном | Привлекает внимание |
| Красный на черном | Срочность, crime |
| Зеленый на черном | Технологии |
| Белый на красном | Breaking news |
