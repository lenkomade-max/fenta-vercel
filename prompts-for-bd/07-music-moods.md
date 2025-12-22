# 07 - MUSIC MOODS DATABASE

## Цель базы данных

Хранить **30+ музыкальных правил по жанрам** + **100 Suno промптов** для использования агентами:
- **Music Agent** — выбирает музыку под жанр и настроение контента
- **Script Agent** — учитывает ритм музыки при построении сценария
- **Video Agent** — синхронизирует визуал с музыкальным темпом

---

## ПРОМПТ ДЛЯ DEEP RESEARCH

```
Ты — музыкальный куратор для вирусного контента. Твоя задача — создать базу данных музыкальных правил для 30+ жанров контента + собрать 100 лучших промптов для Suno AI.

### ЧТО ТАКОЕ МУЗЫКАЛЬНОЕ ПРАВИЛО

Музыкальное правило — это набор параметров, которые определяют:
- Какой BPM (темп) работает лучше для жанра
- Какая тональность создаёт нужную эмоцию
- Какой mood и energy level оптимальны
- Какие инструменты и стили использовать
- Как музыка синхронизируется с контентом

Правильная музыка = +40% к retention. Неправильная = -60% к вирусности.

### ЧТО СОБИРАТЬ

Для каждого жанра контента собери:

1. **id** — уникальный ID (music_rule_001...)

2. **genre** — жанр контента (НЕ музыки!):
   - true-crime
   - facts
   - how-to
   - news
   - story
   - pov
   - review
   - comparison
   - motivation
   - educational
   - business
   - lifestyle
   - tech
   - science
   - mystery
   - conspiracy
   - transformation
   - entertainment
   - comedy
   - fitness
   - travel
   - food
   - fashion
   - gaming
   - asmr

3. **music_style** — стиль музыки (object):
   - **primary_genre** — основной музыкальный жанр (hip-hop, electronic, ambient, etc.)
   - **sub_genres** — поджанры (array: ["lo-fi", "trap", "synthwave"])
   - **avoid_genres** — что НЕ использовать (array)

4. **tempo** — темп (object):
   - **bpm_range** — диапазон BPM (object: {min: 80, max: 100})
   - **optimal_bpm** — идеальный BPM (integer)
   - **why** — почему этот темп (string)

5. **key_and_mode** — тональность (object):
   - **recommended_keys** — рекомендуемые тональности (array: ["C minor", "D minor"])
   - **mode** — мажор/минор (enum: "major", "minor", "both")
   - **emotional_reason** — почему эта тональность (string)

6. **mood** — настроение музыки (object):
   - **primary_mood** — основное настроение (string: "dark", "uplifting", "mysterious")
   - **secondary_moods** — дополнительные (array)
   - **avoid_moods** — нежелательные настроения (array)

7. **energy** — энергетика (object):
   - **level** — уровень энергии 1-10 (integer)
   - **dynamic_range** — динамический диапазон (enum: "low", "medium", "high")
   - **build_type** — как строится энергия (enum: "constant", "building", "drops", "wave")

8. **instrumentation** — инструменты (object):
   - **primary_instruments** — основные инструменты (array)
   - **texture** — текстура (enum: "minimal", "layered", "dense")
   - **vocals** — вокал (enum: "none", "ambient", "lyrics", "both")

9. **sync_points** — точки синхронизации с контентом (array of objects):
   - **timing** — время в секундах (integer)
   - **element** — элемент контента (string: "hook", "twist", "reveal")
   - **music_event** — что должно произойти в музыке (string: "drop", "build", "silence")

10. **platforms** — оптимально для платформ (array: ["tiktok", "reels", "shorts", "youtube"])

11. **viral_score** — средний вирусный потенциал этой комбинации (0-100)

12. **examples** — примеры успешного использования (array of objects):
    - **track_name** — название трека (если известен)
    - **description** — описание звучания
    - **viral_proof** — доказательство (string: "Used in 2M+ TikToks")

13. **suno_prompts** — готовые промпты для Suno AI (array of strings, минимум 3)

14. **source** — источник данных (string)

### ДОПОЛНИТЕЛЬНО: БАЗА SUNO ПРОМПТОВ

Отдельно собери 100 лучших промптов для Suno AI в формате:

{
  "id": "suno_001",
  "prompt": "Dark atmospheric trap beat, 85 BPM, heavy 808 bass, minimal hi-hats, eerie piano melody, true crime documentary style",
  "style_tags": ["dark", "trap", "cinematic"],
  "best_for_genres": ["true-crime", "mystery", "conspiracy"],
  "bpm": 85,
  "energy": 6,
  "mood": "dark",
  "example_use_case": "Background music for true crime story reveals",
  "viral_proof": "Style used in top true-crime TikTok creators"
}

### ГДЕ ИСКАТЬ

**Музыкальная теория:**
- "Music Theory for Computer Musicians" by Michael Hewitt
- "The Psychology of Music" by Diana Deutsch
- Hooktheory.com — database of chord progressions
- LANDR blog — music production articles

**Suno AI:**
- Suno documentation — https://suno.ai/
- Suno Discord — примеры лучших промптов
- Reddit r/SunoAI — community best practices
- Suno prompt libraries

**Анализ вирусного контента:**
- TikTok Creative Center — trending sounds
- Epidemic Sound blog — social media music trends
- Artlist blog — video music guides
- Uppbeat blog — content creator guides

**Научные исследования:**
- "The Emotional Power of Music: Multidisciplinary perspectives" — academic papers
- Spotify Research — music psychology
- MIT Media Lab — music and emotion research
- Journal of Music Psychology

**Creator insights:**
- MrBeast production notes — music choices
- Colin and Samir — creator music strategies
- Video Creators (Tim Schmoyer) — YouTube music best practices
- Think Media — social video music guides

**Платформенные гайды:**
- TikTok Creator Portal — music recommendations
- Instagram Creators — Reels music guide
- YouTube Audio Library — mood categorization
- Meta Sound Collection — best practices

**Инструменты анализа:**
- TuneFind — viral video music tracking
- Chartmetric — music analytics
- InfluencerDB — trending sounds
- Viberate — music trend analysis

### КРИТЕРИИ КАЧЕСТВА

Музыкальное правило ХОРОШЕЕ если:
✅ Подкреплено данными (>10 вирусных примеров)
✅ Специфично для жанра (не generic)
✅ Учитывает психологию восприятия
✅ Протестировано на разных платформах
✅ Имеет точные музыкальные параметры (BPM, key, etc.)
✅ Включает sync points для ключевых моментов
✅ Содержит работающие Suno промпты

Музыкальное правило ПЛОХОЕ если:
❌ Generic советы ("используйте upbeat music")
❌ Нет конкретных параметров
❌ Основано на личных предпочтениях, не данных
❌ Не учитывает платформенную специфику
❌ Противоречит музыкальной теории
❌ Нет примеров успешного использования

### КОЛИЧЕСТВО

Собери минимум:
- 30 жанров контента × детальные музыкальные правила = 30 записей
- 100 Suno промптов с разными стилями
- 5 универсальных правил (работают для всех жанров)

Приоритетные жанры:
1. True-crime (самый популярный)
2. Facts/Science
3. How-to/Tutorial
4. POV/Story
5. Business/Motivation
6. Tech reviews
7. Conspiracy/Mystery
8. Transformation
9. Comedy
10. Educational

### ФОРМАТ ВЫВОДА

Верни два JSON array:

// Music Rules
[
  {
    "id": "music_rule_001",
    "genre": "true-crime",
    "music_style": {
      "primary_genre": "cinematic-trap",
      "sub_genres": ["dark-ambient", "trap", "noir"],
      "avoid_genres": ["upbeat-pop", "happy", "dance"]
    },
    "tempo": {
      "bpm_range": {"min": 80, "max": 95},
      "optimal_bpm": 85,
      "why": "Slow enough to create tension but fast enough to maintain engagement. Matches natural speech rhythm for narration."
    },
    "key_and_mode": {
      "recommended_keys": ["C minor", "D minor", "F minor"],
      "mode": "minor",
      "emotional_reason": "Minor keys create unease and mystery essential for true crime storytelling"
    },
    "mood": {
      "primary_mood": "dark",
      "secondary_moods": ["mysterious", "tense", "ominous"],
      "avoid_moods": ["happy", "playful", "romantic"]
    },
    "energy": {
      "level": 6,
      "dynamic_range": "medium",
      "build_type": "building"
    },
    "instrumentation": {
      "primary_instruments": ["808 bass", "dark piano", "ambient pads", "minimal percussion"],
      "texture": "layered",
      "vocals": "none"
    },
    "sync_points": [
      {
        "timing": 3,
        "element": "hook",
        "music_event": "bass drop or tension build"
      },
      {
        "timing": 35,
        "element": "twist",
        "music_event": "sudden silence or pattern break"
      },
      {
        "timing": 50,
        "element": "reveal",
        "music_event": "full build with all elements"
      }
    ],
    "platforms": ["tiktok", "reels", "shorts"],
    "viral_score": 92,
    "examples": [
      {
        "track_name": "Dark Trap Beat",
        "description": "85 BPM, minor key, heavy 808s, eerie piano",
        "viral_proof": "Used in 5M+ true crime TikToks"
      }
    ],
    "suno_prompts": [
      "Dark cinematic trap, 85 BPM, heavy 808 bass, eerie piano melody, minimal hi-hats, noir atmosphere, true crime documentary style",
      "Atmospheric dark trap beat with ominous piano, deep sub bass, slow tempo, mysterious pads, suspenseful build",
      "True crime background music: dark ambient trap, 85 BPM, minor key, tension building, cinematic documentary feel"
    ],
    "source": "Analysis of 500+ viral true-crime TikToks + music psychology research"
  }
]

// Suno Prompts Library
[
  {
    "id": "suno_001",
    "prompt": "Dark atmospheric trap beat, 85 BPM, heavy 808 bass, minimal hi-hats, eerie piano melody, true crime documentary style",
    "style_tags": ["dark", "trap", "cinematic"],
    "best_for_genres": ["true-crime", "mystery", "conspiracy"],
    "bpm": 85,
    "energy": 6,
    "mood": "dark",
    "example_use_case": "Background music for true crime story reveals",
    "viral_proof": "Style used by top true-crime creators with 10M+ followers"
  }
]
```

---

## JSON СХЕМА

### Music Rules Schema:

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "array",
  "items": {
    "type": "object",
    "required": ["id", "genre", "music_style", "tempo", "mood", "energy", "platforms"],
    "properties": {
      "id": {
        "type": "string",
        "pattern": "^music_rule_[0-9]{3}$"
      },
      "genre": {
        "type": "string",
        "enum": ["true-crime", "facts", "how-to", "news", "story", "pov", "review", "comparison", "motivation", "educational", "business", "lifestyle", "tech", "science", "mystery", "conspiracy", "transformation", "entertainment", "comedy", "fitness", "travel", "food", "fashion", "gaming", "asmr", "universal"]
      },
      "music_style": {
        "type": "object",
        "required": ["primary_genre"],
        "properties": {
          "primary_genre": {"type": "string"},
          "sub_genres": {
            "type": "array",
            "items": {"type": "string"}
          },
          "avoid_genres": {
            "type": "array",
            "items": {"type": "string"}
          }
        }
      },
      "tempo": {
        "type": "object",
        "required": ["bpm_range", "optimal_bpm"],
        "properties": {
          "bpm_range": {
            "type": "object",
            "properties": {
              "min": {"type": "integer", "minimum": 40, "maximum": 200},
              "max": {"type": "integer", "minimum": 40, "maximum": 200}
            }
          },
          "optimal_bpm": {"type": "integer", "minimum": 40, "maximum": 200},
          "why": {"type": "string"}
        }
      },
      "key_and_mode": {
        "type": "object",
        "properties": {
          "recommended_keys": {
            "type": "array",
            "items": {"type": "string"}
          },
          "mode": {
            "type": "string",
            "enum": ["major", "minor", "both"]
          },
          "emotional_reason": {"type": "string"}
        }
      },
      "mood": {
        "type": "object",
        "required": ["primary_mood"],
        "properties": {
          "primary_mood": {"type": "string"},
          "secondary_moods": {
            "type": "array",
            "items": {"type": "string"}
          },
          "avoid_moods": {
            "type": "array",
            "items": {"type": "string"}
          }
        }
      },
      "energy": {
        "type": "object",
        "required": ["level"],
        "properties": {
          "level": {"type": "integer", "minimum": 1, "maximum": 10},
          "dynamic_range": {
            "type": "string",
            "enum": ["low", "medium", "high"]
          },
          "build_type": {
            "type": "string",
            "enum": ["constant", "building", "drops", "wave"]
          }
        }
      },
      "instrumentation": {
        "type": "object",
        "properties": {
          "primary_instruments": {
            "type": "array",
            "items": {"type": "string"}
          },
          "texture": {
            "type": "string",
            "enum": ["minimal", "layered", "dense"]
          },
          "vocals": {
            "type": "string",
            "enum": ["none", "ambient", "lyrics", "both"]
          }
        }
      },
      "sync_points": {
        "type": "array",
        "items": {
          "type": "object",
          "properties": {
            "timing": {"type": "integer"},
            "element": {"type": "string"},
            "music_event": {"type": "string"}
          }
        }
      },
      "platforms": {
        "type": "array",
        "items": {
          "type": "string",
          "enum": ["tiktok", "reels", "shorts", "youtube", "all"]
        }
      },
      "viral_score": {
        "type": "integer",
        "minimum": 0,
        "maximum": 100
      },
      "examples": {
        "type": "array",
        "items": {
          "type": "object",
          "properties": {
            "track_name": {"type": "string"},
            "description": {"type": "string"},
            "viral_proof": {"type": "string"}
          }
        }
      },
      "suno_prompts": {
        "type": "array",
        "items": {"type": "string"},
        "minItems": 1
      },
      "source": {"type": "string"}
    }
  }
}
```

### Suno Prompts Schema:

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "array",
  "items": {
    "type": "object",
    "required": ["id", "prompt", "best_for_genres", "mood"],
    "properties": {
      "id": {
        "type": "string",
        "pattern": "^suno_[0-9]{3}$"
      },
      "prompt": {
        "type": "string",
        "minLength": 20,
        "maxLength": 500
      },
      "style_tags": {
        "type": "array",
        "items": {"type": "string"}
      },
      "best_for_genres": {
        "type": "array",
        "items": {"type": "string"}
      },
      "bpm": {
        "type": "integer",
        "minimum": 40,
        "maximum": 200
      },
      "energy": {
        "type": "integer",
        "minimum": 1,
        "maximum": 10
      },
      "mood": {"type": "string"},
      "example_use_case": {"type": "string"},
      "viral_proof": {"type": "string"}
    }
  }
}
```

---

## ИСТОЧНИКИ ДЛЯ ПОИСКА

### Обязательные:
1. **Suno AI** — https://suno.ai/ + Discord community
2. **TikTok Creative Center** — https://ads.tiktok.com/business/creativecenter (trending sounds)
3. **Epidemic Sound Blog** — https://www.epidemicsound.com/blog/
4. **Artlist** — https://artlist.io/blog (music for creators)

### Музыкальная теория:
5. **Hooktheory** — https://www.hooktheory.com/ (chord progressions database)
6. **Music Theory for Computer Musicians** — book
7. **The Psychology of Music** by Diana Deutsch
8. **LANDR Blog** — https://blog.landr.com/

### Исследования:
9. **Spotify Research** — https://research.atspotify.com/
10. **MIT Media Lab** — music and emotion research
11. **Journal of Music Psychology** — academic papers
12. **"The Emotional Power of Music"** studies

### Creator resources:
13. **Colin and Samir** — creator music strategies
14. **Video Creators (Tim Schmoyer)** — music best practices
15. **Think Media** — social video music guides
16. **Peter McKinnon** — cinematic music choices

### Платформы:
17. **YouTube Audio Library** — mood categorization
18. **Instagram Creators** — Reels music guide
19. **TikTok Creator Portal** — music recommendations
20. **Meta Sound Collection** — best practices

---

## КРИТЕРИИ КАЧЕСТВА

### Правило проходит валидацию если:

| Критерий | Требование |
|----------|------------|
| Специфичность | Конкретные BPM, тональности, инструменты |
| Доказательства | Минимум 3 примера вирусного использования |
| Теория | Подкреплено музыкальной теорией/психологией |
| Sync points | Указаны точки синхронизации с контентом |
| Suno промпты | Минимум 3 работающих промпта |
| Платформы | Адаптировано под специфику платформ |
| Viral score | Основан на реальных данных |
| Источник | Указан авторитетный источник |

---

## КОЛИЧЕСТВО ЗАПИСЕЙ

### Music Rules:

| Жанр контента | Минимум |
|---------------|---------|
| True-crime | 1 |
| Facts/Science | 1 |
| How-to | 1 |
| POV/Story | 1 |
| Business/Motivation | 1 |
| Tech | 1 |
| Mystery/Conspiracy | 1 |
| Transformation | 1 |
| Comedy | 1 |
| Educational | 1 |
| Review | 1 |
| News | 1 |
| Lifestyle | 1 |
| Travel | 1 |
| Food | 1 |
| Fashion | 1 |
| Fitness | 1 |
| Gaming | 1 |
| ASMR | 1 |
| Other genres | 11 |
| Universal rules | 5 |
| **TOTAL** | **30+** |

### Suno Prompts: **100 промптов**

---

## ПРИМЕР ГОТОВЫХ ДАННЫХ

### Music Rules:

```json
[
  {
    "id": "music_rule_001",
    "genre": "true-crime",
    "music_style": {
      "primary_genre": "cinematic-trap",
      "sub_genres": ["dark-ambient", "trap", "noir"],
      "avoid_genres": ["upbeat-pop", "happy", "dance", "romantic"]
    },
    "tempo": {
      "bpm_range": {"min": 80, "max": 95},
      "optimal_bpm": 85,
      "why": "Slow enough to create tension and suspense, but fast enough to maintain engagement. Matches natural speech rhythm for true crime narration."
    },
    "key_and_mode": {
      "recommended_keys": ["C minor", "D minor", "F minor", "G minor"],
      "mode": "minor",
      "emotional_reason": "Minor keys create unease, mystery, and darkness essential for true crime storytelling"
    },
    "mood": {
      "primary_mood": "dark",
      "secondary_moods": ["mysterious", "tense", "ominous", "suspenseful"],
      "avoid_moods": ["happy", "playful", "romantic", "celebratory"]
    },
    "energy": {
      "level": 6,
      "dynamic_range": "medium",
      "build_type": "building"
    },
    "instrumentation": {
      "primary_instruments": ["808 bass", "dark piano", "ambient pads", "minimal percussion", "sub bass"],
      "texture": "layered",
      "vocals": "none"
    },
    "sync_points": [
      {
        "timing": 3,
        "element": "hook",
        "music_event": "bass drop or tension build starts"
      },
      {
        "timing": 35,
        "element": "twist",
        "music_event": "sudden silence or pattern break for impact"
      },
      {
        "timing": 50,
        "element": "reveal",
        "music_event": "full build with all elements, peak intensity"
      }
    ],
    "platforms": ["tiktok", "reels", "shorts"],
    "viral_score": 92,
    "examples": [
      {
        "track_name": "Dark Documentary Trap",
        "description": "85 BPM, C minor, heavy 808s, eerie piano melody, tension building throughout",
        "viral_proof": "Used in 5M+ true crime TikToks by creators like @baileyarian"
      },
      {
        "track_name": "Noir Investigation",
        "description": "80 BPM trap with dark ambient pads and minimal percussion",
        "viral_proof": "Background music for top 100 true crime creators"
      }
    ],
    "suno_prompts": [
      "Dark cinematic trap, 85 BPM, heavy 808 bass, eerie piano melody, minimal hi-hats, noir atmosphere, true crime documentary style, tension building, C minor",
      "Atmospheric dark trap beat with ominous piano, deep sub bass, 80-85 BPM, mysterious ambient pads, suspenseful build, true crime background music",
      "True crime soundtrack: dark ambient trap, 85 BPM, minor key, cinematic documentary feel, layered textures, building intensity"
    ],
    "source": "Analysis of 500+ viral true-crime TikToks + music psychology research (Diana Deutsch)"
  },
  {
    "id": "music_rule_002",
    "genre": "motivation",
    "music_style": {
      "primary_genre": "epic-electronic",
      "sub_genres": ["future-bass", "progressive-house", "uplifting-trance"],
      "avoid_genres": ["sad", "dark", "slow-tempo"]
    },
    "tempo": {
      "bpm_range": {"min": 125, "max": 140},
      "optimal_bpm": 128,
      "why": "Fast enough to energize but not overwhelming. 128 BPM is the sweet spot for motivational content - creates urgency and momentum."
    },
    "key_and_mode": {
      "recommended_keys": ["C major", "D major", "E major", "G major"],
      "mode": "major",
      "emotional_reason": "Major keys create optimism, hope, and empowerment essential for motivation"
    },
    "mood": {
      "primary_mood": "uplifting",
      "secondary_moods": ["energetic", "empowering", "triumphant", "hopeful"],
      "avoid_moods": ["sad", "dark", "anxious", "melancholic"]
    },
    "energy": {
      "level": 9,
      "dynamic_range": "high",
      "build_type": "building"
    },
    "instrumentation": {
      "primary_instruments": ["synth leads", "big drums", "uplifting pads", "power chords", "risers"],
      "texture": "dense",
      "vocals": "ambient"
    },
    "sync_points": [
      {
        "timing": 5,
        "element": "hook",
        "music_event": "build starts with risers"
      },
      {
        "timing": 15,
        "element": "main message",
        "music_event": "drop with full energy"
      },
      {
        "timing": 50,
        "element": "call-to-action",
        "music_event": "final build to peak intensity"
      }
    ],
    "platforms": ["tiktok", "reels", "shorts", "youtube"],
    "viral_score": 88,
    "examples": [
      {
        "track_name": "Epic Motivational",
        "description": "128 BPM, D major, huge synths, powerful drums, uplifting progression",
        "viral_proof": "Used by Gary Vee, Alex Hormozi and 1M+ motivational creators"
      }
    ],
    "suno_prompts": [
      "Epic uplifting electronic music, 128 BPM, major key, powerful synth leads, big drums, motivational anthem, progressive build, triumphant energy",
      "Inspirational future bass, 130 BPM, uplifting pads, energetic drums, hopeful melody, empowerment soundtrack, high energy build",
      "Motivational EDM track, 128 BPM, D major, epic synths, driving beat, victorious atmosphere, perfect for success stories"
    ],
    "source": "Analysis of top motivational creators + sports psychology music research"
  },
  {
    "id": "music_rule_003",
    "genre": "comedy",
    "music_style": {
      "primary_genre": "quirky-upbeat",
      "sub_genres": ["ukulele-pop", "playful-electronic", "retro-gaming"],
      "avoid_genres": ["serious", "dark", "emotional"]
    },
    "tempo": {
      "bpm_range": {"min": 110, "max": 140},
      "optimal_bpm": 120,
      "why": "Medium-fast tempo creates playful energy without being chaotic. Allows for comedic timing and punch lines."
    },
    "key_and_mode": {
      "recommended_keys": ["C major", "F major", "G major"],
      "mode": "major",
      "emotional_reason": "Bright major keys enhance playfulness and lighthearted comedy"
    },
    "mood": {
      "primary_mood": "playful",
      "secondary_moods": ["quirky", "fun", "silly", "lighthearted"],
      "avoid_moods": ["serious", "dramatic", "sad", "angry"]
    },
    "energy": {
      "level": 7,
      "dynamic_range": "medium",
      "build_type": "constant"
    },
    "instrumentation": {
      "primary_instruments": ["ukulele", "pizzicato strings", "xylophone", "quirky synths", "light percussion"],
      "texture": "minimal",
      "vocals": "none"
    },
    "sync_points": [
      {
        "timing": 8,
        "element": "setup",
        "music_event": "playful melody continues"
      },
      {
        "timing": 25,
        "element": "punchline",
        "music_event": "comedic sting or silence for impact"
      }
    ],
    "platforms": ["tiktok", "reels", "shorts"],
    "viral_score": 85,
    "examples": [
      {
        "track_name": "Quirky Comedy",
        "description": "120 BPM, ukulele with pizzicato strings, playful and bouncy",
        "viral_proof": "Used in 10M+ comedy TikToks"
      }
    ],
    "suno_prompts": [
      "Quirky comedy music, 120 BPM, ukulele, pizzicato strings, xylophone, playful and bouncy, lighthearted sitcom style",
      "Silly upbeat track, fun ukulele melody, quirky sound effects, playful energy, comedy sketch background music, 120 BPM",
      "Playful comedic music, major key, bouncy rhythm, quirky instruments, lighthearted and fun, perfect for funny videos"
    ],
    "source": "Analysis of viral comedy TikToks + sitcom music patterns"
  }
]
```

### Suno Prompts Library:

```json
[
  {
    "id": "suno_001",
    "prompt": "Dark cinematic trap, 85 BPM, heavy 808 bass, eerie piano melody, minimal hi-hats, noir atmosphere, true crime documentary style, tension building, C minor",
    "style_tags": ["dark", "trap", "cinematic", "noir"],
    "best_for_genres": ["true-crime", "mystery", "conspiracy"],
    "bpm": 85,
    "energy": 6,
    "mood": "dark",
    "example_use_case": "Background music for true crime story reveals and suspenseful narration",
    "viral_proof": "Style used by top true-crime creators with 10M+ followers like @baileyarian"
  },
  {
    "id": "suno_002",
    "prompt": "Epic uplifting electronic music, 128 BPM, major key, powerful synth leads, big drums, motivational anthem, progressive build, triumphant energy",
    "style_tags": ["epic", "uplifting", "motivational", "electronic"],
    "best_for_genres": ["motivation", "business", "transformation", "fitness"],
    "bpm": 128,
    "energy": 9,
    "mood": "uplifting",
    "example_use_case": "Motivational speeches, success stories, workout content, business wins",
    "viral_proof": "Used by Gary Vee, Alex Hormozi, and top business influencers"
  },
  {
    "id": "suno_003",
    "prompt": "Lo-fi hip hop beat, 85 BPM, jazz piano chords, vinyl crackle, smooth bass, chill atmosphere, study/work music vibe, relaxed and focused",
    "style_tags": ["lo-fi", "chill", "hip-hop", "relaxed"],
    "best_for_genres": ["educational", "how-to", "tech", "lifestyle"],
    "bpm": 85,
    "energy": 4,
    "mood": "chill",
    "example_use_case": "Tutorial videos, educational content, tech reviews, productivity tips",
    "viral_proof": "Lo-fi style has 50M+ YouTube searches, proven retention booster"
  },
  {
    "id": "suno_004",
    "prompt": "Mysterious ambient soundscape, 70 BPM, ethereal pads, distant bells, subtle percussion, conspiracy theory atmosphere, enigmatic and haunting",
    "style_tags": ["ambient", "mysterious", "ethereal", "conspiracy"],
    "best_for_genres": ["mystery", "conspiracy", "paranormal", "science"],
    "bpm": 70,
    "energy": 5,
    "mood": "mysterious",
    "example_use_case": "Conspiracy theories, unexplained phenomena, mystery reveals",
    "viral_proof": "Mystery content with ambient music has 2x higher retention on TikTok"
  },
  {
    "id": "suno_005",
    "prompt": "Quirky comedy music, 120 BPM, ukulele, pizzicato strings, xylophone, playful and bouncy, lighthearted sitcom style, fun energy",
    "style_tags": ["quirky", "comedy", "playful", "ukulele"],
    "best_for_genres": ["comedy", "entertainment", "pov", "lifestyle"],
    "bpm": 120,
    "energy": 7,
    "mood": "playful",
    "example_use_case": "Comedy sketches, funny POV videos, lighthearted entertainment",
    "viral_proof": "Quirky ukulele music used in 10M+ comedy TikToks"
  }
]
```
