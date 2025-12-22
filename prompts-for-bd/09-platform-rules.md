# 09 - PLATFORM RULES DATABASE

## Цель базы данных

Хранить **детальные правила 4 платформ** (TikTok, Instagram Reels, YouTube Shorts, YouTube) для использования агентами:
- **Все агенты** — адаптируют контент под специфику платформы
- **Orchestrator** — выбирает оптимальную платформу для задачи
- **Quality Agent** — проверяет соответствие контента требованиям платформы

---

## ПРОМПТ ДЛЯ DEEP RESEARCH

```
Ты — платформенный стратег для контента. Твоя задача — создать детальную базу данных правил, best practices и алгоритмических фишек для 4 основных платформ: TikTok, Instagram Reels, YouTube Shorts, YouTube.

### ЧТО ТАКОЕ ПЛАТФОРМЕННЫЕ ПРАВИЛА

Платформенные правила — это набор технических требований, алгоритмических особенностей и best practices, которые определяют:
- Технические спецификации (aspect ratio, duration, file size)
- Алгоритмические предпочтения (что платформа продвигает)
- Формат контента (hooks, captions, hashtags)
- Оптимизацию под аудиторию платформы
- Запрещенные практики и ограничения

Контент идеальный для TikTok может полностью провалиться на YouTube и наоборот.

### ЧТО СОБИРАТЬ

Для каждой платформы собери:

1. **id** — уникальный ID (platform_rule_001...)

2. **platform** — платформа (enum):
   - tiktok
   - instagram_reels
   - youtube_shorts
   - youtube
   - all (универсальные правила)

3. **technical_specs** — технические требования (object):
   - **aspect_ratio** — рекомендуемые соотношения (array: ["9:16", "1:1"])
   - **optimal_aspect** — оптимальное (string: "9:16")
   - **duration** — длительность (object):
     - **min_seconds** — минимум (integer)
     - **max_seconds** — максимум (integer)
     - **optimal_seconds** — оптимально (integer)
     - **sweet_spot** — самый вирусный диапазон (string: "15-30s")
   - **resolution** — разрешение (object):
     - **min** — минимум (string: "720p")
     - **recommended** — рекомендуемое (string: "1080p")
     - **max** — максимум (string: "4K")
   - **file_size** — размер файла (object):
     - **max_mb** — максимум в MB (integer)
     - **recommended_mb** — рекомендуемый (integer)
   - **framerate** — FPS (array: [24, 30, 60])
   - **codec** — рекомендуемые кодеки (array: ["H.264", "H.265"])

4. **content_format** — формат контента (object):
   - **hook_timing** — когда должен быть хук (object):
     - **critical_seconds** — критические секунды (integer: 3)
     - **why** — почему (string)
   - **caption_rules** — правила подписей (object):
     - **max_length** — максимальная длина (integer)
     - **optimal_length** — оптимальная (integer)
     - **best_practices** — рекомендации (array of strings)
   - **hashtag_strategy** — стратегия хештегов (object):
     - **min_count** — минимум (integer)
     - **max_count** — максимум (integer)
     - **optimal_count** — оптимально (integer)
     - **types** — типы хештегов (array: ["trending", "niche", "branded"])
     - **placement** — где размещать (string)
   - **text_overlay** — текстовые оверлеи (object):
     - **recommended** — рекомендуется? (boolean)
     - **max_words_on_screen** — макс слов на экране (integer)
     - **font_size_guidance** — рекомендации по размеру (string)
   - **music_requirements** — требования к музыке (object):
     - **recommended** — рекомендуется? (boolean)
     - **trending_boost** — буст от трендовой музыки (string: "+40% reach")
     - **library** — библиотека музыки (string: "platform library")

5. **algorithm_preferences** — что продвигает алгоритм (object):
   - **ranking_factors** — факторы ранжирования (array of objects):
     - **factor** — фактор (string: "watch time")
     - **weight** — вес (enum: "critical", "high", "medium", "low")
     - **description** — описание (string)
   - **engagement_signals** — сигналы вовлечения (array of strings):
     - likes, comments, shares, saves, etc.
   - **negative_signals** — негативные сигналы (array of strings):
     - skips, reports, "not interested", etc.
   - **boost_mechanisms** — механизмы буста (array of objects):
     - **mechanism** — механизм (string: "For You Page")
     - **how_to_trigger** — как попасть (string)
   - **content_preferences** — что алгоритм любит (array of strings)
   - **content_penalties** — что алгоритм наказывает (array of strings)

6. **audience_characteristics** — характеристики аудитории (object):
   - **primary_age_range** — основной возраст (string: "18-24")
   - **gender_split** — распределение по полу (string: "60% female")
   - **peak_activity_times** — пик активности (array of strings):
     - ["7-9 AM EST", "6-10 PM EST"]
   - **content_consumption_behavior** — поведение (object):
     - **avg_session_length** — средняя сессия (string: "52 minutes")
     - **videos_per_session** — видео за сессию (integer)
     - **skip_rate** — процент пропусков (string: "45%")
   - **trending_genres** — трендовые жанры на платформе (array)

7. **optimization_tips** — советы по оптимизации (array of objects):
   - **category** — категория (string: "retention")
   - **tip** — совет (string)
   - **impact** — влияние (enum: "critical", "high", "medium", "low")
   - **evidence** — доказательство (string)

8. **posting_strategy** — стратегия публикации (object):
   - **optimal_frequency** — оптимальная частота (string: "1-3 times per day")
   - **best_times** — лучшее время (array of strings)
   - **consistency_importance** — важность регулярности (enum: "critical", "high", "medium", "low")

9. **monetization** — монетизация (object):
   - **requirements** — требования (array of strings)
   - **revenue_mechanisms** — механизмы дохода (array of strings)
   - **avg_rpm** — средний RPM (string: "$0.01-0.03")

10. **prohibited_content** — запрещенный контент (object):
    - **hard_bans** — жесткие баны (array: ["violence", "nudity"])
    - **soft_limits** — мягкие ограничения (array: ["political content"])
    - **shadowban_triggers** — триггеры шэдоубана (array)

11. **unique_features** — уникальные фишки платформы (array of objects):
    - **feature** — фича (string: "Duet")
    - **how_to_leverage** — как использовать (string)
    - **virality_potential** — вирусный потенциал (string: "high")

12. **cross_platform_strategy** — стратегия кросс-постинга (object):
    - **repost_same_content** — можно ли репостить (boolean)
    - **adaptation_required** — нужна адаптация (array of strings)
    - **watermark_penalty** — штраф за водяной знак (string)

13. **success_metrics** — метрики успеха (object):
    - **good_performance** — хороший результат (object)
    - **viral_threshold** — порог вирусности (object)

14. **source** — источник данных (string)

15. **last_updated** — дата обновления (string: "2025-01")

16. **notes** — важные заметки (string)

### ГДЕ ИСКАТЬ

**Официальные ресурсы:**
- TikTok Creator Portal — https://www.tiktok.com/creators/
- TikTok Creative Center — https://ads.tiktok.com/business/creativecenter
- Instagram Creators — https://creators.instagram.com/
- YouTube Creator Academy — https://creatoracademy.youtube.com/
- YouTube Shorts Best Practices — official guides
- Meta Business Suite — Reels insights

**Creator insights:**
- Paddy Galloway — YouTube algorithm analysis
- Colin and Samir — platform strategies
- vidIQ — platform analytics and guides
- TubeBuddy — YouTube optimization
- Later blog — Instagram best practices
- Hootsuite — social media guides

**Исследования и данные:**
- Sprout Social — platform research
- Buffer blog — social media data
- Socialblade — platform analytics
- Influencer Marketing Hub — platform stats
- HubSpot research — social media trends

**Insider knowledge:**
- Reddit r/TikTokCreators, r/InstagramCreators, r/YouTubeCreators
- Twitter from platform employees
- Creator Discord servers
- Conference talks (VidCon, Social Media Marketing World)

**Testing and analysis:**
- Analyze top 100 videos per platform
- Document what works vs what doesn't
- Track algorithm updates
- Monitor policy changes

### КРИТЕРИИ КАЧЕСТВА

Платформенное правило ХОРОШЕЕ если:
✅ Основано на официальных источниках
✅ Подкреплено данными и примерами
✅ Учитывает последние изменения алгоритма
✅ Содержит конкретные числа и метрики
✅ Включает практические советы
✅ Описывает уникальные фишки платформы
✅ Актуально (обновлено в последние 3 месяца)

Платформенное правило ПЛОХОЕ если:
❌ Устаревшая информация (>6 месяцев)
❌ Generic советы без специфики платформы
❌ Нет конкретных цифр
❌ Основано на слухах, не фактах
❌ Игнорирует последние изменения
❌ Нет источников

### КОЛИЧЕСТВО

Собери:
- 4 основные платформы (детальные правила)
- 10+ универсальных правил (работают везде)
- 20+ optimization tips на платформу
- 5+ unique features на платформу

Приоритет:
1. TikTok (самая важная для short-form)
2. Instagram Reels
3. YouTube Shorts
4. YouTube (long-form)

### ФОРМАТ ВЫВОДА

Верни JSON array:

[
  {
    "id": "platform_rule_001",
    "platform": "tiktok",
    "technical_specs": {
      "aspect_ratio": ["9:16", "1:1"],
      "optimal_aspect": "9:16",
      "duration": {
        "min_seconds": 3,
        "max_seconds": 180,
        "optimal_seconds": 30,
        "sweet_spot": "15-30s for maximum virality"
      },
      "resolution": {
        "min": "720p",
        "recommended": "1080p",
        "max": "4K"
      },
      "file_size": {
        "max_mb": 287,
        "recommended_mb": 100
      },
      "framerate": [24, 30, 60],
      "codec": ["H.264", "H.265"]
    },
    "content_format": {
      "hook_timing": {
        "critical_seconds": 1,
        "why": "TikTok users decide to skip within 1-2 seconds. Hook must be immediate."
      },
      "caption_rules": {
        "max_length": 2200,
        "optimal_length": 150,
        "best_practices": [
          "First line is critical - shows in feed",
          "Use line breaks for readability",
          "Include CTA at the end",
          "Ask questions to boost comments"
        ]
      },
      "hashtag_strategy": {
        "min_count": 3,
        "max_count": 5,
        "optimal_count": 4,
        "types": ["trending", "niche", "content-specific"],
        "placement": "End of caption, not beginning"
      },
      "text_overlay": {
        "recommended": true,
        "max_words_on_screen": 8,
        "font_size_guidance": "Large enough to read on mobile without zooming"
      },
      "music_requirements": {
        "recommended": true,
        "trending_boost": "+40% reach with trending sounds",
        "library": "TikTok Sound Library or original audio"
      }
    },
    "algorithm_preferences": {
      "ranking_factors": [
        {
          "factor": "Watch time / Completion rate",
          "weight": "critical",
          "description": "Users who watch to the end = strong signal"
        },
        {
          "factor": "Re-watches",
          "weight": "critical",
          "description": "Users rewatching = extremely strong signal"
        },
        {
          "factor": "Shares",
          "weight": "high",
          "description": "Shares count more than likes"
        },
        {
          "factor": "Comments",
          "weight": "high",
          "description": "Comment quality matters, not just quantity"
        },
        {
          "factor": "Likes",
          "weight": "medium",
          "description": "Weakest engagement signal"
        }
      ],
      "engagement_signals": [
        "completion rate",
        "re-watches",
        "shares",
        "comments",
        "likes",
        "follows from video",
        "profile visits",
        "saves"
      ],
      "negative_signals": [
        "skip within 2 seconds",
        "swipe away",
        "not interested",
        "report",
        "hide",
        "unfollow after video"
      ],
      "boost_mechanisms": [
        {
          "mechanism": "For You Page (FYP)",
          "how_to_trigger": "High engagement in first 1 hour from initial test audience (300-500 users)"
        },
        {
          "mechanism": "Second wave push",
          "how_to_trigger": "If first wave performs well, algorithm pushes to larger audience"
        }
      ],
      "content_preferences": [
        "Original content (not reposts)",
        "Trending sounds",
        "High watch time",
        "Native uploads (not cross-posted with watermarks)",
        "Participates in trends",
        "Consistent posting schedule"
      ],
      "content_penalties": [
        "Watermarks from other platforms",
        "Low-quality video (blurry, pixelated)",
        "Recycled content",
        "Clickbait that doesn't deliver",
        "Excessive self-promotion",
        "Asking for follows/likes explicitly"
      ]
    },
    "audience_characteristics": {
      "primary_age_range": "18-24 (largest segment)",
      "gender_split": "61% female, 39% male",
      "peak_activity_times": [
        "7-9 AM EST (before work/school)",
        "12-1 PM EST (lunch)",
        "7-11 PM EST (evening peak)"
      ],
      "content_consumption_behavior": {
        "avg_session_length": "52 minutes per day",
        "videos_per_session": 100,
        "skip_rate": "Within 2 seconds if not hooked"
      },
      "trending_genres": [
        "true-crime",
        "pov",
        "story-time",
        "comedy",
        "facts",
        "transformation",
        "how-to"
      ]
    },
    "optimization_tips": [
      {
        "category": "retention",
        "tip": "Loop your video - make the end connect to beginning for re-watches",
        "impact": "critical",
        "evidence": "Looping videos get 3x more re-watches"
      },
      {
        "category": "hook",
        "tip": "Use text overlay for hook even if you have voiceover - many watch without sound initially",
        "impact": "high",
        "evidence": "Videos with text hooks get 25% higher retention"
      },
      {
        "category": "timing",
        "tip": "Post during peak hours but test your specific audience",
        "impact": "medium",
        "evidence": "Peak hours give +30% initial reach"
      }
    ],
    "posting_strategy": {
      "optimal_frequency": "1-3 times per day",
      "best_times": ["7-9 AM EST", "6-10 PM EST"],
      "consistency_importance": "high"
    },
    "monetization": {
      "requirements": [
        "10,000 followers",
        "100,000 video views in last 30 days",
        "18+ years old",
        "Comply with Community Guidelines"
      ],
      "revenue_mechanisms": [
        "Creator Fund",
        "TikTok Shop",
        "LIVE Gifts",
        "Brand partnerships"
      ],
      "avg_rpm": "$0.01-0.03 (Creator Fund is low)"
    },
    "prohibited_content": {
      "hard_bans": [
        "Nudity/sexual content",
        "Violence/gore",
        "Hate speech",
        "Dangerous acts/challenges",
        "Misinformation"
      ],
      "soft_limits": [
        "Political content (limited reach)",
        "Controversial topics",
        "Excessive profanity"
      ],
      "shadowban_triggers": [
        "Multiple community guideline violations",
        "Posting copyrighted music/content",
        "Sudden change in content type",
        "Suspicious engagement (bots)"
      ]
    },
    "unique_features": [
      {
        "feature": "Duet / Stitch",
        "how_to_leverage": "Enable duets/stitches on viral videos to multiply reach",
        "virality_potential": "high"
      },
      {
        "feature": "Trending sounds",
        "how_to_leverage": "Use sounds in first 24 hours of trending for maximum boost",
        "virality_potential": "very high"
      },
      {
        "feature": "Series / Playlists",
        "how_to_leverage": "Create multi-part content to increase follow rate",
        "virality_potential": "medium"
      }
    ],
    "cross_platform_strategy": {
      "repost_same_content": false,
      "adaptation_required": [
        "Remove watermarks from other platforms",
        "Re-edit for TikTok pacing (faster)",
        "Add trending sounds",
        "Optimize for 9:16"
      ],
      "watermark_penalty": "Severe - algorithm heavily suppresses videos with Instagram/YouTube watermarks"
    },
    "success_metrics": {
      "good_performance": {
        "views": "10,000+ in first 24h for small accounts",
        "engagement_rate": "8-12%",
        "watch_time": "60%+ completion"
      },
      "viral_threshold": {
        "views": "1M+ views",
        "shares": "10,000+",
        "completion_rate": "80%+"
      }
    },
    "source": "TikTok Creator Portal + analysis of 500+ viral TikToks + creator insights",
    "last_updated": "2025-01",
    "notes": "TikTok algorithm changes frequently. Watch time and completion rate are becoming MORE important over time."
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
    "required": ["id", "platform", "technical_specs", "content_format", "algorithm_preferences"],
    "properties": {
      "id": {
        "type": "string",
        "pattern": "^platform_rule_[0-9]{3}$"
      },
      "platform": {
        "type": "string",
        "enum": ["tiktok", "instagram_reels", "youtube_shorts", "youtube", "all"]
      },
      "technical_specs": {
        "type": "object",
        "required": ["aspect_ratio", "duration", "resolution"],
        "properties": {
          "aspect_ratio": {
            "type": "array",
            "items": {"type": "string"}
          },
          "optimal_aspect": {"type": "string"},
          "duration": {
            "type": "object",
            "properties": {
              "min_seconds": {"type": "integer"},
              "max_seconds": {"type": "integer"},
              "optimal_seconds": {"type": "integer"},
              "sweet_spot": {"type": "string"}
            }
          },
          "resolution": {"type": "object"},
          "file_size": {"type": "object"},
          "framerate": {
            "type": "array",
            "items": {"type": "integer"}
          },
          "codec": {
            "type": "array",
            "items": {"type": "string"}
          }
        }
      },
      "content_format": {
        "type": "object",
        "properties": {
          "hook_timing": {"type": "object"},
          "caption_rules": {"type": "object"},
          "hashtag_strategy": {"type": "object"},
          "text_overlay": {"type": "object"},
          "music_requirements": {"type": "object"}
        }
      },
      "algorithm_preferences": {
        "type": "object",
        "properties": {
          "ranking_factors": {"type": "array"},
          "engagement_signals": {
            "type": "array",
            "items": {"type": "string"}
          },
          "negative_signals": {
            "type": "array",
            "items": {"type": "string"}
          },
          "boost_mechanisms": {"type": "array"},
          "content_preferences": {
            "type": "array",
            "items": {"type": "string"}
          },
          "content_penalties": {
            "type": "array",
            "items": {"type": "string"}
          }
        }
      },
      "audience_characteristics": {"type": "object"},
      "optimization_tips": {
        "type": "array",
        "items": {"type": "object"}
      },
      "posting_strategy": {"type": "object"},
      "monetization": {"type": "object"},
      "prohibited_content": {"type": "object"},
      "unique_features": {
        "type": "array",
        "items": {"type": "object"}
      },
      "cross_platform_strategy": {"type": "object"},
      "success_metrics": {"type": "object"},
      "source": {"type": "string"},
      "last_updated": {"type": "string"},
      "notes": {"type": "string"}
    }
  }
}
```

---

## ИСТОЧНИКИ ДЛЯ ПОИСКА

### Официальные ресурсы (ОБЯЗАТЕЛЬНО):
1. **TikTok Creator Portal** — https://www.tiktok.com/creators/
2. **TikTok Creative Center** — https://ads.tiktok.com/business/creativecenter
3. **Instagram Creators** — https://creators.instagram.com/
4. **YouTube Creator Academy** — https://creatoracademy.youtube.com/
5. **Meta Business Suite** — https://business.facebook.com/

### Creator insights:
6. **Paddy Galloway** — https://www.youtube.com/@PaddyGalloway (algorithm analysis)
7. **Colin and Samir** — platform strategies
8. **vidIQ Blog** — https://vidiq.com/blog/
9. **TubeBuddy** — YouTube optimization
10. **Later Blog** — https://later.com/blog/ (Instagram)
11. **Hootsuite** — https://blog.hootsuite.com/

### Исследования:
12. **Sprout Social Index** — annual social media reports
13. **Buffer State of Social** — https://buffer.com/state-of-social
14. **Socialblade** — platform analytics
15. **Influencer Marketing Hub** — industry reports
16. **HubSpot Social Media Trends** — annual reports

### Community insights:
17. **Reddit** — r/TikTokCreators, r/InstagramCreators, r/YouTubeCreators
18. **Creator Discord servers** — platform-specific communities
19. **Twitter** — follow platform employees and algorithm experts
20. **VidCon / SMM conferences** — talks and panels

---

## КРИТЕРИИ КАЧЕСТВА

### Правило проходит валидацию если:

| Критерий | Требование |
|----------|------------|
| Актуальность | Обновлено в последние 3 месяца |
| Источники | Минимум 2 официальных источника |
| Специфика | Уникально для платформы, не generic |
| Данные | Конкретные цифры и метрики |
| Практичность | Actionable советы, не теория |
| Полнота | Все основные секции заполнены |
| Доказательства | Примеры и кейсы успешного применения |

---

## КОЛИЧЕСТВО ЗАПИСЕЙ

| Платформа | Детальность |
|-----------|-------------|
| TikTok | Full comprehensive guide |
| Instagram Reels | Full comprehensive guide |
| YouTube Shorts | Full comprehensive guide |
| YouTube | Full comprehensive guide |
| Universal rules | 10+ cross-platform rules |
| **TOTAL** | **4 platforms + universal** |

---

## ПРИМЕР ГОТОВЫХ ДАННЫХ

```json
[
  {
    "id": "platform_rule_001",
    "platform": "tiktok",
    "technical_specs": {
      "aspect_ratio": ["9:16", "1:1"],
      "optimal_aspect": "9:16",
      "duration": {
        "min_seconds": 3,
        "max_seconds": 180,
        "optimal_seconds": 30,
        "sweet_spot": "15-30 seconds for maximum virality, though 60s+ can work for storytelling"
      },
      "resolution": {
        "min": "720p",
        "recommended": "1080p (1080x1920)",
        "max": "4K"
      },
      "file_size": {
        "max_mb": 287,
        "recommended_mb": 100
      },
      "framerate": [24, 30, 60],
      "codec": ["H.264", "H.265"]
    },
    "content_format": {
      "hook_timing": {
        "critical_seconds": 1,
        "why": "TikTok users decide to skip within 1-2 seconds. Hook must be IMMEDIATE and visual + audio."
      },
      "caption_rules": {
        "max_length": 2200,
        "optimal_length": 150,
        "best_practices": [
          "First line shows in feed - make it compelling",
          "Use line breaks for readability",
          "Include CTA at the end (comment, share, follow)",
          "Ask questions to boost comments",
          "Use emojis strategically"
        ]
      },
      "hashtag_strategy": {
        "min_count": 3,
        "max_count": 5,
        "optimal_count": 4,
        "types": ["1 trending", "2 niche", "1 content-specific"],
        "placement": "End of caption after text content"
      },
      "text_overlay": {
        "recommended": true,
        "max_words_on_screen": 8,
        "font_size_guidance": "Large, bold fonts. Users watch on mobile - must be instantly readable."
      },
      "music_requirements": {
        "recommended": true,
        "trending_boost": "+40% reach with trending sounds in first 24h",
        "library": "TikTok Sound Library, trending sounds, or original audio"
      }
    },
    "algorithm_preferences": {
      "ranking_factors": [
        {
          "factor": "Watch time / Completion rate",
          "weight": "critical",
          "description": "Most important signal. Videos watched to end get massive boost."
        },
        {
          "factor": "Re-watches",
          "weight": "critical",
          "description": "User watching multiple times = extremely strong signal. Loop videos for this."
        },
        {
          "factor": "Shares",
          "weight": "high",
          "description": "Shares count MORE than likes. Shareable content = viral content."
        },
        {
          "factor": "Comments",
          "weight": "high",
          "description": "Quality matters. Engaged comments better than 'lol'."
        },
        {
          "factor": "Profile visits & Follows",
          "weight": "high",
          "description": "Users following from this video = strong content signal"
        },
        {
          "factor": "Likes",
          "weight": "medium",
          "description": "Weakest engagement signal but still counted"
        }
      ],
      "engagement_signals": [
        "completion rate (watch to end)",
        "re-watches",
        "shares",
        "comments",
        "likes",
        "follows from video",
        "profile visits",
        "saves",
        "duets/stitches"
      ],
      "negative_signals": [
        "skip within 2 seconds",
        "swipe away quickly",
        "not interested click",
        "report",
        "hide video",
        "unfollow after video"
      ],
      "boost_mechanisms": [
        {
          "mechanism": "For You Page (FYP) - Initial Test",
          "how_to_trigger": "Every video gets shown to 300-500 test users. High engagement = second wave."
        },
        {
          "mechanism": "Second Wave Push",
          "how_to_trigger": "If first wave performs well (high watch time, shares), algorithm pushes to larger audience (10k-100k)"
        },
        {
          "mechanism": "Viral Push",
          "how_to_trigger": "Second wave performs extremely well = millions of impressions"
        }
      ],
      "content_preferences": [
        "Original content (not reposts)",
        "Trending sounds (within first 24-48h)",
        "High watch time / completion rate",
        "Native uploads (no watermarks)",
        "Participates in trends/challenges",
        "Consistent posting (1-3x per day)",
        "Strong hooks (first 1-2 seconds)"
      ],
      "content_penalties": [
        "Watermarks from Instagram/YouTube (HEAVY penalty)",
        "Low-quality video (blurry, bad lighting)",
        "Recycled/reposted content",
        "Clickbait that doesn't deliver",
        "Excessive self-promotion",
        "Asking for follows/likes explicitly",
        "Copyrighted music outside TikTok library"
      ]
    },
    "audience_characteristics": {
      "primary_age_range": "18-24 (38%), 13-17 (25%)",
      "gender_split": "61% female, 39% male",
      "peak_activity_times": [
        "7-9 AM EST (morning commute)",
        "12-1 PM EST (lunch break)",
        "7-11 PM EST (evening peak - BEST)"
      ],
      "content_consumption_behavior": {
        "avg_session_length": "52 minutes per day",
        "videos_per_session": 100,
        "skip_rate": "Within 2 seconds if not hooked - ruthless audience"
      },
      "trending_genres": [
        "true-crime",
        "pov",
        "story-time",
        "comedy/skits",
        "facts/did-you-know",
        "transformation",
        "how-to/hacks",
        "dance/trends"
      ]
    },
    "optimization_tips": [
      {
        "category": "retention",
        "tip": "Loop your video - make the end seamlessly connect to beginning for infinite re-watches",
        "impact": "critical",
        "evidence": "Looping videos get 3x more re-watches which signals to algorithm"
      },
      {
        "category": "hook",
        "tip": "Use text overlay for hook even with voiceover - 80% watch without sound initially",
        "impact": "critical",
        "evidence": "Text hooks increase retention by 25% in first 3 seconds"
      },
      {
        "category": "pacing",
        "tip": "Cut dead air. Every second must add value. Fast cuts keep attention.",
        "impact": "high",
        "evidence": "Videos with fast pacing have 40% higher completion rate"
      },
      {
        "category": "timing",
        "tip": "Post during peak hours (7-9 PM EST) for maximum initial test audience reach",
        "impact": "medium",
        "evidence": "Peak hour posts get +30% initial reach"
      },
      {
        "category": "engagement bait",
        "tip": "Ask polarizing questions or create 'comment baiting' hooks to boost comments",
        "impact": "high",
        "evidence": "Videos with questions get 2x more comments"
      }
    ],
    "posting_strategy": {
      "optimal_frequency": "1-3 times per day for maximum reach without burning out audience",
      "best_times": [
        "7-9 AM EST (secondary)",
        "6-10 PM EST (PRIMARY PEAK)",
        "Weekends: 9 AM - 11 PM (all day engagement)"
      ],
      "consistency_importance": "high - algorithm favors consistent creators"
    },
    "monetization": {
      "requirements": [
        "10,000 followers",
        "100,000 video views in last 30 days",
        "18+ years old",
        "Comply with Community Guidelines & Terms of Service"
      ],
      "revenue_mechanisms": [
        "Creator Fund (low RPM)",
        "TikTok Shop / Affiliate",
        "LIVE Gifts",
        "Brand partnerships (main income)",
        "TikTok Pulse (ad revenue share)"
      ],
      "avg_rpm": "$0.01-0.03 (Creator Fund is notoriously low - don't rely on it)"
    },
    "prohibited_content": {
      "hard_bans": [
        "Nudity/sexual content",
        "Violence/gore",
        "Hate speech/discrimination",
        "Dangerous acts/challenges",
        "Misinformation about health/elections",
        "Illegal activities"
      ],
      "soft_limits": [
        "Political content (limited reach, not banned)",
        "Controversial topics (may not hit FYP)",
        "Excessive profanity (limited reach)"
      ],
      "shadowban_triggers": [
        "Multiple community guideline strikes",
        "Posting copyrighted content repeatedly",
        "Sudden dramatic change in content type",
        "Suspicious engagement (buying followers/likes)",
        "Mass reporting by users",
        "Using banned hashtags"
      ]
    },
    "unique_features": [
      {
        "feature": "Duet & Stitch",
        "how_to_leverage": "Enable duets/stitches on all videos. When video goes viral, duets multiply reach 10x.",
        "virality_potential": "very high"
      },
      {
        "feature": "Trending Sounds",
        "how_to_leverage": "Use trending sounds within first 24 hours of trending for maximum algorithm boost.",
        "virality_potential": "very high - +40% reach"
      },
      {
        "feature": "Series / Part 2",
        "how_to_leverage": "Create multi-part content. Cliffhangers drive follows and profile visits.",
        "virality_potential": "medium-high for building audience"
      },
      {
        "feature": "LIVE",
        "how_to_leverage": "Go live after posting video. Pushes video to more users.",
        "virality_potential": "medium"
      }
    ],
    "cross_platform_strategy": {
      "repost_same_content": false,
      "adaptation_required": [
        "Remove ALL watermarks from other platforms (critical)",
        "Re-edit for TikTok pacing (faster, punchier)",
        "Add trending TikTok sounds",
        "Optimize for 9:16 vertical",
        "Adjust hook for 1-second attention span"
      ],
      "watermark_penalty": "SEVERE - algorithm heavily suppresses videos with Instagram/YouTube watermarks. Will not go viral."
    },
    "success_metrics": {
      "good_performance": {
        "views": "10,000+ in first 24h (for accounts under 10k followers)",
        "engagement_rate": "8-12% (likes+comments+shares / views)",
        "watch_time": "60%+ completion rate",
        "shares": "100+ shares"
      },
      "viral_threshold": {
        "views": "1M+ views",
        "shares": "10,000+ shares",
        "completion_rate": "75%+ watch to end",
        "engagement_rate": "15%+"
      }
    },
    "source": "TikTok Creator Portal + TikTok Creative Center + Analysis of 500+ viral TikToks + Creator insights from VidCon 2024",
    "last_updated": "2025-01",
    "notes": "TikTok algorithm changes FREQUENTLY. Watch time and completion rate are becoming MORE important. Shares are now weighted higher than likes. Loop videos and strong hooks are critical for 2025."
  }
]
```
