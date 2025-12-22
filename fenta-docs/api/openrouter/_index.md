# OpenRouter API (LLM провайдер)

> Внутренний провайдер для AI-агентов и генерации скриптов.
> Пользователи видят: "Claude", "GPT-4" — НЕ видят "OpenRouter"

## Base URL
```
https://openrouter.ai/api/v1
```

## Authentication
```
Authorization: Bearer YOUR_OPENROUTER_KEY
HTTP-Referer: https://fenta.app
X-Title: Fenta
```

---

## Используемые модели

### Для AI-агента (скрипты, workflow)

| Модель | ID | Input/1M | Output/1M | Контекст | Использование |
|--------|-----|----------|-----------|----------|---------------|
| Claude 3.5 Sonnet | `anthropic/claude-3.5-sonnet` | $3 | $15 | 200K | Основной агент |
| Claude 3.5 Haiku | `anthropic/claude-3.5-haiku` | $1 | $5 | 200K | Быстрые задачи |
| GPT-4o | `openai/gpt-4o` | $2.50 | $10 | 128K | Альтернатива |
| GPT-4o mini | `openai/gpt-4o-mini` | $0.15 | $0.60 | 128K | Экономный |
| Llama 3.1 70B | `meta-llama/llama-3.1-70b-instruct` | $0.50 | $0.75 | 128K | Free tier |

### Для генерации скриптов

| Задача | Рекомендуемая модель | Почему |
|--------|---------------------|--------|
| True Crime сценарий | Claude 3.5 Sonnet | Лучший storytelling |
| Факты/списки | GPT-4o mini | Быстро и дёшево |
| Новостной скрипт | GPT-4o | Актуальность |
| Длинный нарратив | Claude 3.5 Sonnet | Большой контекст |

---

## API Endpoints

### Chat Completions
```
POST https://openrouter.ai/api/v1/chat/completions
```

### Request
```json
{
  "model": "anthropic/claude-3.5-sonnet",
  "messages": [
    {
      "role": "system",
      "content": "You are a professional video scriptwriter..."
    },
    {
      "role": "user",
      "content": "Write a 60-second true crime script about..."
    }
  ],
  "max_tokens": 2000,
  "temperature": 0.7
}
```

### Response
```json
{
  "id": "gen-abc123",
  "model": "anthropic/claude-3.5-sonnet",
  "choices": [
    {
      "message": {
        "role": "assistant",
        "content": "HOOK: [0-5s]\nIn 1987, a small town..."
      },
      "finish_reason": "stop"
    }
  ],
  "usage": {
    "prompt_tokens": 150,
    "completion_tokens": 450,
    "total_tokens": 600
  }
}
```

---

## Streaming

```typescript
const response = await fetch('https://openrouter.ai/api/v1/chat/completions', {
  method: 'POST',
  headers: {
    'Authorization': `Bearer ${OPENROUTER_KEY}`,
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    model: 'anthropic/claude-3.5-sonnet',
    messages: [...],
    stream: true
  })
});

const reader = response.body.getReader();
// Process SSE stream...
```

---

## Интеграция в Fenta

### Конфиг
```typescript
// src/lib/openrouter/config.ts
export const OPENROUTER_CONFIG = {
  baseUrl: 'https://openrouter.ai/api/v1',
  defaultModel: 'anthropic/claude-3.5-sonnet',

  models: {
    agent: 'anthropic/claude-3.5-sonnet',      // AI помощник
    scriptFast: 'openai/gpt-4o-mini',          // Быстрые скрипты
    scriptQuality: 'anthropic/claude-3.5-sonnet', // Качественные скрипты
    free: 'meta-llama/llama-3.1-70b-instruct'  // Free tier
  }
};
```

### Клиент
```typescript
// src/lib/openrouter/client.ts
export async function generateScript(
  prompt: string,
  genre: string,
  model?: string
): Promise<string> {
  const response = await fetch(`${OPENROUTER_CONFIG.baseUrl}/chat/completions`, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${process.env.OPENROUTER_API_KEY}`,
      'HTTP-Referer': 'https://fenta.app',
      'X-Title': 'Fenta',
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      model: model || OPENROUTER_CONFIG.defaultModel,
      messages: [
        { role: 'system', content: getSystemPrompt(genre) },
        { role: 'user', content: prompt }
      ],
      max_tokens: 2000,
      temperature: 0.7
    })
  });

  const data = await response.json();
  return data.choices[0].message.content;
}
```

---

## Расчёт кредитов

```typescript
function calculateLLMCredits(usage: { prompt_tokens: number, completion_tokens: number }, model: string): number {
  const pricing = {
    'anthropic/claude-3.5-sonnet': { input: 3, output: 15 },    // per 1M
    'anthropic/claude-3.5-haiku': { input: 1, output: 5 },
    'openai/gpt-4o': { input: 2.5, output: 10 },
    'openai/gpt-4o-mini': { input: 0.15, output: 0.6 },
  };

  const p = pricing[model];
  const inputCost = (usage.prompt_tokens / 1_000_000) * p.input;
  const outputCost = (usage.completion_tokens / 1_000_000) * p.output;

  // x2 наценка, конвертация в кредиты ($0.01 = 1 credit)
  const totalUsd = (inputCost + outputCost) * 2;
  return Math.ceil(totalUsd * 100); // credits
}
```

---

## Error Handling

| Code | Description | Action |
|------|-------------|--------|
| 400 | Bad request | Check params |
| 401 | Invalid API key | Check key |
| 402 | Insufficient credits | Top up OpenRouter |
| 429 | Rate limited | Retry with backoff |
| 500 | Server error | Retry |
| 503 | Model unavailable | Fallback to another model |

---

## Fallback Strategy

```typescript
const MODEL_FALLBACKS = {
  'anthropic/claude-3.5-sonnet': ['openai/gpt-4o', 'anthropic/claude-3.5-haiku'],
  'openai/gpt-4o': ['anthropic/claude-3.5-sonnet', 'openai/gpt-4o-mini'],
};

async function generateWithFallback(prompt: string, model: string) {
  try {
    return await generate(prompt, model);
  } catch (error) {
    if (error.status === 503) {
      const fallbacks = MODEL_FALLBACKS[model] || [];
      for (const fallback of fallbacks) {
        try {
          return await generate(prompt, fallback);
        } catch {}
      }
    }
    throw error;
  }
}
```

---

## Промпты для жанров

```typescript
const GENRE_PROMPTS = {
  'true-crime': `You are a true crime scriptwriter. Write gripping, suspenseful narratives with:
- Hook in first 5 seconds
- 4-6 story beats
- Dramatic pacing
- Cliffhanger moments`,

  'facts-list': `You are a fact-based content writer. Create engaging listicles with:
- 6-10 surprising facts
- Each fact is 1-2 sentences
- Visual description for each
- Hook at the start`,

  'explainer': `You are an educational content creator. Explain complex topics with:
- Simple language
- Clear structure: What, Why, How
- Relatable examples
- Call to action at end`,
};
```

---

## Sources

- [OpenRouter Documentation](https://openrouter.ai/docs)
- [OpenRouter Models](https://openrouter.ai/models)
- [OpenRouter Pricing](https://openrouter.ai/pricing)
