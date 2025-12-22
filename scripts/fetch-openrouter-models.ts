#!/usr/bin/env tsx
/**
 * Скрипт для получения актуального списка моделей из OpenRouter API
 * и создания документа с топ-20 моделями 2025 года и их ценами
 */

interface OpenRouterModel {
  id: string;
  name: string;
  description?: string;
  created?: number;
  pricing?: {
    prompt: string;
    completion: string;
  };
  context_length?: number;
  architecture?: {
    modality: string;
    tokenizer: string;
  };
  top_provider?: {
    max_completion_tokens?: number;
  };
}

interface OpenRouterModelsResponse {
  data: OpenRouterModel[];
}

async function fetchOpenRouterModels(): Promise<OpenRouterModel[]> {
  console.log('🔍 Запрашиваю список моделей из OpenRouter API...');
  const headers: Record<string, string> = {
    'HTTP-Referer': 'https://fenta.app',
    'X-Title': 'Fenta',
  };
  const apiKey = process.env.OPENROUTER_API_KEY;
  if (apiKey) headers['Authorization'] = `Bearer ${apiKey}`;
  const response = await fetch('https://openrouter.ai/api/v1/models', { method: 'GET', headers });
  if (!response.ok) throw new Error(`OpenRouter API error: ${response.status}`);
  const data: OpenRouterModelsResponse = await response.json();
  console.log(`✅ Получено ${data.data.length} моделей`);
  return data.data;
}

function parsePrice(priceStr: string | undefined): number {
  if (!priceStr) return 0;
  const cleaned = priceStr.toString().replace(/[$,\s]/g, '').trim();
  const pricePerToken = parseFloat(cleaned);
  if (isNaN(pricePerToken) || pricePerToken === 0) return 0;
  return pricePerToken * 1_000_000;
}

function getModelPriority(model: OpenRouterModel): number {
  const id = model.id.toLowerCase();
  if (id.includes('gpt-5.1') || id.includes('gpt-5')) return 200;
  if (id.includes('claude-opus-4.5') || id.includes('claude-4')) return 190;
  if (id.includes('deepseek-v3.2') || id.includes('deepseek-v3.1')) return 180;
  if (id.includes('gemini-3') || id.includes('gemini-2.5')) return 175;
  if (id.includes('qwen3') && (id.includes('max') || id.includes('235b'))) return 170;
  if (id.includes('grok-4') || id.includes('grok-4.1')) return 165;
  if (id.includes('mistral-large-3')) return 160;
  if (id.includes('nova-2') || id.includes('nova-premier')) return 155;
  if (id.includes('claude-3.5')) return 100;
  if (id.includes('gpt-4o')) return 90;
  return 50;
}

function sortModels(models: OpenRouterModel[]): OpenRouterModel[] {
  return models.sort((a, b) => {
    const aInputPrice = parsePrice(a.pricing?.prompt);
    const bInputPrice = parsePrice(b.pricing?.prompt);
    if (aInputPrice < 0) return 1;
    if (bInputPrice < 0) return -1;
    const aPriority = getModelPriority(a);
    const bPriority = getModelPriority(b);
    if (aPriority !== bPriority) return bPriority - aPriority;
    const aCreated = a.created || 0;
    const bCreated = b.created || 0;
    if (aCreated !== bCreated) return bCreated - aCreated;
    const aHasPrice = aInputPrice > 0.0001;
    const bHasPrice = bInputPrice > 0.0001;
    if (!aHasPrice && bHasPrice) return 1;
    if (aHasPrice && !bHasPrice) return -1;
    return aInputPrice - bInputPrice;
  });
}

function formatPrice(price: number): string {
  if (price === 0) return 'Free';
  if (price < 0.01) return `$${price.toFixed(4)}`;
  if (price < 1) return `$${price.toFixed(2)}`;
  return `$${price.toFixed(2)}`;
}

function generateMarkdownDocument(topModels: OpenRouterModel[]): string {
  const date = new Date();
  const year = date.getFullYear();
  const quarter = Math.floor((date.getMonth() + 3) / 3);
  let markdown = `# Топ-20 AI моделей OpenRouter (Q${quarter} ${year})\n\n`;
  markdown += `> Актуальный список самых новых моделей 2025 года и их цены на ${date.toLocaleDateString('ru-RU', { year: 'numeric', month: 'long', day: 'numeric' })}\n\n`;
  markdown += `**Источник:** [OpenRouter.ai](https://openrouter.ai/models)\n\n---\n\n## 📊 Сводная таблица\n\n`;
  markdown += `| № | Модель | ID | Input (1M) | Output (1M) | Контекст |\n|---|--------|-----|------------|-------------|----------|\n`;
  topModels.forEach((model, index) => {
    const inputPrice = parsePrice(model.pricing?.prompt);
    const outputPrice = parsePrice(model.pricing?.completion);
    const contextLength = model.context_length ? `${(model.context_length / 1000).toFixed(0)}K` : 'N/A';
    markdown += `| ${index + 1} | ${model.name} | \`${model.id}\` | ${formatPrice(inputPrice)} | ${formatPrice(outputPrice)} | ${contextLength} |\n`;
  });
  markdown += `\n---\n\n## 📝 Детальная информация\n\n`;
  topModels.forEach((model, index) => {
    const inputPrice = parsePrice(model.pricing?.prompt);
    const outputPrice = parsePrice(model.pricing?.completion);
    markdown += `### ${index + 1}. ${model.name}\n\n- **ID:** \`${model.id}\`\n`;
    if (model.description) {
      const cleanDesc = model.description.replace(/\n+/g, ' ').trim();
      markdown += `- **Описание:** ${cleanDesc}\n`;
    }
    markdown += `- **Цены:**\n  - Input: ${formatPrice(inputPrice)} за 1M токенов\n  - Output: ${formatPrice(outputPrice)} за 1M токенов\n`;
    if (model.context_length) markdown += `- **Контекстное окно:** ${model.context_length.toLocaleString()} токенов\n`;
    if (model.architecture) markdown += `- **Архитектура:** ${model.architecture.modality || 'text'}\n`;
    if (model.top_provider?.max_completion_tokens) markdown += `- **Макс. completion tokens:** ${model.top_provider.max_completion_tokens.toLocaleString()}\n`;
    if (model.created) {
      const createdDate = new Date(model.created * 1000);
      markdown += `- **Дата создания:** ${createdDate.toLocaleDateString('ru-RU')}\n`;
    }
    markdown += `\n`;
  });
  markdown += `---\n\n## 💡 Примечания\n\n- Цены указаны в USD за 1 миллион токенов\n- Контекстное окно показывает максимальное количество токенов, которые модель может обработать за один запрос\n- Модели отсортированы по актуальности (новые модели 2025 года приоритетны)\n- Актуальность данных: ${date.toLocaleDateString('ru-RU')}\n- Для получения самой актуальной информации посетите [OpenRouter.ai](https://openrouter.ai/models)\n`;
  return markdown;
}

async function main() {
  try {
    console.log('🚀 Начинаю получение актуальных моделей 2025 из OpenRouter...\n');
    const apiKeyFromArgs = process.argv.find(arg => arg.startsWith('--key='))?.split('=')[1];
    if (apiKeyFromArgs) process.env.OPENROUTER_API_KEY = apiKeyFromArgs;
    const allModels = await fetchOpenRouterModels();
    const activeModels = allModels.filter(model => {
      const hasPricing = model.pricing?.prompt || model.pricing?.completion;
      const isImageVideo = (model.id.includes('image') && !model.id.includes('text')) || model.id.includes('video') || model.id.includes('midjourney') || (model.id.includes('flux') && !model.id.includes('text'));
      return hasPricing && !isImageVideo;
    });
    console.log(`📝 Найдено ${activeModels.length} активных моделей\n`);
    const sortedModels = sortModels(activeModels);
    const top20 = sortedModels.slice(0, 20);
    console.log('📊 Топ-20 актуальных моделей 2025:');
    top20.forEach((model, index) => {
      const inputPrice = parsePrice(model.pricing?.prompt);
      const createdDate = model.created ? new Date(model.created * 1000).toLocaleDateString('ru-RU') : 'N/A';
      console.log(`  ${index + 1}. ${model.name} - Input: ${formatPrice(inputPrice)} (created: ${createdDate})`);
    });
    const markdown = generateMarkdownDocument(top20);
    const { writeFile } = await import('fs/promises');
    const date = new Date();
    const dateStr = date.toISOString().split('T')[0].replace(/-/g, '');
    const filename = `fenta-docs/api/openrouter/openrouter-top20-models-${dateStr}.md`;
    await writeFile(filename, markdown, 'utf-8');
    console.log(`\n✅ Документ создан: ${filename}`);
    console.log(`📄 Всего моделей в документе: ${top20.length}`);
    console.log(`📊 Размер файла: ${markdown.length} символов`);
  } catch (error) {
    console.error('❌ Ошибка:', error);
    process.exit(1);
  }
}

main();
