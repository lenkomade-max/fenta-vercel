# 06 - VISUAL STYLES DATABASE

## Цель базы данных

Хранить **50+ визуальных стилей/эстетик** с детальным описанием для использования агентами:
- **Style Agent** — выбирает стиль под жанр и brand
- **Video Prompt Agent** — добавляет style keywords в промпты
- **Image Prompt Agent** — генерирует визуальные референсы
- **Quality Agent** — проверяет консистентность стиля

---

## ПРОМПТ ДЛЯ DEEP RESEARCH

```
Ты — эксперт по визуальной эстетике и art direction. Твоя задача — собрать базу из 50+ визуальных стилей для коротких видео.

### ЧТО ТАКОЕ ВИЗУАЛЬНЫЙ СТИЛЬ

Визуальный стиль (aesthetic) — это набор характеристик который определяет:
- Цветовую палитру
- Текстуру и зернистость
- Освещение и контраст
- Композиционные приёмы
- Mood и атмосферу
- Референсы и влияния

Примеры: Cyberpunk, Vaporwave, Film Noir, Wes Anderson, Cottagecore, Y2K, etc.

### ЧТО СОБИРАТЬ

Для каждого стиля собери:

1. **id** — уникальный ID (style_001...)

2. **name** — название стиля (например: "Cyberpunk Neon", "Cottagecore", "Film Noir")

3. **aliases** — альтернативные названия (array)

4. **description** — детальное описание (100-200 слов)

5. **color_palette** — цветовая палитра (object):
   - **primary_colors** — основные цвета (array of hex codes)
   - **secondary_colors** — вторичные цвета (array)
   - **accent_colors** — акцентные цвета (array)
   - **color_mood** — warm, cool, neutral, vibrant, muted, pastel, neon
   - **saturation_level** — low, medium, high
   - **contrast_level** — low, medium, high

6. **lighting_characteristics** — особенности света (object):
   - **primary_lighting** — soft, hard, dramatic, flat, neon, natural, artificial
   - **shadows** — deep, soft, absent, stylized
   - **highlights** — blown, controlled, subdued
   - **mood** — bright, dark, moody, ethereal, harsh

7. **texture** — текстурные характеристики (object):
   - **grain** — none, subtle, heavy, film-grain
   - **sharpness** — razor-sharp, slightly-soft, dreamy, blurred
   - **surface** — smooth, rough, glossy, matte
   - **noise** — clean, grainy, digital-noise

8. **composition_style** — композиционные приёмы (array):
   - symmetry
   - rule-of-thirds
   - centered-framing
   - negative-space
   - tight-framing
   - wide-expansive
   - depth-layers
   - flat-graphic

9. **camera_characteristics** — характеристики камеры (object):
   - **movement** — static, slow-smooth, fast-dynamic, handheld-shaky
   - **focal_length_preference** — wide, normal, telephoto
   - **depth_of_field** — shallow, medium, deep

10. **post_processing** — постобработка (object):
    - **color_grading** — natural, teal-orange, desaturated, high-contrast, vintage, bleach-bypass, etc.
    - **vignette** — none, subtle, heavy
    - **bloom/glow** — none, subtle, heavy
    - **film_effects** — light-leaks, frame-burn, scratches, dust
    - **sharpening** — none, moderate, heavy

11. **era/time_period** — временной период (если применимо):
    - modern
    - retro-80s
    - retro-90s
    - y2k-2000s
    - vintage-film
    - futuristic
    - timeless

12. **cultural_references** — культурные референсы (array):
    - movies, directors, photographers, artists, movements

13. **mood_keywords** — ключевые слова настроения (array):
    - dreamy, dark, energetic, calm, mysterious, cheerful, melancholic, etc.

14. **best_for_genres** — для каких жанров подходит (array):
    - fashion, tech, food, travel, horror, sci-fi, romance, etc.

15. **best_for_platforms** — на каких платформах работает лучше (array):
    - tiktok, reels, shorts, youtube, vimeo

16. **prompt_keywords** — ключевые слова для AI промптов (array):
    - список слов которые вызывают этот стиль в Midjourney/Runway/Sora

17. **example_images** — примеры (URLs если есть)

18. **example_videos** — примеры видео (URLs если есть)

19. **do_use** — что использовать в этом стиле (array)

20. **dont_use** — чего избегать (array)

21. **difficulty** — сложность достижения стиля:
    - easy
    - moderate
    - difficult

22. **source** — источник описания (Pinterest, aesthetic wiki, film analysis, etc.)

### ГДЕ ИСКАТЬ

**Aesthetic ресурсы:**
- **Aesthetics Wiki** — https://aesthetics.fandom.com/ (огромная база стилей)
- **Pinterest** — boards по эстетикам
- **Tumblr** — aesthetic communities
- **Are.na** — curated aesthetic collections
- **Behance** — professional design

**Film & Photography:**
- **Shot Deck** — frames from films
- **Film Grab** — movie screenshots
- **Cinematography Database** — DP portfolios
- **Magnum Photos** — photography styles
- **Masters of Cinema** — film analysis

**AI Art communities:**
- **Midjourney** — style exploration
- **Stable Diffusion** — prompt libraries
- **Lexica.art** — style search
- **PromptHero** — style examples
- **Civitai** — aesthetic models

**Design & Art:**
- **Dribbble** — UI/graphic styles
- **Awwwards** — web design trends
- **Adobe Color** — color palettes
- **Coolors** — palette inspiration
- **Color Hunt** — trending palettes

**Specific aesthetics:**
- **Cyberpunk** — Blade Runner, Ghost in the Shell, Akira
- **Vaporwave** — 80s/90s internet culture
- **Film Noir** — classic noir films analysis
- **Cottagecore** — Pinterest, Tumblr communities
- **Y2K** — early 2000s culture
- **Brutalism** — architectural/design movement

**YouTube analysis:**
- Every Frame a Painting — director styles
- Nerdwriter — visual analysis
- Now You See It — film style breakdowns

**Books:**
- "The Filmmaker's Eye" — visual styles
- "Color and Light" by James Gurney
- "Interaction of Color" by Josef Albers

### КРИТЕРИИ КАЧЕСТВА

Стиль ХОРОШИЙ если:
✅ Имеет чёткие визуальные характеристики
✅ Легко узнаваем
✅ Имеет примеры (images/videos)
✅ Детальное описание цветов (hex codes)
✅ Можно воспроизвести в AI
✅ Применим к разным темам
✅ Имеет культурные референсы

Стиль ПЛОХОЙ если:
❌ Слишком абстрактный/расплывчатый
❌ Нет визуальных примеров
❌ Нельзя описать технически
❌ Только для одной очень узкой ниши
❌ Нет AI prompt keywords

### ПРИОРИТЕТЫ СБОРА

**Популярные стили (must-have):**
1. Cyberpunk
2. Vaporwave
3. Film Noir
4. Cottagecore
5. Y2K/2000s
6. Minimalist Modern
7. Retro 80s
8. Vintage Film
9. Neon Noir
10. Brutalist

**Cinematic стили:**
11. Wes Anderson
12. Christopher Nolan
13. David Fincher
14. Blade Runner
15. Studio Ghibli

**Art movements:**
16. Impressionism
17. Art Deco
18. Bauhaus
19. Memphis Design
20. Surrealism

**Internet aesthetics:**
21. Dark Academia
22. Weirdcore
23. Dreamcore
24. Glitchcore
25. Analog Horror

**Commercial styles:**
26. Apple Product Style
27. Nike Sports
28. Fashion Editorial
29. Food Photography
30. Travel Cinematic

**Plus 20 more** для достижения 50+

### ФОРМАТ ВЫВОДА

Верни JSON array:

[
  {
    "id": "style_001",
    "name": "Cyberpunk Neon",
    "aliases": ["Neon Noir", "Blade Runner aesthetic", "Dystopian Future"],
    "description": "Dark urban environments dominated by neon lighting and rain-slicked streets. High contrast between deep shadows and vibrant neon colors (pink, cyan, purple). Often features Asian-inspired typography, holographic elements, and a gritty dystopian atmosphere. Think Blade Runner meets Tokyo nightlife.",
    "color_palette": {
      "primary_colors": ["#FF006E", "#00F5FF", "#8338EC"],
      "secondary_colors": ["#000000", "#1A1A2E", "#0F0F1E"],
      "accent_colors": ["#FFBE0B", "#06FFA5"],
      "color_mood": "neon vibrant on dark",
      "saturation_level": "high",
      "contrast_level": "very high"
    },
    "lighting_characteristics": {
      "primary_lighting": "neon artificial lights",
      "shadows": "deep black shadows",
      "highlights": "blown neon highlights",
      "mood": "dark with vibrant accents"
    },
    "texture": {
      "grain": "subtle digital grain",
      "sharpness": "razor-sharp",
      "surface": "wet glossy (rain effects)",
      "noise": "slight digital noise for grit"
    },
    "composition_style": ["depth-layers", "leading-lines", "reflections", "negative-space"],
    "camera_characteristics": {
      "movement": "slow smooth or static",
      "focal_length_preference": "wide to normal (24-50mm)",
      "depth_of_field": "medium to shallow for bokeh neon lights"
    },
    "post_processing": {
      "color_grading": "teal-magenta split toning",
      "vignette": "subtle to medium",
      "bloom/glow": "heavy on neon elements",
      "film_effects": "none (clean digital)",
      "sharpening": "heavy for crisp neon"
    },
    "era/time_period": "futuristic dystopian",
    "cultural_references": [
      "Blade Runner (1982, 2049)",
      "Ghost in the Shell",
      "Akira",
      "Cyberpunk 2077",
      "Tokyo nightlife photography"
    ],
    "mood_keywords": ["dystopian", "mysterious", "energetic", "urban", "futuristic", "gritty"],
    "best_for_genres": ["sci-fi", "tech", "urban", "fashion", "mystery"],
    "best_for_platforms": ["tiktok", "reels", "shorts", "youtube"],
    "prompt_keywords": [
      "cyberpunk",
      "neon lights",
      "rain-slicked streets",
      "blade runner aesthetic",
      "tokyo night",
      "holographic",
      "dystopian city",
      "neon noir",
      "pink and cyan neon",
      "wet reflections",
      "cinematic lighting"
    ],
    "example_images": ["URLs to cyberpunk reference images"],
    "example_videos": ["Blade Runner 2049 scenes, cyberpunk TikToks"],
    "do_use": [
      "High contrast neon vs dark",
      "Rain and wet surfaces",
      "Asian-inspired neon signs",
      "Reflections in puddles",
      "Bokeh from neon lights",
      "Steam/fog for atmosphere"
    ],
    "dont_use": [
      "Bright daylight",
      "Warm natural colors",
      "Pastoral/nature elements",
      "Soft pastel tones",
      "Vintage film grain"
    ],
    "difficulty": "moderate",
    "source": "Analysis of Blade Runner, cyberpunk aesthetics wiki, Midjourney cyberpunk explorations"
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
    "required": ["id", "name", "description", "color_palette", "mood_keywords", "prompt_keywords"],
    "properties": {
      "id": {"type": "string", "pattern": "^style_[0-9]{3}$"},
      "name": {"type": "string"},
      "aliases": {"type": "array", "items": {"type": "string"}},
      "description": {"type": "string", "minLength": 100},
      "color_palette": {
        "type": "object",
        "properties": {
          "primary_colors": {"type": "array", "items": {"type": "string", "pattern": "^#[0-9A-F]{6}$"}},
          "secondary_colors": {"type": "array"},
          "accent_colors": {"type": "array"},
          "color_mood": {"type": "string"},
          "saturation_level": {"type": "string"},
          "contrast_level": {"type": "string"}
        }
      },
      "lighting_characteristics": {"type": "object"},
      "texture": {"type": "object"},
      "composition_style": {"type": "array"},
      "camera_characteristics": {"type": "object"},
      "post_processing": {"type": "object"},
      "era": {"type": "string"},
      "cultural_references": {"type": "array", "items": {"type": "string"}},
      "mood_keywords": {"type": "array", "items": {"type": "string"}},
      "best_for_genres": {"type": "array"},
      "best_for_platforms": {"type": "array"},
      "prompt_keywords": {"type": "array", "items": {"type": "string"}},
      "example_images": {"type": "array"},
      "example_videos": {"type": "array"},
      "do_use": {"type": "array"},
      "dont_use": {"type": "array"},
      "difficulty": {"type": "string", "enum": ["easy", "moderate", "difficult"]},
      "source": {"type": "string"}
    }
  }
}
```

---

## ИСТОЧНИКИ ДЛЯ ПОИСКА

### Обязательные:
1. **Aesthetics Wiki** — https://aesthetics.fandom.com/
2. **Pinterest** — aesthetic boards
3. **Midjourney** — style exploration
4. **Lexica.art** — visual style search

### Design:
5. **Behance** — https://www.behance.net/
6. **Dribbble** — https://dribbble.com/
7. **Adobe Color** — https://color.adobe.com/
8. **Coolors** — https://coolors.co/

### Film & Photo:
9. **Shot Deck** — https://shotdeck.com/
10. **Film Grab** — https://film-grab.com/
11. **Cinematography Database**

### AI Art:
12. **Civitai** — https://civitai.com/
13. **PromptHero** — https://prompthero.com/
14. **Stable Diffusion Reddit** — r/StableDiffusion

---

## КРИТЕРИИ КАЧЕСТВА

| Критерий | Требование |
|----------|------------|
| Visual clarity | Стиль легко узнаваем |
| Color specificity | Hex codes для primary colors |
| Examples | Минимум 2 visual examples |
| AI compatibility | Prompt keywords для AI generation |
| References | Cultural/film references указаны |
| Applicability | Работает для multiple subjects |
| Technical detail | Описание lighting, texture, grading |

---

## КОЛИЧЕСТВО ЗАПИСЕЙ

**Минимум: 50 стилей**
- Popular/Internet aesthetics: 15
- Cinematic styles: 10
- Art movements: 5
- Commercial styles: 5
- Era-specific: 5
- Platform-specific: 5
- Other/Experimental: 5

---

## ПРИМЕР ГОТОВЫХ ДАННЫХ

```json
[
  {
    "id": "style_001",
    "name": "Film Noir",
    "aliases": ["Classic Noir", "Black and White Crime"],
    "description": "High-contrast black and white cinematography with dramatic shadow play. Deep shadows (chiaroscuro lighting), venetian blind shadows, rain-slicked streets, and femme fatale mystique. Emphasizes moral ambiguity through visual darkness. Low-key lighting dominates.",
    "color_palette": {
      "primary_colors": ["#000000", "#FFFFFF"],
      "secondary_colors": ["#1A1A1A", "#E8E8E8"],
      "accent_colors": ["#404040"],
      "color_mood": "monochrome high-contrast",
      "saturation_level": "none (B&W)",
      "contrast_level": "very high"
    },
    "lighting_characteristics": {
      "primary_lighting": "hard dramatic single-source",
      "shadows": "deep black chiaroscuro",
      "highlights": "controlled bright highlights",
      "mood": "dark mysterious"
    },
    "texture": {
      "grain": "film grain heavy",
      "sharpness": "sharp with atmospheric smoke",
      "surface": "matte with wet streets glossy",
      "noise": "vintage film grain"
    },
    "composition_style": ["deep-shadows", "diagonal-lines", "low-angles", "silhouettes"],
    "camera_characteristics": {
      "movement": "static or slow deliberate",
      "focal_length_preference": "wide to normal",
      "depth_of_field": "deep for full-scene clarity"
    },
    "post_processing": {
      "color_grading": "black and white conversion, crushed blacks",
      "vignette": "heavy",
      "bloom/glow": "none",
      "film_effects": "heavy grain, slight scratches",
      "sharpening": "moderate"
    },
    "era/time_period": "1940s-1950s",
    "cultural_references": [
      "The Maltese Falcon",
      "Double Indemnity",
      "Sunset Boulevard",
      "Touch of Evil",
      "Sin City (modern noir)"
    ],
    "mood_keywords": ["dark", "mysterious", "dramatic", "morally-ambiguous", "cynical"],
    "best_for_genres": ["crime", "mystery", "thriller", "drama"],
    "best_for_platforms": ["youtube", "vimeo", "shorts"],
    "prompt_keywords": [
      "film noir",
      "black and white",
      "chiaroscuro lighting",
      "venetian blind shadows",
      "1940s crime",
      "dramatic shadows",
      "high contrast B&W",
      "femme fatale",
      "rain-slicked streets",
      "detective aesthetic"
    ],
    "do_use": [
      "Single hard light source",
      "Venetian blind shadows",
      "Smoke/fog for atmosphere",
      "Low-key lighting",
      "Silhouettes",
      "Rain effects"
    ],
    "dont_use": [
      "Bright even lighting",
      "Color (stay B&W)",
      "Soft romantic lighting",
      "Cheerful subjects"
    ],
    "difficulty": "moderate",
    "source": "Classic film noir analysis + ASC cinematography articles"
  }
]
```
