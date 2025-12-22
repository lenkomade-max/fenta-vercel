# Midjourney API (KIE.ai)

## Endpoint
```
POST https://api.kie.ai/api/v1/mj/generate
```

## Authentication
```
Authorization: Bearer YOUR_API_KEY
```

## Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `taskType` | string | Yes | `mj_txt2img`, `mj_img2img`, `mj_video` |
| `prompt` | string | Yes | Image description |
| `speed` | string | No | `Relax`, `Fast`, `Turbo` |
| `version` | string | No | `7`, `6.1`, `Niji6` |
| `aspectRatio` | string | No | `16:9`, `1:1`, `9:16`, `4:3`, etc. |
| `stylization` | integer | No | 0-1000 (default varies by version) |
| `weirdness` | integer | No | 0-3000 |
| `fileUrl` | string | No | Input image URL (required for img2img/video) |
| `waterMark` | string | No | Custom watermark text |
| `callBackUrl` | string | No | Webhook URL for async notification |

## Task Types
- **mj_txt2img** - Text-to-image generation
- **mj_img2img** - Image-to-image transformation
- **mj_video** - Animate image to video

## Versions
- **7** - Latest model (latest features, best quality)
- **6.1** - Previous stable version
- **Niji6** - Anime/illustration specialized model

## Example Request
```json
{
  "taskType": "mj_txt2img",
  "prompt": "Help me generate a sci-fi themed fighter jet in a beautiful sky, to be used as a computer wallpaper",
  "version": "7",
  "aspectRatio": "16:9",
  "speed": "Fast",
  "stylization": 500,
  "weirdness": 100
}
```

## Response
```json
{
  "code": 200,
  "msg": "success",
  "data": {
    "taskId": "mj_task_abc123"
  }
}
```

## Check Status
```
GET https://api.kie.ai/api/v1/mj/record-info?taskId=YOUR_TASK_ID
```

## Status Codes
- `0` - Generating
- `1` - Success
- `2` - Failed
- `3` - Creation failed

## Response Example (Success)
```json
{
  "taskId": "mj_task_abc123",
  "taskType": "mj_txt2img",
  "successFlag": 1,
  "paramJson": {
    "prompt": "sci-fi fighter jet",
    "version": "7",
    "aspectRatio": "16:9",
    "speed": "Fast",
    "stylization": 500,
    "weirdness": 100
  },
  "resultUrls": [
    "https://cdn.kie.ai/mj/image1.jpg",
    "https://cdn.kie.ai/mj/image2.jpg",
    "https://cdn.kie.ai/mj/image3.jpg",
    "https://cdn.kie.ai/mj/image4.jpg"
  ],
  "createTime": "2025-12-07T10:00:00Z",
  "completeTime": "2025-12-07T10:05:30Z"
}
```

## Specs
- Cost: 25 credits per task
- Models: v7, 6.1, Niji6
- Output: 4 images per generation
- Storage: 14 days
- Speed modes: Relax (slowest, cheapest), Fast, Turbo (fastest, most expensive)
- Supported task types: Text-to-image, Image-to-image, Image-to-video
