# 04 - VIDEO PROMPTS DATABASE

## Цель базы данных

Хранить **200+ работающих промптов** для AI-генерации видео (Sora, Kling, Runway, Minimax, Luma Dream Machine) для использования агентом:
- **Video Prompt Agent** — использует proven промпты как базу для создания новых
- **Style Agent** — анализирует связь стиля и промпт-параметров
- **Quality Agent** — сравнивает output качество с референсными примерами

---

## ПРОМПТ ДЛЯ DEEP RESEARCH

```
Ты — специалист по AI-генерации видео. Твоя задача — собрать базу данных из 200+ работающих промптов для text-to-video моделей с примерами результатов.

### ВАЖНО: ЧТО СОБИРАЕМ

Мы собираем НЕ теоретические промпты, а **ДОКАЗАННЫЕ** — те которые:
- Реально были использованы
- Дали качественный результат
- Имеют screenshots/URLs результата
- Протестированы на конкретной модели

### ЧТО СОБИРАТЬ

Для каждого промпта собери:

1. **id** — уникальный ID (vidprompt_001...)

2. **model** — AI модель:
   - sora (OpenAI Sora)
   - kling (Kling AI)
   - runway-gen3 (Runway Gen-3)
   - runway-gen2 (Runway Gen-2)
   - pika (Pika Labs)
   - minimax (Minimax Video-01)
   - luma (Luma Dream Machine)
   - stable-video
   - other

3. **prompt** — полный текст промпта (как был использован)

4. **negative_prompt** — что исключить (если использовалось)

5. **genre** — жанр видео:
   - cinematic
   - documentary
   - product-demo
   - abstract
   - nature
   - urban
   - sci-fi
   - fantasy
   - horror
   - retro
   - futuristic
   - commercial
   - educational
   - social-media

6. **style** — визуальный стиль:
   - photorealistic
   - anime
   - 3d-render
   - claymation
   - watercolor
   - oil-painting
   - pixel-art
   - vintage-film
   - drone-footage
   - gopro-pov
   - security-camera
   - professional-video
   - lo-fi
   - hyper-stylized

7. **subject** — главный объект:
   - person
   - animal
   - object
   - landscape
   - architecture
   - abstract
   - vehicle
   - food
   - product
   - nature-scene

8. **camera_movement** — движение камеры:
   - static
   - pan-left / pan-right
   - tilt-up / tilt-down
   - dolly-in / dolly-out
   - crane-up / crane-down
   - orbit
   - handheld
   - drone-rising
   - tracking-shot
   - whip-pan
   - zoom-in / zoom-out

9. **duration_seconds** — длина видео (обычно 2-10 сек)

10. **parameters** — технические параметры (object):
    - aspect_ratio (16:9, 9:16, 1:1, etc.)
    - fps (24, 30, 60)
    - resolution (720p, 1080p, 4K)
    - motion_strength (1-10)
    - seed (если известен)
    - cfg_scale
    - steps

11. **quality_score** — оценка качества результата (0-100):
    - 90-100: Production-ready
    - 70-89: Good with minor fixes
    - 50-69: Usable for some contexts
    - <50: Poor quality

12. **artifacts** — проблемы с генерацией (array):
    - morphing
    - hand-deformation
    - face-distortion
    - physics-violation
    - inconsistent-lighting
    - temporal-flickering
    - motion-blur-artifacts
    - watermark
    - low-resolution
    - none

13. **best_for** — для чего подходит:
    - b-roll
    - main-footage
    - transitions
    - backgrounds
    - social-media
    - advertising
    - stock-footage
    - experimental

14. **result_url** — ссылка на результат (если публичный)

15. **thumbnail_url** — ссылка на preview/screenshot

16. **source** — откуда промпт (Discord, Reddit, GitHub, официальные примеры)

17. **author** — автор промпта (если известен)

18. **date_created** — когда создан/протестирован

19. **tips** — советы по улучшению (array of strings)

20. **variations** — вариации промпта и результаты (array)

### ГДЕ ИСКАТЬ

**Официальные ресурсы:**

**OpenAI Sora:**
- OpenAI Cookbook (когда появится)
- OpenAI Discord server
- r/OpenAI subreddit
- Twitter: @OpenAI announcements
- Ждать публичного доступа

**Kling AI:**
- Kling Discord: https://discord.gg/kling
- r/KlingAI subreddit
- Kuaishou (китайская платформа-создатель)
- YouTube tutorials: "Kling AI prompts"
- Twitter: #KlingAI

**Runway:**
- Runway Discord: https://discord.gg/runwayml
- Runway Academy: https://academy.runwayml.com/
- r/RunwayML subreddit
- Runway Gen-3 Prompt Guide (официальный)
- YouTube: Runway ML tutorials
- Twitter: @runwayml

**Pika Labs:**
- Pika Discord: https://discord.gg/pika
- r/PikaLabs subreddit
- Pika Prompt Library (community)
- YouTube: "Pika Labs best prompts"

**Minimax:**
- Hailuo AI platform
- GitHub: minimax-video examples
- r/MediaSynthesis
- Twitter: #MinimaxVideo

**Luma Dream Machine:**
- Luma Discord
- r/LumaAI
- Twitter: @LumaLabsAI
- YouTube: "Luma Dream Machine prompts"

**Stable Video Diffusion:**
- Stability AI Discord
- Hugging Face: stable-video-diffusion models
- GitHub: generative-models (Stability AI)
- r/StableDiffusion (video section)

**Community агрегаторы:**
- **Civitai.com** — огромная база промптов и моделей
- **PromptHero.com** — база промптов с примерами
- **Lexica.art** — визуальный поиск промптов
- **Reddit r/MediaSynthesis** — новые AI video tools

**YouTube каналы:**
- Theoretically Media
- Olivio Sarikas
- Nerdy Rodent
- MattVidPro AI
- AI Samson

**Twitter hashtags:**
- #AIVideo
- #Sora
- #RunwayML
- #KlingAI
- #TextToVideo

### КРИТЕРИИ КАЧЕСТВА

Промпт ХОРОШИЙ если:
✅ Дал качественный результат (score >70)
✅ Специфичен (детальное описание)
✅ Воспроизводим (повторяемый результат)
✅ Включает технические параметры (камера, освещение, стиль)
✅ Есть proof (screenshot/URL результата)
✅ Протестирован на конкретной модели
✅ Минимум артефактов

Промпт ПЛОХОЙ если:
❌ Нет подтверждения результата
❌ Слишком generic ("beautiful landscape")
❌ Не указаны параметры
❌ Результат низкого качества
❌ Морфинг/артефакты критичны
❌ Не указана модель

### СТРУКТУРА ПРОМПТА (BEST PRACTICES)

Эффективный промпт содержит:
1. **Subject** — что показываем (person, object, scene)
2. **Action/Motion** — что происходит
3. **Camera** — угол, движение, тип съёмки
4. **Lighting** — освещение и время суток
5. **Style** — визуальный стиль, референсы
6. **Technical** — разрешение, fps, ratio
7. **Mood** — эмоциональная атмосфера

Пример:
"A woman in her 30s walking through a bustling Tokyo street at night, neon signs reflecting in puddles, camera follows from behind with smooth steadicam movement, cinematic lighting with bokeh background, shot on Arri Alexa, 2.35:1 aspect ratio, photorealistic style, moody and atmospheric"

### ПРИОРИТЕТЫ СБОРА

По моделям:
- Runway Gen-3: 50 промптов (самая доступная)
- Kling AI: 40 промптов (хорошее качество)
- Pika Labs: 30 промптов
- Luma Dream Machine: 30 промптов
- Minimax: 20 промптов
- Sora: 10 промптов (когда появится доступ)
- Другие: 20 промптов

По жанрам:
- Cinematic/Documentary: 40 промптов
- Product Demo: 30 промптов
- Nature/Landscape: 25 промптов
- Urban/City: 25 промптов
- Abstract/Artistic: 20 промптов
- Sci-Fi/Fantasy: 20 промптов
- Social Media: 20 промптов
- Другие: 20 промптов

### ФОРМАТ ВЫВОДА

Верни JSON array:

[
  {
    "id": "vidprompt_001",
    "model": "runway-gen3",
    "prompt": "Close-up shot of a steaming cup of coffee on a wooden table, camera slowly dollies in, warm morning sunlight streaming through a window creating soft shadows, shot on vintage film with slight grain, cozy and intimate atmosphere, 16:9, photorealistic",
    "negative_prompt": "people, hands, text, watermark",
    "genre": "product-demo",
    "style": "photorealistic",
    "subject": "object",
    "camera_movement": "dolly-in",
    "duration_seconds": 5,
    "parameters": {
      "aspect_ratio": "16:9",
      "fps": 24,
      "resolution": "1080p",
      "motion_strength": 6,
      "cfg_scale": 7
    },
    "quality_score": 88,
    "artifacts": ["slight-temporal-flickering"],
    "best_for": ["b-roll", "advertising", "social-media"],
    "result_url": "https://example.com/result.mp4",
    "thumbnail_url": "https://example.com/thumb.jpg",
    "source": "Runway Discord community",
    "author": "user_example",
    "date_created": "2024-11-15",
    "tips": [
      "Keep camera movement slow for better quality",
      "Warm lighting keywords improve atmosphere",
      "Vintage film grain hides small artifacts"
    ],
    "variations": [
      {
        "change": "Switch to tea instead of coffee",
        "result": "Works equally well, same quality"
      },
      {
        "change": "Add 'condensation on glass' detail",
        "result": "More dynamic, slightly lower quality due to complexity"
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
    "required": ["id", "model", "prompt", "genre", "style", "quality_score"],
    "properties": {
      "id": {"type": "string", "pattern": "^vidprompt_[0-9]{3,4}$"},
      "model": {
        "type": "string",
        "enum": ["sora", "kling", "runway-gen3", "runway-gen2", "pika", "minimax", "luma", "stable-video", "other"]
      },
      "prompt": {"type": "string", "minLength": 20},
      "negative_prompt": {"type": "string"},
      "genre": {
        "type": "string",
        "enum": ["cinematic", "documentary", "product-demo", "abstract", "nature", "urban", "sci-fi", "fantasy", "horror", "retro", "futuristic", "commercial", "educational", "social-media"]
      },
      "style": {
        "type": "string",
        "enum": ["photorealistic", "anime", "3d-render", "claymation", "watercolor", "oil-painting", "pixel-art", "vintage-film", "drone-footage", "gopro-pov", "security-camera", "professional-video", "lo-fi", "hyper-stylized"]
      },
      "subject": {
        "type": "string",
        "enum": ["person", "animal", "object", "landscape", "architecture", "abstract", "vehicle", "food", "product", "nature-scene"]
      },
      "camera_movement": {"type": "string"},
      "duration_seconds": {"type": "integer", "minimum": 1, "maximum": 20},
      "parameters": {
        "type": "object",
        "properties": {
          "aspect_ratio": {"type": "string"},
          "fps": {"type": "integer"},
          "resolution": {"type": "string"},
          "motion_strength": {"type": "integer"},
          "seed": {"type": "integer"},
          "cfg_scale": {"type": "number"},
          "steps": {"type": "integer"}
        }
      },
      "quality_score": {"type": "integer", "minimum": 0, "maximum": 100},
      "artifacts": {
        "type": "array",
        "items": {
          "type": "string",
          "enum": ["morphing", "hand-deformation", "face-distortion", "physics-violation", "inconsistent-lighting", "temporal-flickering", "motion-blur-artifacts", "watermark", "low-resolution", "none"]
        }
      },
      "best_for": {"type": "array", "items": {"type": "string"}},
      "result_url": {"type": "string", "format": "uri"},
      "thumbnail_url": {"type": "string", "format": "uri"},
      "source": {"type": "string"},
      "author": {"type": "string"},
      "date_created": {"type": "string", "format": "date"},
      "tips": {"type": "array", "items": {"type": "string"}},
      "variations": {
        "type": "array",
        "items": {
          "type": "object",
          "properties": {
            "change": {"type": "string"},
            "result": {"type": "string"}
          }
        }
      }
    }
  }
}
```

---

## ИСТОЧНИКИ ДЛЯ ПОИСКА

### Discord серверы (PRIMARY):
1. **Runway** — https://discord.gg/runwayml
2. **Pika Labs** — https://discord.gg/pika
3. **Kling AI** — https://discord.gg/kling
4. **Stability AI** — https://discord.gg/stablediffusion
5. **Luma AI** — https://discord.gg/lumalabs

### Community базы:
6. **Civitai** — https://civitai.com/ (prompts + models)
7. **PromptHero** — https://prompthero.com/
8. **OpenArt.ai** — https://openart.ai/

### Reddit:
9. **r/RunwayML** — https://reddit.com/r/RunwayML
10. **r/StableDiffusion** — video posts
11. **r/MediaSynthesis** — all AI video
12. **r/artificial** — AI video discussions

### YouTube каналы:
13. **Theoretically Media** — AI video tutorials
14. **Olivio Sarikas** — prompts & workflows
15. **MattVidPro AI** — latest tools
16. **Nerdy Rodent** — technical deep dives

### Официальные ресурсы:
17. **Runway Academy** — https://academy.runwayml.com/
18. **Stability AI GitHub** — https://github.com/Stability-AI
19. **Pika Docs** — https://docs.pika.art/

---

## КРИТЕРИИ КАЧЕСТВА

| Критерий | Требование |
|----------|------------|
| Proof | Screenshot/URL результата обязателен |
| Specificity | Детальное описание (>50 слов) |
| Quality | Score >70 для включения в базу |
| Parameters | Указаны aspect ratio, movement, style |
| Reproducibility | Промпт даёт similar результаты |
| Artifacts | Документированы все проблемы |
| Source | Указан авторитетный источник |
| Date | Актуальность (предпочтительно <6 мес) |

---

## КОЛИЧЕСТВО ЗАПИСЕЙ

| Модель | Минимум |
|--------|---------|
| Runway Gen-3 | 50 |
| Kling AI | 40 |
| Pika Labs | 30 |
| Luma Dream Machine | 30 |
| Minimax Video-01 | 20 |
| Sora | 10 |
| Другие | 20 |
| **TOTAL** | **200** |

---

## ПРИМЕР ГОТОВЫХ ДАННЫХ

```json
[
  {
    "id": "vidprompt_001",
    "model": "runway-gen3",
    "prompt": "Aerial drone shot rising above a misty forest at sunrise, golden light breaking through the fog, camera ascends smoothly revealing mountain ranges in the distance, cinematic color grading with teal shadows and warm highlights, shot on RED camera, 2.35:1 aspect ratio, breathtaking and serene",
    "negative_prompt": "people, buildings, roads, text",
    "genre": "nature",
    "style": "cinematic",
    "subject": "landscape",
    "camera_movement": "crane-up",
    "duration_seconds": 6,
    "parameters": {
      "aspect_ratio": "2.35:1",
      "fps": 24,
      "resolution": "4K",
      "motion_strength": 7,
      "cfg_scale": 8
    },
    "quality_score": 92,
    "artifacts": ["none"],
    "best_for": ["b-roll", "main-footage", "stock-footage"],
    "result_url": "https://runway.com/example/forest-sunrise",
    "source": "Runway Discord - Community Showcase",
    "author": "cinematography_pro",
    "date_created": "2024-10-20",
    "tips": [
      "Use 'misty' or 'fog' for atmospheric depth",
      "Specify color grading for cinematic look",
      "Smooth camera movements work better than fast",
      "Golden hour lighting keywords improve quality"
    ],
    "variations": [
      {
        "change": "Change to sunset instead of sunrise",
        "result": "Works great, warmer tones, score 90"
      },
      {
        "change": "Add 'birds flying' to the scene",
        "result": "Added complexity, slight quality drop to 85"
      }
    ]
  },
  {
    "id": "vidprompt_002",
    "model": "kling",
    "prompt": "POV shot walking through a neon-lit cyberpunk alley at night, rain-slicked streets reflecting colorful signs, camera moves forward with slight handheld shake, depth of field with bokeh lights, blade runner aesthetic, moody and atmospheric, 16:9, photorealistic with slight film grain",
    "negative_prompt": "daytime, people close-up, text in focus",
    "genre": "urban",
    "style": "cinematic",
    "subject": "architecture",
    "camera_movement": "tracking-shot",
    "duration_seconds": 8,
    "parameters": {
      "aspect_ratio": "16:9",
      "fps": 24,
      "motion_strength": 8
    },
    "quality_score": 87,
    "artifacts": ["slight-temporal-flickering"],
    "best_for": ["b-roll", "social-media", "main-footage"],
    "result_url": "https://kling.ai/example/cyberpunk-alley",
    "source": "Kling Discord - Top Generations",
    "author": "scifi_creator",
    "date_created": "2024-11-01",
    "tips": [
      "Rain and reflections add production value",
      "Handheld shake makes it feel real",
      "Specific aesthetic reference (Blade Runner) helps consistency",
      "Bokeh keywords improve depth perception"
    ],
    "variations": [
      {
        "change": "Change to Tokyo street instead of generic cyberpunk",
        "result": "More consistent architecture, score 89"
      }
    ]
  },
  {
    "id": "vidprompt_003",
    "model": "pika",
    "prompt": "Extreme close-up of honey dripping from a wooden dipper onto pancakes in slow motion, warm kitchen lighting from the side, steam rising gently, shallow depth of field, commercial food photography style, appetizing and rich colors, 9:16 vertical format",
    "negative_prompt": "people, hands, utensils moving",
    "genre": "product-demo",
    "style": "photorealistic",
    "subject": "food",
    "camera_movement": "static",
    "duration_seconds": 4,
    "parameters": {
      "aspect_ratio": "9:16",
      "fps": 60,
      "motion_strength": 3
    },
    "quality_score": 85,
    "artifacts": ["none"],
    "best_for": ["advertising", "social-media", "product-demo"],
    "result_url": "https://pika.art/example/honey-drip",
    "source": "Pika Discord - Food Category",
    "author": "foodvideo_expert",
    "date_created": "2024-10-15",
    "tips": [
      "Slow motion works best with simple motions (dripping, pouring)",
      "Side lighting creates appealing highlights on food",
      "Static camera keeps focus on the product",
      "9:16 format perfect for Instagram Reels/TikTok"
    ],
    "variations": [
      {
        "change": "Change honey to chocolate sauce",
        "result": "Works well, slightly darker lighting needed"
      },
      {
        "change": "Add steam to emphasize warmth",
        "result": "Already included, key detail for food shots"
      }
    ]
  }
]
```
