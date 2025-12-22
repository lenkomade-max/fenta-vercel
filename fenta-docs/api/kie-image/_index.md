# KIE.ai Image Generation APIs

## Base URL
```
https://api.kie.ai
```

## Authentication
```
Authorization: Bearer YOUR_API_KEY
```

## Available Models

| Model | Endpoint | Credits | Notes |
|-------|----------|---------|-------|
| GPT-4o Image | `/api/v1/gpt4o-image/generate` | 10 | Text-to-image & editing |
| Flux Kontext | `/api/v1/flux/kontext/generate` | 8 | Pro & Max variants |
| Midjourney | `/api/v1/mj/generate` | 25 | v7, 6.1, Niji6 |
| Seedream V4 | `/api/v1/seedream/generate` | 3.5 | ByteDance, up to 4K |
| Nano Banana | `/api/v1/nano-banana/generate` | 4 | Gemini 2.5 Flash |
| Qwen Image | `/api/v1/qwen/generate` | 6-8 | Chinese & English |
| Recraft Upscale | `/api/v1/recraft/upscale` | 2-4 | 2x/4x upscaling |
| Recraft Remove BG | `/api/v1/recraft/remove-background` | 1-2 | Transparent PNG |
| Ghibli Style | See [ghibli-style.md](./ghibli-style.md) | 8-12 | Style via GPT-4o or Flux |

## Common Pattern

### 1. Create Task
```http
POST /api/v1/{service}/generate
Content-Type: application/json
Authorization: Bearer API_KEY

{
  "prompt": "description",
  "size": "1:1"
}
```

### 2. Check Status
```http
GET /api/v1/{service}/record-info?taskId={taskId}
```

### 3. Status Codes
- `0` - generating
- `1` - success
- `2` - failed

## Storage
- Files stored: 14 days
- Download URL valid: 20 minutes

## Documentation Files

### Model Documentation
- [gpt4o-image.md](./gpt4o-image.md) - GPT-4o Image API
- [flux.md](./flux.md) - Flux Kontext API
- [midjourney.md](./midjourney.md) - Midjourney API
- [seedream.md](./seedream.md) - Seedream V4 API
- [nano-banana.md](./nano-banana.md) - Nano Banana API
- [qwen.md](./qwen.md) - Qwen Image API
- [recraft.md](./recraft.md) - Recraft Upscale & Remove Background

### Guides
- [ghibli-style.md](./ghibli-style.md) - Ghibli Style Generation (Style Guide)
- [comparison.md](./comparison.md) - Model Comparison & Selection Guide
