# 03 - STRUCTURES DATABASE

## Цель базы данных

Хранить **30+ структур/формул** для создания сценариев по жанрам для использования агентами:
- **Orchestrator Agent** — выбирает структуру под задачу пользователя
- **Script Agent** — использует структуру как каркас сценария
- **Quality Agent** — проверяет соответствие сценария выбранной структуре

---

## ПРОМПТ ДЛЯ DEEP RESEARCH

```
Ты — архитектор вирусного контента. Твоя задача — собрать базу данных из 30+ storytelling структур для коротких видео по жанрам.

### ЧТО ТАКОЕ СТРУКТУРА

Структура — это проверенная формула построения сценария, которая определяет:
- Какие "биты" (beats) использовать
- В каком порядке
- Сколько времени на каждый бит
- Какие эмоции вызывать на каждом этапе

Структура = скелет сценария. Контент = мясо на костях.

### ЧТО СОБИРАТЬ

Для каждой структуры собери:

1. **id** — уникальный ID (structure_001...)

2. **name** — название структуры (например: "Hook-Context-Twist-Reveal")

3. **genre** — для какого жанра оптимальна:
   - true-crime
   - facts
   - how-to
   - news
   - story
   - explainer
   - review
   - comparison
   - motivation
   - educational
   - business
   - tech
   - mystery
   - conspiracy
   - transformation
   - entertainment

4. **best_for_platforms** — на каких платформах работает лучше (array):
   - tiktok
   - reels
   - shorts
   - youtube

5. **beats** — массив битов структуры, каждый бит содержит:
   - **name** — название бита (Hook, Context, Build, Twist, Payoff, CTA, etc.)
   - **duration_percent** — процент от общей длины (0-100)
   - **duration_seconds** — примерная длина в секундах для 60-сек видео
   - **purpose** — что должен делать этот бит
   - **emotional_goal** — какую эмоцию вызвать
   - **techniques** — рекомендуемые техники (array)
   - **examples** — примеры фраз для этого бита (array of strings)

6. **total_duration_range** — рекомендуемая длина видео:
   - min_seconds
   - max_seconds

7. **difficulty** — сложность использования:
   - beginner
   - intermediate
   - advanced

8. **retention_score** — средний retention rate для этой структуры (0-100)

9. **viral_potential** — потенциал вирусности (0-100)

10. **when_to_use** — когда использовать эту структуру (описание)

11. **when_not_to_use** — когда НЕ использовать

12. **full_example** — полный пример сценария по этой структуре

13. **source** — откуда взята структура (книга, курс, анализ)

14. **variations** — вариации структуры (array of objects):
    - name
    - description
    - example

### ГДЕ ИСКАТЬ

**Storytelling frameworks:**
- "Save the Cat!" by Blake Snyder (Hero's Journey adaptation)
- "Story" by Robert McKee
- "Building a StoryBrand" by Donald Miller
- "Made to Stick" by Chip & Dan Heath
- "Contagious" by Jonah Berger

**YouTube/TikTok анализ:**
- Paddy Galloway — viral video breakdowns
- Colin and Samir — creator interviews
- Ali Abdaal — scriptwriting frameworks
- MrBeast leaked production documents
- vidIQ research papers

**Copywriting frameworks:**
- AIDA (Attention-Interest-Desire-Action)
- PAS (Problem-Agitate-Solution)
- BAB (Before-After-Bridge)
- 4Ps (Problem-Promise-Proof-Proposal)
- FAB (Features-Advantages-Benefits)

**Курсы по скриптрайтингу:**
- Skillshare: "Viral Video Scripts" courses
- YouTube Creator Academy
- TikTok Creative Center — best practices
- Coursera: "Storytelling for Influence"

**Исследования:**
- Stanford Persuasive Technology Lab papers
- Wharton School virality research (Jonah Berger)
- Google Scholar: "viral content structure"
- MIT Media Lab — computational storytelling

**Анализ топ-контента:**
- VidIQ — trending scripts analysis
- TubeBuddy — script templates
- Deconstructor of Fun (для gaming, но применимо)
- Every viral MrBeast video breakdown

### КРИТЕРИИ КАЧЕСТВА

Структура ХОРОШАЯ если:
✅ Доказана на практике (примеры >1M views)
✅ Универсальна (работает на разных темах)
✅ Имеет чёткие временные метки
✅ Учитывает психологию удержания внимания
✅ Специфична для жанра (не generic)
✅ Включает emotional arc
✅ Тестирована на разных платформах

Структура ПЛОХАЯ если:
❌ Слишком сложная (>7 битов)
❌ Нет доказательств эффективности
❌ Generic (работает для всего = не работает ни для чего)
❌ Не учитывает платформенную специфику
❌ Нет конкретных примеров
❌ Копия другой структуры без адаптации

### ПРИОРИТЕТЫ СБОРА

Обязательные жанры:
1. True-Crime (2-3 структуры)
2. Facts/Science (2-3 структуры)
3. How-To (2-3 структуры)
4. Business/Motivation (2 структуры)
5. Mystery/Conspiracy (2 структуры)
6. Story/POV (2 структуры)
7. Review/Comparison (2 структуры)
8. Educational/Explainer (2 структуры)
9. News (1 структура)
10. Entertainment (1-2 структуры)

Плюс:
- 5 универсальных структур (работают для всех жанров)
- 5 платформо-специфичных (TikTok POV, YouTube Shorts listicle, etc.)

### ФОРМАТ ВЫВОДА

Верни JSON array:

[
  {
    "id": "structure_001",
    "name": "Hook-Context-Twist-Reveal-CTA",
    "genre": "true-crime",
    "best_for_platforms": ["tiktok", "reels", "shorts"],
    "beats": [
      {
        "name": "Hook",
        "duration_percent": 10,
        "duration_seconds": 3,
        "purpose": "Stop the scroll with shocking statement or question",
        "emotional_goal": "curiosity + shock",
        "techniques": ["open-loop", "specificity", "contrast"],
        "examples": [
          "This man walked into a police station and confessed to a murder... that never happened",
          "In 2019, a CEO disappeared without a trace... and her company didn't notice for 6 months"
        ]
      },
      {
        "name": "Context",
        "duration_percent": 25,
        "duration_seconds": 15,
        "purpose": "Set up the story, introduce key facts and characters",
        "emotional_goal": "investment + understanding",
        "techniques": ["specificity", "credibility-building"],
        "examples": [
          "Meet Sarah Chen. 42 years old, CEO of a $50M tech startup...",
          "It started in a small town in Ohio..."
        ]
      },
      {
        "name": "Twist",
        "duration_percent": 20,
        "duration_seconds": 12,
        "purpose": "Introduce unexpected element that changes everything",
        "emotional_goal": "surprise + intrigue",
        "techniques": ["pattern-interrupt", "revelation"],
        "examples": [
          "But here's what police didn't know...",
          "Then they found the security footage..."
        ]
      },
      {
        "name": "Reveal",
        "duration_percent": 35,
        "duration_seconds": 21,
        "purpose": "Deliver payoff, resolve tension, explain the mystery",
        "emotional_goal": "satisfaction + mind-blown",
        "techniques": ["callback", "specificity"],
        "examples": [
          "Turns out, Sarah had been planning this for 3 years...",
          "The confession was a cover for something bigger..."
        ]
      },
      {
        "name": "CTA",
        "duration_percent": 10,
        "duration_seconds": 6,
        "purpose": "Drive engagement and follow",
        "emotional_goal": "action + loyalty",
        "techniques": ["question", "promise"],
        "examples": [
          "Follow for more true crime stories that'll blow your mind",
          "Part 2 coming tomorrow... you won't believe what happens next"
        ]
      }
    ],
    "total_duration_range": {
      "min_seconds": 45,
      "max_seconds": 75
    },
    "difficulty": "intermediate",
    "retention_score": 85,
    "viral_potential": 90,
    "when_to_use": "When you have a true story with a shocking twist or unexpected element. Works best when the reveal genuinely changes the context of the hook.",
    "when_not_to_use": "When the story is predictable or doesn't have a strong twist. Don't use for educational content that needs step-by-step clarity.",
    "full_example": "This woman faked her own death... to escape a $2M debt.\n\nMeet Jennifer Walsh, 34, married, two kids, living in suburban Chicago. Perfect life on Instagram. But behind closed doors, she had a secret: massive gambling debts.\n\nIn March 2021, her car was found abandoned near a bridge. Suicide note inside. Search and rescue found nothing. She was presumed dead.\n\nBut here's the twist: Six months later, she was spotted in Mexico... with a new identity and her debt collector's money.\n\nTurns out, she'd been planning this for a year. Created a fake identity, moved money offshore, even staged the suicide note. She thought she was free.\n\nShe wasn't. Interpol caught her in 2022. Now she's serving 10 years for fraud.\n\nFollow for more unbelievable true crime stories.",
    "source": "Analysis of viral true-crime TikToks + Story by Robert McKee",
    "variations": [
      {
        "name": "Double-Twist Version",
        "description": "Add a second twist before the reveal for extra engagement",
        "example": "Add a beat where viewer thinks they know the answer, then prove them wrong"
      },
      {
        "name": "Mystery Unsolved Version",
        "description": "End with unanswered questions for comment engagement",
        "example": "But one question remains: where is the missing $500K? Comment your theories."
      }
    ]
  }
]
```

---

## JSON СХЕМА

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "array",
  "items": {
    "type": "object",
    "required": ["id", "name", "genre", "best_for_platforms", "beats", "total_duration_range", "difficulty"],
    "properties": {
      "id": {
        "type": "string",
        "pattern": "^structure_[0-9]{3}$"
      },
      "name": {
        "type": "string",
        "minLength": 5,
        "maxLength": 100
      },
      "genre": {
        "type": "string",
        "enum": ["true-crime", "facts", "how-to", "news", "story", "explainer", "review", "comparison", "motivation", "educational", "business", "tech", "mystery", "conspiracy", "transformation", "entertainment", "universal"]
      },
      "best_for_platforms": {
        "type": "array",
        "items": {
          "type": "string",
          "enum": ["tiktok", "reels", "shorts", "youtube", "all"]
        },
        "minItems": 1
      },
      "beats": {
        "type": "array",
        "items": {
          "type": "object",
          "required": ["name", "duration_percent", "purpose", "emotional_goal"],
          "properties": {
            "name": {"type": "string"},
            "duration_percent": {"type": "integer", "minimum": 0, "maximum": 100},
            "duration_seconds": {"type": "integer"},
            "purpose": {"type": "string"},
            "emotional_goal": {"type": "string"},
            "techniques": {
              "type": "array",
              "items": {"type": "string"}
            },
            "examples": {
              "type": "array",
              "items": {"type": "string"}
            }
          }
        },
        "minItems": 3,
        "maxItems": 8
      },
      "total_duration_range": {
        "type": "object",
        "required": ["min_seconds", "max_seconds"],
        "properties": {
          "min_seconds": {"type": "integer", "minimum": 15},
          "max_seconds": {"type": "integer", "maximum": 120}
        }
      },
      "difficulty": {
        "type": "string",
        "enum": ["beginner", "intermediate", "advanced"]
      },
      "retention_score": {
        "type": "integer",
        "minimum": 0,
        "maximum": 100
      },
      "viral_potential": {
        "type": "integer",
        "minimum": 0,
        "maximum": 100
      },
      "when_to_use": {"type": "string"},
      "when_not_to_use": {"type": "string"},
      "full_example": {"type": "string"},
      "source": {"type": "string"},
      "variations": {
        "type": "array",
        "items": {
          "type": "object",
          "properties": {
            "name": {"type": "string"},
            "description": {"type": "string"},
            "example": {"type": "string"}
          }
        }
      }
    }
  }
}
```

---

## ИСТОЧНИКИ ДЛЯ ПОИСКА

### Обязательные книги:
1. **"Save the Cat!"** by Blake Snyder — story beats
2. **"Made to Stick"** by Chip Heath — sticky ideas framework
3. **"Contagious"** by Jonah Berger — STEPPS framework
4. **"Building a StoryBrand"** by Donald Miller — 7-part framework
5. **"Story"** by Robert McKee — story structure masterclass

### YouTube ресурсы:
6. **Paddy Galloway** — https://www.youtube.com/@PaddyGalloway (viral breakdowns)
7. **Colin and Samir** — https://www.youtube.com/@ColinandSamir (creator strategies)
8. **Film Courage** — https://www.youtube.com/@filmcourage (story structure)
9. **Lessons from the Screenplay** — story analysis

### Курсы:
10. **Ali Abdaal** — YouTube scriptwriting course
11. **YouTube Creator Academy** — https://creatoracademy.youtube.com/
12. **Skillshare**: "Writing for TikTok" courses
13. **MasterClass**: storytelling courses (Neil Gaiman, Margaret Atwood)

### Исследования:
14. **Jonah Berger research** — Wharton School papers on virality
15. **Stanford Persuasive Tech Lab** — behavior design
16. **MIT Media Lab** — computational narrative analysis

### Инструменты анализа:
17. **VidIQ** — https://vidiq.com/ (trending analysis)
18. **TubeBuddy** — script templates
19. **TikTok Creative Center** — top ads analysis

---

## КРИТЕРИИ КАЧЕСТВА

### Структура проходит валидацию если:

| Критерий | Требование |
|----------|------------|
| Специфичность | Оптимизирована под конкретный жанр |
| Beats | 3-7 чётких битов с timing |
| Доказательства | Минимум 2 примера вирусных видео |
| Emotional arc | Чёткая эмоциональная кривая |
| Платформа | Адаптирована под специфику платформ |
| Примеры | Конкретные примеры фраз для каждого бита |
| Универсальность | Работает на разных темах внутри жанра |
| Источник | Указан авторитетный источник |

---

## КОЛИЧЕСТВО ЗАПИСЕЙ

| Жанр | Минимум структур |
|------|------------------|
| True-Crime | 2-3 |
| Facts/Science | 2-3 |
| How-To/Tutorial | 2-3 |
| Business/Motivation | 2 |
| Mystery/Conspiracy | 2 |
| Story/POV | 2 |
| Review/Comparison | 2 |
| Educational/Explainer | 2 |
| News | 1 |
| Entertainment | 1-2 |
| Universal (all genres) | 5 |
| Platform-specific | 5 |
| **TOTAL** | **30+** |

---

## ПРИМЕР ГОТОВЫХ ДАННЫХ

```json
[
  {
    "id": "structure_001",
    "name": "Problem-Agitate-Solution (PAS)",
    "genre": "how-to",
    "best_for_platforms": ["tiktok", "reels", "shorts", "youtube"],
    "beats": [
      {
        "name": "Problem",
        "duration_percent": 15,
        "duration_seconds": 9,
        "purpose": "Identify viewer's pain point clearly and specifically",
        "emotional_goal": "recognition + frustration",
        "techniques": ["specificity", "relatable"],
        "examples": [
          "Your AI videos look obviously AI-generated and it's killing your credibility",
          "You're spending 3 hours editing videos when it should take 30 minutes"
        ]
      },
      {
        "name": "Agitate",
        "duration_percent": 25,
        "duration_seconds": 15,
        "purpose": "Make the pain worse, show consequences of not solving it",
        "emotional_goal": "urgency + desire for solution",
        "techniques": ["contrast", "fear"],
        "examples": [
          "Every day you wait, your competitors are posting while you're stuck in editing hell",
          "And it's getting worse - algorithms now penalize obviously AI content"
        ]
      },
      {
        "name": "Solution",
        "duration_percent": 50,
        "duration_seconds": 30,
        "purpose": "Provide step-by-step actionable solution",
        "emotional_goal": "relief + empowerment",
        "techniques": ["specificity", "rule-of-three", "listicle"],
        "examples": [
          "Here's the 5-step system I use...",
          "Step 1: Never use default settings..."
        ]
      },
      {
        "name": "CTA",
        "duration_percent": 10,
        "duration_seconds": 6,
        "purpose": "Drive action and engagement",
        "emotional_goal": "action + commitment",
        "techniques": ["promise", "scarcity"],
        "examples": [
          "Save this now before you forget",
          "Follow for the advanced version tomorrow"
        ]
      }
    ],
    "total_duration_range": {
      "min_seconds": 45,
      "max_seconds": 75
    },
    "difficulty": "beginner",
    "retention_score": 78,
    "viral_potential": 75,
    "when_to_use": "Perfect for how-to and educational content where viewer has a clear problem. Works best when you have a proven solution with specific steps.",
    "when_not_to_use": "Don't use for entertainment or storytelling content. Not ideal when the problem isn't immediately obvious to the viewer.",
    "full_example": "Your resume is getting ignored... and you don't even know why.\n\nHere's the brutal truth: recruiters spend 6 seconds on your resume. If it doesn't pass their scan, you're done. And 95% of resumes fail this test.\n\nEvery job you miss is another month of searching. Another rejection email. Another 'We decided to move forward with other candidates.'\n\nHere's what top performers do differently:\n\nRule 1: Use numbers. Not 'managed team' - 'Led 12-person team to 40% revenue increase.'\n\nRule 2: Kill the objective section. Nobody cares what you want. Lead with impact.\n\nRule 3: One page. If you can't sell yourself in one page, you can't sell anything.\n\nThat's it. Three rules that separate callbacks from crickets.\n\nSave this. Rewrite your resume today.",
    "source": "Classic copywriting PAS framework adapted for short-form video",
    "variations": [
      {
        "name": "Rapid-Fire PAS",
        "description": "Compress each section for ultra-short format (30 sec)",
        "example": "Problem (5s) → Agitate (5s) → Solution rapid list (15s) → CTA (5s)"
      },
      {
        "name": "Story-Based PAS",
        "description": "Use personal story to illustrate problem before revealing solution",
        "example": "Start with 'I used to struggle with X...' then transition to solution"
      }
    ]
  },
  {
    "id": "structure_002",
    "name": "Mystery Box (Open Loop)",
    "genre": "mystery",
    "best_for_platforms": ["tiktok", "shorts", "youtube"],
    "beats": [
      {
        "name": "Mystery Hook",
        "duration_percent": 12,
        "duration_seconds": 7,
        "purpose": "Present impossible question or unexplained phenomenon",
        "emotional_goal": "intense curiosity",
        "techniques": ["open-loop", "specificity", "impossibility"],
        "examples": [
          "This photo was taken in 1995... but the phone in her hand wasn't invented until 2007",
          "NASA found this signal from space... and it repeats every 16 days"
        ]
      },
      {
        "name": "Evidence Build",
        "duration_percent": 30,
        "duration_seconds": 18,
        "purpose": "Present facts that deepen the mystery",
        "emotional_goal": "confusion + investment",
        "techniques": ["specificity", "credibility"],
        "examples": [
          "Scientists analyzed the photo for 10 years...",
          "The signal contains mathematical patterns..."
        ]
      },
      {
        "name": "False Solution",
        "duration_percent": 15,
        "duration_seconds": 9,
        "purpose": "Present obvious explanation that turns out wrong",
        "emotional_goal": "surprise",
        "techniques": ["pattern-interrupt"],
        "examples": [
          "Most people think it's a hoax... but carbon dating proved it's real",
          "At first they thought it was a satellite... until they checked"
        ]
      },
      {
        "name": "Real Explanation",
        "duration_percent": 33,
        "duration_seconds": 20,
        "purpose": "Reveal the actual answer (if known) or deepen mystery (if unsolved)",
        "emotional_goal": "mind-blown OR haunted curiosity",
        "techniques": ["revelation", "callback"],
        "examples": [
          "The truth is even stranger...",
          "To this day, nobody knows..."
        ]
      },
      {
        "name": "CTA",
        "duration_percent": 10,
        "duration_seconds": 6,
        "purpose": "Engagement through question or promise",
        "emotional_goal": "continued engagement",
        "techniques": ["question", "promise"],
        "examples": [
          "What do you think it is? Comment below",
          "Follow for more unexplained mysteries"
        ]
      }
    ],
    "total_duration_range": {
      "min_seconds": 50,
      "max_seconds": 75
    },
    "difficulty": "intermediate",
    "retention_score": 92,
    "viral_potential": 95,
    "when_to_use": "When you have a genuinely mysterious story with either a mind-blowing explanation or an unsolved enigma. Best for content that challenges beliefs.",
    "when_not_to_use": "Don't use if the mystery is weak or easily explainable. Avoid if the payoff isn't satisfying - viewers will feel cheated.",
    "full_example": "This painting from 1860 shows a man holding... an iPhone.\n\nThe painting is called 'The Expected One' by Austrian artist Ferdinand Georg Waldmüller. It's been in a museum for 160 years. And in the background, there's a woman staring at a rectangular object in her hands.\n\nZoom in. It looks exactly like someone scrolling through an iPhone.\n\nSkeptics said it's obviously a prayer book. But here's the problem: the way she's holding it, the posture, the focused gaze - it's identical to someone using a smartphone.\n\nSo what is it really? Art historians analyzed it. The object is a hymnal - a small prayer book common in the 1860s. But here's the mind-blowing part: humans have been doing the exact same gesture for 160 years. We just changed what we're holding.\n\nThe painting didn't predict iPhones. It revealed something deeper: technology changes, but human behavior is eternal.\n\nFollow for more historical mysteries that'll change how you see the world.",
    "source": "Analysis of mystery/conspiracy TikTok + Lost/JJ Abrams mystery box technique",
    "variations": [
      {
        "name": "Unsolved Version",
        "description": "For true unsolved mysteries, end without answer to boost comments",
        "example": "Don't reveal solution - end with 'What do YOU think?' for engagement"
      },
      {
        "name": "Multi-Part Series",
        "description": "Split into 2-3 parts for max engagement",
        "example": "Part 1: Mystery + Evidence, Part 2: False Solution, Part 3: Real Answer"
      }
    ]
  }
]
```
