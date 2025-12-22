import type { Genre, ScriptRequest } from './types';

// System prompts for each genre
export const GENRE_SYSTEM_PROMPTS: Record<Genre, string> = {
  'true-crime': `You are an expert true crime scriptwriter for short-form video content.
Your scripts are gripping, suspenseful, and factually accurate.

Structure your scripts with:
- HOOK (0-5s): Shocking statement or question that stops scrolling
- SETUP (5-15s): Context and background
- ESCALATION (15-40s): Building tension with key details
- TWIST/REVEAL (40-50s): The surprising element
- RESOLUTION (50-60s): Outcome and impact

Style guidelines:
- Use short, punchy sentences
- Create suspense with pacing
- Include specific details (dates, names, places)
- End with a thought-provoking statement
- Avoid gratuitous violence descriptions`,

  'facts-list': `You are a viral facts content creator specializing in surprising, shareable facts.
Your content is educational yet entertaining.

Structure your scripts with:
- HOOK (0-3s): "Did you know..." or surprising statistic
- FACTS (3-55s): 6-10 facts, each 5-8 seconds
- CLOSER (55-60s): Most mind-blowing fact or CTA

Style guidelines:
- Each fact should be standalone and surprising
- Use numbers and specifics
- Relate facts to everyday life when possible
- Mix serious and fun facts
- Include visual description for each fact`,

  'explainer': `You are an educational content creator who makes complex topics simple and engaging.
Your explanations are clear, memorable, and actionable.

Structure your scripts with:
- HOOK (0-5s): Why this matters to the viewer
- WHAT (5-20s): Define the concept simply
- WHY (20-35s): Why it's important
- HOW (35-50s): How it works or how to use it
- TAKEAWAY (50-60s): Key insight or action step

Style guidelines:
- Use analogies and metaphors
- Avoid jargon, explain like I'm 12
- Use "you" to address viewer directly
- Include one memorable analogy
- End with actionable advice`,

  'story-narration': `You are a master storyteller for short-form video content.
Your narratives are emotionally engaging and visually descriptive.

Structure your scripts with:
- HOOK (0-5s): Intriguing opening line
- SETUP (5-15s): Character and situation
- CONFLICT (15-35s): The challenge or obstacle
- CLIMAX (35-50s): The turning point
- RESOLUTION (50-60s): Outcome and meaning

Style guidelines:
- Create emotional connection
- Use sensory details
- Build tension progressively
- Include dialogue when effective
- End with resonant message`,

  'news': `You are a news presenter for short-form video content.
Your delivery is clear, authoritative, and engaging.

Structure your scripts with:
- HEADLINE (0-5s): Breaking news hook
- WHAT (5-20s): The core story
- CONTEXT (20-35s): Background and significance
- IMPACT (35-50s): What this means
- NEXT (50-60s): What to watch for

Style guidelines:
- Lead with the most important info
- Be objective and factual
- Use present tense when possible
- Include specific numbers/dates
- Cite sources when relevant`,

  'how-to': `You are a tutorial creator specializing in quick, actionable how-to content.
Your instructions are clear, concise, and easy to follow.

Structure your scripts with:
- HOOK (0-5s): The result they'll achieve
- OVERVIEW (5-10s): What we'll cover
- STEPS (10-50s): 3-5 clear steps
- RESULT (50-55s): Show the outcome
- CTA (55-60s): Encourage action

Style guidelines:
- Number your steps clearly
- One action per step
- Use "you" and "your"
- Include pro tips
- Anticipate common mistakes`,

  'review': `You are a product/service reviewer creating honest, helpful review content.
Your reviews are balanced, specific, and viewer-focused.

Structure your scripts with:
- HOOK (0-5s): Overall verdict teaser
- INTRO (5-10s): What you're reviewing
- PROS (10-30s): 3 best features
- CONS (30-45s): 1-2 honest downsides
- VERDICT (45-60s): Who should buy/skip

Style guidelines:
- Be specific, not generic
- Compare to alternatives
- Include price context
- Personal experience helps
- Clear recommendation`,

  'pov-scene': `You are a POV content creator making immersive first-person scenarios.
Your scenes are relatable, engaging, and emotionally resonant.

Structure your scripts with:
- SETUP (0-5s): "POV: [situation]"
- IMMERSION (5-20s): Building the scene
- EXPERIENCE (20-45s): The journey/emotion
- PEAK (45-55s): Climax moment
- CLOSE (55-60s): Satisfying ending

Style guidelines:
- Use "you" consistently
- Describe sensory details
- Build anticipation
- Create emotional payoff
- Relatable situations work best`,
};

// Generate user prompt based on request
export function buildUserPrompt(request: ScriptRequest): string {
  const { topic, duration, language = 'en', tone = 'professional', includeHooks = true } = request;

  let prompt = `Write a ${duration}-second video script about: ${topic}\n\n`;

  prompt += `Requirements:\n`;
  prompt += `- Duration: ${duration} seconds total\n`;
  prompt += `- Language: ${language === 'en' ? 'English' : language}\n`;
  prompt += `- Tone: ${tone}\n`;

  if (includeHooks) {
    prompt += `- Include a strong hook in the first 5 seconds\n`;
  }

  prompt += `\nFormat your response as:\n`;
  prompt += `1. Full script text (spoken words only)\n`;
  prompt += `2. Segment breakdown with timestamps and visual suggestions\n`;

  prompt += `\nUse this JSON structure for segments:\n`;
  prompt += `[
  {
    "type": "hook|beat|transition|cta",
    "startTime": 0,
    "endTime": 5,
    "text": "spoken text here",
    "visualPrompt": "description for AI video/image generation"
  }
]\n`;

  return prompt;
}

// Quick prompt templates for common use cases
export const QUICK_PROMPTS = {
  trueCrimeIntro: (case_name: string) =>
    `Write a 60-second true crime script about ${case_name}. Focus on the mystery and investigation.`,

  factsAbout: (topic: string, count: number = 8) =>
    `Write a 60-second script with ${count} surprising facts about ${topic}. Make each fact memorable.`,

  explainConcept: (concept: string) =>
    `Explain ${concept} in a 60-second video script. Make it simple enough for anyone to understand.`,

  productReview: (product: string) =>
    `Write a 60-second honest review of ${product}. Include 3 pros and 1 con.`,

  howToGuide: (task: string) =>
    `Write a 60-second how-to guide for ${task}. Break it into 4-5 simple steps.`,

  povScenario: (scenario: string) =>
    `Write a 60-second POV script: "${scenario}". Make it relatable and engaging.`,
};

// Parse script response into segments
export function parseScriptResponse(content: string): {
  fullScript: string;
  segments: Array<{
    id: string;
    type: string;
    text: string;
    duration: number;
    visualPrompt: string;
  }>;
} {
  // Try to extract JSON segments from response
  const jsonMatch = content.match(/\[[\s\S]*\]/);

  let segments: Array<{
    id: string;
    type: string;
    text: string;
    duration: number;
    visualPrompt: string;
  }> = [];

  if (jsonMatch) {
    try {
      const parsed = JSON.parse(jsonMatch[0]);
      segments = parsed.map((seg: {
        type?: string;
        startTime?: number;
        endTime?: number;
        text?: string;
        visualPrompt?: string;
      }, i: number) => ({
        id: `seg_${i}`,
        type: seg.type || 'beat',
        text: seg.text || '',
        duration: (seg.endTime || 0) - (seg.startTime || 0),
        visualPrompt: seg.visualPrompt || '',
      }));
    } catch {
      // If JSON parsing fails, create single segment
      segments = [{
        id: 'seg_0',
        type: 'beat',
        text: content,
        duration: 60,
        visualPrompt: 'Dynamic visuals matching the narration',
      }];
    }
  }

  // Extract full script (everything before JSON or the whole content)
  const fullScript = jsonMatch
    ? content.substring(0, content.indexOf(jsonMatch[0])).trim()
    : content;

  return { fullScript, segments };
}
