import type { ModelConfig, ModelId } from './types';

export const MODELS: Record<ModelId, ModelConfig> = {
  'anthropic/claude-3.5-sonnet': {
    id: 'anthropic/claude-3.5-sonnet',
    name: 'Claude 3.5 Sonnet',
    inputPrice: 3,
    outputPrice: 15,
    contextWindow: 200000,
    tier: 'pro',
  },
  'anthropic/claude-3.5-haiku': {
    id: 'anthropic/claude-3.5-haiku',
    name: 'Claude 3.5 Haiku',
    inputPrice: 1,
    outputPrice: 5,
    contextWindow: 200000,
    tier: 'starter',
  },
  'anthropic/claude-3-opus': {
    id: 'anthropic/claude-3-opus',
    name: 'Claude 3 Opus',
    inputPrice: 15,
    outputPrice: 75,
    contextWindow: 200000,
    tier: 'business',
  },
  'openai/gpt-4o': {
    id: 'openai/gpt-4o',
    name: 'GPT-4o',
    inputPrice: 2.5,
    outputPrice: 10,
    contextWindow: 128000,
    tier: 'pro',
  },
  'openai/gpt-4o-mini': {
    id: 'openai/gpt-4o-mini',
    name: 'GPT-4o Mini',
    inputPrice: 0.15,
    outputPrice: 0.6,
    contextWindow: 128000,
    tier: 'starter',
  },
  'meta-llama/llama-3.1-70b-instruct': {
    id: 'meta-llama/llama-3.1-70b-instruct',
    name: 'Llama 3.1 70B',
    inputPrice: 0.5,
    outputPrice: 0.75,
    contextWindow: 128000,
    tier: 'free',
  },
  'google/gemini-1.5-pro': {
    id: 'google/gemini-1.5-pro',
    name: 'Gemini 1.5 Pro',
    inputPrice: 2.5,
    outputPrice: 10,
    contextWindow: 2000000,
    tier: 'pro',
  },
};

// Default models for different use cases
export const DEFAULT_MODELS = {
  agent: 'anthropic/claude-3.5-sonnet' as ModelId,
  scriptQuality: 'anthropic/claude-3.5-sonnet' as ModelId,
  scriptFast: 'openai/gpt-4o-mini' as ModelId,
  scriptFree: 'meta-llama/llama-3.1-70b-instruct' as ModelId,
};

// Fallback chain when primary model is unavailable
export const MODEL_FALLBACKS: Record<ModelId, ModelId[]> = {
  'anthropic/claude-3.5-sonnet': ['openai/gpt-4o', 'anthropic/claude-3.5-haiku'],
  'anthropic/claude-3.5-haiku': ['openai/gpt-4o-mini', 'meta-llama/llama-3.1-70b-instruct'],
  'anthropic/claude-3-opus': ['anthropic/claude-3.5-sonnet', 'openai/gpt-4o'],
  'openai/gpt-4o': ['anthropic/claude-3.5-sonnet', 'openai/gpt-4o-mini'],
  'openai/gpt-4o-mini': ['anthropic/claude-3.5-haiku', 'meta-llama/llama-3.1-70b-instruct'],
  'meta-llama/llama-3.1-70b-instruct': ['openai/gpt-4o-mini'],
  'google/gemini-1.5-pro': ['openai/gpt-4o', 'anthropic/claude-3.5-sonnet'],
};

// Get models available for a subscription tier
export function getModelsForTier(tier: 'free' | 'starter' | 'pro' | 'business'): ModelConfig[] {
  const tierOrder = ['free', 'starter', 'pro', 'business'];
  const tierIndex = tierOrder.indexOf(tier);

  return Object.values(MODELS).filter(model => {
    const modelTierIndex = tierOrder.indexOf(model.tier);
    return modelTierIndex <= tierIndex;
  });
}

// Get best available model for user's tier
export function getBestModelForTier(tier: 'free' | 'starter' | 'pro' | 'business'): ModelId {
  switch (tier) {
    case 'business':
      return 'anthropic/claude-3-opus';
    case 'pro':
      return 'anthropic/claude-3.5-sonnet';
    case 'starter':
      return 'anthropic/claude-3.5-haiku';
    case 'free':
    default:
      return 'meta-llama/llama-3.1-70b-instruct';
  }
}
