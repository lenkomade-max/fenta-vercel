# 02 - SCRIPTS DATABASE

## Цель базы данных

Хранить **300+ примеров готовых сценариев** вирусных коротких видео для использования агентами:
- **Script Agent** — обучается на структуре и стиле успешных сценариев
- **Rewrite Agent** — адаптирует сценарии под новые темы
- **Quality Agent** — сравнивает сгенерированные сценарии с proven examples

---

## ПРОМПТ ДЛЯ DEEP RESEARCH

```
Ты — исследователь контента коротких видео. Твоя задача — собрать базу данных из 300+ готовых сценариев вирусных видео (TikTok, Reels, Shorts, YouTube).

### ЧТО ТАКОЕ СЦЕНАРИЙ

Сценарий короткого видео — это полный текст закадрового голоса (voiceover) длиной 30-90 секунд, который:
- Имеет чёткую структуру (Hook → Build → Payoff → CTA)
- Написан для устного произнесения
- Оптимизирован под retention (удержание внимания)
- Доказал свою эффективность (>100K просмотров)

### ЧТО СОБИРАТЬ

Для каждого сценария собери:

1. **id** — уникальный ID (script_001, script_002...)

2. **title** — короткое название/тема (например: "Why Elon Musk sold all his houses")

3. **full_text** — полный текст сценария (100-300 слов)
   - Разбитый на логические блоки
   - Без визуальных описаний (только то что произносится)
   - Включая паузы [pause] если критично

4. **genre** — жанр контента:
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
   - entertainment
   - business
   - lifestyle
   - tech
   - science
   - conspiracy
   - mystery

5. **structure** — использованная структура:
   - hook-context-twist-reveal-cta
   - problem-agitate-solve
   - chronological-story
   - listicle
   - comparison
   - question-answer
   - myth-busting
   - transformation

6. **duration_seconds** — длина в секундах (30-90)

7. **platform** — где опубликовано:
   - tiktok
   - reels
   - shorts
   - youtube

8. **language** — язык (en, ru, es, etc.)

9. **view_count** — количество просмотров (если известно)

10. **engagement_rate** — примерный engagement % (если известно)

11. **source** — откуда взят сценарий (URL канала или "transcribed from viral video")

12. **voice_style** — стиль голоса:
    - conversational
    - narrator
    - enthusiastic
    - serious
    - mystery
    - educational
    - storytelling

13. **pacing** — темп речи:
    - fast (170-200 WPM)
    - medium (140-170 WPM)
    - slow (100-140 WPM)

14. **key_techniques** — использованные техники (array):
    - open-loop (незакрытая интрига)
    - callback (отсылка к началу)
    - cliffhanger
    - pattern-interrupt
    - rule-of-three
    - contrast
    - repetition
    - specificity (конкретные цифры/детали)

15. **why_works** — почему этот сценарий работает (2-3 предложения анализа)

### ГДЕ ИСКАТЬ

**TikTok:**
- Вирусные видео с закадровым голосом (>500K просмотров)
- Creators: @daily.dose.of.internet, @zackdfilms, @mrbeast
- Хэштеги: #storytime #funfact #todayilearned #mindblowing
- TikTok Creative Center → Top Ads

**YouTube Shorts:**
- Trending shorts с voiceover
- Каналы: MrBeast, Vsauce, Veritasium, MKBHD
- Транскрипты через YouTube API или yt-dlp
- Shorts с >1M просмотров в нишах

**Instagram Reels:**
- Top performing Reels в нишах
- Creators: @natgeo, @theskimm, @garyvee
- Business accounts с высоким engagement

**Инструменты для транскрипции:**
- YouTube auto-transcripts
- Whisper AI (openai/whisper)
- Descript
- Rev.com

**Анализ и базы:**
- vidiq.com — trending scripts
- tubebuddy.com — script analysis
- Social Blade — top channels
- Reddit: r/VideoEditing, r/NewTubers

**Курсы и ресурсы:**
- Ali Abdaal's YouTube scriptwriting course
- Paddy Galloway's viral script breakdowns
- Colin and Samir podcast transcripts
- MrBeast leaked production docs

### КРИТЕРИИ КАЧЕСТВА

Сценарий ХОРОШИЙ если:
✅ Имеет сильный hook в первых 3 секундах
✅ Удерживает внимание (нет "провисаний")
✅ Использует конкретные детали (числа, имена, даты)
✅ Написан в разговорном стиле (для устного произнесения)
✅ Имеет чёткий payoff/развязку
✅ Доказанная эффективность (>100K просмотров)
✅ Логичная структура без "мусорных" слов

Сценарий ПЛОХОЙ если:
❌ Слишком длинный (>120 секунд) или короткий (<20 секунд)
❌ Нет чёткого hook
❌ Generic фразы без конкретики
❌ Сложные предложения (hard to speak)
❌ Скучный/предсказуемый
❌ Нет источника/доказательств эффективности

### ПРИОРИТЕТЫ СБОРА

По жанрам (минимум):
- Facts/Science: 50 сценариев
- True-Crime/Mystery: 40 сценариев
- How-to/Educational: 40 сценариев
- Business/Motivation: 30 сценариев
- Tech/Reviews: 30 сценариев
- Entertainment/Story: 30 сценариев
- News/Explainer: 30 сценариев
- Other genres: 50 сценариев

По платформам:
- TikTok: 100 сценариев
- YouTube Shorts: 100 сценариев
- Instagram Reels: 60 сценариев
- Mixed/All: 40 сценариев

### ФОРМАТ ВЫВОДА

Верни JSON array:

[
  {
    "id": "script_001",
    "title": "Why Elon Musk sold all his houses",
    "full_text": "What if I told you that the richest man in the world decided to sell every single house he owned... and now lives in a $50,000 box?\n\nIn 2020, Elon Musk made a shocking announcement: he was selling all his properties. Seven mansions worth over $100 million. Gone.\n\nBut why? Most billionaires collect houses like Pokemon cards. But Elon realized something: possessions own YOU. Every house needs maintenance, taxes, security. It was draining his focus.\n\nSo he moved into a 375 square foot prefab house in Texas. It costs less than a Tesla.\n\nThe lesson? Freedom isn't about what you have. It's about what you're willing to let go.\n\nFollow for more mindset shifts that'll change how you see success.",
    "genre": "business",
    "structure": "hook-context-twist-reveal-cta",
    "duration_seconds": 52,
    "platform": "tiktok",
    "language": "en",
    "view_count": 2300000,
    "engagement_rate": 8.5,
    "source": "Transcribed from viral TikTok business content",
    "voice_style": "conversational",
    "pacing": "medium",
    "key_techniques": ["open-loop", "specificity", "contrast", "callback"],
    "why_works": "Strong curiosity hook with specific numbers, uses contrast (richest man/tiny house), builds tension through question, delivers satisfying philosophical payoff. Numbers are specific and verifiable."
  },
  {
    "id": "script_002",
    "title": "The Voynich Manuscript mystery",
    "full_text": "This book has been studied for 600 years... and nobody knows what it says.\n\nThe Voynich Manuscript. 240 pages of unknown symbols, strange plants that don't exist, and diagrams that make no sense.\n\nCryptographers, linguists, even AI tried to decode it. All failed.\n\nHere's what we know: It was carbon-dated to the 1400s. The illustrations show plants and constellations that don't match anything on Earth. The text follows patterns of real language... but it's not any language we've ever seen.\n\nSome think it's an elaborate hoax. Others believe it's an alien artifact or lost civilization's knowledge.\n\nThe truth? After 600 years, we're no closer to solving it than when it was discovered.\n\nIf you could read one page of this book, would you?",
    "genre": "mystery",
    "structure": "hook-context-twist-reveal-cta",
    "duration_seconds": 58,
    "platform": "shorts",
    "language": "en",
    "view_count": 1800000,
    "engagement_rate": 9.2,
    "source": "YouTube Shorts mystery channel analysis",
    "voice_style": "mystery",
    "pacing": "medium",
    "key_techniques": ["open-loop", "specificity", "pattern-interrupt", "rule-of-three"],
    "why_works": "Immediately establishes impossible mystery, uses specific numbers (600 years, 240 pages), builds credibility with expert attempts, ends with engagement question. Mystery genre performs well."
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
    "required": ["id", "title", "full_text", "genre", "structure", "duration_seconds", "platform", "language"],
    "properties": {
      "id": {
        "type": "string",
        "pattern": "^script_[0-9]{3,4}$"
      },
      "title": {
        "type": "string",
        "minLength": 5,
        "maxLength": 100
      },
      "full_text": {
        "type": "string",
        "minLength": 100,
        "maxLength": 2000
      },
      "genre": {
        "type": "string",
        "enum": ["true-crime", "facts", "how-to", "news", "story", "explainer", "review", "comparison", "motivation", "educational", "entertainment", "business", "lifestyle", "tech", "science", "conspiracy", "mystery"]
      },
      "structure": {
        "type": "string",
        "enum": ["hook-context-twist-reveal-cta", "problem-agitate-solve", "chronological-story", "listicle", "comparison", "question-answer", "myth-busting", "transformation"]
      },
      "duration_seconds": {
        "type": "integer",
        "minimum": 20,
        "maximum": 120
      },
      "platform": {
        "type": "string",
        "enum": ["tiktok", "reels", "shorts", "youtube", "all"]
      },
      "language": {
        "type": "string",
        "pattern": "^[a-z]{2}$"
      },
      "view_count": {
        "type": "integer",
        "minimum": 0
      },
      "engagement_rate": {
        "type": "number",
        "minimum": 0,
        "maximum": 100
      },
      "source": {
        "type": "string"
      },
      "voice_style": {
        "type": "string",
        "enum": ["conversational", "narrator", "enthusiastic", "serious", "mystery", "educational", "storytelling"]
      },
      "pacing": {
        "type": "string",
        "enum": ["fast", "medium", "slow"]
      },
      "key_techniques": {
        "type": "array",
        "items": {
          "type": "string",
          "enum": ["open-loop", "callback", "cliffhanger", "pattern-interrupt", "rule-of-three", "contrast", "repetition", "specificity"]
        }
      },
      "why_works": {
        "type": "string",
        "minLength": 50,
        "maxLength": 500
      }
    }
  }
}
```

---

## ИСТОЧНИКИ ДЛЯ ПОИСКА

### Обязательные:
1. **TikTok Creative Center** — https://ads.tiktok.com/business/creativecenter/inspiration/topads
2. **YouTube Trending Shorts** — https://www.youtube.com/shorts
3. **VidIQ** — https://vidiq.com/youtube-stats/top-youtube-shorts/
4. **Social Blade** — https://socialblade.com/youtube/trending/videos

### Рекомендуемые каналы:

**Facts/Science:**
- Vsauce (YouTube)
- Veritasium (YouTube)
- @daily.dose.of.internet (TikTok)
- @zackdfilms (TikTok)

**True-Crime:**
- @hubaborelli (TikTok)
- @truecrimebryant (TikTok)
- Bailey Sarian (YouTube)

**Business/Motivation:**
- @garyvee (Instagram/TikTok)
- @alexhormozi (Instagram)
- Ali Abdaal (YouTube)

**Tech:**
- MKBHD (YouTube Shorts)
- Linus Tech Tips (YouTube Shorts)
- @techcheck (TikTok)

**Educational:**
- TED-Ed (YouTube)
- CrashCourse (YouTube)
- @scienceirl (TikTok)

### Инструменты:
5. **Whisper AI** — https://github.com/openai/whisper (транскрипция)
6. **Descript** — https://www.descript.com/ (транскрипция)
7. **TubeBuddy** — https://www.tubebuddy.com/

### Аналитика:
8. **Paddy Galloway** — https://www.youtube.com/@PaddyGalloway (разборы вирусных видео)
9. **Colin and Samir** — https://www.youtube.com/@ColinandSamir (podcast с creators)
10. **Creator Wizard** — https://creatorwizard.com/

---

## КРИТЕРИИ КАЧЕСТВА

### Сценарий проходит валидацию если:

| Критерий | Требование |
|----------|------------|
| Длина | 100-300 слов (30-90 секунд) |
| Hook | Первые 3 секунды создают curiosity |
| Структура | Чёткие блоки (Hook → Build → Payoff) |
| Конкретика | Минимум 3 конкретных факта/числа |
| Читаемость | Написано для устного произнесения |
| Retention | Нет скучных моментов, постоянное напряжение |
| Источник | Видео имеет >100K просмотров |
| CTA | Чёткий call-to-action в конце |

### Scoring guide:

- **>1M просмотров**: Top-tier script, приоритет для сбора
- **500K-1M**: Strong performer
- **100K-500K**: Proven good
- **<100K**: Только если уникальный жанр/подход

---

## КОЛИЧЕСТВО ЗАПИСЕЙ

| Жанр | Минимум | Идеально |
|------|---------|----------|
| Facts/Science | 50 | 70 |
| True-Crime/Mystery | 40 | 60 |
| How-to/Educational | 40 | 60 |
| Business/Motivation | 30 | 50 |
| Tech/Reviews | 30 | 40 |
| Entertainment/Story | 30 | 40 |
| News/Explainer | 30 | 40 |
| Other genres | 50 | 80 |
| **TOTAL** | **300** | **440** |

---

## ПРИМЕР ГОТОВЫХ ДАННЫХ

```json
[
  {
    "id": "script_001",
    "title": "Why airports use carpet",
    "full_text": "Ever wondered why airports spend millions on ugly carpet?\n\nTurns out, it's genius.\n\nFirst: noise. With thousands of people dragging suitcases, carpet absorbs 70% more sound than tile. Less chaos, less stress.\n\nSecond: safety. When you're rushing to catch a flight, carpet provides better traction. Fewer slips, fewer lawsuits.\n\nThird: wayfinding. Airports use carpet patterns to guide you. Different colors for different terminals. You're being subconsciously directed.\n\nBut here's the crazy part: that 'ugly' design is intentional. Busy patterns hide stains and wear. One airport calculated they save $2 million per year on cleaning.\n\nSo next time you're judging airport carpet, remember: you're walking on millions of dollars of psychology and engineering.\n\nFollow for more hidden design secrets.",
    "genre": "facts",
    "structure": "question-answer",
    "duration_seconds": 48,
    "platform": "shorts",
    "language": "en",
    "view_count": 3200000,
    "engagement_rate": 12.3,
    "source": "YouTube Shorts design channel",
    "voice_style": "conversational",
    "pacing": "medium",
    "key_techniques": ["specificity", "rule-of-three", "pattern-interrupt", "callback"],
    "why_works": "Relatable hook (everyone has seen airport carpet), uses rule of three for reasons, specific numbers build credibility, mind-blown payoff with cost savings"
  },
  {
    "id": "script_002",
    "title": "The craziest prison escape ever",
    "full_text": "In 2015, two inmates escaped from maximum security... using power tools they got from a prison employee they seduced.\n\nRichard Matt and David Sweat. Both killers. Both in for life. Both shouldn't have been able to escape.\n\nThey befriended Joyce Mitchell, a prison employee. She smuggled them hacksaw blades hidden in frozen meat. For months, they cut through steel walls at night.\n\nThey left decoy heads in their beds made of papier-mâché. Then crawled through tunnels, broke through a wall, and disappeared.\n\nThe manhunt involved 1,300 officers. It lasted three weeks. Finally, Matt was shot and killed. Sweat was captured near the Canadian border.\n\nJoyce? She got 7 years for helping them. She said she was in love.\n\nThe cost of the escape? $23 million.\n\nCraziest part? This happened in 2015, not the 1800s.\n\nFollow for more insane true crime stories.",
    "genre": "true-crime",
    "structure": "hook-context-twist-reveal-cta",
    "duration_seconds": 67,
    "platform": "tiktok",
    "language": "en",
    "view_count": 5600000,
    "engagement_rate": 14.8,
    "source": "TikTok true crime creator analysis",
    "voice_style": "narrator",
    "pacing": "fast",
    "key_techniques": ["open-loop", "specificity", "contrast", "pattern-interrupt"],
    "why_works": "Shocking hook with specific details, chronological storytelling builds tension, multiple payoffs (cost, date), strong specificity throughout (names, numbers, timeline)"
  },
  {
    "id": "script_003",
    "title": "How to make AI videos that don't look AI",
    "full_text": "Stop making AI videos that scream 'I used AI.'\n\nHere's what pros do differently:\n\nRule 1: Never use default settings. Everyone uses them. Your video looks like everyone else's. Customize every parameter.\n\nRule 2: Layer multiple AI tools. Use Runway for motion, Topaz for upscaling, After Effects for compositing. Single-tool videos look flat.\n\nRule 3: Add imperfections. Real cameras have grain, slight motion blur, lens distortion. AI is too perfect. Make it slightly worse.\n\nRule 4: Manual color grading. AI color is always too saturated. Use DaVinci Resolve. Pull back saturation by 20%.\n\nRule 5: Sound design is 50% of believability. Bad audio ruins perfect visuals. Layer ambient sound, foley, and music.\n\nBonus: Add subtle camera shake. Lock-steady shots look fake. 1-2 pixels of movement sells reality.\n\nThat's it. Five rules that separate amateurs from pros.\n\nSave this. You'll need it.",
    "genre": "how-to",
    "structure": "problem-agitate-solve",
    "duration_seconds": 58,
    "platform": "reels",
    "language": "en",
    "view_count": 890000,
    "engagement_rate": 11.2,
    "source": "Instagram Reels AI creator",
    "voice_style": "educational",
    "pacing": "medium",
    "key_techniques": ["rule-of-three", "specificity", "contrast", "repetition"],
    "why_works": "Identifies common problem, provides actionable numbered steps, uses specific tool names and percentages, strong CTA to save, listicle structure is retention-friendly"
  }
]
```
