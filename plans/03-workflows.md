# 03 - Workflow Builder (React Flow)

## Цель
Визуальный редактор пайплайнов видеопроизводства с drag-n-drop узлами.
**+ AI-агент который сам строит workflow из 6 вопросов** (см. 09-ai-agent.md)

## Что реализовать

### Установить
- `npm install reactflow`

### Типы узлов
- `src/components/workflow/nodes/input-stock.tsx` - Pexels/stock
- `src/components/workflow/nodes/input-kai.tsx` - KIE.ai генерация
- `src/components/workflow/nodes/script-generate.tsx` - LLM скрипт
- `src/components/workflow/nodes/voice-tts.tsx` - TTS озвучка
- `src/components/workflow/nodes/subtitle-auto.tsx` - авто-субтитры
- `src/components/workflow/nodes/edit-timeline.tsx` - сборка
- `src/components/workflow/nodes/output-render.tsx` - рендер

### Основные компоненты
- `src/components/workflow/workflow-canvas.tsx` - React Flow canvas
- `src/components/workflow/node-palette.tsx` - панель узлов слева
- `src/components/workflow/node-inspector.tsx` - редактор параметров
- `src/components/workflow/workflow-toolbar.tsx` - save, run, preview

### Zustand Store
- `src/stores/workflow-store.ts` - nodes, edges, selectedNode, actions

### API Routes
- `src/app/api/workflows/route.ts` - CRUD workflows
- `src/app/api/workflows/[id]/route.ts` - конкретный workflow
- `src/app/api/workflows/[id]/run/route.ts` - запуск workflow

### Страницы
- `src/app/(dashboard)/workflows/page.tsx` - список workflows
- `src/app/(dashboard)/workflows/[id]/page.tsx` - редактор
- `src/app/(dashboard)/workflows/new/page.tsx` - создание

## Два режима создания

### 1. AI-режим (для новичков)
Агент задаёт 6 вопросов → автоматически строит workflow.
Пользователь только подтверждает и запускает.
(Подробнее: 09-ai-agent.md)

### 2. Manual-режим (для продвинутых)
Drag-n-drop ноды, ручная настройка каждого параметра.
Полный контроль над пайплайном.

---

## Зависимости
- 01-auth, 02-dashboard
- 09-ai-agent (для AI-режима)

## Ключевые референсы
- `fenta-docs/workflows/overview.md`
- `supabase/migrations/00003_content.sql`
