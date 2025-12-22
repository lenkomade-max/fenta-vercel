# 05 - Биллинг и подписки

## Цель
DodoPayments интеграция, подписки, usage tracking, invoices.

## Что реализовать

### DodoPayments интеграция (dodopayments.com)
- `src/lib/dodo/client.ts` - DodoPayments SDK
- `src/lib/dodo/webhooks.ts` - обработка Dodo events
- `src/lib/dodo/products.ts` - Free/Starter/Pro/Enterprise

### Webhook handlers
- `src/app/api/webhooks/dodo/route.ts` - subscription events

### API Routes
- `src/app/api/billing/checkout/route.ts` - checkout session
- `src/app/api/billing/portal/route.ts` - customer portal
- `src/app/api/billing/usage/route.ts` - текущее использование
- `src/app/api/billing/invoices/route.ts` - история счетов

### Zustand Store
- `src/stores/billing-store.ts` - plan, quota, usage

### Компоненты
- `src/components/billing/plan-selector.tsx` - выбор плана
- `src/components/billing/usage-chart.tsx` - график использования
- `src/components/billing/quota-alert.tsx` - предупреждение о лимитах
- `src/components/billing/invoice-list.tsx`
- `src/components/billing/upgrade-modal.tsx`

### Страница
- `src/app/(dashboard)/billing/page.tsx` - полная страница биллинга

### Usage tracking
- `src/lib/billing/track-usage.ts` - запись в usage_records
- `src/lib/billing/check-quota.ts` - проверка лимитов

## Зависимости
- 01-auth, 02-dashboard

## Ключевые референсы
- `fenta-docs/billing/overview.md`
- `supabase/migrations/00005_billing.sql`
