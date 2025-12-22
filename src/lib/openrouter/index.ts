// OpenRouter Integration
// Internal LLM provider for AI agents and script generation

export { OpenRouterClient, OpenRouterError, createOpenRouterClient, getOpenRouterClient } from './client';
export { MODELS, DEFAULT_MODELS, MODEL_FALLBACKS, getModelsForTier, getBestModelForTier } from './models';
export { GENRE_SYSTEM_PROMPTS, QUICK_PROMPTS, buildUserPrompt, parseScriptResponse } from './prompts';
export { calculateCredits, estimateCredits, estimateTokens, getCostBreakdown, estimateScriptCredits, CREDIT_PACKAGES, PLAN_CREDITS } from './credits';
export type {
  ModelId,
  ModelConfig,
  ChatMessage,
  ChatCompletionRequest,
  ChatCompletionResponse,
  StreamChunk,
  Genre,
  ScriptRequest,
  ScriptResponse,
  ScriptSegment,
} from './types';
