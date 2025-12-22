# Audio Nodes — TTS и аудио-микширование

Audio узлы обрабатывают голос и музыку для видео.

---

## Voice.TTS

Преобразование текста в речь.

**Тип:** `Voice.TTS`

**Параметры:**
```typescript
{
  engine: 'kokoro' | 'elevenlabs' | 'openai';
  voice: string;                // ID или имя голоса
  lang?: string;                // Код языка
  speed?: number;               // Скорость речи (0.5 - 2.0, default: 1.0)
  pitch?: number;               // Высота голоса (-1.0 to 1.0)
  emotion?: string;             // Эмоция/стиль (зависит от engine)
}
```

---

### Kokoro Engine (Встроенный)

Бесплатный TTS движок в FantaProjekt. 72+ голоса.

**Доступные голоса:**

#### American Female (af_)
| Voice ID | Характеристика |
|----------|---------------|
| `af_heart` | Теплый, дружелюбный |
| `af_alloy` | Нейтральный, чистый |
| `af_bella` | Молодой, энергичный |
| `af_jessica` | Профессиональный |
| `af_nicole` | Мягкий, спокойный |
| `af_sarah` | Уверенный |
| `af_sky` | Легкий, позитивный |

#### American Male (am_)
| Voice ID | Характеристика |
|----------|---------------|
| `am_adam` | Глубокий, авторитетный |
| `am_echo` | Теплый, дружелюбный |
| `am_onyx` | Глубокий, драматичный |
| `am_michael` | Профессиональный |
| `am_fenrir` | Мощный |
| `am_puck` | Легкий, разговорный |

#### British Female (bf_)
| Voice ID | Характеристика |
|----------|---------------|
| `bf_emma` | Классический британский |
| `bf_lily` | Мягкий, элегантный |
| `bf_alice` | Молодой |

#### British Male (bm_)
| Voice ID | Характеристика |
|----------|---------------|
| `bm_george` | Классический британский |
| `bm_daniel` | Профессиональный |
| `bm_lewis` | Разговорный |

**Пример:**
```json
{
  "id": "voice_tts",
  "type": "Voice.TTS",
  "params": {
    "engine": "kokoro",
    "voice": "af_heart",
    "speed": 1.02,
    "lang": "en"
  }
}
```

**Стоимость Kokoro:** ~0.015 USD/минута (render seconds)

---

### OpenAI TTS Engine

Высококачественный TTS от OpenAI.

**Доступные голоса:**

| Voice ID | Характеристика |
|----------|---------------|
| `openai_alloy` | Нейтральный, универсальный |
| `openai_echo` | Мужской, теплый |
| `openai_fable` | Британский акцент |
| `openai_onyx` | Глубокий, авторитетный |
| `openai_nova` | Женский, энергичный |
| `openai_shimmer` | Мягкий, дружелюбный |

**HD версии (высокое качество):**
- `openai_alloy_hd`
- `openai_echo_hd`

**Пример:**
```json
{
  "id": "openai_voice",
  "type": "Voice.TTS",
  "params": {
    "engine": "openai",
    "voice": "openai_onyx",
    "speed": 1.0
  }
}
```

**Стоимость OpenAI:** ~$0.015/1000 символов (standard), ~$0.03/1000 символов (HD)

---

### ElevenLabs Engine

Премиум TTS с широким выбором голосов и эмоций.

**Параметры:**
```typescript
{
  engine: 'elevenlabs';
  voice: string;                // ID голоса ElevenLabs
  stability?: number;           // Стабильность (0.0 - 1.0)
  similarityBoost?: number;     // Точность голоса (0.0 - 1.0)
  style?: number;               // Стиль (0.0 - 1.0)
}
```

**Популярные голоса:**
- Rachel, Domi, Bella (Female)
- Adam, Antoni, Arnold (Male)
- Elli, Josh, Sam (Neutral)

**Пример:**
```json
{
  "id": "elevenlabs_voice",
  "type": "Voice.TTS",
  "params": {
    "engine": "elevenlabs",
    "voice": "rachel",
    "stability": 0.5,
    "similarityBoost": 0.8,
    "speed": 1.0
  }
}
```

**Стоимость ElevenLabs:** 5-10 KAI credits/минута

---

### Входы

- `script` (text, required) — Текст для озвучки

### Выходы

- `audio` (audio) — Сгенерированный аудиофайл
- `duration` (number) — Длительность в секундах
- `wordTimings` (array) — Тайминги слов для субтитров

**Структура wordTimings:**
```json
{
  "wordTimings": [
    {"word": "Breaking", "start": 0.0, "end": 0.5},
    {"word": "news", "start": 0.6, "end": 1.0},
    {"word": "from", "start": 1.1, "end": 1.3}
  ]
}
```

---

### Voice Instructions

Дополнительные инструкции для озвучки:

```json
{
  "params": {
    "engine": "kokoro",
    "voice": "am_onyx",
    "voiceInstructions": "Speak dramatically, with pauses for emphasis"
  }
}
```

**Примеры инструкций:**
- `"Speak dramatically, with pauses for emphasis"`
- `"News anchor tone, professional and clear"`
- `"Casual, conversational, like talking to a friend"`
- `"Whispered, mysterious tone"`
- `"Excited, energetic, fast-paced"`

---

## Audio.Mix

Микширование голоса с фоновой музыкой.

**Тип:** `Audio.Mix`

**Параметры:**
```typescript
{
  musicAssetId?: string;        // ID ассета музыки
  musicTag?: string;            // Тег музыки из библиотеки
  musicVolume?: number;         // Громкость музыки (0.0 - 1.0, default: 0.3)
  ducking?: boolean;            // Приглушать музыку при голосе (default: true)
  duckingLevel?: number;        // Уровень приглушения (0.0 - 1.0, default: 0.1)
  fadeIn?: number;              // Fade in в секундах
  fadeOut?: number;             // Fade out в секундах
}
```

---

### Music Tags (Библиотека музыки)

Доступные теги настроений:

| Тег | Описание | Использование |
|-----|----------|---------------|
| `sad` | Грустная, меланхоличная | Drama, emotional stories |
| `melancholic` | Задумчивая | Reflective content |
| `happy` | Веселая, позитивная | Upbeat content |
| `euphoric/high` | Эйфоричная | Celebrations, wins |
| `excited` | Энергичная | Action, reveals |
| `chill` | Расслабленная | Lifestyle, chill content |
| `uneasy` | Тревожная | Suspense, mystery |
| `angry` | Агрессивная | Conflict, drama |
| `dark` | Темная, мрачная | True crime, horror |
| `hopeful` | Оптимистичная | Inspirational |
| `contemplative` | Созерцательная | Thoughtful content |
| `funny/quirky` | Забавная | Comedy, memes |

**Crime-специфичные теги:**
| Тег | Описание |
|-----|----------|
| `crime_anepic` | Эпическая криминальная |
| `crime_darkhorror` | Темный хоррор |
| `crime_disturbance` | Тревожная |
| `crime_dronesystem` | Атмосферная |
| `crime_drone_system_stalker` | Преследование |
| `crime_new_report` | Новостной репортаж |

---

### Ducking (Автоматическое приглушение)

Автоматически снижает громкость музыки когда говорит голос:

```
┌────────────────────────────────────────────────────┐
│ Voice:     ████████      ████████████      ████    │
│                                                    │
│ Music:  ─────┐    ┌──────┐          ┌──────┐   ┌── │
│          100%│    │ 10%  │   100%   │ 10%  │   │   │
│              └────┘      └──────────┘      └───┘   │
└────────────────────────────────────────────────────┘
```

---

### Входы

- `voiceAudio` (audio, required) — Голосовая дорожка
- `musicAudio` (audio, optional) — Музыкальная дорожка

### Выходы

- `audio` (audio) — Смикшированный аудиофайл

### Стоимость

Бесплатно (только обработка)

---

### Полный пример

```json
{
  "id": "mix_audio",
  "type": "Audio.Mix",
  "params": {
    "musicTag": "dark",
    "musicVolume": 0.25,
    "ducking": true,
    "duckingLevel": 0.08,
    "fadeIn": 1.0,
    "fadeOut": 2.0
  }
}
```

---

## Audio.SoundEffects

Добавление звуковых эффектов.

**Тип:** `Audio.SoundEffects`

**Параметры:**
```typescript
{
  effects: [
    {
      type: 'whoosh' | 'impact' | 'transition' | 'ambient' | 'custom';
      timestamp: number;        // Время в секундах
      volume?: number;          // Громкость (0.0 - 1.0)
      assetId?: string;         // Для custom эффектов
    }
  ]
}
```

### Входы

- `audio` (audio, required) — Основная аудиодорожка

### Выходы

- `audio` (audio) — Аудио с эффектами

---

## Audio.Normalize

Нормализация громкости аудио.

**Тип:** `Audio.Normalize`

**Параметры:**
```typescript
{
  targetLUFS?: number;          // Целевой уровень громкости (default: -14)
  peakLimit?: number;           // Максимальный пик (default: -1.0 dB)
}
```

**Стандарты платформ:**
| Платформа | Рекомендуемый LUFS |
|-----------|-------------------|
| YouTube | -14 LUFS |
| TikTok | -14 LUFS |
| Instagram | -14 LUFS |
| Spotify | -14 LUFS |
| Apple Music | -16 LUFS |

### Входы

- `audio` (audio, required) — Аудио для нормализации

### Выходы

- `audio` (audio) — Нормализованное аудио

---

## Рекомендации по аудио

### 1. Выбор голоса по жанру

| Жанр | Рекомендуемые голоса |
|------|---------------------|
| Crime/Mystery | am_onyx, bm_george |
| News | af_alloy, am_michael |
| Comedy | af_bella, am_puck |
| Explainer | af_heart, am_adam |
| Story | bf_emma, bm_daniel |

### 2. Скорость речи

| Платформа | Рекомендуемая скорость |
|-----------|----------------------|
| TikTok | 1.1 - 1.3x |
| YouTube Shorts | 1.0 - 1.2x |
| Instagram Reels | 1.0 - 1.2x |
| Long-form | 1.0x |

### 3. Баланс голоса и музыки

- Голос всегда должен быть четко слышен
- Music volume: 0.2 - 0.3 при наличии голоса
- Ducking: обязательно включать
- Fade in/out: 1-2 секунды для плавных переходов

### 4. Качество аудио

- Sample rate: 48000 Hz
- Bit depth: 16 bit
- Bitrate: 192 kbps minimum
- Format: AAC или MP3
