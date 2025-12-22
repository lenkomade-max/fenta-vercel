# Kling API (KIE.ai)

## Endpoint
```
POST https://api.kie.ai/api/v1/kling/generate
GET https://api.kie.ai/api/v1/kling/record-info
```

## Authentication
```
Authorization: Bearer YOUR_API_KEY
```

## Create Task

### Request - Text to Video
```json
{
  "prompt": "A professional business meeting in a modern office, cinematic lighting",
  "model": "kling-2-5-turbo",
  "duration": 10,
  "resolution": "1080p",
  "aspectRatio": "16:9",
  "seed": 45678,
  "callBackUrl": "https://webhook.your-domain.com/kling"
}
```

### Request - Image to Video
```json
{
  "imageUrl": "https://example.com/image.jpg",
  "prompt": "The person walks forward with confident motion",
  "model": "kling-2-1-pro",
  "duration": 10,
  "resolution": "1080p",
  "aspectRatio": "16:9",
  "callBackUrl": "https://webhook.your-domain.com/kling"
}
```

### Parameters
| Parameter | Type | Required | Values | Description |
|-----------|------|----------|--------|-------------|
| prompt | string | Yes | max 1000 chars | Video scene description |
| imageUrl | string | Conditional | valid URL | For image-to-video only |
| model | string | No | "kling-2-1", "kling-2-1-pro", "kling-2-5-turbo", "kling-2-6" | Model version |
| duration | number | No | 5, 10 | Video length in seconds |
| resolution | string | No | "720p", "1080p" | Output quality |
| aspectRatio | string | No | "16:9", "9:16", "1:1" | Frame size |
| seed | number | No | 10000-99999 | Reproducibility seed |
| callBackUrl | string | No | valid URL | Webhook endpoint |

### Response
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "taskId": "kling_def456uvw",
    "status": 0
  }
}
```

## Check Status

### Request
```
GET https://api.kie.ai/api/v1/kling/record-info?taskId=kling_def456uvw
Authorization: Bearer YOUR_API_KEY
```

### Response
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "taskId": "kling_def456uvw",
    "status": 1,
    "videoUrl": "https://storage.kie.ai/videos/kling_def456uvw.mp4",
    "duration": 10,
    "resolution": "1080p",
    "createdAt": "2025-09-29T12:00:00Z",
    "completedAt": "2025-09-29T12:02:30Z"
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
| Model | Version | Type | Cost | Notes |
|-------|---------|------|------|-------|
| Kling 2.1 | Latest | T2V | 50 cr/5s | Stable, realistic motion |
| Kling 2.1 Pro | Latest | I2V | 50 cr/5s | Professional image animation |
| Kling 2.5 Turbo | Latest | T2V, I2V | 50 cr/5s | Fast generation, better prompt adherence |
| Kling 2.6 | Latest | T2V, I2V, A2V | 70 cr/5s | Native audio with lip-sync |
| Kling Avatar | Avatar | I2A | $0.04-0.08/s | Talking head from image |

## Key Features
- **Advanced Motion**: Realistic physics simulation and natural motion transitions
- **Cinematic Quality**: Professional camera work with smooth pans, zooms, tilts
- **Character Animation**: Accurate emotions, expressions, body language
- **Physics Simulation**: High-precision simulation for object interactions
- **Kling 2.6**: Native audio generation with synchronized dialogue and sound effects

## Kling Avatar API

For converting images to talking videos:

```json
{
  "imageUrl": "https://example.com/person.jpg",
  "voiceUrl": "https://example.com/audio.mp3",
  "model": "kling-avatar",
  "resolution": "1080p",
  "callBackUrl": "https://webhook.your-domain.com/kling-avatar"
}
```

Supported audio formats: MP3, WAV, AAC, MP4, OGG (max 10MB)

## Specs
| Spec | Value |
|------|-------|
| Max Duration | 10 seconds |
| Max Resolution | 1080p (1920x1080) |
| Aspect Ratios | 16:9, 9:16, 1:1 |
| Output Format | MP4 |
| Storage Duration | 14 days |
| Concurrent Limit | 10 tasks |
| Avatar Tier | 720p (Standard), 1080p (Pro) |

## Webhook Callback
```json
{
  "taskId": "kling_def456uvw",
  "status": 1,
  "videoUrl": "https://storage.kie.ai/videos/kling_def456uvw.mp4",
  "duration": 10,
  "completedAt": "2025-09-29T12:02:30Z"
}
```

## Pricing
| Model | 5 Seconds | 10 Seconds | Cost Per Second |
|-------|-----------|------------|-----------------|
| Kling 2.1 | 50 cr | 100 cr | $0.05/s |
| Kling 2.1 Pro | 50 cr | 100 cr | $0.05/s |
| Kling 2.5 Turbo | 50 cr | 100 cr | $0.05/s |
| Kling 2.6 | 70 cr | 140 cr | $0.07/s |
| Kling Avatar Standard | - | - | $0.04/s |
| Kling Avatar Pro | - | - | $0.08/s |

## Error Codes
| Code | Message | Cause |
|------|---------|-------|
| 1001 | Invalid prompt | Prompt too short, empty, or contains banned words |
| 1002 | Invalid image | Image format not supported or file corrupted |
| 1003 | Insufficient credits | Not enough balance |
| 1004 | Invalid parameters | Wrong parameter values |
| 1005 | Model overloaded | Server busy, retry later |

## Integration Notes
- Image-to-video requires publicly accessible image URLs
- Max image size: 10MB (JPEG, PNG, WebP formats)
- Same seed produces identical videos
- Avatar voices must be clear and audible for best lip-sync
- Poll status every 3-5 seconds or use webhooks for real-time updates
- Always store video URLs immediately before 14-day expiration
