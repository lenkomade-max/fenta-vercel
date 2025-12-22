# 08 - VOICE PROFILES DATABASE

## Цель базы данных

Хранить **все голоса ElevenLabs** + правила их использования для агентов:
- **Voice Agent** — выбирает голос под жанр и настроение контента
- **Script Agent** — адаптирует сценарий под характеристики голоса
- **Quality Agent** — проверяет соответствие голоса контенту

---

## ПРОМПТ ДЛЯ DEEP RESEARCH

```
Ты — эксперт по voice casting для контента. Твоя задача — создать базу данных всех доступных голосов ElevenLabs + правила когда какой голос использовать.

### ЧТО ТАКОЕ VOICE PROFILE

Voice Profile — это детальное описание голоса, которое включает:
- Технические параметры голоса (voice_id, model)
- Характеристики (age, gender, accent, tone, energy)
- Для каких жанров контента оптимален
- Рекомендуемые настройки (stability, clarity, style exaggeration)
- Примеры успешного использования

Правильный голос = +50% к retention. Неправильный голос = зритель уходит через 2 секунды.

### ЧТО СОБИРАТЬ

Для каждого голоса собери:

1. **id** — уникальный ID (voice_profile_001...)

2. **voice_id** — ID голоса в ElevenLabs API (string)

3. **name** — название голоса в ElevenLabs (string)

4. **category** — категория (enum):
   - premade (готовые голоса ElevenLabs)
   - professional (проф. голоса)
   - generated (AI-сгенерированные)
   - cloned (клонированные)

5. **characteristics** — характеристики голоса (object):
   - **gender** — пол (enum: "male", "female", "neutral")
   - **age_range** — возрастной диапазон (enum: "young", "middle-aged", "mature", "elderly")
   - **accent** — акцент (string: "American", "British", "Australian", etc.)
   - **tone** — тон (array: ["warm", "authoritative", "friendly", "serious", "energetic"])
   - **energy_level** — уровень энергии 1-10 (integer)
   - **pitch** — высота голоса (enum: "low", "medium", "high")
   - **pace** — скорость речи (enum: "slow", "moderate", "fast")
   - **emotional_range** — эмоциональный диапазон (enum: "narrow", "moderate", "wide")

6. **best_for_genres** — оптимальные жанры контента (array):
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
   - asmr

7. **avoid_for_genres** — НЕ использовать для (array)

8. **platforms** — лучше работает на (array: ["tiktok", "reels", "shorts", "youtube", "all"])

9. **recommended_settings** — рекомендуемые настройки ElevenLabs (object):
   - **stability** — стабильность 0-100 (integer, default: 50)
   - **similarity_boost** — усиление схожести 0-100 (integer, default: 75)
   - **style** — стиль 0-100 (integer, default: 0)
   - **use_speaker_boost** — усиление голоса (boolean, default: true)

10. **use_cases** — конкретные сценарии использования (array of objects):
    - **scenario** — сценарий (string)
    - **why** — почему этот голос (string)
    - **example** — пример текста (string)

11. **strengths** — сильные стороны (array of strings)

12. **weaknesses** — слабые стороны (array of strings)

13. **viral_score** — средний вирусный потенциал этого голоса (0-100)

14. **retention_impact** — влияние на retention (enum: "negative", "neutral", "positive", "very_positive")

15. **authenticity_score** — насколько естественно звучит (0-100)

16. **emotional_delivery** — способность передавать эмоции (0-100)

17. **examples** — примеры успешного использования (array of objects):
    - **creator** — кто использует (string)
    - **genre** — жанр контента (string)
    - **result** — результат (string: "5M views average")

18. **alternatives** — похожие голоса (array of voice_ids)

19. **source** — источник данных (string)

20. **notes** — дополнительные заметки (string)

### ДОПОЛНИТЕЛЬНО: VOICE CASTING RULES

Создай также набор правил выбора голоса:

{
  "rule_id": "voice_rule_001",
  "rule_name": "True Crime Gender Rule",
  "description": "For true crime content, female voices perform 40% better than male voices",
  "genres": ["true-crime", "mystery"],
  "recommendation": "Use female voices with serious, authoritative tone",
  "data_source": "Analysis of 1000+ viral true crime videos",
  "priority": "high"
}

### ГДЕ ИСКАТЬ

**ElevenLabs ресурсы:**
- ElevenLabs API documentation — https://elevenlabs.io/docs
- ElevenLabs Voice Library — https://elevenlabs.io/voice-library
- ElevenLabs Discord — community insights
- ElevenLabs blog — best practices

**Voice acting guides:**
- "Voice-Over Voice Actor" by Yuri Lowenthal
- "The Art of Voice Acting" by James Alburger
- Voices.com blog — voice acting tips
- Edge Studio blog — narration guides

**Creator insights:**
- Top TikTok creators — analyze their voice choices
- YouTube documentary channels — voice analysis
- Podcast production guides — voice selection
- Audiobook narration best practices

**Научные исследования:**
- "The Psychology of Voice Perception" — academic papers
- Stanford Persuasion Lab — voice and trust research
- MIT Media Lab — voice and emotion
- Journal of Voice — scientific voice research

**Анализ контента:**
- Analyze 100+ viral videos per genre
- Note which voices perform best
- Track retention rates by voice type
- Document creator preferences

**Платформенные исследования:**
- TikTok Creator Portal — voice trends
- YouTube Creator Academy — narration best practices
- Meta Creator Studio — Reels voice insights
- Twitter spaces — voice content analysis

### КРИТЕРИИ КАЧЕСТВА

Voice Profile ХОРОШИЙ если:
✅ Содержит точные технические параметры
✅ Указаны конкретные жанры (с доказательствами)
✅ Есть рекомендуемые настройки ElevenLabs
✅ Включает примеры успешного использования
✅ Описаны сильные и слабые стороны
✅ Указаны альтернативные голоса
✅ Основан на анализе реального контента

Voice Profile ПЛОХОЙ если:
❌ Generic описание ("хороший голос для всего")
❌ Нет конкретных параметров
❌ Не указаны жанры и use cases
❌ Нет данных о performance
❌ Отсутствуют настройки
❌ Нет примеров использования

### КОЛИЧЕСТВО

Собери минимум:
- 50 голосов ElevenLabs (все основные + популярные)
- 20 voice casting rules (правила выбора голоса)
- 10 use case studies (детальные кейсы использования)

Приоритет:
1. Premade voices ElevenLabs (все доступные)
2. Professional voices (топ-10)
3. Popular cloned voices (если доступны)
4. Voice casting rules по жанрам

### ФОРМАТ ВЫВОДА

Верни три JSON array:

// Voice Profiles
[
  {
    "id": "voice_profile_001",
    "voice_id": "21m00Tcm4TlvDq8ikWAM",
    "name": "Rachel",
    "category": "premade",
    "characteristics": {
      "gender": "female",
      "age_range": "young",
      "accent": "American",
      "tone": ["calm", "composed", "narration"],
      "energy_level": 6,
      "pitch": "medium",
      "pace": "moderate",
      "emotional_range": "moderate"
    },
    "best_for_genres": ["educational", "how-to", "tech", "science", "news"],
    "avoid_for_genres": ["comedy", "high-energy", "entertainment"],
    "platforms": ["youtube", "shorts", "all"],
    "recommended_settings": {
      "stability": 70,
      "similarity_boost": 75,
      "style": 20,
      "use_speaker_boost": true
    },
    "use_cases": [
      {
        "scenario": "Educational explainer videos",
        "why": "Clear articulation, professional tone, trustworthy",
        "example": "In this video, we'll explore the fascinating science behind..."
      }
    ],
    "strengths": ["clarity", "professionalism", "versatility", "trustworthy"],
    "weaknesses": ["not ideal for emotional content", "can sound too formal"],
    "viral_score": 78,
    "retention_impact": "positive",
    "authenticity_score": 85,
    "emotional_delivery": 70,
    "examples": [
      {
        "creator": "Educational tech channels",
        "genre": "tech",
        "result": "Used by creators with 5M+ avg views"
      }
    ],
    "alternatives": ["Bella", "Elli"],
    "source": "ElevenLabs official + analysis of 500+ videos",
    "notes": "One of the most popular ElevenLabs voices for educational content"
  }
]

// Voice Casting Rules
[
  {
    "rule_id": "voice_rule_001",
    "rule_name": "True Crime Female Advantage",
    "description": "For true crime content, female voices perform 40% better in retention and virality compared to male voices",
    "genres": ["true-crime", "mystery"],
    "recommendation": "Use female voices with serious, authoritative, slightly darker tone (e.g., Bella, Charlotte)",
    "data_source": "Analysis of 1000+ viral true crime TikToks",
    "priority": "high",
    "evidence": "Top 20 true crime creators: 18 use female voices"
  }
]

// Use Case Studies
[
  {
    "study_id": "usecase_001",
    "title": "True Crime Voice Optimization",
    "scenario": "60-second true crime TikTok",
    "voice_tested": ["Bella", "Josh", "Charlotte"],
    "winner": "Bella",
    "results": {
      "bella": {"retention": 85, "completion": 72, "shares": 450},
      "josh": {"retention": 68, "completion": 58, "shares": 180},
      "charlotte": {"retention": 80, "completion": 68, "shares": 380}
    },
    "conclusion": "Bella's authoritative female voice with dark tone performed best for true crime content",
    "settings_used": {
      "stability": 75,
      "similarity_boost": 80,
      "style": 40
    }
  }
]
```

---

## JSON СХЕМА

### Voice Profiles Schema:

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "array",
  "items": {
    "type": "object",
    "required": ["id", "voice_id", "name", "category", "characteristics", "best_for_genres"],
    "properties": {
      "id": {
        "type": "string",
        "pattern": "^voice_profile_[0-9]{3}$"
      },
      "voice_id": {"type": "string"},
      "name": {"type": "string"},
      "category": {
        "type": "string",
        "enum": ["premade", "professional", "generated", "cloned"]
      },
      "characteristics": {
        "type": "object",
        "required": ["gender", "age_range", "accent", "tone", "energy_level"],
        "properties": {
          "gender": {
            "type": "string",
            "enum": ["male", "female", "neutral"]
          },
          "age_range": {
            "type": "string",
            "enum": ["young", "middle-aged", "mature", "elderly"]
          },
          "accent": {"type": "string"},
          "tone": {
            "type": "array",
            "items": {"type": "string"}
          },
          "energy_level": {
            "type": "integer",
            "minimum": 1,
            "maximum": 10
          },
          "pitch": {
            "type": "string",
            "enum": ["low", "medium", "high"]
          },
          "pace": {
            "type": "string",
            "enum": ["slow", "moderate", "fast"]
          },
          "emotional_range": {
            "type": "string",
            "enum": ["narrow", "moderate", "wide"]
          }
        }
      },
      "best_for_genres": {
        "type": "array",
        "items": {"type": "string"}
      },
      "avoid_for_genres": {
        "type": "array",
        "items": {"type": "string"}
      },
      "platforms": {
        "type": "array",
        "items": {
          "type": "string",
          "enum": ["tiktok", "reels", "shorts", "youtube", "all"]
        }
      },
      "recommended_settings": {
        "type": "object",
        "properties": {
          "stability": {"type": "integer", "minimum": 0, "maximum": 100},
          "similarity_boost": {"type": "integer", "minimum": 0, "maximum": 100},
          "style": {"type": "integer", "minimum": 0, "maximum": 100},
          "use_speaker_boost": {"type": "boolean"}
        }
      },
      "use_cases": {
        "type": "array",
        "items": {
          "type": "object",
          "properties": {
            "scenario": {"type": "string"},
            "why": {"type": "string"},
            "example": {"type": "string"}
          }
        }
      },
      "strengths": {
        "type": "array",
        "items": {"type": "string"}
      },
      "weaknesses": {
        "type": "array",
        "items": {"type": "string"}
      },
      "viral_score": {
        "type": "integer",
        "minimum": 0,
        "maximum": 100
      },
      "retention_impact": {
        "type": "string",
        "enum": ["negative", "neutral", "positive", "very_positive"]
      },
      "authenticity_score": {
        "type": "integer",
        "minimum": 0,
        "maximum": 100
      },
      "emotional_delivery": {
        "type": "integer",
        "minimum": 0,
        "maximum": 100
      },
      "examples": {
        "type": "array",
        "items": {
          "type": "object",
          "properties": {
            "creator": {"type": "string"},
            "genre": {"type": "string"},
            "result": {"type": "string"}
          }
        }
      },
      "alternatives": {
        "type": "array",
        "items": {"type": "string"}
      },
      "source": {"type": "string"},
      "notes": {"type": "string"}
    }
  }
}
```

### Voice Casting Rules Schema:

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "array",
  "items": {
    "type": "object",
    "required": ["rule_id", "rule_name", "description", "genres", "recommendation"],
    "properties": {
      "rule_id": {
        "type": "string",
        "pattern": "^voice_rule_[0-9]{3}$"
      },
      "rule_name": {"type": "string"},
      "description": {"type": "string"},
      "genres": {
        "type": "array",
        "items": {"type": "string"}
      },
      "recommendation": {"type": "string"},
      "data_source": {"type": "string"},
      "priority": {
        "type": "string",
        "enum": ["low", "medium", "high", "critical"]
      },
      "evidence": {"type": "string"}
    }
  }
}
```

### Use Case Studies Schema:

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "array",
  "items": {
    "type": "object",
    "required": ["study_id", "title", "scenario", "voice_tested", "winner"],
    "properties": {
      "study_id": {
        "type": "string",
        "pattern": "^usecase_[0-9]{3}$"
      },
      "title": {"type": "string"},
      "scenario": {"type": "string"},
      "voice_tested": {
        "type": "array",
        "items": {"type": "string"}
      },
      "winner": {"type": "string"},
      "results": {"type": "object"},
      "conclusion": {"type": "string"},
      "settings_used": {"type": "object"}
    }
  }
}
```

---

## ИСТОЧНИКИ ДЛЯ ПОИСКА

### Обязательные:
1. **ElevenLabs API Docs** — https://elevenlabs.io/docs
2. **ElevenLabs Voice Library** — https://elevenlabs.io/voice-library
3. **ElevenLabs Discord** — community best practices
4. **ElevenLabs Blog** — https://elevenlabs.io/blog

### Voice acting resources:
5. **"The Art of Voice Acting"** by James Alburger
6. **"Voice-Over Voice Actor"** by Yuri Lowenthal
7. **Voices.com Blog** — https://www.voices.com/blog/
8. **Edge Studio** — https://edgestudio.com/blogs

### Creator analysis:
9. **Top TikTok true crime creators** — analyze voice choices
10. **YouTube documentary channels** — narration analysis
11. **Podcast production guides** — voice selection strategies
12. **Audiobook narration** — professional voice use

### Научные исследования:
13. **Stanford Persuasion Lab** — voice and trust
14. **MIT Media Lab** — voice and emotion research
15. **Journal of Voice** — scientific voice studies
16. **"The Psychology of Voice Perception"** — academic papers

### Платформы:
17. **TikTok Creator Portal** — voice trends
18. **YouTube Creator Academy** — narration best practices
19. **Podcast Insights** — voice engagement data
20. **Descript resources** — voice AI best practices

---

## КРИТЕРИИ КАЧЕСТВА

### Voice Profile проходит валидацию если:

| Критерий | Требование |
|----------|------------|
| Voice ID | Валидный ElevenLabs voice_id |
| Характеристики | Полные технические параметры |
| Жанры | Минимум 3 best_for_genres с обоснованием |
| Settings | Рекомендуемые настройки ElevenLabs |
| Use cases | Минимум 2 конкретных сценария |
| Strengths/Weaknesses | Честная оценка возможностей |
| Evidence | Примеры реального использования |
| Scores | Viral, retention, authenticity scores |

---

## КОЛИЧЕСТВО ЗАПИСЕЙ

### Voice Profiles: **50 голосов**

| Категория | Минимум |
|-----------|---------|
| Premade voices (ElevenLabs) | 30 |
| Professional voices | 10 |
| Popular cloned/generated | 10 |
| **TOTAL** | **50** |

### Voice Casting Rules: **20 правил**

### Use Case Studies: **10 кейсов**

---

## ПРИМЕР ГОТОВЫХ ДАННЫХ

### Voice Profiles:

```json
[
  {
    "id": "voice_profile_001",
    "voice_id": "EXAVITQu4vr4xnSDxMaL",
    "name": "Bella",
    "category": "premade",
    "characteristics": {
      "gender": "female",
      "age_range": "young",
      "accent": "American",
      "tone": ["authoritative", "serious", "calm", "dark"],
      "energy_level": 6,
      "pitch": "medium",
      "pace": "moderate",
      "emotional_range": "moderate"
    },
    "best_for_genres": ["true-crime", "mystery", "news", "documentary", "conspiracy"],
    "avoid_for_genres": ["comedy", "entertainment", "upbeat-content"],
    "platforms": ["tiktok", "reels", "shorts", "youtube"],
    "recommended_settings": {
      "stability": 75,
      "similarity_boost": 80,
      "style": 40,
      "use_speaker_boost": true
    },
    "use_cases": [
      {
        "scenario": "True crime story narration",
        "why": "Authoritative female voice creates trust and engagement, dark tone enhances mystery",
        "example": "In 2019, a woman vanished without a trace. What police found three months later would shock the nation..."
      },
      {
        "scenario": "Conspiracy theory videos",
        "why": "Serious tone adds credibility to controversial topics",
        "example": "What if everything you knew about this event... was carefully crafted misinformation?"
      }
    ],
    "strengths": [
      "Perfect for serious content",
      "High retention on true crime",
      "Authoritative without being aggressive",
      "Clear articulation",
      "Emotional depth"
    ],
    "weaknesses": [
      "Too serious for comedy",
      "Not energetic enough for motivation",
      "Can sound monotone if stability too high"
    ],
    "viral_score": 92,
    "retention_impact": "very_positive",
    "authenticity_score": 88,
    "emotional_delivery": 85,
    "examples": [
      {
        "creator": "Top true crime TikTokers",
        "genre": "true-crime",
        "result": "18 out of top 20 true crime creators use Bella or similar female voice"
      },
      {
        "creator": "Mystery/conspiracy channels",
        "genre": "mystery",
        "result": "Average 2M+ views per video"
      }
    ],
    "alternatives": ["Charlotte", "Rachel", "Domi"],
    "source": "ElevenLabs + analysis of 1000+ viral true crime videos",
    "notes": "THE go-to voice for true crime content. Outperforms male voices by 40% in this genre."
  },
  {
    "id": "voice_profile_002",
    "voice_id": "pNInz6obpgDQGcFmaJgB",
    "name": "Adam",
    "category": "premade",
    "characteristics": {
      "gender": "male",
      "age_range": "middle-aged",
      "accent": "American",
      "tone": ["deep", "narrator", "professional", "warm"],
      "energy_level": 5,
      "pitch": "low",
      "pace": "slow",
      "emotional_range": "moderate"
    },
    "best_for_genres": ["documentary", "educational", "news", "business", "explainer"],
    "avoid_for_genres": ["comedy", "high-energy", "youth-content"],
    "platforms": ["youtube", "all"],
    "recommended_settings": {
      "stability": 80,
      "similarity_boost": 75,
      "style": 30,
      "use_speaker_boost": true
    },
    "use_cases": [
      {
        "scenario": "Documentary-style explainer",
        "why": "Deep, authoritative voice commands attention and respect",
        "example": "For millions of years, Earth's climate has shifted in cycles. But what we're witnessing now... is unprecedented."
      },
      {
        "scenario": "Business/finance content",
        "why": "Professional tone builds trust for serious topics",
        "example": "The stock market crash of 2008 taught us three critical lessons..."
      }
    ],
    "strengths": [
      "Extremely professional",
      "Perfect documentary voice",
      "High trust factor",
      "Clear and authoritative",
      "Great for long-form"
    ],
    "weaknesses": [
      "Too slow for short-form",
      "Not relatable for younger audiences",
      "Can sound overly formal",
      "Low energy"
    ],
    "viral_score": 70,
    "retention_impact": "neutral",
    "authenticity_score": 90,
    "emotional_delivery": 65,
    "examples": [
      {
        "creator": "Educational YouTube channels",
        "genre": "educational",
        "result": "Strong performance for 10+ minute videos"
      }
    ],
    "alternatives": ["Josh", "Antoni"],
    "source": "ElevenLabs + documentary voice analysis",
    "notes": "Better for YouTube long-form than TikTok/Shorts. Too slow-paced for viral short content."
  },
  {
    "id": "voice_profile_003",
    "voice_id": "ErXwobaYiN019PkySvjV",
    "name": "Antoni",
    "category": "premade",
    "characteristics": {
      "gender": "male",
      "age_range": "young",
      "accent": "American",
      "tone": ["energetic", "friendly", "upbeat", "casual"],
      "energy_level": 8,
      "pitch": "medium",
      "pace": "fast",
      "emotional_range": "wide"
    },
    "best_for_genres": ["how-to", "tech", "review", "lifestyle", "entertainment"],
    "avoid_for_genres": ["true-crime", "serious-news", "documentary"],
    "platforms": ["tiktok", "reels", "shorts", "youtube"],
    "recommended_settings": {
      "stability": 60,
      "similarity_boost": 70,
      "style": 50,
      "use_speaker_boost": true
    },
    "use_cases": [
      {
        "scenario": "Tech product review",
        "why": "Energetic and relatable, keeps attention in fast-paced reviews",
        "example": "Okay so this new iPhone feature is actually insane. Let me show you why..."
      },
      {
        "scenario": "How-to tutorial",
        "why": "Friendly tone makes learning feel easy and fun",
        "example": "Here's the trick nobody tells you about editing videos faster..."
      }
    ],
    "strengths": [
      "High energy keeps attention",
      "Relatable to younger audiences",
      "Great for fast-paced content",
      "Enthusiastic delivery",
      "Wide emotional range"
    ],
    "weaknesses": [
      "Too casual for serious topics",
      "Can sound overly excited",
      "Not authoritative enough for certain genres"
    ],
    "viral_score": 82,
    "retention_impact": "positive",
    "authenticity_score": 80,
    "emotional_delivery": 88,
    "examples": [
      {
        "creator": "Tech review TikToks",
        "genre": "tech",
        "result": "High engagement with 18-35 demographic"
      }
    ],
    "alternatives": ["Josh", "Clyde"],
    "source": "ElevenLabs + tech creator analysis",
    "notes": "Perfect for upbeat, fast content. Younger audience favorite."
  }
]
```

### Voice Casting Rules:

```json
[
  {
    "rule_id": "voice_rule_001",
    "rule_name": "True Crime Female Advantage",
    "description": "For true crime content, female voices perform 40% better in retention and virality compared to male voices",
    "genres": ["true-crime", "mystery"],
    "recommendation": "Use female voices with serious, authoritative, slightly darker tone (Bella, Charlotte, Domi)",
    "data_source": "Analysis of 1000+ viral true crime TikToks",
    "priority": "high",
    "evidence": "Top 20 true crime creators: 18 use female voices. Average retention: Female 85%, Male 68%"
  },
  {
    "rule_id": "voice_rule_002",
    "rule_name": "Youth Content Energy Rule",
    "description": "Content targeting 18-25 demographics requires high-energy voices (energy level 7+)",
    "genres": ["entertainment", "comedy", "lifestyle", "tech"],
    "recommendation": "Use energetic, casual voices like Antoni, Clyde. Avoid slow, formal voices.",
    "data_source": "TikTok audience analysis + engagement metrics",
    "priority": "high",
    "evidence": "High-energy voices get 2.3x more shares in youth demographics"
  },
  {
    "rule_id": "voice_rule_003",
    "rule_name": "Documentary Depth Rule",
    "description": "Long-form educational content (5+ min) benefits from deeper, slower voices that build authority",
    "genres": ["documentary", "educational", "news"],
    "recommendation": "Use deep male voices (Adam, Antoni with lower stability) or mature female voices",
    "data_source": "YouTube educational channel analysis",
    "priority": "medium",
    "evidence": "Watch time 15% higher with authoritative deep voices for 10+ min videos"
  }
]
```

### Use Case Studies:

```json
[
  {
    "study_id": "usecase_001",
    "title": "True Crime Voice A/B Test",
    "scenario": "60-second true crime TikTok about unsolved mystery",
    "voice_tested": ["Bella", "Josh", "Charlotte", "Adam"],
    "winner": "Bella",
    "results": {
      "bella": {
        "avg_views": 850000,
        "retention": 85,
        "completion_rate": 72,
        "shares": 4500,
        "comments": 1200
      },
      "josh": {
        "avg_views": 420000,
        "retention": 68,
        "completion_rate": 58,
        "shares": 1800,
        "comments": 650
      },
      "charlotte": {
        "avg_views": 720000,
        "retention": 80,
        "completion_rate": 68,
        "shares": 3800,
        "comments": 980
      },
      "adam": {
        "avg_views": 380000,
        "retention": 65,
        "completion_rate": 55,
        "shares": 1500,
        "comments": 580
      }
    },
    "conclusion": "Bella's authoritative female voice with dark tone performed best for true crime. Male voices underperformed by 50%+. Charlotte (also female) was second best.",
    "settings_used": {
      "stability": 75,
      "similarity_boost": 80,
      "style": 40,
      "use_speaker_boost": true
    }
  }
]
```
