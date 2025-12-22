# Billing — Отслеживание использования

## Real-Time Metering

Каждая тарифицируемая операция записывается в `usage_records`:

```sql
INSERT INTO usage_records (
  org_id, user_id, job_id,
  resource_type,
  llm_tokens_prompt, llm_tokens_output,
  kai_credits, render_seconds,
  cost_usd, created_at
) VALUES (
  'org_abc123', 'user_xyz789', 'job_def456',
  'llm_tokens',
  500, 1200,
  0, 0,
  0.0102, NOW()
);
```

---

## Проверка квоты

Перед выполнением job:

```typescript
async function checkQuota(
  orgId: string,
  estimatedUsage: UsageEstimate
): Promise<QuotaCheckResult> {
  const quota = await getQuotaLimit(orgId);
  const used = await getCurrentUsage(orgId);

  const checks = {
    tokens: used.tokens + estimatedUsage.tokens <= quota.tokens_limit,
    kaiCredits: used.kaiCredits + estimatedUsage.kaiCredits <= quota.kai_credits_limit,
    renderSeconds: used.renderSeconds + estimatedUsage.renderSeconds <= quota.render_seconds_limit,
  };

  return {
    allowed: Object.values(checks).every(Boolean),
    checks,
    overage: calculateOverage(quota, used, estimatedUsage)
  };
}
```

---

## Оценка стоимости перед job

```http
POST /v1/workflows/{id}/estimate
```

**Response:**
```json
{
  "estimated": {
    "tokens": 5000,
    "renderSeconds": 45.0,
    "kaiCredits": 120,
    "totalUsd": 0.87,
    "duration": "2-5 minutes"
  },
  "breakdown": [
    {
      "component": "Script Generation",
      "resource": "llm_tokens",
      "quantity": 500,
      "cost": 0.02
    },
    {
      "component": "Video Generation (Sora)",
      "resource": "kai_credits",
      "quantity": 100,
      "cost": 0.40
    },
    {
      "component": "Voice Synthesis",
      "resource": "llm_tokens",
      "quantity": 1200,
      "cost": 0.05
    },
    {
      "component": "Final Render",
      "resource": "render_seconds",
      "quantity": 45,
      "cost": 0.40
    }
  ],
  "quotaStatus": {
    "tokens": {
      "available": 750000,
      "required": 5000,
      "sufficient": true
    },
    "kaiCredits": {
      "available": 1850,
      "required": 120,
      "sufficient": true
    },
    "renderSeconds": {
      "available": 9500,
      "required": 45,
      "sufficient": true
    }
  }
}
```

---

## Budget Constraints

Установка бюджетных лимитов на job:

```http
POST /v1/jobs
{
  "template_id": "tmpl_shorts_v1",
  "sources": [...],
  "budget": {
    "max_cost_usd": 0.50,
    "max_tokens": 10000,
    "max_kai_credits": 100,
    "max_render_seconds": 60
  }
}
```

**Поведение при превышении бюджета:**
1. Job приостанавливается
2. Пользователь получает уведомление
3. Выбор: подтвердить overage или отменить

---

## API отслеживания

### Текущая квота

```http
GET /v1/usage/quota
```

**Response:**
```json
{
  "plan": "pro",
  "limits": {
    "tokens": 5000000,
    "renderSeconds": 10800,
    "kaiCredits": 2000,
    "storage": 214748364800
  },
  "used": {
    "tokens": 2350000,
    "renderSeconds": 8950,
    "kaiCredits": 1850,
    "storage": 185000000000
  },
  "remaining": {
    "tokens": 2650000,
    "renderSeconds": 1850,
    "kaiCredits": 150,
    "storage": 29748364800
  },
  "resetAt": "2025-02-01T00:00:00Z"
}
```

### Статистика использования

```http
GET /v1/usage?startDate=2025-01-01&endDate=2025-01-31&groupBy=day
```

**Response:**
```json
{
  "period": {
    "startDate": "2025-01-01",
    "endDate": "2025-01-31"
  },
  "summary": {
    "llmTokens": {
      "prompt": 125000,
      "output": 385000,
      "total": 510000
    },
    "kaiCredits": 1850,
    "renderSeconds": 8950.5,
    "storage": 185000000000,
    "totalCostUsd": 125.80
  },
  "breakdown": [
    {
      "date": "2025-01-01",
      "tokens": 18000,
      "kaiCredits": 80,
      "renderSeconds": 350,
      "costUsd": 5.20
    }
  ]
}
```

---

## Агрегация данных

Ежедневная агрегация в materialized view:

```sql
SELECT
  org_id,
  date,
  total_tokens,
  total_kai_credits,
  total_render_seconds,
  total_cost_usd
FROM mv_daily_usage
WHERE org_id = 'org_abc123'
  AND date >= '2025-01-01'
ORDER BY date DESC;
```

---

## Dashboard метрики

### Текущий период

- Токены использовано / осталось
- KAI кредиты использовано / осталось
- Render seconds использовано / осталось
- Storage использовано / осталось
- Оценка превышения

### Исторические данные

- Тренд использования за 30 дней
- Breakdown по типам ресурсов
- Топ workflow по стоимости
- Средняя стоимость видео

### Прогнозы

- Оценка использования к концу месяца
- Проекция превышения
- Рекомендация по upgrade

---

## Soft Limits vs Hard Limits

### Soft Limits

- Предупреждение при 80% использования
- Алерт при 90% использования
- Email уведомление owner/admin

### Hard Limits

- **Free tier:** Блокировка выполнения job при 100% квоты
- **Paid tiers:** Разрешение overage с дополнительной оплатой

---

## Настройки квоты

```json
{
  "quota_settings": {
    "allow_overage": true,
    "overage_cap_usd": 100.00,
    "pause_on_cap": true,
    "alerts": {
      "at_80_percent": true,
      "at_90_percent": true,
      "daily_digest": true
    }
  }
}
```

### API обновления настроек

```http
PATCH /v1/billing/settings
{
  "allowOverage": true,
  "overageCapUsd": 200.00,
  "alerts": {
    "at80Percent": true,
    "at90Percent": true,
    "dailyDigest": false
  }
}
```

---

## Алерты и уведомления

### Квотные алерты

**Email:**
- 80%: "You're approaching your monthly limit"
- 90%: "Running low on quota"
- 100% (Free): "Quota limit reached"
- Daily digest: Usage summary

**In-App:**
- Toast при 90%
- Banner на dashboard при 95%
- Modal перед job если недостаточно квоты

**Webhook:**
```json
{
  "event": "quota.warning",
  "data": {
    "org_id": "org_abc123",
    "resource": "kai_credits",
    "used": 1800,
    "limit": 2000,
    "percentage": 90
  }
}
```

### Биллинговые алерты

- Неудачный платеж (авто-retry 3 раза)
- Истекает карта (за 30 дней)
- Подписка отменена
- Приближение к overage cap
- Overage cap достигнут
