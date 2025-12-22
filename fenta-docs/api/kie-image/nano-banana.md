# Nano Banana API (KIE.ai)

## Endpoint
```
POST https://api.kie.ai/api/v1/nano-banana/generate
```

## Authentication
```
Authorization: Bearer YOUR_API_KEY
```

## Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `prompt` | string | Yes | Image description |
| `model` | string | No | `google/nano-banana` or `google/nano-banana-edit` |
| `img_url` | string | No | Input image URL for editing (separate multiple with commas, up to 5) |
| `negative_prompt` | string | No | What to avoid in the image |
| `seed` | integer | No | Random seed for reproducibility |
| `width` | integer | No | Output width in pixels |
| `height` | integer | No | Output height in pixels |
| `steps` | integer | No | Number of inference steps (20-60) |
| `guidance_scale` | float | No | Prompt strength (1-20) |
| `callBackUrl` | string | No | Webhook URL for async notification |

## Models
- **google/nano-banana** - Text-to-image generation (Gemini 2.5 Flash)
- **google/nano-banana-edit** - Image-to-image editing (preserves subject identity)
- **google/nano-banana-pro** - Enhanced version (Gemini 3 Pro) - higher quality

## Example Request (Text-to-Image)
```json
{
  "prompt": "A hyper-realistic portrait of a woman in a flowing dress in a field of wildflowers",
  "model": "google/nano-banana",
  "width": 1024,
  "height": 1024,
  "steps": 40,
  "guidance_scale": 7.5
}
```

## Example Request (Image Editing)
```json
{
  "prompt": "Change the background to a sunset beach scene",
  "model": "google/nano-banana-edit",
  "img_url": "https://example.com/image.jpg",
  "negative_prompt": "blurry, low quality",
  "guidance_scale": 8.5
}
```

## Response
```json
{
  "code": 200,
  "msg": "success",
  "data": {
    "taskId": "nano_banana_task_abc123"
  }
}
```

## Check Status
```
GET https://api.kie.ai/api/v1/nano-banana/record-info?taskId=YOUR_TASK_ID
```

## Status Codes
- `0` - Generating
- `1` - Success
- `2` - Failed
- `3` - Creation failed

## Response Example (Success)
```json
{
  "taskId": "nano_banana_task_abc123",
  "successFlag": 1,
  "imageUrl": "https://cdn.kie.ai/nano-banana/image.jpg",
  "createTime": "2025-12-07T10:00:00Z",
  "completeTime": "2025-12-07T10:02:15Z"
}
```

## Specs
- Cost: 4 credits per image ($0.02)
- Models: Standard (Gemini 2.5 Flash), Pro (Gemini 3 Pro)
- Generation time: ~30-60 seconds
- Storage: 14 days
- Supports: Text-to-image, Image-to-image editing
- Max images for reference: 5
- Strengths: Subject consistency, physics-aware visuals, accurate text rendering
- Output formats: JPEG, PNG, WebP
