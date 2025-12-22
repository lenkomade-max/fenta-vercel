# Minimax API (KIE.ai)

## Endpoint
```
POST https://api.kie.ai/api/v1/minimax/generate
GET https://api.kie.ai/api/v1/minimax/record-info
```

## Authentication
```
Authorization: Bearer YOUR_API_KEY
```

## Create Task

### Request - Text to Video
```json
{
  "prompt": "A serene landscape with mountains and sunset, cinematic quality",
  "model": "minimax-hailuo-02",
  "duration": 10,
  "resolution": "1080p",
  "aspectRatio": "16:9",
  "seed": 54321,
  "callBackUrl": "https://webhook.your-domain.com/minimax"
}
```

### Request - Image to Video
```json
{
  "imageUrl": "https://example.com/landscape.jpg",
  "prompt": "The landscape transitions through different weather conditions",
  "model": "minimax-hailuo-02",
  "duration": 10,
  "resolution": "1080p",
  "callBackUrl": "https://webhook.your-domain.com/minimax"
}
```

### Parameters
| Parameter | Type | Required | Values | Description |
|-----------|------|----------|--------|-------------|
| prompt | string | Yes | max 800 chars | Video scene description |
| imageUrl | string | Conditional | valid URL | For image-to-video only |
| model | string | No | "minimax-hailuo-02", "minimax-hailuo-2-3", "minimax-hailuo-2-3-fast" | Model version |
| duration | number | No | 6, 8, 10 | Video length in seconds |
| resolution | string | No | "768p", "1080p" | Output quality |
| aspectRatio | string | No | "16:9", "9:16", "1:1" | Frame format |
| seed | number | No | -1 to 99999 | Reproducibility (use -1 for random) |
| callBackUrl | string | No | valid URL | Webhook endpoint |

### Response
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "taskId": "minimax_stu345vwx",
    "status": 0
  }
}
```

## Check Status

### Request
```
GET https://api.kie.ai/api/v1/minimax/record-info?taskId=minimax_stu345vwx
Authorization: Bearer YOUR_API_KEY
```

### Response
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "taskId": "minimax_stu345vwx",
    "status": 1,
    "videoUrl": "https://storage.kie.ai/videos/minimax_stu345vwx.mp4",
    "duration": 10,
    "resolution": "1080p",
    "createdAt": "2025-11-20T16:45:00Z",
    "completedAt": "2025-11-20T16:49:30Z"
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
| Model | Version | Features | Cost | Best For |
|-------|---------|----------|------|----------|
| Hailuo 02 (Kangaroo) | Latest | T2V, I2V, cinematic | 60 cr | High-quality cinematic videos |
| Hailuo 2.3 Standard | Latest | T2V, I2V, improved physics | 70 cr | Professional content with advanced styling |
| Hailuo 2.3 Fast | Latest | I2V only, 55s generation | 50 cr | High-volume, time-sensitive workflows |

## Key Features

### Hailuo 02 (Kangaroo)
- **Cinematic Quality**: Optimized for professional video production
- **Physics Simulation**: Realistic motion and object interactions
- **Precise Camera Control**: Professional camera movements
- **1080P Support**: High-resolution output
- **Image Consistency**: Better object preservation across frames

### Hailuo 2.3
- **Improved Physics**: Enhanced character movements and interactions
- **Realistic Expressions**: Better micro-expressions and emotions
- **Advanced Styling**: Anime, illustration, ink wash painting, game CG support
- **Stylization**: Pixar-style, surrealist, and custom art styles
- **Dynamic Range**: Smooth generation from subtle to large-scale movements
- **Physical Realism**: Maintains high stability across complex scenes

### Hailuo 2.3 Fast
- **Speed**: Generates 6-second clips in ~55 seconds
- **Image-Only**: Optimized for image-to-video transformation
- **VFX Capabilities**: Powerful visual effects and transitions
- **Style Transfer**: Seamless style transformation between inputs
- **Lower Cost**: Most affordable option

## Specs
| Spec | Value |
|------|-------|
| Max Duration | 10 seconds (6s for Fast) |
| Max Resolution | 1080p (768p for Fast) |
| Aspect Ratios | 16:9, 9:16, 1:1 |
| Output Format | MP4 |
| Storage Duration | 14 days |
| Download TTL | 20 minutes |
| Image Formats | JPEG, PNG, WebP (max 10MB) |
| Concurrent Tasks | 10 per account |

## Webhook Callback
```json
{
  "taskId": "minimax_stu345vwx",
  "status": 1,
  "videoUrl": "https://storage.kie.ai/videos/minimax_stu345vwx.mp4",
  "duration": 10,
  "completedAt": "2025-11-20T16:49:30Z"
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
| 1001 | Invalid prompt | Prompt too short, empty, or banned content |
| 1002 | Invalid image | Unsupported format or file corrupted |
| 1003 | Insufficient credits | Insufficient account balance |
| 1004 | Invalid parameters | Wrong values for duration, resolution |
| 1005 | Rate limit exceeded | Too many requests in short time |
| 1006 | Image too large | File exceeds 10MB limit |

## Supported Art Styles
Hailuo 2.3 supports specialized rendering for:
- Anime and illustration styles
- Ink wash painting (Chinese traditional art)
- Game CG (video game graphics)
- Pixar-style animation
- Surrealist effects
- Photo-realistic
- Custom styles via prompt

## Integration Notes
- Image URLs must be publicly accessible
- Use seed: -1 for random variations
- Same seed produces identical results (except Fast variant)
- Max 10-second videos only at standard resolutions
- Hailuo 2.3 Fast is image-only (no text-to-video)
- Poll status every 5 seconds or use webhooks
- Download videos before 14-day automatic deletion
- Hailuo 2.3 offers best quality and style flexibility
- Hailuo 2.3 Fast ideal for speed-critical applications
- Hailuo 02 optimal for cinematic, professional content
- MiniMax is backed by Tencent, Alibaba, miHoYo ($850M+ funding)
