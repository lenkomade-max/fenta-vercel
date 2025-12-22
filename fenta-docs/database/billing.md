# База данных — Billing & Usage

## usage_records

Детальное отслеживание использования (партиционируется).

```sql
CREATE TABLE usage_records (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID NOT NULL REFERENCES orgs(id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id),
  job_id UUID REFERENCES jobs(id) ON DELETE SET NULL,

  resource_type TEXT NOT NULL, -- llm_tokens, kai_credits, render_seconds, storage

  -- LLM specific
  llm_tokens_prompt INTEGER,
  llm_tokens_output INTEGER,
  llm_model TEXT,

  -- KAI specific
  kai_credits INTEGER,
  kai_model TEXT,

  -- Render specific
  render_seconds DECIMAL(10, 2),
  render_profile TEXT,

  -- Storage specific
  storage_bytes BIGINT,

  -- Cost
  cost_usd DECIMAL(10, 4) NOT NULL,

  created_at TIMESTAMPTZ DEFAULT NOW()
) PARTITION BY RANGE (created_at);

-- Партиции по месяцам
CREATE TABLE usage_records_2024_12 PARTITION OF usage_records
  FOR VALUES FROM ('2024-12-01') TO ('2025-01-01');

CREATE TABLE usage_records_2025_01 PARTITION OF usage_records
  FOR VALUES FROM ('2025-01-01') TO ('2025-02-01');

-- Индексы
CREATE INDEX idx_usage_records_org ON usage_records(org_id, created_at);
CREATE INDEX idx_usage_records_user ON usage_records(user_id);
CREATE INDEX idx_usage_records_job ON usage_records(job_id);
CREATE INDEX idx_usage_records_resource ON usage_records(resource_type);
```

**Примеры записей:**
```json
// LLM tokens
{
  "resource_type": "llm_tokens",
  "llm_tokens_prompt": 500,
  "llm_tokens_output": 1200,
  "llm_model": "gpt-4",
  "cost_usd": 0.102
}

// KAI credits
{
  "resource_type": "kai_credits",
  "kai_credits": 100,
  "kai_model": "sora",
  "cost_usd": 4.00
}

// Render seconds
{
  "resource_type": "render_seconds",
  "render_seconds": 90.5,
  "render_profile": "9x16_1080p",
  "cost_usd": 1.36
}
```

---

## quota_limits

Лимиты и текущее использование организации.

```sql
CREATE TABLE quota_limits (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID UNIQUE NOT NULL REFERENCES orgs(id) ON DELETE CASCADE,

  -- Monthly limits (NULL = unlimited)
  tokens_limit INTEGER,
  render_seconds_limit INTEGER,
  kai_credits_limit INTEGER,
  storage_bytes_limit BIGINT,

  -- Current usage (reset monthly)
  tokens_used INTEGER DEFAULT 0,
  render_seconds_used DECIMAL(10, 2) DEFAULT 0,
  kai_credits_used INTEGER DEFAULT 0,
  storage_bytes_used BIGINT DEFAULT 0,

  -- Overage settings
  allow_overage BOOLEAN DEFAULT true,
  overage_cap_usd DECIMAL(10, 2),

  -- Reset timestamp
  reset_at TIMESTAMPTZ NOT NULL,

  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_quota_limits_org ON quota_limits(org_id);
```

**Пример по тарифам:**
```sql
-- Free tier
INSERT INTO quota_limits (org_id, tokens_limit, render_seconds_limit, kai_credits_limit, storage_bytes_limit, allow_overage, reset_at)
VALUES ('org_free', 100000, 300, 50, 5368709120, false, '2025-01-01');

-- Pro tier
INSERT INTO quota_limits (org_id, tokens_limit, render_seconds_limit, kai_credits_limit, storage_bytes_limit, allow_overage, reset_at)
VALUES ('org_pro', 5000000, 10800, 2000, 214748364800, true, '2025-01-01');
```

---

## invoices

Счета за использование.

```sql
CREATE TABLE invoices (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID NOT NULL REFERENCES orgs(id) ON DELETE CASCADE,

  stripe_invoice_id TEXT UNIQUE,

  amount_usd DECIMAL(10, 2) NOT NULL,
  status TEXT NOT NULL, -- draft, open, paid, void

  period_start DATE NOT NULL,
  period_end DATE NOT NULL,

  line_items JSONB DEFAULT '[]',

  paid_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_invoices_org ON invoices(org_id);
CREATE INDEX idx_invoices_stripe ON invoices(stripe_invoice_id);
CREATE INDEX idx_invoices_period ON invoices(period_start, period_end);
```

**Структура line_items:**
```json
[
  {
    "description": "Pro Plan - Monthly Subscription",
    "quantity": 1,
    "unit_price": 99.00,
    "amount": 99.00
  },
  {
    "description": "LLM Tokens - Overage (500K tokens)",
    "quantity": 500000,
    "unit_price": 0.0000008,
    "amount": 0.40
  },
  {
    "description": "KAI Credits - Overage (150 credits)",
    "quantity": 150,
    "unit_price": 0.04,
    "amount": 6.00
  }
]
```

---

## credit_packs

Предоплаченные пакеты кредитов.

```sql
CREATE TABLE credit_packs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID NOT NULL REFERENCES orgs(id) ON DELETE CASCADE,

  pack_type TEXT NOT NULL, -- small, medium, large
  credits_purchased INTEGER NOT NULL,
  credits_remaining INTEGER NOT NULL,
  price_usd DECIMAL(10, 2) NOT NULL,

  stripe_payment_id TEXT,

  purchased_at TIMESTAMPTZ DEFAULT NOW(),
  expires_at TIMESTAMPTZ -- NULL = never expires
);

CREATE INDEX idx_credit_packs_org ON credit_packs(org_id);
CREATE INDEX idx_credit_packs_remaining ON credit_packs(credits_remaining) WHERE credits_remaining > 0;
```

---

## integrations

Интеграции с внешними сервисами.

```sql
CREATE TABLE integrations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID NOT NULL REFERENCES orgs(id) ON DELETE CASCADE,

  provider TEXT NOT NULL, -- kai, openai, pexels, stripe
  status TEXT DEFAULT 'active', -- active, expired, revoked

  credentials JSONB NOT NULL, -- зашифрованные ключи
  config JSONB DEFAULT '{}',

  last_used_at TIMESTAMPTZ,
  expires_at TIMESTAMPTZ,

  created_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_integrations_org ON integrations(org_id);
CREATE INDEX idx_integrations_provider ON integrations(provider);
```

---

## kai_generations

Трекинг KAI генераций.

```sql
CREATE TABLE kai_generations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID NOT NULL REFERENCES orgs(id) ON DELETE CASCADE,
  job_id UUID REFERENCES jobs(id) ON DELETE SET NULL,

  type TEXT NOT NULL, -- image, video, edit, voice, music
  model TEXT NOT NULL, -- veo3, sora, flux-pro, elevenlabs, suno

  prompt TEXT NOT NULL,
  params JSONB DEFAULT '{}',

  status TEXT DEFAULT 'queued', -- queued, processing, completed, failed

  -- Results
  result_asset_ids UUID[],

  -- Cost
  credits_used INTEGER DEFAULT 0,
  cost_usd DECIMAL(10, 4) DEFAULT 0,

  -- External tracking
  external_task_id TEXT, -- KIE.ai taskId

  created_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  completed_at TIMESTAMPTZ
);

CREATE INDEX idx_kai_generations_org ON kai_generations(org_id);
CREATE INDEX idx_kai_generations_job ON kai_generations(job_id);
CREATE INDEX idx_kai_generations_status ON kai_generations(status);
CREATE INDEX idx_kai_generations_external ON kai_generations(external_task_id);
```

---

## mv_daily_usage (Materialized View)

Агрегированная статистика по дням.

```sql
CREATE MATERIALIZED VIEW mv_daily_usage AS
SELECT
  org_id,
  DATE(created_at) as date,
  SUM(CASE WHEN resource_type = 'llm_tokens'
    THEN COALESCE(llm_tokens_prompt, 0) + COALESCE(llm_tokens_output, 0)
    ELSE 0 END) as total_tokens,
  SUM(CASE WHEN resource_type = 'kai_credits' THEN kai_credits ELSE 0 END) as total_kai_credits,
  SUM(CASE WHEN resource_type = 'render_seconds' THEN render_seconds ELSE 0 END) as total_render_seconds,
  SUM(cost_usd) as total_cost_usd,
  COUNT(DISTINCT job_id) as job_count
FROM usage_records
GROUP BY org_id, DATE(created_at);

CREATE UNIQUE INDEX idx_mv_daily_usage ON mv_daily_usage(org_id, date);

-- Обновление (ежечасно через cron)
REFRESH MATERIALIZED VIEW CONCURRENTLY mv_daily_usage;
```

---

## Функции

### Проверка квоты

```sql
CREATE OR REPLACE FUNCTION check_quota(
  p_org_id UUID,
  p_tokens INTEGER DEFAULT 0,
  p_kai_credits INTEGER DEFAULT 0,
  p_render_seconds DECIMAL DEFAULT 0
)
RETURNS TABLE (
  allowed BOOLEAN,
  tokens_ok BOOLEAN,
  kai_ok BOOLEAN,
  render_ok BOOLEAN
) AS $$
DECLARE
  v_quota quota_limits%ROWTYPE;
BEGIN
  SELECT * INTO v_quota FROM quota_limits WHERE org_id = p_org_id;

  tokens_ok := v_quota.tokens_limit IS NULL
    OR (v_quota.tokens_used + p_tokens <= v_quota.tokens_limit)
    OR v_quota.allow_overage;

  kai_ok := v_quota.kai_credits_limit IS NULL
    OR (v_quota.kai_credits_used + p_kai_credits <= v_quota.kai_credits_limit)
    OR v_quota.allow_overage;

  render_ok := v_quota.render_seconds_limit IS NULL
    OR (v_quota.render_seconds_used + p_render_seconds <= v_quota.render_seconds_limit)
    OR v_quota.allow_overage;

  allowed := tokens_ok AND kai_ok AND render_ok;

  RETURN NEXT;
END;
$$ LANGUAGE plpgsql;
```

### Обновление квоты

```sql
CREATE OR REPLACE FUNCTION update_quota_usage()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE quota_limits
  SET
    tokens_used = tokens_used + COALESCE(NEW.llm_tokens_prompt, 0) + COALESCE(NEW.llm_tokens_output, 0),
    kai_credits_used = kai_credits_used + COALESCE(NEW.kai_credits, 0),
    render_seconds_used = render_seconds_used + COALESCE(NEW.render_seconds, 0),
    updated_at = NOW()
  WHERE org_id = NEW.org_id;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_quota
  AFTER INSERT ON usage_records
  FOR EACH ROW EXECUTE FUNCTION update_quota_usage();
```

---

## RLS Policies

```sql
ALTER TABLE usage_records ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Org members can view usage"
  ON usage_records FOR SELECT
  USING (
    org_id IN (SELECT org_id FROM org_members WHERE user_id = auth.uid())
  );

ALTER TABLE quota_limits ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Org members can view quotas"
  ON quota_limits FOR SELECT
  USING (
    org_id IN (SELECT org_id FROM org_members WHERE user_id = auth.uid())
  );

ALTER TABLE invoices ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Admins can view invoices"
  ON invoices FOR SELECT
  USING (
    org_id IN (
      SELECT org_id FROM org_members
      WHERE user_id = auth.uid()
      AND role IN ('owner', 'admin')
    )
  );
```
