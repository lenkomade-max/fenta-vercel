# Seedance API (KIE.ai)

## Endpoint
```
POST https://api.kie.ai/api/v1/seedance/generate
GET https://api.kie.ai/api/v1/seedance/record-info
```

## Authentication
```
Authorization: Bearer YOUR_API_KEY
```

## Create Task

### Request - Text to Video
```json
{
  "prompt": "A futuristic city street scene with flying cars and neon lights, cinematic quality",
  "model": "seedance-1-0-lite",
  "duration": 10,
  "resolution": "1080p",
  "aspectRatio": "16:9",
  "seed": 12345,
  "safetyChecker": true,
  "callBackUrl": "https://webhook.your-domain.com/seedance"
}
```

### Request - Image to Video
```json
{
  "imageUrl": "https://example.com/city.jpg",
  "prompt": "The city lights gradually brighten as night falls into early morning",
  "model": "seedance-1-0-pro-fast",
  "duration": 6,
  "resolution": "1080p",
  "seed": 67890,
  "callBackUrl": "https://webhook.your-domain.com/seedance"
}
```

### Parameters
| Parameter | Type | Required | Values | Description |
|-----------|------|----------|--------|-------------|
| prompt | string | Yes | max 1000 chars | Video scene description |
| imageUrl | string | Conditional | valid URL | For image-to-video mode |
| model | string | No | "seedance-1-0-lite", "seedance-1-0-pro", "seedance-1-0-pro-fast" | Model version |
| duration | number | No | 6, 8, 10 | Video length in seconds |
| resolution | string | No | "720p", "1080p" | Output quality |
| aspectRatio | string | No | "16:9", "9:16", "1:1" | Frame format |
| seed | number | No | -1 to 99999 | Reproducibility (-1 for random) |
| endImage | string | No | valid URL | Image to end video with |
| safetyChecker | boolean | No | true, false | Enable content safety checks (always true in UI) |
| callBackUrl | string | No | valid URL | Webhook endpoint |

### Response
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "taskId": "seedance_xyz789abc",
    "status": 0
  }
}
```

## Check Status

### Request
```
GET https://api.kie.ai/api/v1/seedance/record-info?taskId=seedance_xyz789abc
Authorization: Bearer YOUR_API_KEY
```

### Response
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "taskId": "seedance_xyz789abc",
    "status": 1,
    "videoUrl": "https://storage.kie.ai/videos/seedance_xyz789abc.mp4",
    "duration": 10,
    "resolution": "1080p",
    "createdAt": "2025-12-01T20:30:00Z",
    "completedAt": "2025-12-01T20:35:45Z"
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
| Model | Type | Speed | Cost | Best For |
|-------|------|-------|------|----------|
| Seedance 1.0 Lite | T2V | Standard | $0.055/s | Affordable text-to-video |
| Seedance 1.0 Pro | T2V, I2V | Standard | $0.055/s | High-quality multi-shot videos |
| Seedance 1.0 Pro Fast | I2V | 3× Faster | $0.044/s | Image-to-video, time-critical workflows |

## Key Features

### Seedance Overview
- **Multi-Shot Support**: Generate complex multi-scene videos
- **Semantic Understanding**: Advanced prompt comprehension
- **Wide Dynamic Range**: Smooth motion from subtle to large movements
- **Physical Realism**: Maintains stability and natural motion
- **1080p Resolution**: High-quality cinematic output
- **Smooth Motion**: Rich details and cinematic aesthetics

### Seedance 1.0 Lite
- **Affordable**: Best price-per-second option
- **Text-to-Video**: Pure text prompts
- **Quick generation**: Standard processing speed
- **Ideal for**: Budget-conscious, high-volume content

### Seedance 1.0 Pro
- **Versatile**: Both text-to-video and image-to-video
- **Multi-Shot**: Generate complex narrative videos
- **Cinematic Quality**: Professional visual aesthetics
- **Ideal for**: Professional content creators

### Seedance 1.0 Pro Fast
- **3× Faster**: ~55 seconds for 6-second video (vs 3 minutes standard)
- **Image-Only**: Optimized for image-to-video transformation
- **Cost-Effective**: 20% cheaper than Pro
- **Ideal for**: Time-sensitive, high-volume operations

## Specs
| Spec | Value |
|------|-------|
| Max Duration | 10 seconds |
| Max Resolution | 1080p (1920x1080) |
| Min Resolution | 720p (1280x720) |
| Aspect Ratios | 16:9, 9:16, 1:1 |
| Output Format | MP4 |
| Storage Duration | 14 days |
| Download TTL | 20 minutes |
| Max Image Size | 10MB |
| Concurrent Tasks | 10 per account |
| Generation Time | 3-4 mins (standard), ~55 secs (fast) |

## Webhook Callback
```json
{
  "taskId": "seedance_xyz789abc",
  "status": 1,
  "videoUrl": "https://storage.kie.ai/videos/seedance_xyz789abc.mp4",
  "duration": 10,
  "resolution": "1080p",
  "completedAt": "2025-12-01T20:35:45Z"
}
```

## Pricing
| Model | 5 Seconds | 6 Seconds | 8 Seconds | 10 Seconds | Per Second |
|-------|-----------|-----------|-----------|------------|-----------|
| Seedance 1.0 Lite | $0.27 | $0.33 | $0.44 | $0.55 | $0.055/s |
| Seedance 1.0 Pro | $0.27 | $0.33 | $0.44 | $0.55 | $0.055/s |
| Seedance 1.0 Pro Fast | $0.22 | $0.26 | $0.35 | $0.44 | $0.044/s |

## End Image Feature
Optionally specify an image URL to transition to at the end of the video:

```json
{
  "prompt": "A person walks through a beautiful garden",
  "imageUrl": "https://example.com/start.jpg",
  "endImage": "https://example.com/end.jpg",
  "duration": 8,
  "model": "seedance-1-0-pro"
}
```

## Error Codes
| Code | Message | Cause |
|------|---------|-------|
| 1001 | Invalid prompt | Prompt too short, empty, or contains banned content |
| 1002 | Invalid image | Unsupported format or file corrupted |
| 1003 | Insufficient credits | Insufficient account balance |
| 1004 | Invalid parameters | Wrong values for duration, resolution |
| 1005 | Rate limit exceeded | Too many requests |
| 1006 | Content unsafe | Failed safety check (can be disabled via API) |
| 1007 | Image too large | File exceeds 10MB limit |

## ByteDance Integration
- Seedance is developed by **ByteDance** (creators of TikTok)
- Inherits technology from Pika, Douyin (Chinese TikTok), and internal video research
- Optimized for short-form video content
- Strong understanding of trending and viral content patterns

## Integration Notes
- Image and end image URLs must be publicly accessible
- Use seed: -1 for random variations each time
- Same seed produces identical videos
- Safety checker always enabled in UI, can be disabled via API
- Seedance 1.0 Pro Fast is image-only (no pure text-to-video)
- Poll status every 5 seconds or use webhooks
- Download videos before 14-day automatic deletion
- Seedance 1.0 Lite optimal for cost-sensitive applications
- Seedance 1.0 Pro best for professional multi-shot narratives
- Seedance 1.0 Pro Fast ideal for high-speed production workflows
- Perfect for TikTok, Reels, Shorts style videos (ByteDance origin)
- Strong semantic understanding of complex prompts
- Wide dynamic range supports subtle to explosive motion

## ByteDance Technology
Seedance represents ByteDance's investment in AI video generation:
- Trained on massive short-form video datasets
- Understanding of what makes content engaging
- Optimized for viral/trending content patterns
- Direct connection to TikTok/Douyin best practices
