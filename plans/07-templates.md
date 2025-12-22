# 07 - Монтажные шаблоны (Templates)

## Цель
Визуальное оформление видео: субтитры, оверлеи, переходы, стили. Отдельно от жанров контента.

**Жанр** = ЧТО рассказываем (True Crime, How-to...)
**Template** = КАК выглядит (шрифты, цвета, анимации...)

---

## Структура Template

```json
{
  "id": "tmpl_bold_shorts",
  "name": "Bold Shorts",
  "aspect": "9:16",
  "resolution": "1080x1920",

  "tracks": [
    {"type": "video", "id": "main", "z": 0},
    {"type": "subtitle", "id": "subs", "z": 10},
    {"type": "overlay", "id": "top", "z": 20}
  ],

  "subtitle_style": {
    "font": "Inter Bold",
    "size": 48,
    "color": "#FFFFFF",
    "background": "box",
    "animation": "word_bounce",
    "position": "center"
  },

  "overlays": [
    {"track": "top", "type": "text", "content": "HOOK TEXT", "animation": "slide_down"}
  ],

  "transitions": "cut",
  "music_ducking": true,

  "rules": {
    "min_scene": 1.5,
    "max_scene": 4.0,
    "cuts": "auto_by_speech"
  }
}
```

---

## Базовые Templates (V1)

### 1. Bold Shorts
- Крупные белые субтитры, чёрный box
- Word-by-word анимация
- Для: Facts, How-to, Explainers

### 2. Cinematic Dark
- Тонкие субтитры снизу
- Без анимации, минимализм
- Для: True Crime, Stories, Documentary

### 3. Karaoke Pop
- Цветные субтитры, bounce эффект
- Highlight текущего слова
- Для: Entertainment, Quiz, Fun Facts

### 4. News Lower Third
- Субтитры как в новостях (нижняя плашка)
- Ticker стиль
- Для: News, Explainers, B2B

### 5. Clean Minimal
- Мелкие субтитры, без эффектов
- Максимум видео, минимум UI
- Для: Aesthetic, ASMR, Visual

### 6. Brand Heavy
- Лого, CTA, watermark
- Корпоративные цвета
- Для: E-commerce, Product, B2B

---

## Что реализовать

### Компоненты
- `src/components/templates/template-editor.tsx` - визуальный редактор
- `src/components/templates/template-preview.tsx` - live превью
- `src/components/templates/subtitle-styler.tsx` - настройка субтитров
- `src/components/templates/overlay-manager.tsx` - управление оверлеями
- `src/components/templates/template-card.tsx` - карточка в галерее

### API Routes
- `src/app/api/templates/route.ts` - CRUD templates
- `src/app/api/templates/[id]/route.ts` - конкретный template
- `src/app/api/templates/[id]/preview/route.ts` - генерация превью

### Zustand Store
- `src/stores/template-store.ts` - текущий template, редактирование

### Страницы
- `src/app/(dashboard)/templates/page.tsx` - галерея templates
- `src/app/(dashboard)/templates/[id]/page.tsx` - редактор
- `src/app/(dashboard)/templates/new/page.tsx` - создание

---

## Зависимости
- 01-auth
- 04-video-generation (для превью)

## Ключевые референсы
- `fenta-docs/templates/`
- `supabase/migrations/00003_content.sql` - таблица templates
