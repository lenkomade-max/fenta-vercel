// OpenRouter API Types

export type ModelId =
  | 'anthropic/claude-3.5-sonnet'
  | 'anthropic/claude-3.5-haiku'
  | 'anthropic/claude-3-opus'
  | 'openai/gpt-4o'
  | 'openai/gpt-4o-mini'
  | 'meta-llama/llama-3.1-70b-instruct'
  | 'google/gemini-1.5-pro';

export interface ModelConfig {
  id: ModelId;
  name: string;
  inputPrice: number;  // per 1M tokens
  outputPrice: number; // per 1M tokens
  contextWindow: number;
  tier: 'free' | 'starter' | 'pro' | 'business';
}

export interface ChatMessage {
  role: 'system' | 'user' | 'assistant';
  content: string;
}

export interface ChatCompletionRequest {
  model: ModelId;
  messages: ChatMessage[];
  max_tokens?: number;
  temperature?: number;
  stream?: boolean;
}

export interface ChatCompletionResponse {
  id: string;
  model: string;
  choices: {
    message: {
      role: 'assistant';
      content: string;
    };
    finish_reason: 'stop' | 'length' | 'content_filter';
  }[];
  usage: {
    prompt_tokens: number;
    completion_tokens: number;
    total_tokens: number;
  };
}

export interface StreamChunk {
  id: string;
  choices: {
    delta: {
      content?: string;
    };
    finish_reason: 'stop' | null;
  }[];
}

export type Genre =
  | 'true-crime'
  | 'facts-list'
  | 'explainer'
  | 'story-narration'
  | 'news'
  | 'how-to'
  | 'review'
  | 'pov-scene';

export interface ScriptRequest {
  genre: Genre;
  topic: string;
  duration: 30 | 45 | 60 | 90;
  language?: 'en' | 'es' | 'de' | 'fr';
  tone?: 'dramatic' | 'casual' | 'professional' | 'humorous';
  includeHooks?: boolean;
}

export interface ScriptResponse {
  script: string;
  segments: ScriptSegment[];
  tokensUsed: {
    input: number;
    output: number;
  };
  creditsUsed: number;
  model: ModelId;
}

export interface ScriptSegment {
  id: string;
  type: 'hook' | 'beat' | 'transition' | 'cta';
  text: string;
  duration: number;
  visualPrompt: string;
}
