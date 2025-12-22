# 02 - Дашборд пользователя

## Цель
Рабочий дашборд с реальными данными: статистика, последние видео, квоты.

## Что реализовать

### API Routes
- `src/app/api/stats/route.ts` - статистика пользователя
- `src/app/api/videos/route.ts` - список видео (jobs + renders)
- `src/app/api/quota/route.ts` - текущие квоты

### Zustand Stores
- `src/stores/user-store.ts` - профиль, org, квоты
- `src/stores/videos-store.ts` - список видео

### TanStack Query
- `src/lib/queries/use-stats.ts`
- `src/lib/queries/use-videos.ts`
- `src/lib/queries/use-quota.ts`

### Компоненты
- `src/components/dashboard/stats-cards.tsx` - 4 карточки статистики
- `src/components/dashboard/recent-videos.tsx` - последние 5 видео
- `src/components/dashboard/quota-progress.tsx` - прогресс квот
- `src/components/dashboard/quick-actions.tsx`

### Обновить страницы
- `src/app/(dashboard)/dashboard/page.tsx` - реальные данные
- `src/app/(dashboard)/videos/page.tsx` - список всех видео с пагинацией

## Зависимости
- 01-auth (нужен user_id для запросов)

## Файлы для изменения
- Существующий dashboard/page.tsx - заменить моки на реальные данные
