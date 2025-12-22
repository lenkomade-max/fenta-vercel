# Workflow Builder - Node Reference

## Overview

The Workflow Builder uses a visual node-based system for creating video production pipelines. Each node represents a specific operation with inputs, outputs, and configurable parameters.

## Node Categories

1. **Input Nodes** - Fetch or generate source materials
2. **Script Nodes** - Generate or transform text content
3. **Audio Nodes** - Voice synthesis and audio mixing
4. **Subtitle Nodes** - Automatic subtitle generation
5. **Edit Nodes** - Video editing and timeline assembly
6. **Output Nodes** - Export and delivery

## Node Execution Flow

Nodes execute in **topological order** based on the dependency graph. Each node:

1. Waits for all input dependencies
2. Validates input data
3. Executes its operation
4. Produces output data
5. Passes to downstream nodes

## Common Node Properties

All nodes share these base properties:

```typescript
interface BaseNode {
  id: string;                    // Unique identifier (e.g., "n1", "n2")
  type: NodeType;                // Node type enum
  params: Record<string, any>;   // Node-specific parameters
  position: {                    // UI position in canvas
    x: number;
    y: number;
  };
  label?: string;                // Optional custom label
  disabled?: boolean;            // Skip execution if true
}
```

## Input/Output Ports

Each node defines input and output ports:

```typescript
interface NodePort {
  id: string;          // Port identifier
  type: PortDataType;  // 'text', 'image', 'video', 'audio', 'array', 'object'
  required: boolean;   // Whether this port must be connected
  label: string;       // Display label
}
```

---

## Input Nodes

### Input.Upload

Load user-uploaded assets from storage.

**Type**: `Input.Upload`

**Parameters:**
```typescript
{
  assetIds: string[];  // Array of asset IDs to load
}
```

**Inputs:** None

**Outputs:**
- `assets` (array) - Array of asset objects with URLs

**Cost:** Free (assets already uploaded)

**Example:**
```json
{
  "id": "n1",
  "type": "Input.Upload",
  "params": {
    "assetIds": ["asset_abc123", "asset_xyz789"]
  }
}
```

---

### Input.Stock

Search and fetch stock footage from Pexels.

**Type**: `Input.Stock`

**Parameters:**
```typescript
{
  provider: 'pexels';           // Stock provider (currently only Pexels)
  query: string;                // Search query
  type?: 'image' | 'video';     // Asset type (default: 'video')
  count?: number;               // Number of results (default: 1, max: 10)
  orientation?: 'portrait' | 'landscape' | 'square';
  minDuration?: number;         // Min duration in seconds (video only)
  maxDuration?: number;         // Max duration in seconds (video only)
}
```

**Inputs:** None

**Outputs:**
- `assets` (array) - Array of stock assets with URLs

**Cost:** Free (Pexels is free stock)

**Example:**
```json
{
  "id": "n1",
  "type": "Input.Stock",
  "params": {
    "provider": "pexels",
    "query": "storm city night",
    "type": "video",
    "count": 3,
    "orientation": "portrait",
    "minDuration": 5,
    "maxDuration": 15
  }
}
```

---

### Input.KAI.GenerateImage

Generate images using KAI models.

**Type**: `Input.KAI.GenerateImage`

**Parameters:**
```typescript
{
  prompt: string;               // Generation prompt
  model?: string;               // Model name (default: 'flux-pro')
  width?: number;               // Image width (default: 1024)
  height?: number;              // Image height (default: 1024)
  seed?: number;                // Random seed for reproducibility
  variations?: number;          // Number of variations (default: 1, max: 4)
  style?: string;               // Style preset
}
```

**Inputs:**
- `prompt` (text, optional) - Override or append to prompt parameter

**Outputs:**
- `images` (array) - Array of generated image assets

**Cost:** ~0.04 USD per image (model-dependent)

**Example:**
```json
{
  "id": "n1",
  "type": "Input.KAI.GenerateImage",
  "params": {
    "prompt": "A futuristic city at sunset, cyberpunk style, neon lights",
    "model": "flux-pro",
    "width": 1024,
    "height": 1024,
    "variations": 3,
    "seed": 42
  }
}
```

---

### Input.KAI.GenerateVideo

Generate video clips using AI video models.

**Type**: `Input.KAI.GenerateVideo`

**Parameters:**
```typescript
{
  prompt: string;               // Generation prompt
  model: 'sora' | 'veo' | 'minimax' | 'bio3' | 'cdance';
  duration?: number;            // Duration in seconds (model-dependent)
  aspect?: '9:16' | '16:9' | '1:1';  // Aspect ratio
  seed?: number;                // Random seed
  fps?: number;                 // Frames per second (default: 24)
}
```

**Model Limitations:**
- **Sora**: 10-15 seconds max
- **VEO**: 8-12 seconds max
- **Minimax**: 6-10 seconds max
- **BIO3**: 6-8 seconds max
- **C-DANCE**: 4-6 seconds max

**Inputs:**
- `prompt` (text, optional) - Override or append to prompt

**Outputs:**
- `video` (video) - Generated video clip

**Cost:** 0.10 - 0.50 USD per generation (model-dependent)

**Example:**
```json
{
  "id": "n2",
  "type": "Input.KAI.GenerateVideo",
  "params": {
    "prompt": "A cat walking through a neon-lit alley at night",
    "model": "sora",
    "duration": 10,
    "aspect": "9:16",
    "fps": 24
  }
}
```

---

### Input.KAI.EditVideo

Edit existing video using AI.

**Type**: `Input.KAI.EditVideo`

**Parameters:**
```typescript
{
  prompt: string;               // Edit instruction
  model?: string;               // Edit model
  strength?: number;            // Edit strength (0.0 - 1.0)
}
```

**Inputs:**
- `video` (video, required) - Source video to edit

**Outputs:**
- `video` (video) - Edited video

**Cost:** ~0.30 USD per edit

**Example:**
```json
{
  "id": "n3",
  "type": "Input.KAI.EditVideo",
  "params": {
    "prompt": "Make it rain heavily",
    "strength": 0.7
  }
}
```

---

## Script Nodes

### Script.Generate

Generate video script using LLM.

**Type**: `Script.Generate`

**Parameters:**
```typescript
{
  genre: 'crime' | 'humor' | 'news' | 'explainer' | 'story' | 'facts' | 'review' | 'howto';
  lang?: string;                // Language code (default: 'en')
  prompt?: string;              // Additional instructions
  targetDuration?: number;      // Target duration in seconds
  tone?: 'casual' | 'formal' | 'energetic' | 'calm';
  beats?: number;               // Number of story beats (for story/narration)
  model?: 'gpt-4' | 'gpt-3.5-turbo' | 'claude-3-sonnet';
}
```

**Genre Templates:**

- **crime**: True crime story structure (hook, backstory, twist, resolution)
- **humor**: Setup, punchline, callback
- **news**: Headline, context, key points, what's next
- **explainer**: Problem, explanation, solution
- **story**: Classic story arc with 4-6 beats
- **facts**: List of interesting facts
- **review**: Product/service review structure
- **howto**: Step-by-step instructions

**Inputs:**
- `topic` (text, optional) - Topic or subject matter

**Outputs:**
- `script` (text) - Generated script text
- `metadata` (object) - Script metadata (beats, estimated duration)

**Cost:** ~0.01 - 0.05 USD (based on model and length)

**Example:**
```json
{
  "id": "n4",
  "type": "Script.Generate",
  "params": {
    "genre": "news",
    "lang": "en",
    "prompt": "30s punchy headline + 3 key points",
    "targetDuration": 30,
    "tone": "energetic",
    "model": "gpt-4"
  }
}
```

**Sample Output:**
```json
{
  "script": "BREAKING: Scientists discover...\n\nHere's what you need to know:\n1. The discovery...\n2. Why it matters...\n3. What comes next...",
  "metadata": {
    "beats": 4,
    "estimatedDuration": 28,
    "wordCount": 85
  }
}
```

---

### Script.Transform

Transform existing script (translate, compress, adapt).

**Type**: `Script.Transform`

**Parameters:**
```typescript
{
  operation: 'translate' | 'compress' | 'expand' | 'adapt';
  targetLang?: string;          // For translation
  targetDuration?: number;      // For compression/expansion
  style?: string;               // For adaptation
  model?: string;
}
```

**Inputs:**
- `script` (text, required) - Source script

**Outputs:**
- `script` (text) - Transformed script

**Cost:** ~0.01 - 0.03 USD

**Example:**
```json
{
  "id": "n5",
  "type": "Script.Transform",
  "params": {
    "operation": "compress",
    "targetDuration": 15
  }
}
```

---

## Audio Nodes

### Voice.TTS

Convert text to speech using TTS engine.

**Type**: `Voice.TTS`

**Parameters:**
```typescript
{
  engine: 'kokoro' | 'elevenlabs' | 'openai';
  voice: string;                // Voice ID or name
  lang?: string;                // Language code
  speed?: number;               // Speech rate (0.5 - 2.0, default: 1.0)
  pitch?: number;               // Voice pitch adjustment (-1.0 to 1.0)
  emotion?: string;             // Emotion/style (engine-dependent)
}
```

**Available Voices (Kokoro):**
- `alloy_en` - Neutral, clear
- `echo_en` - Male, warm
- `fable_en` - British accent
- `onyx_en` - Deep, authoritative
- `nova_en` - Female, energetic
- `shimmer_en` - Soft, friendly

**Inputs:**
- `script` (text, required) - Text to synthesize

**Outputs:**
- `audio` (audio) - Generated audio file
- `duration` (number) - Audio duration in seconds

**Cost:** ~0.015 USD per minute of audio

**Example:**
```json
{
  "id": "n6",
  "type": "Voice.TTS",
  "params": {
    "engine": "kokoro",
    "voice": "alloy_en",
    "speed": 1.02,
    "emotion": "energetic"
  }
}
```

---

### Audio.Mix

Mix multiple audio tracks with ducking.

**Type**: `Audio.Mix`

**Parameters:**
```typescript
{
  musicAssetId?: string;        // Background music asset ID
  musicVolume?: number;         // Music volume (0.0 - 1.0, default: 0.3)
  ducking?: boolean;            // Lower music when voice active (default: true)
  duckingLevel?: number;        // Duck to this volume (0.0 - 1.0, default: 0.1)
  fadeIn?: number;              // Fade in duration (seconds)
  fadeOut?: number;             // Fade out duration (seconds)
}
```

**Inputs:**
- `voiceAudio` (audio, required) - Voice track
- `musicAudio` (audio, optional) - Background music

**Outputs:**
- `audio` (audio) - Mixed audio file

**Cost:** Free (processing only)

**Example:**
```json
{
  "id": "n7",
  "type": "Audio.Mix",
  "params": {
    "musicAssetId": "asset_music_123",
    "musicVolume": 0.25,
    "ducking": true,
    "duckingLevel": 0.08,
    "fadeIn": 1.0,
    "fadeOut": 2.0
  }
}
```

---

## Subtitle Nodes

### Subtitle.Auto

Generate subtitles from audio or script.

**Type**: `Subtitle.Auto`

**Parameters:**
```typescript
{
  source: 'audio' | 'script';   // Generate from audio (ASR) or script
  style: string;                // Subtitle style preset
  lang?: string;                // Language code

  // Style options
  font?: string;
  fontSize?: number;
  fontColor?: string;
  backgroundColor?: string;
  position?: 'top' | 'center' | 'bottom';
  maxCharsPerLine?: number;
  maxLines?: number;

  // Timing
  karaoke?: boolean;            // Word-by-word highlighting
  minDuration?: number;         // Min subtitle duration (seconds)
  maxDuration?: number;         // Max subtitle duration (seconds)
}
```

**Subtitle Style Presets:**

- **karaoke_bounce**: Word-by-word with bounce animation
- **clean_box**: Simple box background, centered
- **neon_glow**: Glowing text effect
- **minimal**: No background, bottom position
- **bold_shadow**: Bold text with strong shadow

**Inputs:**
- `audio` (audio, required if source='audio') - Audio for ASR
- `script` (text, required if source='script') - Script text

**Outputs:**
- `subtitles` (object) - Subtitle data with timing
- `srt` (text) - SRT format subtitles

**Cost:** ~0.006 USD per minute (for ASR)

**Example:**
```json
{
  "id": "n8",
  "type": "Subtitle.Auto",
  "params": {
    "source": "audio",
    "style": "karaoke_bounce",
    "font": "Inter",
    "fontSize": 44,
    "fontColor": "#FFFFFF",
    "backgroundColor": "#000000CC",
    "position": "bottom",
    "karaoke": true,
    "maxCharsPerLine": 40,
    "maxLines": 2
  }
}
```

**Sample Output:**
```json
{
  "subtitles": [
    {
      "index": 1,
      "start": 0.0,
      "end": 2.5,
      "text": "Breaking news from the city",
      "words": [
        {"word": "Breaking", "start": 0.0, "end": 0.5},
        {"word": "news", "start": 0.6, "end": 1.0},
        {"word": "from", "start": 1.1, "end": 1.3},
        {"word": "the", "start": 1.4, "end": 1.5},
        {"word": "city", "start": 1.6, "end": 2.5}
      ]
    }
  ]
}
```

---

## Edit Nodes

### Edit.Timeline

Assemble video timeline using template.

**Type**: `Edit.Timeline`

**Parameters:**
```typescript
{
  templateId: string;           // Template ID to use

  // Override template settings
  transitionStyle?: string;
  transitionDuration?: number;  // In seconds

  // Scene timing
  autoTiming?: boolean;         // Auto-calculate scene durations
  minSceneDuration?: number;
  maxSceneDuration?: number;

  // Placeholders
  placeholders?: {
    [key: string]: string;      // Placeholder name -> asset ID
  };
}
```

**Inputs:**
- `video` (video | array, required) - Video clip(s) to assemble
- `audio` (audio, optional) - Audio track
- `subtitles` (object, optional) - Subtitle data
- `overlays` (array, optional) - Overlay elements

**Outputs:**
- `timeline` (object) - Complete timeline specification
- `duration` (number) - Total video duration

**Cost:** Free (processing only)

**Example:**
```json
{
  "id": "n9",
  "type": "Edit.Timeline",
  "params": {
    "templateId": "tmpl_shorts_v1",
    "transitionStyle": "crossfade",
    "transitionDuration": 0.3,
    "autoTiming": true,
    "minSceneDuration": 1.2,
    "maxSceneDuration": 4.0,
    "placeholders": {
      "logo": "asset_logo_123"
    }
  }
}
```

**Timeline Output Structure:**
```json
{
  "timeline": {
    "duration": 60.5,
    "tracks": [
      {
        "type": "video",
        "clips": [
          {
            "assetId": "asset_video_1",
            "start": 0,
            "end": 10.5,
            "trim": {"in": 0, "out": 10.5},
            "transition": {"type": "crossfade", "duration": 0.3}
          }
        ]
      },
      {
        "type": "audio",
        "clips": [...]
      },
      {
        "type": "subtitle",
        "items": [...]
      }
    ]
  }
}
```

---

## Output Nodes

### Output.Render

Render final video using FantaProjekt.

**Type**: `Output.Render`

**Parameters:**
```typescript
{
  profile: '9x16_1080p' | '16x9_1080p' | '1x1_1080p' | '9x16_720p';

  // Quality settings
  bitrate?: number;             // Video bitrate in kbps
  fps?: number;                 // Frames per second (default: 30)
  codec?: 'h264' | 'h265';      // Video codec

  // Audio settings
  audioBitrate?: number;        // Audio bitrate in kbps (default: 192)
  audioSampleRate?: number;     // Sample rate (default: 48000)

  // Export options
  format?: 'mp4' | 'mov';       // Output format
  preset?: 'fast' | 'balanced' | 'quality';  // Encoding preset
}
```

**Render Profiles:**

| Profile       | Resolution | Aspect | Typical Use        |
|---------------|------------|--------|--------------------|
| 9x16_1080p    | 1080x1920  | 9:16   | TikTok, Reels, Shorts |
| 16x9_1080p    | 1920x1080  | 16:9   | YouTube, Twitter   |
| 1x1_1080p     | 1080x1080  | 1:1    | Instagram Feed     |
| 9x16_720p     | 720x1280   | 9:16   | Budget option      |

**Inputs:**
- `timeline` (object, required) - Complete timeline from Edit.Timeline

**Outputs:**
- `renderJobId` (text) - FantaProjekt job ID for tracking

**Cost:** Based on duration and quality
- 720p: ~0.02 USD per second
- 1080p: ~0.03 USD per second

**Example:**
```json
{
  "id": "n10",
  "type": "Output.Render",
  "params": {
    "profile": "9x16_1080p",
    "fps": 30,
    "codec": "h264",
    "audioBitrate": 192,
    "preset": "balanced"
  }
}
```

---

### Output.Download

Make rendered video available for download.

**Type**: `Output.Download`

**Parameters:**
```typescript
{
  generateThumbnail?: boolean;  // Generate thumbnail (default: true)
  thumbnailTime?: number;       // Thumbnail timestamp (seconds, default: 0)
  includeSrt?: boolean;         // Include SRT file (default: true)
  expiresIn?: number;           // URL expiration (seconds, default: 3600)
}
```

**Inputs:**
- `renderJobId` (text, required) - Render job ID from Output.Render

**Outputs:**
- `videoUrl` (text) - Presigned download URL
- `thumbnailUrl` (text) - Thumbnail URL
- `srtUrl` (text) - Subtitle file URL (if available)
- `metadata` (object) - Video metadata

**Cost:** Free (storage costs apply separately)

**Example:**
```json
{
  "id": "n11",
  "type": "Output.Download",
  "params": {
    "generateThumbnail": true,
    "thumbnailTime": 1.0,
    "includeSrt": true,
    "expiresIn": 7200
  }
}
```

---

## Scheduling Node

### Schedule.Cron

Execute workflow on schedule.

**Type**: `Schedule.Cron`

**Parameters:**
```typescript
{
  cron: string;                 // Cron expression
  timezone?: string;            // Timezone (default: 'UTC')
  enabled?: boolean;            // Enable/disable (default: true)
  maxRuns?: number;             // Max executions (optional)
  runUntil?: string;            // End date (ISO 8601, optional)
}
```

**Cron Examples:**
- `0 10 * * *` - Daily at 10:00 AM
- `0 */6 * * *` - Every 6 hours
- `0 9 * * 1` - Every Monday at 9:00 AM
- `0 0 1 * *` - First day of every month

**Inputs:** None (workflow-level configuration)

**Outputs:** None (triggers workflow execution)

**Cost:** Free (execution costs apply)

**Example:**
```json
{
  "id": "sched1",
  "type": "Schedule.Cron",
  "params": {
    "cron": "0 10 * * *",
    "timezone": "America/New_York",
    "enabled": true
  }
}
```

---

## Advanced Node Patterns

### Conditional Execution

Use node parameters to enable conditional logic:

```json
{
  "id": "n5",
  "type": "Input.Stock",
  "params": {
    "query": "{{fallback_query}}",
    "count": 1
  },
  "disabled": "{{use_generated_video}}"  // Disable if using generated video
}
```

### Parallel Execution

Nodes without dependencies execute in parallel:

```json
{
  "nodes": [
    {"id": "n1", "type": "Input.Stock", "params": {...}},
    {"id": "n2", "type": "Script.Generate", "params": {...}},
    {"id": "n3", "type": "Input.KAI.GenerateImage", "params": {...}}
  ],
  "edges": [
    // No edges between n1, n2, n3 - they run in parallel
    {"from": "n1", "to": "n4"},
    {"from": "n2", "to": "n4"},
    {"from": "n3", "to": "n4"}
  ]
}
```

### Loop/Iteration

For multiple variants, use array inputs and variations parameter:

```json
{
  "id": "n1",
  "type": "Input.KAI.GenerateImage",
  "params": {
    "prompt": "Scene {{scene_number}}",
    "variations": 3  // Generate 3 variants
  }
}
```

---

## Error Handling

Each node can fail with specific error codes:

```typescript
interface NodeError {
  code: string;
  message: string;
  details?: any;
  retryable: boolean;
}
```

**Common Error Codes:**

- `INVALID_PARAMS` - Invalid node parameters
- `MISSING_INPUT` - Required input not provided
- `QUOTA_EXCEEDED` - User quota limit reached
- `API_ERROR` - External API failure
- `PROCESSING_FAILED` - Internal processing error
- `TIMEOUT` - Node execution timeout

**Retry Strategy:**
- Retryable errors: 3 attempts with exponential backoff
- Non-retryable errors: Fail immediately
- Timeout: 5 minutes per node (configurable)

---

## Cost Estimation

Before executing workflow, estimate total cost:

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
    {"node": "n2", "type": "Script.Generate", "cost": 0.02},
    {"node": "n3", "type": "Input.KAI.GenerateVideo", "cost": 0.40},
    {"node": "n6", "type": "Voice.TTS", "cost": 0.05},
    {"node": "n10", "type": "Output.Render", "cost": 0.40}
  ]
}
```

---

## Best Practices

### 1. Node Naming

Use descriptive IDs for clarity:
```json
{"id": "stock_broll", "type": "Input.Stock", ...}
{"id": "generate_script", "type": "Script.Generate", ...}
{"id": "render_final", "type": "Output.Render", ...}
```

### 2. Parameter Validation

Validate parameters before submission to avoid runtime errors.

### 3. Resource Cleanup

Failed nodes automatically clean up temporary resources.

### 4. Progress Tracking

Monitor node execution through job status:
```json
{
  "progress": 65,
  "currentNode": "n8",
  "completedNodes": ["n1", "n2", "n3", "n4", "n5", "n6", "n7"]
}
```

### 5. Testing

Use test mode to render only first 10-15 seconds:
```http
POST /v1/workflows/{id}/run
{
  "mode": "test"
}
```

---

## Node Development Guide

Custom nodes can be added following this interface:

```typescript
interface CustomNode extends BaseNode {
  execute(inputs: NodeInputs, params: NodeParams): Promise<NodeOutputs>;
  validate(params: NodeParams): ValidationResult;
  estimateCost(params: NodeParams): CostEstimate;
}
```

See [Contributing Guide](../CONTRIBUTING.md) for details.
