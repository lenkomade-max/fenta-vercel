# 05 - CINEMATOGRAPHY DATABASE

## Цель базы данных

Хранить **правила кинематографии** (камера, свет, движение, композиция) для 30+ жанров видео для использования агентом:
- **Video Prompt Agent** — добавляет cinematic детали в промпты
- **Cinematography Agent** — выбирает правила под жанр и mood
- **Quality Agent** — проверяет соответствие cinematography best practices

---

## ПРОМПТ ДЛЯ DEEP RESEARCH

```
Ты — кинематограф и DP (Director of Photography). Твоя задача — собрать базу cinematography правил для коротких видео по жанрам.

### ЧТО ТАКОЕ CINEMATOGRAPHY RULES

Это набор правил которые определяют:
- Какие **углы камеры** использовать
- Какие **движения камеры** подходят
- Как настроить **освещение**
- Какую **цветокоррекцию** применять
- Какой **motion design** использовать
- Какие **линзы/focal length** выбрать

Каждый жанр имеет свои правила. Документальное видео ≠ horror ≠ product demo.

### ЧТО СОБИРАТЬ

Для каждого жанра создай cinematography ruleset:

1. **id** — уникальный ID (cinema_001...)

2. **genre** — жанр видео:
   - documentary
   - cinematic-story
   - horror
   - sci-fi
   - commercial-product
   - fashion
   - food
   - travel
   - vlog
   - music-video
   - corporate
   - educational
   - sports
   - nature
   - urban
   - lifestyle
   - true-crime
   - mystery
   - comedy
   - drama
   - action
   - romance
   - abstract-art
   - news
   - interview
   - tutorial
   - social-media-casual
   - testimonial
   - event-coverage
   - architectural

3. **camera_angles** — рекомендуемые углы камеры (array of objects):
   - **angle_name**: eye-level, low-angle, high-angle, dutch-angle, bird's-eye, worm's-eye, over-shoulder, POV
   - **when_to_use**: описание
   - **emotional_effect**: какую эмоцию вызывает
   - **frequency**: always, often, sometimes, rarely, never

4. **camera_movements** — движения камеры (array of objects):
   - **movement_name**: static, pan, tilt, dolly, tracking, crane, handheld, steadicam, drone, orbit, whip-pan, zoom, rack-focus
   - **when_to_use**: описание
   - **speed**: slow, medium, fast
   - **frequency**: always, often, sometimes, rarely, never
   - **purpose**: для чего использовать

5. **shot_types** — типы кадров (array of objects):
   - **shot_name**: extreme-close-up (ECU), close-up (CU), medium-close-up (MCU), medium-shot (MS), medium-long-shot (MLS), long-shot (LS), extreme-long-shot (ELS), establishing-shot
   - **usage_percent**: сколько % от видео
   - **purpose**: для чего

6. **lighting** — правила освещения (object):
   - **primary_style**: natural, three-point, high-key, low-key, silhouette, practical, motivated, flat, dramatic, rim-light, Rembrandt, split-lighting
   - **mood**: bright-cheerful, dark-moody, neutral, warm-inviting, cool-clinical, dramatic-contrasty
   - **color_temperature**: warm (2700-3500K), neutral (4000-5000K), cool (5500-7000K), mixed
   - **direction**: front, side, back, top, bottom, 45-degree
   - **hardness**: hard (sharp shadows), soft (diffused), mixed
   - **contrast_ratio**: low (2:1), medium (4:1), high (8:1+)

7. **color_grading** — цветокоррекция (object):
   - **primary_look**: natural, cinematic-teal-orange, desaturated, vibrant, vintage, bleach-bypass, film-noir, neon, pastel, monochrome, high-contrast
   - **lut_reference**: какие LUTs использовать (если есть стандарт)
   - **highlights**: crushed, soft, neutral, blown
   - **shadows**: lifted, crushed, teal-tinted, warm-tinted
   - **saturation**: low (-30%), normal, boosted (+20%)
   - **contrast**: low, medium, high, s-curve

8. **lens_focal_length** — фокусное расстояние (array):
   - ultra-wide (14-24mm) — когда использовать
   - wide (24-35mm) — когда использовать
   - normal (35-50mm) — когда использовать
   - portrait (50-85mm) — когда использовать
   - telephoto (85-200mm) — когда использовать

9. **depth_of_field** — глубина резкости:
   - shallow (f/1.2-2.8) — когда использовать
   - medium (f/4-5.6) — когда использовать
   - deep (f/8-16) — когда использовать

10. **frame_rate** — частота кадров:
    - 24fps — cinematic standard
    - 30fps — broadcast standard
    - 60fps — slow motion source
    - 120fps — dramatic slow motion
    - recommended_default

11. **aspect_ratio** — соотношение сторон:
    - 16:9 (standard)
    - 9:16 (vertical/mobile)
    - 1:1 (square)
    - 2.35:1 (cinematic widescreen)
    - 2.39:1 (anamorphic)
    - recommended_default

12. **motion_characteristics** — характер движения:
    - **subject_motion**: static, slow, moderate, fast, frenetic
    - **camera_stability**: locked-off, minimal-movement, handheld-shake, smooth-gimbal
    - **transition_style**: cuts, dissolves, whip-pans, match-cuts, j-cuts, l-cuts

13. **composition_rules** — правила композиции (array):
    - rule-of-thirds
    - golden-ratio
    - leading-lines
    - symmetry
    - negative-space
    - framing-within-frame
    - depth-layers
    - headroom-and-looking-space

14. **reference_films** — референсные фильмы/видео (array of strings)

15. **reference_cinematographers** — известные DP в этом стиле (array)

16. **technical_specs** — технические рекомендации (object):
    - **camera_type**: cinema-camera, DSLR, mirrorless, smartphone, drone, action-cam, vintage-film
    - **iso_range**: recommended ISO range
    - **shutter_speed**: 180-degree rule or specific
    - **bit_depth**: 8-bit, 10-bit, 12-bit+

17. **common_mistakes** — частые ошибки в жанре (array of strings)

18. **pro_tips** — советы от профессионалов (array of strings)

19. **source** — источник правил (книга, курс, DP, анализ)

### ГДЕ ИСКАТЬ

**Книги по кинематографии:**
- "The Filmmaker's Eye" by Gustavo Mercado
- "Cinematography: Theory and Practice" by Blain Brown
- "The Visual Story" by Bruce Block
- "Shot by Shot" by Steven D. Katz
- "Master Shots" series by Christopher Kenworthy
- "Painting with Light" by John Alton

**Онлайн курсы:**
- MasterClass: Roger Deakins, Martin Scorsese
- YouTube: Every Frame a Painting
- YouTube: Wolfcrow cinematography tutorials
- Cinematography Database (cinematographers.nl)
- No Film School — cinematography articles
- IndieWire — DP interviews

**Анализ референсов:**
- Shot Deck (shotdeck.com) — кадры из фильмов
- Vimeo Staff Picks — cinematography
- Behance — cinematography projects
- ARRI Academy — lighting tutorials
- RED Digital Cinema — camera guides

**YouTube каналы:**
- Wandering DP
- Cinematography Database
- Film Riot
- Indy Mogul
- Potato Jet
- Philip Bloom
- Dave Maze

**Документации:**
- ARRI Lighting Handbook
- Panavision lens guides
- ASC (American Society of Cinematographers) articles
- British Cinematographer magazine

**Жанровый анализ:**
- True Crime: анализ Netflix documentaries (Making a Murderer, Tiger King)
- Horror: A24 films breakdown (Hereditary, Midsommar)
- Commercial: анализ Apple, Nike ads
- Food: Tasty, Bon Appetit style guides
- Fashion: Vogue, i-D cinematography

**Профессиональные ресурсы:**
- ASC Magazine
- British Cinematographer
- Cinematography.com
- Reddit: r/cinematography
- CML (Cinematography Mailing List)

### КРИТЕРИИ КАЧЕСТВА

Cinematography ruleset ХОРОШИЙ если:
✅ Специфичен для жанра (не generic)
✅ Включает конкретные параметры (numbers, не абстракции)
✅ Имеет референсы (фильмы, DP, примеры)
✅ Основан на реальной практике
✅ Включает технические specs
✅ Объясняет WHY (эмоциональный/narrative эффект)
✅ Учитывает платформу (cinema vs social media)

Ruleset ПЛОХОЙ если:
❌ Слишком generic ("use good lighting")
❌ Нет конкретных параметров
❌ Противоречит жанровым конвенциям
❌ Нет источников/референсов
❌ Технически неграмотен

### ПРИОРИТЕТЫ СБОРА

Обязательные жанры (30):
1. Documentary — 1 ruleset
2. Cinematic Story — 1 ruleset
3. Horror — 1 ruleset
4. Sci-Fi — 1 ruleset
5. Commercial Product — 1 ruleset
6. Fashion — 1 ruleset
7. Food — 1 ruleset
8. Travel — 1 ruleset
9. Music Video — 1 ruleset
10. Corporate — 1 ruleset
11. Educational — 1 ruleset
12. Sports — 1 ruleset
13. Nature — 1 ruleset
14. Urban — 1 ruleset
15. True Crime — 1 ruleset
16. Mystery — 1 ruleset
17. Comedy — 1 ruleset
18. Drama — 1 ruleset
19. Action — 1 ruleset
20. Social Media Casual — 1 ruleset
21-30. Другие жанры

### ФОРМАТ ВЫВОДА

Верни JSON array с детальными cinematography rulesets.

---

## JSON СХЕМА

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "array",
  "items": {
    "type": "object",
    "required": ["id", "genre", "camera_angles", "camera_movements", "lighting", "color_grading"],
    "properties": {
      "id": {"type": "string", "pattern": "^cinema_[0-9]{3}$"},
      "genre": {"type": "string"},
      "camera_angles": {
        "type": "array",
        "items": {
          "type": "object",
          "properties": {
            "angle_name": {"type": "string"},
            "when_to_use": {"type": "string"},
            "emotional_effect": {"type": "string"},
            "frequency": {"type": "string", "enum": ["always", "often", "sometimes", "rarely", "never"]}
          }
        }
      },
      "camera_movements": {
        "type": "array",
        "items": {
          "type": "object",
          "properties": {
            "movement_name": {"type": "string"},
            "when_to_use": {"type": "string"},
            "speed": {"type": "string", "enum": ["slow", "medium", "fast", "variable"]},
            "frequency": {"type": "string"},
            "purpose": {"type": "string"}
          }
        }
      },
      "shot_types": {
        "type": "array",
        "items": {
          "type": "object",
          "properties": {
            "shot_name": {"type": "string"},
            "usage_percent": {"type": "integer"},
            "purpose": {"type": "string"}
          }
        }
      },
      "lighting": {"type": "object"},
      "color_grading": {"type": "object"},
      "lens_focal_length": {"type": "array"},
      "depth_of_field": {"type": "object"},
      "frame_rate": {"type": "object"},
      "aspect_ratio": {"type": "object"},
      "motion_characteristics": {"type": "object"},
      "composition_rules": {"type": "array"},
      "reference_films": {"type": "array", "items": {"type": "string"}},
      "reference_cinematographers": {"type": "array", "items": {"type": "string"}},
      "technical_specs": {"type": "object"},
      "common_mistakes": {"type": "array", "items": {"type": "string"}},
      "pro_tips": {"type": "array", "items": {"type": "string"}},
      "source": {"type": "string"}
    }
  }
}
```

---

## ИСТОЧНИКИ ДЛЯ ПОИСКА

### Обязательные книги:
1. **"The Filmmaker's Eye"** by Gustavo Mercado
2. **"Cinematography: Theory and Practice"** by Blain Brown
3. **"The Visual Story"** by Bruce Block
4. **"Master Shots Vol 1-3"** by Christopher Kenworthy

### YouTube (PRIMARY):
5. **Every Frame a Painting** — film analysis
6. **Wandering DP** — cinematography tutorials
7. **Film Riot** — practical techniques
8. **Wolfcrow** — technical deep dives

### Онлайн ресурсы:
9. **Shot Deck** — https://shotdeck.com (frame references)
10. **ASC Magazine** — https://theasc.com/
11. **No Film School** — https://nofilmschool.com/cinematography
12. **Cinematography Database** — https://www.cinematographers.nl/

### Профессиональные:
13. **ARRI Academy** — https://www.arri.com/en/learn
14. **RED Education** — https://www.red.com/learn
15. **MasterClass**: Roger Deakins

---

## КРИТЕРИИ КАЧЕСТВА

| Критерий | Требование |
|----------|------------|
| Specificity | Конкретные параметры (f-stop, focal length, K temperature) |
| References | Минимум 2 film/video примера |
| Technical accuracy | Технически корректные specs |
| Emotional mapping | Связь техники с эмоцией/narrative |
| Platform awareness | Учёт cinema vs social media |
| Common mistakes | Включены типичные ошибки |
| Pro tips | Минимум 3 совета от профи |

---

## КОЛИЧЕСТВО ЗАПИСЕЙ

**30 жанров** = 30 rulesets (один детальный ruleset на жанр)

---

## ПРИМЕР ГОТОВЫХ ДАННЫХ

```json
[
  {
    "id": "cinema_001",
    "genre": "true-crime",
    "camera_angles": [
      {
        "angle_name": "eye-level",
        "when_to_use": "Interviews, neutral documentary footage",
        "emotional_effect": "Objective, trustworthy, journalistic",
        "frequency": "often"
      },
      {
        "angle_name": "low-angle",
        "when_to_use": "When showing authority figures or creating unease about suspect",
        "emotional_effect": "Power, intimidation, unease",
        "frequency": "sometimes"
      },
      {
        "angle_name": "high-angle",
        "when_to_use": "Victim perspective, vulnerability moments",
        "emotional_effect": "Vulnerability, powerlessness",
        "frequency": "sometimes"
      }
    ],
    "camera_movements": [
      {
        "movement_name": "static",
        "when_to_use": "Interviews, crime scene documentation",
        "speed": "n/a",
        "frequency": "often",
        "purpose": "Creates stability and credibility"
      },
      {
        "movement_name": "slow-push-in",
        "when_to_use": "Dramatic revelations, building tension",
        "speed": "slow",
        "frequency": "sometimes",
        "purpose": "Builds suspense, focuses attention"
      },
      {
        "movement_name": "handheld",
        "when_to_use": "POV sequences, recreations of events",
        "speed": "medium",
        "frequency": "sometimes",
        "purpose": "Creates immediacy and realism"
      }
    ],
    "shot_types": [
      {"shot_name": "close-up", "usage_percent": 30, "purpose": "Emotional reactions, evidence details"},
      {"shot_name": "medium-shot", "usage_percent": 35, "purpose": "Interviews, subject presentation"},
      {"shot_name": "wide-shot", "usage_percent": 20, "purpose": "Location establishing, context"},
      {"shot_name": "extreme-close-up", "usage_percent": 15, "purpose": "Evidence, documents, tension"}
    ],
    "lighting": {
      "primary_style": "naturalistic with motivated drama",
      "mood": "dark-moody with selective highlights",
      "color_temperature": "cool (5000-6000K) for clinical feel",
      "direction": "side lighting (45-degree) for interviews",
      "hardness": "mixed - soft for interviews, hard for dramatic moments",
      "contrast_ratio": "medium-high (6:1) for dramatic mood"
    },
    "color_grading": {
      "primary_look": "desaturated with teal-blue shadows",
      "lut_reference": "Netflix documentary look, teal-orange but subdued",
      "highlights": "slightly crushed to avoid cheerfulness",
      "shadows": "teal-tinted, lifted slightly to maintain detail",
      "saturation": "low (-20 to -30%)",
      "contrast": "medium-high with s-curve"
    },
    "lens_focal_length": [
      {"range": "24-35mm", "when_to_use": "Location wide shots, establishing"},
      {"range": "50mm", "when_to_use": "Natural perspective for interviews"},
      {"range": "85mm", "when_to_use": "Flattering interview close-ups"},
      {"range": "100-200mm", "when_to_use": "Evidence details, compression"}
    ],
    "depth_of_field": {
      "shallow": "For subject isolation in interviews (f/2.8-4)",
      "medium": "For context with subject (f/5.6-8)",
      "deep": "Crime scene documentation (f/8-11)"
    },
    "frame_rate": {
      "24fps": "Cinematic documentary standard",
      "30fps": "Broadcast if needed",
      "60fps": "Dramatic slow-motion for key moments",
      "recommended_default": "24fps"
    },
    "aspect_ratio": {
      "recommended_default": "16:9",
      "alternatives": ["9:16 for social media vertical"]
    },
    "motion_characteristics": {
      "subject_motion": "minimal to moderate - controlled, deliberate",
      "camera_stability": "stable gimbal or locked off, occasional handheld for impact",
      "transition_style": "j-cuts and l-cuts for audio continuity, hard cuts for impact"
    },
    "composition_rules": [
      "rule-of-thirds for interviews (eyes on upper third line)",
      "looking-space in interviews (subject looks into frame)",
      "leading-lines to guide attention to evidence",
      "negative-space for isolation and tension",
      "framing-within-frame for confinement feeling"
    ],
    "reference_films": [
      "Making a Murderer (Netflix)",
      "The Staircase",
      "Tiger King",
      "Evil Genius",
      "The Jinx"
    ],
    "reference_cinematographers": [
      "Netflix documentary team",
      "HBO documentary DPs",
      "Errol Morris documentary style"
    ],
    "technical_specs": {
      "camera_type": "cinema camera or high-end mirrorless (Sony FX, Canon C-series)",
      "iso_range": "400-3200 (low light capability crucial)",
      "shutter_speed": "1/50s (180-degree rule at 24fps)",
      "bit_depth": "10-bit minimum for grading flexibility"
    },
    "common_mistakes": [
      "Over-stylizing - true crime needs credibility, not music video looks",
      "Too bright/cheerful lighting - undermines serious tone",
      "Shaky handheld overuse - creates amateur look",
      "Over-saturated colors - looks like entertainment not documentary",
      "Ignoring audio - bad interview audio ruins credibility"
    ],
    "pro_tips": [
      "Use practical lights in frame for motivated lighting (desk lamps, windows)",
      "Shoot interviews near windows for natural soft light",
      "Add subtle vignette in post to focus attention",
      "Use slow subtle camera moves - fast moves feel sensational",
      "Shoot evidence in ECU with shallow DOF for cinematic drama",
      "Mix static and moving shots - all static = boring, all moving = nauseating",
      "Cool color temp + desaturation = serious credible tone"
    ],
    "source": "Analysis of Netflix true crime docs + ASC documentary cinematography articles"
  }
]
```
