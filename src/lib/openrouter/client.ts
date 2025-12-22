import { MODELS, MODEL_FALLBACKS, DEFAULT_MODELS } from './models';
import { GENRE_SYSTEM_PROMPTS, buildUserPrompt, parseScriptResponse } from './prompts';
import { calculateCredits, estimateScriptCredits } from './credits';
import type {
  ModelId,
  ChatMessage,
  ChatCompletionRequest,
  ChatCompletionResponse,
  Genre,
  ScriptRequest,
  ScriptResponse,
  ScriptSegment,
} from './types';

const OPENROUTER_BASE_URL = 'https://openrouter.ai/api/v1';

interface OpenRouterConfig {
  apiKey: string;
  siteUrl?: string;
  siteName?: string;
}

export class OpenRouterClient {
  private apiKey: string;
  private siteUrl: string;
  private siteName: string;

  constructor(config: OpenRouterConfig) {
    this.apiKey = config.apiKey;
    this.siteUrl = config.siteUrl || 'https://fenta.app';
    this.siteName = config.siteName || 'Fenta';
  }

  private async request<T>(
    endpoint: string,
    body: object
  ): Promise<T> {
    const response = await fetch(`${OPENROUTER_BASE_URL}${endpoint}`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${this.apiKey}`,
        'HTTP-Referer': this.siteUrl,
        'X-Title': this.siteName,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(body),
    });

    if (!response.ok) {
      const error = await response.json().catch(() => ({}));
      throw new OpenRouterError(
        error.message || `OpenRouter API error: ${response.status}`,
        response.status,
        error.code
      );
    }

    return response.json();
  }

  /**
   * Chat completion (non-streaming)
   */
  async chat(
    messages: ChatMessage[],
    model: ModelId = DEFAULT_MODELS.agent,
    options: { maxTokens?: number; temperature?: number } = {}
  ): Promise<ChatCompletionResponse> {
    const request: ChatCompletionRequest = {
      model,
      messages,
      max_tokens: options.maxTokens || 2000,
      temperature: options.temperature ?? 0.7,
    };

    return this.request<ChatCompletionResponse>('/chat/completions', request);
  }

  /**
   * Chat completion with automatic fallback
   */
  async chatWithFallback(
    messages: ChatMessage[],
    model: ModelId = DEFAULT_MODELS.agent,
    options: { maxTokens?: number; temperature?: number } = {}
  ): Promise<ChatCompletionResponse & { actualModel: ModelId }> {
    const modelsToTry = [model, ...(MODEL_FALLBACKS[model] || [])];

    let lastError: Error | null = null;

    for (const tryModel of modelsToTry) {
      try {
        const response = await this.chat(messages, tryModel, options);
        return { ...response, actualModel: tryModel };
      } catch (error) {
        lastError = error as Error;

        // Only retry on 503 (model unavailable) or 429 (rate limit)
        if (error instanceof OpenRouterError) {
          if (error.status !== 503 && error.status !== 429) {
            throw error;
          }
        }
      }
    }

    throw lastError || new Error('All models failed');
  }

  /**
   * Generate video script
   */
  async generateScript(request: ScriptRequest): Promise<ScriptResponse> {
    const { genre } = request;

    // Select model based on quality needs
    const model = DEFAULT_MODELS.scriptQuality;

    const messages: ChatMessage[] = [
      { role: 'system', content: GENRE_SYSTEM_PROMPTS[genre] },
      { role: 'user', content: buildUserPrompt(request) },
    ];

    const response = await this.chatWithFallback(messages, model, {
      maxTokens: 2000,
      temperature: 0.7,
    });

    const content = response.choices[0]?.message?.content || '';
    const { fullScript, segments } = parseScriptResponse(content);

    const creditsUsed = calculateCredits(
      response.usage.prompt_tokens,
      response.usage.completion_tokens,
      response.actualModel
    );

    return {
      script: fullScript,
      segments: segments as ScriptSegment[],
      tokensUsed: {
        input: response.usage.prompt_tokens,
        output: response.usage.completion_tokens,
      },
      creditsUsed,
      model: response.actualModel,
    };
  }

  /**
   * Estimate credits before generation
   */
  estimateScriptCredits(genre: Genre, duration: 30 | 45 | 60 | 90, model?: ModelId) {
    return estimateScriptCredits(genre, duration, model || DEFAULT_MODELS.scriptQuality);
  }

  /**
   * Streaming chat completion
   */
  async *chatStream(
    messages: ChatMessage[],
    model: ModelId = DEFAULT_MODELS.agent,
    options: { maxTokens?: number; temperature?: number } = {}
  ): AsyncGenerator<string, void, unknown> {
    const request: ChatCompletionRequest = {
      model,
      messages,
      max_tokens: options.maxTokens || 2000,
      temperature: options.temperature ?? 0.7,
      stream: true,
    };

    const response = await fetch(`${OPENROUTER_BASE_URL}/chat/completions`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${this.apiKey}`,
        'HTTP-Referer': this.siteUrl,
        'X-Title': this.siteName,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(request),
    });

    if (!response.ok) {
      throw new OpenRouterError(
        `OpenRouter API error: ${response.status}`,
        response.status
      );
    }

    const reader = response.body?.getReader();
    if (!reader) throw new Error('No response body');

    const decoder = new TextDecoder();
    let buffer = '';

    while (true) {
      const { done, value } = await reader.read();
      if (done) break;

      buffer += decoder.decode(value, { stream: true });
      const lines = buffer.split('\n');
      buffer = lines.pop() || '';

      for (const line of lines) {
        if (line.startsWith('data: ')) {
          const data = line.slice(6);
          if (data === '[DONE]') return;

          try {
            const parsed = JSON.parse(data);
            const content = parsed.choices?.[0]?.delta?.content;
            if (content) yield content;
          } catch {
            // Skip invalid JSON
          }
        }
      }
    }
  }

  /**
   * Simple prompt completion
   */
  async complete(
    prompt: string,
    model: ModelId = DEFAULT_MODELS.agent,
    systemPrompt?: string
  ): Promise<string> {
    const messages: ChatMessage[] = [];

    if (systemPrompt) {
      messages.push({ role: 'system', content: systemPrompt });
    }
    messages.push({ role: 'user', content: prompt });

    const response = await this.chat(messages, model);
    return response.choices[0]?.message?.content || '';
  }
}

/**
 * Custom error class for OpenRouter errors
 */
export class OpenRouterError extends Error {
  constructor(
    message: string,
    public status: number,
    public code?: string
  ) {
    super(message);
    this.name = 'OpenRouterError';
  }
}

/**
 * Create client instance
 */
export function createOpenRouterClient(): OpenRouterClient {
  const apiKey = process.env.OPENROUTER_API_KEY;

  if (!apiKey) {
    throw new Error('OPENROUTER_API_KEY environment variable is not set');
  }

  return new OpenRouterClient({
    apiKey,
    siteUrl: process.env.NEXT_PUBLIC_APP_URL || 'https://fenta.app',
    siteName: 'Fenta',
  });
}

// Singleton instance
let clientInstance: OpenRouterClient | null = null;

export function getOpenRouterClient(): OpenRouterClient {
  if (!clientInstance) {
    clientInstance = createOpenRouterClient();
  }
  return clientInstance;
}
