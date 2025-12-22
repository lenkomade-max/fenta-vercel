# Qwen Image API (KIE.ai)

## Endpoint
```
POST https://api.kie.ai/api/v1/qwen/generate
```

## Authentication
```
Authorization: Bearer YOUR_API_KEY
```

## Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `prompt` | string | Yes | Image description (supports Chinese and English) |
| `image_size` | string | No | Image aspect ratio |
| `num_inference_steps` | integer | No | Quality/speed tradeoff (default: 30) |
| `guidance_scale` | float | No | CFG scale, controls prompt adherence (default: 7.5) |
| `seed` | integer | No | Random seed for reproducibility |
| `acceleration_level` | string | No | `none`, `regular`, `high` |
| `output_format` | string | No | Image format (default: `png`) |
| `safety_check` | boolean | No | Enable safety checker (default: true) |
| `callBackUrl` | string | No | Webhook URL for async notification |

## Image Size Options
- `square` - 1:1
- `square_hd` - 1:1 HD
- `portrait_4_3` - 4:3
- `portrait_3_2` - 3:2
- `portrait_16_9` - 16:9
- `landscape_4_3` - 4:3 (default)
- `landscape_3_2` - 3:2
- `landscape_16_9` - 16:9

## Example Request (Text-to-Image)
```json
{
  "prompt": "A dragon flying over ancient mountains, digital art style",
  "image_size": "landscape_16_9",
  "num_inference_steps": 30,
  "guidance_scale": 7.5,
  "acceleration_level": "regular"
}
```

## Response
```json
{
  "code": 200,
  "msg": "success",
  "data": {
    "taskId": "qwen_task_xyz789"
  }
}
```

## Check Status
```
GET https://api.kie.ai/api/v1/qwen/record-info?taskId=YOUR_TASK_ID
```

## Status Codes
- `0` - Generating
- `1` - Success
- `2` - Failed
- `3` - Creation failed

## Response Example (Success)
```json
{
  "taskId": "qwen_task_xyz789",
  "successFlag": 1,
  "imageUrl": "https://cdn.kie.ai/qwen/image.png",
  "createTime": "2025-12-07T10:00:00Z",
  "completeTime": "2025-12-07T10:08:00Z"
}
```

## Acceleration Levels
- **none** - Highest quality, slowest generation
- **regular** - Balanced quality and speed (recommended)
- **high** - Fastest generation, good quality

## Specs
- Cost: 6-8 credits per image (pricing varies by acceleration)
- Model: Qwen Image (Alibaba)
- Language support: Chinese and English
- Strengths: Complex text rendering, precise image editing, multilingual prompts
- Reproducibility: Same seed + same prompt = same output
- Output formats: PNG, JPG
- Storage: 14 days
