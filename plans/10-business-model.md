# 10 - Бизнес-модель и Pricing

## Принцип

```
Пользователь видит: Sora, Claude, Flux, Veo...
Пользователь НЕ видит: KIE.ai, OpenRouter (внутренние провайдеры)

Наценка = x2 от себестоимости
Модель = Подписка + Кредиты
```

---

## Себестоимость (что платим мы)

### VIDEO (через KIE.ai)

| Модель | Наша цена | x2 Наценка | За что |
|--------|-----------|------------|--------|
| Sora 2 | $0.15 | $0.30 | 10 сек видео |
| Sora 2 Pro | $0.45 | $0.90 | 10 сек HD |
| Veo 3.1 | $0.35 | $0.70 | 10 сек видео |
| Veo 3.1 Fast | $0.28 | $0.56 | 10 сек видео |
| Kling 2.5 | $0.25 | $0.50 | 5 сек видео |
| Runway Gen-3 | $0.35 | $0.70 | 5 сек видео |
| Minimax | $0.25 | $0.50 | 5 сек видео |
| Hailuo | $0.30 | $0.60 | 5 сек видео |
| Wan 2.5 | $0.30 | $0.60 | 5 сек видео |
| Seedance | $0.22 | $0.44 | 5 сек видео |

### IMAGE (через KIE.ai)

| Модель | Наша цена | x2 Наценка | За что |
|--------|-----------|------------|--------|
| GPT-4o Image | $0.05 | $0.10 | 1 изображение |
| Flux Kontext | $0.04 | $0.08 | 1 изображение |
| Midjourney | $0.12 | $0.24 | 4 изображения |
| Seedream V4 | $0.02 | $0.04 | 1 изображение |
| Qwen Image | $0.03 | $0.06 | 1 изображение |

### MUSIC (через KIE.ai)

| Модель | Наша цена | x2 Наценка | За что |
|--------|-----------|------------|--------|
| Suno V4 | $0.10 | $0.20 | 1 трек ~2 мин |
| Suno V4.5 | $0.12 | $0.24 | 1 трек ~4 мин |
| Suno V5 | $0.15 | $0.30 | 1 трек ~4 мин |

### LLM / AI Agent (через OpenRouter)

| Модель | Input/1M | Output/1M | x2 Input | x2 Output |
|--------|----------|-----------|----------|-----------|
| GPT-4o | $2.50 | $10 | $5 | $20 |
| GPT-4o mini | $0.15 | $0.60 | $0.30 | $1.20 |
| Claude 3.5 Sonnet | $3 | $15 | $6 | $30 |
| Claude 3.5 Haiku | $1 | $5 | $2 | $10 |
| Claude 3 Opus | $15 | $75 | $30 | $150 |
| Llama 3.1 70B | $0.50 | $0.75 | $1 | $1.50 |
| Gemini 1.5 Pro | $2.50 | $10 | $5 | $20 |

### AUDIO TTS (через KIE.ai / ElevenLabs)

| Модель | Наша цена | x2 Наценка | За что |
|--------|-----------|------------|--------|
| ElevenLabs TTS | $0.03 | $0.06 | 1000 символов |
| Kokoro (свой) | $0.00 | $0.02 | 1000 символов |

---

## Система кредитов

**1 кредит = $0.01**

### Конвертация в кредиты

| Действие | Кредиты | Для пользователя |
|----------|---------|------------------|
| Sora 2 (10 сек) | 30 | "30 кредитов" |
| Veo 3.1 (10 сек) | 70 | "70 кредитов" |
| Kling (5 сек) | 50 | "50 кредитов" |
| Flux Image | 8 | "8 кредитов" |
| Midjourney (4 img) | 24 | "24 кредита" |
| Suno Track | 20 | "20 кредитов" |
| Claude Sonnet (1K tokens) | 2 | "2 кредита" |
| GPT-4o (1K tokens) | 2 | "2 кредита" |
| TTS (1000 chars) | 6 | "6 кредитов" |

---

## Планы подписки

### Free - $0/мес
- 50 кредитов при регистрации (одноразово)
- 10 кредитов/день (бесплатные модели)
- Доступ: Seedream, Kokoro TTS, Llama 3.1
- Водяной знак на видео
- 720p макс качество
- 3 workflow максимум

### Starter - $19/мес
- 500 кредитов/мес
- Доступ: все базовые модели
- Без водяного знака
- 1080p качество
- 10 workflows
- 5 scheduled jobs
- Email поддержка

### Pro - $49/мес
- 2000 кредитов/мес
- Доступ: ВСЕ модели (Sora, Claude Opus...)
- 4K качество
- Безлимит workflows
- Безлимит schedules
- Приоритетная генерация
- API доступ (лимит)
- Chat поддержка

### Business - $149/мес
- 8000 кредитов/мес
- Всё из Pro
- Team (5 пользователей)
- Полный API доступ
- Webhook интеграции
- Приоритетная поддержка
- Custom branding

### Enterprise - Custom
- Безлимит кредитов
- Dedicated infrastructure
- SLA 99.9%
- Custom integrations
- Account manager

---

## Дополнительные кредиты

| Пакет | Цена | Кредиты | Бонус |
|-------|------|---------|-------|
| Small | $10 | 1000 | - |
| Medium | $25 | 2800 | +12% |
| Large | $50 | 6000 | +20% |
| XL | $100 | 13000 | +30% |

---

## Пример расчёта для пользователя

### Создание 1-минутного видео (True Crime)

| Этап | Модель | Кредиты |
|------|--------|---------|
| Сценарий | Claude Sonnet (~2K tokens) | 4 |
| 6 видео-сегментов | Kling × 6 | 300 |
| Озвучка (1 мин) | ElevenLabs | 36 |
| Музыка | Suno | 20 |
| Рендер | FantaProjekt | 10 |
| **ИТОГО** | | **370 кредитов** |

**На плане Pro (2000 кр/мес):** ~5 видео в месяц включено

---

## Маржинальность

| Компонент | Себестоимость | Цена | Маржа |
|-----------|---------------|------|-------|
| Video (avg) | $0.30 | $0.60 | 50% |
| Image (avg) | $0.04 | $0.08 | 50% |
| LLM (avg) | $0.01 | $0.02 | 50% |
| TTS | $0.03 | $0.06 | 50% |
| **Подписка** | - | $19-149 | 100% |

**Целевая маржа: 50% на кредитах + 100% на подписке**

---

## Что включено в подписку (без кредитов)

- Доступ к платформе
- Workflow Builder
- Template Editor
- AI Agent помощник
- Базовое хранилище (5-50 GB)
- Экспорт в соцсети (Pro+)
- Analytics (Pro+)
- API (Pro+)

---

## Ограничения по планам

| Feature | Free | Starter | Pro | Business |
|---------|------|---------|-----|----------|
| Workflows | 3 | 10 | ∞ | ∞ |
| Schedules | 0 | 5 | ∞ | ∞ |
| Storage | 1 GB | 10 GB | 50 GB | 200 GB |
| Export quality | 720p | 1080p | 4K | 4K |
| Watermark | Yes | No | No | No |
| API | No | No | Yes (limit) | Yes |
| Team | 1 | 1 | 1 | 5 |
| Support | Docs | Email | Chat | Priority |

---

## Реализация в БД

```sql
-- plans table
CREATE TABLE plans (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  price_monthly INTEGER, -- cents
  credits_monthly INTEGER,
  features JSONB,
  limits JSONB
);

-- usage tracking
CREATE TABLE usage_records (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES users,
  resource_type TEXT, -- 'video', 'image', 'llm', 'tts', 'render'
  model TEXT,
  credits_used INTEGER,
  cost_usd DECIMAL(10,4),
  metadata JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- credit balance
CREATE TABLE credit_balances (
  user_id UUID PRIMARY KEY REFERENCES users,
  subscription_credits INTEGER DEFAULT 0,
  purchased_credits INTEGER DEFAULT 0,
  bonus_credits INTEGER DEFAULT 0,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

---

## API для проверки баланса

```typescript
// Check before generation
async function checkCredits(userId: string, required: number): Promise<boolean> {
  const balance = await getBalance(userId);
  const total = balance.subscription + balance.purchased + balance.bonus;
  return total >= required;
}

// Deduct credits (order: bonus → subscription → purchased)
async function deductCredits(userId: string, amount: number, metadata: object) {
  // 1. Deduct from bonus first
  // 2. Then subscription
  // 3. Then purchased
  // 4. Log to usage_records
}
```

---

## Sources

- [KIE.ai Sora 2 Pricing](https://kie.ai/sora-2)
- [KIE.ai Veo 3 Pricing](https://kie.ai/v3-api-pricing)
- [OpenRouter Pricing](https://openrouter.ai/pricing)
