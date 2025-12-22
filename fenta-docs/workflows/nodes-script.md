# Script Nodes — Генерация и трансформация текста

Script узлы отвечают за создание и обработку текстового контента для видео.

---

## Script.Generate

Генерация сценария видео через LLM.

**Тип:** `Script.Generate`

**Параметры:**
```typescript
{
  genre: 'crime' | 'humor' | 'news' | 'explainer' |
         'story' | 'facts' | 'review' | 'howto';
  lang?: string;                // Код языка (default: 'en')
  prompt?: string;              // Дополнительные инструкции
  targetDuration?: number;      // Целевая длительность в секундах
  tone?: 'casual' | 'formal' | 'energetic' | 'calm';
  beats?: number;               // Количество сюжетных точек
  model?: 'gpt-4' | 'gpt-3.5-turbo' | 'claude-3-sonnet';
}
```

---

### Шаблоны жанров

#### Crime (True Crime)

Структура: hook → backstory → twist → resolution

```json
{
  "genre": "crime",
  "prompt": "True crime story about mysterious disappearance",
  "targetDuration": 60,
  "tone": "energetic",
  "beats": 4
}
```

Выход:
```
HOOK: "What happened on that cold December night would shock the entire town..."

BACKSTORY: "Sarah Miller, 28, was last seen leaving her office at 6 PM..."

TWIST: "But security cameras revealed something no one expected..."

RESOLUTION: "The investigation is still ongoing. If you have any information..."
```

---

#### News

Структура: headline → context → key points → what's next

```json
{
  "genre": "news",
  "prompt": "30s punchy headline + 3 key points",
  "targetDuration": 30,
  "tone": "energetic"
}
```

Выход:
```
BREAKING: Scientists discover New type of star that shouldn't exist.

Here's what you need to know:

1. The star is 1,000 light-years away and defies current physics models.

2. It could rewrite everything we know about stellar evolution.

3. NASA is launching a new mission to study it next year.
```

---

#### Humor

Структура: setup → punchline → callback

```json
{
  "genre": "humor",
  "prompt": "Relatable workplace humor",
  "targetDuration": 15,
  "tone": "casual"
}
```

---

#### Explainer

Структура: problem → explanation → solution

```json
{
  "genre": "explainer",
  "prompt": "Explain how blockchain works to beginners",
  "targetDuration": 45,
  "tone": "casual"
}
```

---

#### Story

Классическая сюжетная арка с 4-6 точками.

```json
{
  "genre": "story",
  "prompt": "Inspirational story about overcoming challenges",
  "targetDuration": 60,
  "beats": 5
}
```

---

#### Facts

Список интересных фактов.

```json
{
  "genre": "facts",
  "prompt": "5 mind-blowing facts about the ocean",
  "targetDuration": 40
}
```

---

#### Review

Структура обзора продукта/сервиса.

```json
{
  "genre": "review",
  "prompt": "iPhone 15 Pro honest review",
  "targetDuration": 60,
  "tone": "casual"
}
```

---

#### HowTo

Пошаговые инструкции.

```json
{
  "genre": "howto",
  "prompt": "How to start a YouTube channel in 2024",
  "targetDuration": 45
}
```

---

### Входы

- `topic` (text, optional) — Тема или предмет

### Выходы

- `script` (text) — Сгенерированный сценарий
- `metadata` (object) — Метаданные скрипта

**Структура metadata:**
```json
{
  "beats": 4,
  "estimatedDuration": 28,
  "wordCount": 85,
  "language": "en",
  "genre": "news"
}
```

### Стоимость

~0.01 - 0.05 USD (зависит от модели и длины)

| Модель | Стоимость/1K tokens |
|--------|---------------------|
| GPT-4 | ~$0.03 input / $0.06 output |
| GPT-3.5 Turbo | ~$0.0015 / $0.002 |
| Claude 3 Sonnet | ~$0.003 / $0.015 |

---

### Полный пример

```json
{
  "id": "generate_script",
  "type": "Script.Generate",
  "params": {
    "genre": "news",
    "lang": "en",
    "prompt": "30s punchy headline + 3 key points about AI breakthrough",
    "targetDuration": 30,
    "tone": "energetic",
    "model": "gpt-4"
  }
}
```

**Выход:**
```json
{
  "script": "BREAKING: Scientists discover AI that can predict earthquakes 24 hours in advance.\n\nHere's what you need to know:\n\n1. The AI analyzes seismic patterns in real-time with 90% accuracy.\n\n2. Early warning systems could save millions of lives.\n\n3. Japan is already testing the technology.",
  "metadata": {
    "beats": 4,
    "estimatedDuration": 28,
    "wordCount": 52,
    "language": "en",
    "genre": "news"
  }
}
```

---

## Script.Transform

Трансформация существующего сценария.

**Тип:** `Script.Transform`

**Параметры:**
```typescript
{
  operation: 'translate' | 'compress' | 'expand' | 'adapt';
  targetLang?: string;          // Для перевода
  targetDuration?: number;      // Для сжатия/расширения
  style?: string;               // Для адаптации
  model?: string;
}
```

---

### Операции

#### Translate

Перевод на другой язык с сохранением стиля.

```json
{
  "id": "translate_script",
  "type": "Script.Transform",
  "params": {
    "operation": "translate",
    "targetLang": "es"
  }
}
```

**Поддерживаемые языки:**
- `en` — English
- `es` — Spanish
- `fr` — French
- `de` — German
- `it` — Italian
- `pt` — Portuguese
- `ru` — Russian
- `zh` — Chinese
- `ja` — Japanese
- `ko` — Korean
- `ar` — Arabic
- `hi` — Hindi

---

#### Compress

Сжатие текста до целевой длительности.

```json
{
  "id": "compress_script",
  "type": "Script.Transform",
  "params": {
    "operation": "compress",
    "targetDuration": 15
  }
}
```

Сохраняет ключевые моменты, убирает лишние слова.

---

#### Expand

Расширение текста с дополнительными деталями.

```json
{
  "id": "expand_script",
  "type": "Script.Transform",
  "params": {
    "operation": "expand",
    "targetDuration": 60
  }
}
```

Добавляет контекст, примеры, детали.

---

#### Adapt

Адаптация под другой стиль/формат.

```json
{
  "id": "adapt_script",
  "type": "Script.Transform",
  "params": {
    "operation": "adapt",
    "style": "casual_tiktok"
  }
}
```

**Доступные стили:**
- `casual_tiktok` — Неформальный TikTok стиль
- `professional_youtube` — Профессиональный YouTube
- `news_anchor` — Стиль новостного ведущего
- `documentary` — Документальный стиль
- `podcast_conversational` — Разговорный подкаст

---

### Входы

- `script` (text, required) — Исходный сценарий

### Выходы

- `script` (text) — Трансформированный сценарий

### Стоимость

~0.01 - 0.03 USD

---

## Script.Split

Разбиение сценария на сцены.

**Тип:** `Script.Split`

**Параметры:**
```typescript
{
  method: 'beats' | 'duration' | 'sentences' | 'paragraphs';
  count?: number;               // Количество сцен (для 'beats')
  maxDuration?: number;         // Макс. длительность сцены
}
```

### Входы

- `script` (text, required) — Полный сценарий

### Выходы

- `scenes` (array) — Массив сцен
- `sceneCount` (number) — Количество сцен

**Структура сцены:**
```json
{
  "scenes": [
    {
      "index": 0,
      "text": "BREAKING: Scientists discover...",
      "estimatedDuration": 5,
      "keywords": ["breaking", "scientists", "discover"]
    },
    {
      "index": 1,
      "text": "Here's what you need to know...",
      "estimatedDuration": 8,
      "keywords": ["need", "know"]
    }
  ]
}
```

---

## Script.Enhance

Улучшение сценария для лучшей озвучки.

**Тип:** `Script.Enhance`

**Параметры:**
```typescript
{
  addPauses?: boolean;          // Добавить паузы (...)
  addEmphasis?: boolean;        // Добавить акценты (*word*)
  simplifyPronunciation?: boolean;  // Упростить сложные слова
  targetAudience?: 'general' | 'professional' | 'young';
}
```

### Входы

- `script` (text, required) — Исходный сценарий

### Выходы

- `script` (text) — Улучшенный сценарий

### Пример

**До:**
```
The phenomenon observed in 2024 was unprecedented.
```

**После:**
```
The phenomenon... *observed* in twenty-twenty-four... was *unprecedented*.
```

---

## Рекомендации по скриптам

### 1. Длительность слов

Примерное соотношение слов к секундам:
- Медленная речь: ~120 слов/мин = 2 слова/сек
- Обычная речь: ~150 слов/мин = 2.5 слова/сек
- Быстрая речь: ~180 слов/мин = 3 слова/сек

### 2. Структура для коротких видео

**15 секунд:**
- Hook: 3 сек
- Main point: 10 сек
- CTA: 2 сек

**30 секунд:**
- Hook: 3 сек
- Point 1: 7 сек
- Point 2: 7 сек
- Point 3: 7 сек
- CTA: 6 сек

**60 секунд:**
- Hook: 5 сек
- Context: 10 сек
- Main story: 30 сек
- Resolution: 10 сек
- CTA: 5 сек

### 3. Оптимизация для TTS

- Избегайте аббревиатур без пояснений
- Числа лучше писать словами
- Добавляйте паузы после ключевых фраз
- Используйте короткие предложения

### 4. Локализация

При переводе учитывайте:
- Скорость речи в разных языках
- Культурные особенности
- Длину текста (немецкий ~30% длиннее английского)
