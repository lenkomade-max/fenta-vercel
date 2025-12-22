# Seedream API (KIE.ai)

## Endpoint
```
POST https://api.kie.ai/api/v1/seedream/generate
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
| `image_resolution` | string | No | `1K`, `2K`, `4K` |
| `num_inference_steps` | integer | No | Quality/speed tradeoff (1-50) |
| `guidance_scale` | float | No | Prompt adherence (1-20) |
| `seed` | integer | No | Random seed for reproducibility |
| `input_image_url` | string | No | Input image for editing (img2img) |
| `callBackUrl` | string | No | Webhook URL for async notification |

## Image Size Options
- `square` - 1:1
- `square_hd` - 1:1 HD
- `portrait_4_3` - 4:3
- `portrait_3_2` - 3:2
- `portrait_16_9` - 16:9
- `landscape_4_3` - 4:3
- `landscape_3_2` - 3:2
- `landscape_16_9` - 16:9
- `landscape_21_9` - 21:9

## Resolution Examples
- `1K` - 1024×1024
- `2K` - 2048×2048
- `4K` - 4096×3072 (with 4:3 ratio)

## Example Request (Text-to-Image)
```json
{
  "prompt": "A serene misty mountain landscape at sunrise with cherry blossoms",
  "image_size": "landscape_16_9",
  "image_resolution": "2K",
  "num_inference_steps": 30,
  "guidance_scale": 7.5
}
```

## Example Request (Image-to-Image)
```json
{
  "prompt": "Transform the image into an anime style",
  "input_image_url": "https://example.com/image.jpg",
  "image_size": "landscape_16_9",
  "image_resolution": "2K",
  "guidance_scale": 8.5
}
```

## Response
```json
{
  "code": 200,
  "msg": "success",
  "data": {
    "taskId": "seedream_task_xyz789"
  }
}
```

## Check Status
```
GET https://api.kie.ai/api/v1/seedream/record-info?taskId=YOUR_TASK_ID
```

## Status Codes
- `0` - Generating
- `1` - Success
- `2` - Failed
- `3` - Creation failed

## Response Example (Success)
```json
{
  "taskId": "seedream_task_xyz789",
  "successFlag": 1,
  "imageUrl": "https://cdn.kie.ai/seedream/image.jpg",
  "createTime": "2025-12-07T10:00:00Z",
  "completeTime": "2025-12-07T10:15:30Z"
}
```

## Specs
- Cost: 3.5 credits per image ($0.0175)
- Models: Seedream 4.0 (latest), Seedream 3.0
- Resolutions: 1K, 2K, 4K
- Native resolution: Up to 4K (4096×3072px)
- Storage: 14 days
- Supports: Text-to-image, Image-to-image, Editing
- Bilingual: Chinese and English prompt support
- Quality: Fast generation with professional-quality outputs
