import { MODELS } from './models';
import type { ModelId } from './types';

// 1 credit = $0.01
const CREDIT_VALUE_USD = 0.01;

// Markup multiplier (2x = 100% margin)
const MARKUP_MULTIPLIER = 2;

/**
 * Calculate credits for LLM usage
 * @param promptTokens - Number of input tokens
 * @param completionTokens - Number of output tokens
 * @param model - Model ID
 * @returns Credits to charge user
 */
export function calculateCredits(
  promptTokens: number,
  completionTokens: number,
  model: ModelId
): number {
  const modelConfig = MODELS[model];
  if (!modelConfig) {
    throw new Error(`Unknown model: ${model}`);
  }

  // Calculate cost in USD (prices are per 1M tokens)
  const inputCostUsd = (promptTokens / 1_000_000) * modelConfig.inputPrice;
  const outputCostUsd = (completionTokens / 1_000_000) * modelConfig.outputPrice;
  const totalCostUsd = inputCostUsd + outputCostUsd;

  // Apply markup
  const markedUpCostUsd = totalCostUsd * MARKUP_MULTIPLIER;

  // Convert to credits (round up to nearest credit)
  const credits = Math.ceil(markedUpCostUsd / CREDIT_VALUE_USD);

  // Minimum 1 credit
  return Math.max(1, credits);
}

/**
 * Estimate credits before generation
 * @param estimatedInputTokens - Estimated input tokens
 * @param estimatedOutputTokens - Estimated output tokens
 * @param model - Model ID
 * @returns Estimated credits
 */
export function estimateCredits(
  estimatedInputTokens: number,
  estimatedOutputTokens: number,
  model: ModelId
): number {
  return calculateCredits(estimatedInputTokens, estimatedOutputTokens, model);
}

/**
 * Estimate tokens from character count
 * Rough estimate: 1 token ≈ 4 characters for English
 */
export function estimateTokens(text: string): number {
  return Math.ceil(text.length / 4);
}

/**
 * Get cost breakdown for transparency
 */
export function getCostBreakdown(
  promptTokens: number,
  completionTokens: number,
  model: ModelId
): {
  inputCost: number;
  outputCost: number;
  baseCost: number;
  markup: number;
  totalCredits: number;
} {
  const modelConfig = MODELS[model];

  const inputCost = (promptTokens / 1_000_000) * modelConfig.inputPrice;
  const outputCost = (completionTokens / 1_000_000) * modelConfig.outputPrice;
  const baseCost = inputCost + outputCost;
  const markup = baseCost * (MARKUP_MULTIPLIER - 1);
  const totalCredits = calculateCredits(promptTokens, completionTokens, model);

  return {
    inputCost: Math.round(inputCost * 10000) / 10000,
    outputCost: Math.round(outputCost * 10000) / 10000,
    baseCost: Math.round(baseCost * 10000) / 10000,
    markup: Math.round(markup * 10000) / 10000,
    totalCredits,
  };
}

/**
 * Estimate credits for a script generation
 */
export function estimateScriptCredits(
  genre: string,
  duration: 30 | 45 | 60 | 90,
  model: ModelId
): {
  estimated: number;
  min: number;
  max: number;
} {
  // Average tokens based on script duration
  const outputTokensPerSecond = 15; // ~15 tokens per second of script
  const systemPromptTokens = 500; // Genre system prompt
  const userPromptTokens = 100; // User request

  const estimatedInputTokens = systemPromptTokens + userPromptTokens;
  const estimatedOutputTokens = duration * outputTokensPerSecond;

  const estimated = estimateCredits(estimatedInputTokens, estimatedOutputTokens, model);

  return {
    estimated,
    min: Math.floor(estimated * 0.7),
    max: Math.ceil(estimated * 1.5),
  };
}

/**
 * Credit packages available for purchase
 */
export const CREDIT_PACKAGES = [
  { id: 'small', credits: 1000, price: 10, bonus: 0 },
  { id: 'medium', credits: 2800, price: 25, bonus: 12 },
  { id: 'large', credits: 6000, price: 50, bonus: 20 },
  { id: 'xl', credits: 13000, price: 100, bonus: 30 },
] as const;

/**
 * Subscription plan credits
 */
export const PLAN_CREDITS = {
  free: 50, // one-time
  starter: 500,
  pro: 2000,
  business: 8000,
} as const;
