# Hailuo API (KIE.ai)

## Endpoint
```
POST https://api.kie.ai/api/v1/hailuo/generate
GET https://api.kie.ai/api/v1/hailuo/record-info
```

## Authentication
```
Authorization: Bearer YOUR_API_KEY
```

## Create Task

### Request - Text to Video
```json
{
  "prompt": "A dramatic scene of ocean waves crashing against rocky cliffs with cinematic lighting",
  "model": "hailuo-2-3",
  "duration": 10,
  "resolution": "1080p",
  "aspectRatio": "16:9",
  "seed": 67890,
  "callBackUrl": "https://webhook.your-domain.com/hailuo"
}
```

### Request - Image to Video
```json
{
  "imageUrl": "https://example.com/landscape.jpg",
  "prompt": "The landscape slowly transforms with changing light and subtle movement",
  "model": "hailuo-2-3",
  "duration": 8,
  "resolution": "1080p",
  "callBackUrl": "https://webhook.your-domain.com/hailuo"
}
```

### Parameters
| Parameter | Type | Required | Values | Description |
|-----------|------|----------|--------|-------------|
| prompt | string | Yes | max 800 chars | Video scene description |
| imageUrl | string | Conditional | valid URL | Required for image-to-video |
| model | string | No | "hailuo-02", "hailuo-2-3", "hailuo-2-3-fast" | Model version |
| duration | number | No | 6, 8, 10 | Video length in seconds |
| resolution | string | No | "720p", "1080p" | Output quality |
| aspectRatio | string | No | "16:9", "9:16", "1:1" | Frame dimensions |
| seed | number | No | 10000-99999 | Reproducibility seed |
| callBackUrl | string | No | valid URL | Webhook endpoint |

**Note**: 10-second videos not supported at 1080p resolution.

### Response
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "taskId": "hailuo_ghi789jkl",
    "status": 0
  }
}
```

## Check Status

### Request
```
GET https://api.kie.ai/api/v1/hailuo/record-info?taskId=hailuo_ghi789jkl
Authorization: Bearer YOUR_API_KEY
```

### Response
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "taskId": "hailuo_ghi789jkl",
    "status": 1,
    "videoUrl": "https://storage.kie.ai/videos/hailuo_ghi789jkl.mp4",
    "duration": 10,
    "resolution": "1080p",
    "createdAt": "2025-11-15T14:20:00Z",
    "completedAt": "2025-11-15T14:23:45Z"
  }
}
```

## Status Codes
| Code | Status | Description |
|------|--------|-------------|
| 0 | Generating | Task in progress |
| 1 | Success | Video generated successfully |
| 2 | Failed | Generation failed |

## Models Available
| Model | Version | Features | Cost | Speed |
|-------|---------|----------|------|-------|
| Hailuo 02 | Latest | T2V, I2V, 1080p | 60 cr | Standard |
| Hailuo 2.3 | Latest | T2V, I2V, realistic motion | 70 cr | Standard |
| Hailuo 2.3 Fast | Latest | Faster generation | 50 cr | Fast |

## Key Features
- **Realistic Motion**: Advanced physics simulation for natural movement
- **Expressive Characters**: Detailed facial expressions and body language
- **Cinematic Visuals**: Professional camera control and lighting
- **Complex Scenes**: Handles intricate movements and dynamic environments
- **Physics Accuracy**: High-fidelity simulation of real-world interactions

## Hailuo 02 Specifications
Hailuo 02 is MiniMax's advanced AI video generation model:
- Text or image input for video generation
- 1080P resolution support
- Realistic motion and physics simulation
- Precise camera control
- Best for cinematic, professional content

## Specs
| Spec | Value |
|------|-------|
| Max Duration | 12 seconds |
| Max Resolution | 1080p (1920x1080) |
| Aspect Ratios | 16:9, 9:16, 1:1 |
| Output Format | MP4 |
| Storage Duration | 14 days |
| Download TTL | 20 minutes |
| Concurrent Tasks | 10 per account |
| 10-second limitation | Not at 1080p |

## Webhook Callback
```json
{
  "taskId": "hailuo_ghi789jkl",
  "status": 1,
  "videoUrl": "https://storage.kie.ai/videos/hailuo_ghi789jkl.mp4",
  "duration": 10,
  "completedAt": "2025-11-15T14:23:45Z"
}
```

## Pricing
| Model | 6 Seconds | 8 Seconds | 10 Seconds | Cost Per Second |
|-------|-----------|-----------|------------|-----------------|
| Hailuo 02 | 45 cr | 60 cr | 60 cr | $0.06/s |
| Hailuo 2.3 | 52.5 cr | 70 cr | 70 cr | $0.07/s |
| Hailuo 2.3 Fast | 37.5 cr | 50 cr | 50 cr | $0.05/s |

## Error Codes
| Code | Message | Cause |
|------|---------|-------|
| 1001 | Invalid prompt | Prompt missing, too short, or banned content |
| 1002 | Invalid image | Unsupported format or corrupted file |
| 1003 | Insufficient credits | Account balance too low |
| 1004 | Invalid parameters | Wrong duration, resolution, or aspect ratio |
| 1005 | Rate limit exceeded | Too many requests, wait before retrying |

## Rate Limits
- Max concurrent tasks: 10 per account
- Max tasks per hour: 60
- Min interval between requests: 1 second

## Integration Notes
- Image URLs must be publicly accessible
- Max image size: 10MB (JPEG, PNG, WebP)
- 10-second videos only work at 720p resolution
- Use identical seed for reproducible outputs
- Poll status every 5 seconds or implement webhooks
- Download videos before 14-day automatic deletion
- Hailuo 2.3 offers best balance of quality and cost
- Hailuo 2.3 Fast ideal for high-volume, time-sensitive workflows
