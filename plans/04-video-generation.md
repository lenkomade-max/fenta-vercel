# 04 - Генерация видео

## Цель
Интеграция с FantaProjekt (рендер) и KIE.ai (100+ AI моделей), real-time прогресс.

## Что реализовать

### KIE.ai — единый API к 100+ моделям
Одна интеграция даёт доступ ко всем топовым моделям:
- **Видео:** Sora, Veo, Minimax, BIO3, Runway, Pika, Kling и др.
- **Фото:** Midjourney, DALL-E, Stable Diffusion, Flux и др.
- **Редактирование:** Inpaint, Outpaint, Upscale, Style Transfer

### API клиенты
- `src/lib/api/fantaprojekt.ts` - клиент FantaProjekt API (рендер/монтаж)
- `src/lib/api/kie-ai.ts` - клиент KIE.ai API (100+ генеративных моделей)

### Webhook handlers
- `src/app/api/webhooks/fantaprojekt/route.ts` - статус рендера
- `src/app/api/webhooks/kie-ai/route.ts` - результат AI генерации

### Job система
- `src/lib/jobs/create-job.ts` - создание задачи
- `src/lib/jobs/execute-workflow.ts` - выполнение workflow графа
- `src/lib/jobs/node-executors/` - исполнители для каждого типа узла

### Real-time прогресс
- `src/hooks/use-job-progress.ts` - Supabase realtime подписка
- `src/components/video/job-progress.tsx` - UI прогресса

### Компоненты
- `src/components/video/video-preview.tsx` - превью готового видео
- `src/components/video/video-player.tsx` - плеер с контролами
- `src/components/video/download-button.tsx`

### Страницы
- `src/app/(dashboard)/create/page.tsx` - простое создание
- `src/app/(dashboard)/history/page.tsx` - история всех jobs

## Зависимости
- 01-auth, 02-dashboard, 03-workflows

## Логика сегментации (длинные видео из коротких)

Модели генерят 8-15 сек за раз. Для 60 сек ролика:
1. Разбить сценарий на 6-8 сегментов (beats)
2. Параллельная генерация через KIE.ai (разные seed)
3. Fallback на Pexels если сегмент не вышел
4. Склейка в FantaProjekt по шаблону монтажа

```
60 сек ролик = 6 сегментов × 10 сек
├── Segment 1: KIE.ai (Sora) → 10 сек
├── Segment 2: KIE.ai (Veo) → 10 сек
├── Segment 3: Pexels fallback → 10 сек
├── ...
└── Склейка в FantaProjekt
```

## Ключевые референсы
- `fenta-docs/api/fantaprojekt.md`
- `fenta-docs/integrations/kie-ai.md`
- `supabase/migrations/00004_jobs.sql`
