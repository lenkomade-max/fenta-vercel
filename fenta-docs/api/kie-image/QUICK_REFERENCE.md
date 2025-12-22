# KIE.ai Image APIs - Quick Reference Sheet

## Models at a Glance

| Model | Endpoint | Credits | Speed | Quality | Best For |
|-------|----------|---------|-------|---------|----------|
| **Seedream** | `/seedream/generate` | 3.5 💰 | ⚡⚡⚡ | ★★★★ | Budget, 4K |
| **Nano Banana** | `/nano-banana/generate` | 4 💰 | ⚡⚡⚡ | ★★★★ | Editing |
| **Qwen** | `/qwen/generate` | 6-8 | ⚡⚡ | ★★★★ | Text, Chinese |
| **Flux** | `/flux/kontext/generate` | 8-12 | ⚡⚡ | ★★★★★ | Pro editing |
| **GPT-4o** | `/gpt4o-image/generate` | 10 | ⚡⚡ | ★★★★★ | Text quality |
| **Midjourney** | `/mj/generate` | 25 | ⚡ | ★★★★★ | Artistic |
| **Recraft BG** | `/recraft/remove-background` | 1-2 | ⚡⚡⚡ | ★★★★ | Remove BG |
| **Recraft 2x** | `/recraft/upscale` | 2-4 | ⚡⚡⚡ | ★★★★ | Upscale |

---

## Fastest Implementation (Copy-Paste)

### 1. Seedream V4 (Cheapest & Fast)
```bash
curl -X POST https://api.kie.ai/api/v1/seedream/generate \
  -H "Authorization: Bearer YOUR_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "A beautiful sunset over mountains",
    "image_size": "landscape_16_9",
    "image_resolution": "2K"
  }'
```

### 2. Check Status
```bash
curl -X GET "https://api.kie.ai/api/v1/seedream/record-info?taskId=TASK_ID" \
  -H "Authorization: Bearer YOUR_KEY"
```

---

## By Use Case

### 💰 Budget Mode (< $0.02 per image)
```json
{
  "model": "seedream",
  "endpoint": "/api/v1/seedream/generate",
  "cost": "3.5 credits",
  "notes": "Perfect for TikTok/Reels bulk"
}
```

### ⚡ Speed Mode (< 30 seconds)
```json
{
  "model": "seedream or nano-banana",
  "cost": "3.5-4 credits",
  "speed": "15-30 seconds",
  "notes": "Real-time apps"
}
```

### ✨ Quality Mode (Best images)
```json
{
  "model": "flux-kontext-max or midjourney",
  "cost": "8-25 credits",
  "quality": "Professional/Portfolio",
  "notes": "High-stakes projects"
}
```

### 🎨 Artistic Mode (Styles, anime)
```json
{
  "model": "midjourney",
  "versions": ["v7", "niji6"],
  "cost": "25 credits",
  "notes": "For creative work"
}
```

### 📝 Text Mode (Text in images)
```json
{
  "model": "gpt4o or qwen",
  "cost": "6-10 credits",
  "notes": "Posters, ads, graphics"
}
```

### 🌏 Chinese Mode
```json
{
  "model": "seedream or qwen",
  "languages": ["中文", "English"],
  "cost": "3.5-8 credits"
}
```

### 🛠️ Utility Mode
```json
{
  "remove_bg": "/api/v1/recraft/remove-background",
  "upscale": "/api/v1/recraft/upscale",
  "cost": "1-4 credits",
  "notes": "Image processing"
}
```

---

## Common Parameters by Model

### All Models
```json
{
  "prompt": "string, required",
  "callBackUrl": "webhook url, optional",
  "seed": "integer for reproducibility, optional"
}
```

### Seedream V4
```json
{
  "image_size": "square|portrait_4_3|landscape_16_9|...",
  "image_resolution": "1K|2K|4K",
  "num_inference_steps": "1-50, default 30"
}
```

### Nano Banana
```json
{
  "model": "google/nano-banana|google/nano-banana-edit",
  "width": "pixel width",
  "height": "pixel height",
  "steps": "20-60"
}
```

### Qwen
```json
{
  "image_size": "square|landscape_4_3|...",
  "num_inference_steps": "1-50",
  "acceleration_level": "none|regular|high"
}
```

### Flux Kontext
```json
{
  "model": "flux-kontext-pro|flux-kontext-max",
  "aspectRatio": "16:9|1:1|9:16|...",
  "imageUrl": "for editing mode",
  "promptUpsampling": true
}
```

### Midjourney
```json
{
  "taskType": "mj_txt2img|mj_img2img|mj_video",
  "version": "7|6.1|Niji6",
  "speed": "Relax|Fast|Turbo",
  "stylization": "0-1000",
  "weirdness": "0-3000"
}
```

### GPT-4o
```json
{
  "size": "1:1|3:2|2:3",
  "nVariants": "1|2|4",
  "isEnhance": true,
  "filesUrl": ["image1.jpg", "image2.jpg"]
}
```

---

## Status Codes (All Models)
```
0 = Generating (poll again)
1 = Success (resultUrls available)
2 = Failed
3 = Creation failed
```

---

## Response Format (All Models)

### Success Response (code 200)
```json
{
  "code": 200,
  "msg": "success",
  "data": {
    "taskId": "task_abc123"
  }
}
```

### Status Check Response
```json
{
  "taskId": "task_abc123",
  "successFlag": 1,
  "imageUrl": "https://cdn.kie.ai/...",
  "createTime": "2025-12-07T10:00:00Z",
  "completeTime": "2025-12-07T10:05:00Z"
}
```

### Error Response
```json
{
  "code": 402,
  "msg": "Insufficient Credits",
  "data": null
}
```

---

## Authentication
```
All requests require:
Header: Authorization: Bearer YOUR_API_KEY
```

Get API key from: https://kie.ai (Dashboard → API Keys)

---

## Webhooks (Optional)

Send `callBackUrl` when creating task:
```json
{
  "prompt": "...",
  "callBackUrl": "https://your-domain.com/webhook"
}
```

KIE.ai will POST to your webhook when done:
```json
{
  "code": 200,
  "data": {
    "taskId": "task_abc123",
    "resultUrls": ["https://cdn.kie.ai/..."]
  }
}
```

---

## Workflow Examples

### Single Image Generation
```
1. POST /api/v1/{service}/generate
   → Returns taskId
2. GET /api/v1/{service}/record-info?taskId={taskId}
   → Check successFlag
3. When successFlag=1
   → Use resultUrls
```

### Batch Processing
```
1. Queue 100 tasks (Seedream, budget-friendly)
2. Store all taskIds
3. Poll status every 5 seconds
4. Download results when complete
5. Recraft upscale if needed (2-4 credits more)
```

### Pipeline
```
Text → Seedream (3.5 credits)
       ↓
    Upscale (2-4 credits) [Optional]
       ↓
    Remove BG (1-2 credits) [Optional]
       ↓
    Total: 3.5-9.5 credits per image
```

---

## Cost Calculator

```
Budget mode:
- 100 images × 3.5 = 350 credits ≈ $1.75

Balanced mode:
- 100 images × 8 = 800 credits ≈ $4

Premium mode:
- 100 images × 25 = 2500 credits ≈ $12.50

With upscaling:
- 100 images × (3.5 + 2) = 550 credits ≈ $2.75
```

---

## Tips & Tricks

### 1. Prompt Engineering
```
Good: "A serene mountain landscape with misty valleys"
Better: "A serene mountain landscape at sunrise,
         misty valleys, digital art, 4K, highly detailed"
```

### 2. Use Webhooks (Don't Poll)
```
Fast polling = wasted API calls
Use callBackUrl → KIE.ai notifies you when done
```

### 3. Batch in Parallel
```
Send 10-50 requests at once
Don't wait for one to finish
Check status later
```

### 4. Cache Results
```
Results stored 14 days
Download URL valid 20 minutes
Save images locally immediately
```

### 5. Seed for Reproducibility
```json
{
  "prompt": "same prompt",
  "seed": 12345
}
// Same seed + prompt = identical image
```

### 6. Model Selection
```
Quick test: Seedream (cheap, fast)
If good: use it
If bad: try Nano Banana
Still bad: upgrade to Flux/GPT-4o
Last resort: Midjourney (expensive but best)
```

---

## Files Reference

- **Full Docs:** `_index.md`
- **Comparison:** `comparison.md`
- **Each Model:** `{model-name}.md`
- **Ghibli Style:** `ghibli-style.md`

---

## Common HTTP Status Codes

```
200 Success
400 Bad Request (check parameters)
401 Unauthorized (check API key)
402 Insufficient Credits (add credits)
404 Not Found (wrong endpoint)
422 Validation Error (invalid parameters)
429 Rate Limited (wait, then retry)
455 Service Unavailable (KIE.ai maintenance)
500 Server Error (contact support)
```

---

**Last Updated:** Dec 7, 2025
**API Base:** https://api.kie.ai
