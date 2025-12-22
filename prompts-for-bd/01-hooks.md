# 01 - HOOKS DATABASE

## Цель базы данных

Хранить **500+ вирусных хуков** (первые 1-3 секунды видео) для использования агентами:
- **Script Agent** — выбирает хук для сценария
- **Hook Agent** — генерирует вариации на основе примеров
- **Quality Agent** — сравнивает хук с лучшими практиками

---

## ПРОМПТ ДЛЯ DEEP RESEARCH

```
Ты — исследователь вирусного контента. Твоя задача — собрать базу данных из 500+ вирусных хуков для коротких видео (TikTok, Reels, Shorts).

### ЧТО ТАКОЕ ХУК

Хук — это первые 1-3 секунды видео, которые:
- Останавливают скролл
- Создают любопытство
- Заставляют досмотреть

### ЧТО СОБИРАТЬ

Для каждого хука собери:

1. **text** — полный текст хука (1-2 предложения)
2. **genre** — жанр контента:
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
   - entertainment
   - business
   - lifestyle
   - tech
   - science

3. **hook_type** — тип хука:
   - curiosity_gap ("What if I told you...")
   - shock ("This is insane...")
   - question ("Did you know...?")
   - pov ("POV: You just...")
   - challenge ("Try this...")
   - controversy ("Unpopular opinion...")
   - story_start ("When I was...")
   - number ("5 things that...")
   - promise ("After this you'll...")
   - fear ("Stop doing this...")
   - secret ("Nobody talks about...")
   - transformation ("Before/After...")

4. **platform** — где работает лучше всего:
   - tiktok
   - reels
   - shorts
   - youtube
   - all

5. **language** — язык (en, ru, es, etc.)

6. **estimated_score** — оценка силы хука (0-100):
   - 90-100: Viral (миллионы просмотров)
   - 70-89: Strong (сотни тысяч)
   - 50-69: Good (десятки тысяч)
   - 30-49: Average
   - 0-29: Weak

7. **source** — откуда взят (URL или описание)

8. **why_works** — почему этот хук работает (1-2 предложения)

### ГДЕ ИСКАТЬ

**TikTok:**
- Вирусные видео в нишах (>1M просмотров)
- Trending sounds с текстовыми оверлеями
- Creators: @mrbeast, @khaby.lame, @bellapoarch

**YouTube:**
- YouTube Shorts trending
- Транскрипты первых 3 секунд вирусных Shorts
- Каналы: MrBeast, MKBHD, Ali Abdaal

**Блоги и ресурсы:**
- copyblogger.com
- neilpatel.com/blog
- hubspot.com/marketing
- Buffer blog
- Hootsuite blog

**Книги:**
- "Hooked" by Nir Eyal
- "Contagious" by Jonah Berger
- "Made to Stick" by Chip Heath

**Анализ:**
- vidiq.com
- socialblade.com
- Sprout Social research

### КРИТЕРИИ КАЧЕСТВА

Хук ХОРОШИЙ если:
✅ Создаёт немедленное любопытство
✅ Понятен за 1 секунду
✅ Специфичен (не generic)
✅ Эмоционально заряжен
✅ Имеет "pattern interrupt"

Хук ПЛОХОЙ если:
❌ Слишком длинный (>15 слов)
❌ Скучный/generic ("Hey guys...")
❌ Нет конкретики
❌ Не создаёт напряжение/любопытство

### КОЛИЧЕСТВО

Собери минимум:
- 50 хуков для каждого из 10 основных жанров = 500 хуков
- Приоритет: true-crime, facts, how-to, news, story

### ФОРМАТ ВЫВОДА

Верни JSON array:

[
  {
    "id": "hook_001",
    "text": "What if I told you that the world's most successful CEO disappeared without a trace... and nobody noticed for 3 months?",
    "genre": "true-crime",
    "hook_type": "curiosity_gap",
    "platform": "all",
    "language": "en",
    "estimated_score": 92,
    "source": "Analysis of viral TikTok true crime content",
    "why_works": "Combines status (CEO), mystery (disappeared), and shocking detail (3 months unnoticed)"
  },
  {
    "id": "hook_002",
    "text": "POV: You just discovered your favorite company is hiding something dark",
    "genre": "true-crime",
    "hook_type": "pov",
    "platform": "tiktok",
    "language": "en",
    "estimated_score": 85,
    "source": "TikTok trending format analysis",
    "why_works": "POV format creates immersion, 'favorite company' makes it personal"
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
    "required": ["id", "text", "genre", "hook_type", "platform", "language", "estimated_score"],
    "properties": {
      "id": {
        "type": "string",
        "pattern": "^hook_[0-9]{3,4}$"
      },
      "text": {
        "type": "string",
        "minLength": 10,
        "maxLength": 300
      },
      "genre": {
        "type": "string",
        "enum": ["true-crime", "facts", "how-to", "news", "story", "pov", "review", "comparison", "motivation", "educational", "entertainment", "business", "lifestyle", "tech", "science"]
      },
      "hook_type": {
        "type": "string",
        "enum": ["curiosity_gap", "shock", "question", "pov", "challenge", "controversy", "story_start", "number", "promise", "fear", "secret", "transformation"]
      },
      "platform": {
        "type": "string",
        "enum": ["tiktok", "reels", "shorts", "youtube", "all"]
      },
      "language": {
        "type": "string",
        "pattern": "^[a-z]{2}$"
      },
      "estimated_score": {
        "type": "integer",
        "minimum": 0,
        "maximum": 100
      },
      "source": {
        "type": "string"
      },
      "why_works": {
        "type": "string"
      }
    }
  }
}
```

---

## ИСТОЧНИКИ ДЛЯ ПОИСКА

### Обязательные:
1. **TikTok Creative Center** — https://ads.tiktok.com/business/creativecenter
2. **YouTube Trending** — https://www.youtube.com/feed/trending?bp=6gQJRkVleHBsb3Jl
3. **Viral content databases** — vidiq.com, socialblade.com

### Рекомендуемые:
4. **Copywriting resources** — copyblogger.com, copyhackers.com
5. **Marketing blogs** — hubspot.com/blog, buffer.com/resources
6. **Academic papers** — "Virality prediction" studies on Google Scholar

### Creators для анализа:
- @mrbeast (entertainment)
- @garyvee (business)
- @alexhormozi (business)
- @hubaborelli (true-crime)
- @5minutecrafts (how-to)
- @dailydoseofinternet (facts)

---

## КРИТЕРИИ КАЧЕСТВА

### Хук проходит валидацию если:

| Критерий | Требование |
|----------|------------|
| Длина | 5-25 слов |
| Конкретика | Есть числа, имена, детали |
| Эмоция | Вызывает curiosity/shock/fear/excitement |
| Уникальность | Не generic фраза |
| Применимость | Можно адаптировать под разные темы |

### Scoring guide:

- **90-100**: Доказанный viral хук (видео >1M просмотров)
- **70-89**: Сильный паттерн из успешного контента
- **50-69**: Рабочий хук из проверенных источников
- **30-49**: Теоретически хороший, но не проверен
- **0-29**: Слабый или generic

---

## КОЛИЧЕСТВО ЗАПИСЕЙ

| Жанр | Минимум | Идеально |
|------|---------|----------|
| true-crime | 50 | 100 |
| facts | 50 | 100 |
| how-to | 50 | 80 |
| news | 40 | 60 |
| story | 40 | 60 |
| pov | 30 | 50 |
| business | 30 | 50 |
| tech | 30 | 50 |
| motivation | 30 | 40 |
| other genres | 150 | 200 |
| **TOTAL** | **500** | **790** |

---

## ПРИМЕР ГОТОВЫХ ДАННЫХ

```json
[
  {
    "id": "hook_001",
    "text": "What if I told you that the world's most successful CEO disappeared without a trace?",
    "genre": "true-crime",
    "hook_type": "curiosity_gap",
    "platform": "all",
    "language": "en",
    "estimated_score": 92,
    "source": "Pattern from viral true crime TikToks",
    "why_works": "Classic curiosity gap + high status subject + mystery element"
  },
  {
    "id": "hook_002",
    "text": "Scientists just discovered something that changes everything we know about sleep",
    "genre": "science",
    "hook_type": "shock",
    "platform": "all",
    "language": "en",
    "estimated_score": 88,
    "source": "YouTube Shorts science channels analysis",
    "why_works": "Authority (scientists) + recency (just) + universal topic (sleep) + big claim"
  },
  {
    "id": "hook_003",
    "text": "I made $50,000 in one month using this strategy nobody talks about",
    "genre": "business",
    "hook_type": "secret",
    "platform": "tiktok",
    "language": "en",
    "estimated_score": 85,
    "source": "Business TikTok analysis",
    "why_works": "Specific number + timeframe + exclusivity (nobody talks about)"
  },
  {
    "id": "hook_004",
    "text": "POV: You're the only one who knows the truth about your best friend",
    "genre": "story",
    "hook_type": "pov",
    "platform": "tiktok",
    "language": "en",
    "estimated_score": 82,
    "source": "TikTok POV trend analysis",
    "why_works": "Immersive POV + relatable scenario + hidden tension"
  },
  {
    "id": "hook_005",
    "text": "Stop using ChatGPT like this — you're wasting 90% of its potential",
    "genre": "tech",
    "hook_type": "fear",
    "platform": "all",
    "language": "en",
    "estimated_score": 90,
    "source": "Tech content viral analysis",
    "why_works": "Trending topic + fear of missing out + specific metric (90%)"
  }
]
```
