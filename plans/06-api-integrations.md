# 06 - Внешние API интеграции

## Цель
Управление API ключами, интеграции с Pexels, ElevenLabs, OpenAI.

## Что реализовать

### API Routes
- `src/app/api/integrations/route.ts` - список интеграций org
- `src/app/api/integrations/[provider]/route.ts` - CRUD провайдера
- `src/app/api/integrations/test/route.ts` - тест подключения

### Провайдеры
- `src/lib/integrations/openrouter.ts` - роутер LLM (GPT, Claude, Llama и др.)
- `src/lib/integrations/pexels.ts` - stock видео/фото
- `src/lib/integrations/elevenlabs.ts` - TTS озвучка

### Компоненты
- `src/components/settings/integrations-list.tsx`
- `src/components/settings/integration-card.tsx`
- `src/components/settings/api-key-input.tsx` - маскированный ввод

### Страница
- `src/app/(dashboard)/settings/page.tsx` - настройки + интеграции

### API Keys пользователя
- `src/app/api/api-keys/route.ts` - CRUD API ключей
- `src/components/settings/api-keys-table.tsx`

## Зависимости
- 01-auth

## Ключевые референсы
- `fenta-docs/integrations/`
- `supabase/migrations/00005_billing.sql` - таблица integrations
