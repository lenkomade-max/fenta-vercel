# Billing & Usage System Documentation

## Overview

Fenta Web uses a hybrid billing model combining **subscription tiers** with **token-based metering** for granular usage tracking. This allows predictable monthly costs while maintaining flexibility for varying workloads.

## Billing Model

### Hybrid Approach

```
┌─────────────────────────────────────────────────┐
│         SUBSCRIPTION (Monthly Base)             │
├─────────────────────────────────────────────────┤
│  - Base features access                         │
│  - Included quota allocations                   │
│  - Priority support (higher tiers)              │
│  - Predictable monthly cost                     │
└─────────────────────────────────────────────────┘
                       +
┌─────────────────────────────────────────────────┐
│         TOKEN METERING (Usage-based)            │
├─────────────────────────────────────────────────┤
│  - LLM tokens (prompt + completion)             │
│  - KAI credits (image/video generation)         │
│  - Render seconds (video processing time)       │
│  - Storage (GB/month)                           │
└─────────────────────────────────────────────────┘
```

## Subscription Tiers

### Free Tier

**Price:** $0/month

**Included Quota:**
- 100,000 LLM tokens/month
- 50 KAI credits/month
- 300 render seconds/month (5 minutes)
- 5 GB storage

**Limits:**
- Max 3 workflows
- Max 5 templates
- Max 10 jobs/month
- Community support only
- Watermark on exports
- 720p max resolution

**Best For:** Testing, learning, personal projects

---

### Starter Tier

**Price:** $29/month

**Included Quota:**
- 1,000,000 LLM tokens/month
- 500 KAI credits/month
- 3,600 render seconds/month (1 hour)
- 50 GB storage

**Features:**
- Unlimited workflows
- Unlimited templates
- 100 jobs/month
- No watermark
- 1080p resolution
- Email support
- API access
- Webhooks

**Overage Rates:**
- LLM tokens: $0.10 per 100K tokens
- KAI credits: $0.05 per credit
- Render seconds: $0.02 per second
- Storage: $0.10 per GB

**Best For:** Solo creators, small channels

---

### Pro Tier

**Price:** $99/month

**Included Quota:**
- 5,000,000 LLM tokens/month
- 2,000 KAI credits/month
- 10,800 render seconds/month (3 hours)
- 200 GB storage

**Features:**
- Everything in Starter
- Unlimited jobs
- Priority rendering queue
- Advanced workflow features
- Custom templates marketplace
- Priority email support
- Scheduled workflows
- Team collaboration (up to 5 users)

**Overage Rates:**
- LLM tokens: $0.08 per 100K tokens
- KAI credits: $0.04 per credit
- Render seconds: $0.015 per second
- Storage: $0.08 per GB

**Best For:** Professional creators, small teams, agencies

---

### Enterprise Tier

**Price:** Custom (starting at $499/month)

**Included Quota:** Custom allocation

**Features:**
- Everything in Pro
- Unlimited storage
- Dedicated render infrastructure
- Custom SLA guarantees
- White-label options
- SSO (SAML, OAuth)
- Dedicated account manager
- Phone support
- Custom integrations
- Advanced analytics

**Custom Pricing:**
- Volume discounts available
- Annual commitment options
- Reserved capacity pricing

**Best For:** Large teams, agencies, production studios

---

## Resource Units

### 1. LLM Tokens

**What:** Text processed by language models (GPT-4, Claude, etc.)

**Counted As:**
- **Prompt tokens**: Input text (script generation prompts, transformations)
- **Completion tokens**: Generated output (scripts, suggestions)

**Typical Usage:**
- Script generation (30s video): ~500 tokens
- Script transformation: ~300 tokens
- AI agent interaction: ~200 tokens per message

**Pricing:**
- Free: Included up to limit
- Starter: $0.10 per 100K tokens overage
- Pro: $0.08 per 100K tokens overage

**Models:**
| Model | Prompt Cost | Completion Cost |
|-------|-------------|-----------------|
| GPT-3.5 Turbo | $0.0005/1K | $0.0015/1K |
| GPT-4 | $0.03/1K | $0.06/1K |
| Claude 3 Sonnet | $0.003/1K | $0.015/1K |

---

### 2. KAI Credits

**What:** AI-generated images and videos

**Credit Calculation:**
- Based on model, resolution, and duration
- Different models have different credit costs
- Credits are pre-calculated before generation

**Image Generation:**
| Model | Resolution | Credits |
|-------|------------|---------|
| Flux Pro | 1024x1024 | 8 |
| DALL-E 3 | 1024x1024 | 10 |
| Stable Diffusion | 1024x1024 | 4 |

**Video Generation:**
| Model | Duration | Credits |
|-------|----------|---------|
| Sora | 10 seconds | 100 |
| VEO | 8 seconds | 80 |
| Minimax | 6 seconds | 60 |
| BIO3 | 8 seconds | 70 |
| C-DANCE | 4 seconds | 40 |

**Video Editing:**
| Operation | Credits |
|-----------|---------|
| Style transfer | 50 |
| Inpainting | 40 |
| Extend video | 60 |

**Typical Usage:**
- Short video (60s) with 6 AI clips: ~600 credits
- Slideshow with 12 AI images: ~96 credits
- News video with stock footage: 0 credits (stock is free)

**Pricing:**
- Free: 50 credits/month
- Starter: $0.05 per credit overage
- Pro: $0.04 per credit overage

---

### 3. Render Seconds

**What:** Video processing time for final export

**Calculation:**
- Based on **output video duration** × **quality multiplier**
- Not the wall-clock time to render

**Quality Multipliers:**
| Profile | Resolution | Multiplier | Example (60s video) |
|---------|------------|------------|---------------------|
| 9x16_720p | 720x1280 | 1.0x | 60 seconds |
| 9x16_1080p | 1080x1920 | 1.5x | 90 seconds |
| 16x9_1080p | 1920x1080 | 1.5x | 90 seconds |
| 16x9_4K | 3840x2160 | 3.0x | 180 seconds |

**Additional Factors:**
- Complex effects: +20% render seconds
- Multiple subtitle layers: +10%
- Advanced transitions: +15%

**Typical Usage:**
- 30s short (1080p): 45 render seconds
- 60s video (1080p): 90 render seconds
- 60s video (4K): 180 render seconds

**Pricing:**
- Free: 300 seconds/month
- Starter: $0.02 per second overage
- Pro: $0.015 per second overage

---

### 4. Storage

**What:** Asset and render storage in cloud

**Counted:**
- User uploads (images, videos, audio)
- AI generations (kept for 90 days)
- Render outputs (kept for 30 days)
- Templates and previews

**Not Counted:**
- Workflow definitions (JSON)
- Usage logs
- Account data

**Retention Policies:**
| Asset Type | Retention | Auto-Delete |
|------------|-----------|-------------|
| User uploads | Indefinite | Manual only |
| AI generations | 90 days | Yes |
| Render outputs | 30 days | Yes |
| Failed jobs | 7 days | Yes |

**Typical Usage:**
- 10 video uploads (5GB each): 50 GB
- 100 AI generations: ~10 GB
- 50 rendered videos: ~25 GB

**Pricing:**
- Free: 5 GB included
- Starter: $0.10 per GB/month overage
- Pro: $0.08 per GB/month overage

---

## Usage Tracking

### Real-Time Metering

Every billable operation is tracked in `usage_records` table:

```sql
INSERT INTO usage_records (
  org_id,
  user_id,
  job_id,
  resource_type,
  llm_tokens_prompt,
  llm_tokens_output,
  kai_credits,
  render_seconds,
  cost_usd,
  created_at
) VALUES (
  'org_abc123',
  'user_xyz789',
  'job_def456',
  'llm_tokens',
  500,
  1200,
  0,
  0,
  0.0102,
  NOW()
);
```

### Aggregation

Daily usage aggregated in materialized view `mv_daily_usage`:

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
  AND date >= '2024-01-01'
ORDER BY date DESC;
```

### Quota Checking

Before job execution:

```typescript
async function checkQuota(orgId: string, estimatedUsage: UsageEstimate): Promise<QuotaCheckResult> {
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

## Cost Estimation API

### Pre-Job Estimation

Estimate cost before executing workflow:

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

### Budget Constraints

Set budget limits on job:

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

If budget exceeded during execution:
- Job pauses
- User notified
- Option to approve overage or cancel

---

## Invoicing & Payment

### Monthly Billing Cycle

1. **Subscription Charge** (1st of month)
   - Base tier fee
   - Charged via Stripe subscription

2. **Usage Metering** (throughout month)
   - Real-time tracking
   - Daily aggregation
   - Quota alerts

3. **Overage Calculation** (end of month)
   - Sum usage beyond quota
   - Apply tier-specific rates
   - Generate invoice

4. **Payment** (automatic)
   - Charged to card on file
   - Invoice emailed
   - Payment receipt

### Invoice Structure

```json
{
  "id": "inv_abc123",
  "org_id": "org_xyz789",
  "period_start": "2024-01-01",
  "period_end": "2024-01-31",
  "line_items": [
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
    },
    {
      "description": "Render Seconds - Overage (200 seconds)",
      "quantity": 200,
      "unit_price": 0.015,
      "amount": 3.00
    }
  ],
  "subtotal": 108.40,
  "tax": 8.67,
  "total": 117.07,
  "status": "paid",
  "paid_at": "2024-02-01T10:30:00Z"
}
```

### Payment Methods

**Supported:**
- Credit/debit cards (Stripe)
- ACH bank transfer (US only, Enterprise)
- Wire transfer (Enterprise)
- Invoice + NET30 (Enterprise, annual contract)

**Not Supported:**
- PayPal
- Cryptocurrency
- Prepaid cards (in most cases)

---

## Quota Management

### Soft Limits vs Hard Limits

**Soft Limits:**
- Warning at 80% usage
- Alert at 90% usage
- Email notification to owner/admin

**Hard Limits:**
- Prevent job execution at 100% quota (Free tier)
- Allow overage with additional charge (Paid tiers)

### Auto-Scaling Options

**Paid Tiers:**
- Automatic overage billing (default)
- Set monthly overage cap (optional)
- Pre-purchase credit packs (discounted)

**Example Configuration:**
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

### Credit Packs (Pre-Purchase)

Discounted rates for bulk purchase:

| Pack Size | Credits | Price | Per-Credit | Savings |
|-----------|---------|-------|------------|---------|
| Small | 1,000 | $40 | $0.040 | 20% |
| Medium | 5,000 | $175 | $0.035 | 30% |
| Large | 20,000 | $600 | $0.030 | 40% |

**Features:**
- Never expire
- Apply before monthly quota
- Transferable between projects

---

## Cost Optimization

### 1. Use Free Stock Footage

Pexels integration doesn't consume KAI credits:

```json
{
  "type": "Input.Stock",
  "params": {
    "provider": "pexels",
    "query": "city night",
    "count": 5
  }
}
// Cost: $0.00
```

### 2. Choose Appropriate Models

Lower-tier models for simple tasks:

| Task | Premium Model | Budget Model | Savings |
|------|---------------|--------------|---------|
| Script generation | GPT-4 ($0.06) | GPT-3.5 ($0.0015) | 97% |
| Image gen | DALL-E 3 (10 credits) | Flux Pro (8 credits) | 20% |

### 3. Optimize Resolution

Render lower resolution for social media:

| Resolution | Render Seconds (60s video) | Cost |
|------------|----------------------------|------|
| 4K | 180 seconds | $2.70 |
| 1080p | 90 seconds | $1.35 |
| 720p | 60 seconds | $0.90 |

### 4. Batch Processing

Schedule off-peak rendering (future feature):
- 30% discount for scheduled jobs
- Run during low-demand periods

### 5. Reuse Assets

Cache generated assets:
- Same prompt = reuse previous generation
- Save up to 100% on repeated content

---

## Usage Analytics

### Dashboard Metrics

**Current Period:**
- Tokens used / remaining
- KAI credits used / remaining
- Render seconds used / remaining
- Storage used / remaining
- Estimated overage cost

**Historical:**
- Daily usage trend (last 30 days)
- Cost breakdown by resource type
- Top workflows by cost
- Average cost per video

**Projections:**
- Estimated month-end usage
- Projected overage
- Recommended tier upgrade

### API Endpoint

```http
GET /v1/usage?startDate=2024-01-01&endDate=2024-01-31&groupBy=day
```

**Response:**
```json
{
  "period": {
    "startDate": "2024-01-01",
    "endDate": "2024-01-31"
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
      "date": "2024-01-01",
      "tokens": 18000,
      "kaiCredits": 80,
      "renderSeconds": 350,
      "costUsd": 5.20
    }
  ]
}
```

---

## Alerts & Notifications

### Quota Alerts

**Email Notifications:**
- 80% quota used: "You're approaching your monthly limit"
- 90% quota used: "Running low on quota"
- 100% quota reached: "Quota limit reached" (Free tier)
- Daily digest: Usage summary

**In-App Notifications:**
- Toast notification at 90%
- Banner at dashboard at 95%
- Modal before job execution if insufficient quota

**Webhook Events:**
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

### Billing Alerts

**Payment Issues:**
- Payment failed: Retry automatically (3 attempts)
- Card expiring soon (30 days)
- Subscription cancelled

**Overage Warnings:**
- Approaching overage cap
- Overage cap reached (pause jobs)

---

## Fair Use Policy

### Acceptable Use

- Normal production workflows
- Testing and development
- Automated scheduled jobs
- API integrations

### Prohibited Use

- Crypto mining or proof-of-work
- Deliberate service abuse
- Reselling quota to third parties
- Circumventing rate limits
- Generating illegal content

### Enforcement

1. **Warning**: Email notification
2. **Throttling**: Reduce job priority
3. **Suspension**: Temporary account freeze
4. **Termination**: Permanent ban (severe violations)

---

## API Reference

### Get Current Quota

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
  "resetAt": "2024-02-01T00:00:00Z"
}
```

### Get Usage Statistics

```http
GET /v1/usage?startDate=2024-01-01&endDate=2024-01-31&groupBy=day
```

### Purchase Credit Pack

```http
POST /v1/billing/credit-packs
{
  "packSize": "medium",
  "paymentMethodId": "pm_abc123"
}
```

### Update Billing Settings

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

## Frequently Asked Questions

**Q: What happens if I exceed my quota?**
- Free tier: Jobs are paused until next billing cycle
- Paid tiers: Automatic overage billing at tier rates

**Q: Can I upgrade mid-month?**
- Yes, prorated charges apply
- New quota takes effect immediately
- Unused quota from previous tier is forfeited

**Q: Are render failures refunded?**
- Yes, failed renders don't count toward quota
- Credits automatically restored

**Q: Can I carry over unused quota?**
- No, monthly quotas reset on 1st of each month
- Consider downgrading if consistently under-utilizing

**Q: How is storage calculated?**
- Average daily storage usage for the month
- Calculated at end of billing cycle

**Q: What payment methods do you accept?**
- Credit/debit cards (all tiers)
- ACH/wire transfer (Enterprise only)
- Invoice billing (Enterprise with contract)
