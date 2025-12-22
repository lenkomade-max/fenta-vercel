# Veo 3.1 API (KIE.ai)

## Endpoint
```
POST https://api.kie.ai/api/v1/veo/generate
GET https://api.kie.ai/api/v1/veo/record-info
GET https://api.kie.ai/api/v1/veo/get-veo-3-1080-p-video
```

## Authentication
```
Authorization: Bearer YOUR_API_KEY
```

## Create Task

### Request - Text to Video
```json
{
  "prompt": "A cinematic landscape with mountains during golden hour sunset, realistic lighting",
  "model": "veo3",
  "generationType": "TEXT_2_VIDEO",
  "aspectRatio": "16:9",
  "seed": 12345,
  "callBackUrl": "https://webhook.your-domain.com/veo"
}
```

### Request - Image to Video (First & Last Frames)
```json
{
  "imageUrls": ["https://example.com/start.jpg", "https://example.com/end.jpg"],
  "prompt": "Smooth transition between the two scenes",
  "model": "veo3",
  "generationType": "FIRST_AND_LAST_FRAMES_2_VIDEO",
  "aspectRatio": "16:9",
  "callBackUrl": "https://webhook.your-domain.com/veo"
}
```

### Parameters
| Parameter | Type | Required | Values | Description |
|-----------|------|----------|--------|-------------|
| prompt | string | Yes | max 1000 chars | Video description (auto-translated to English) |
| imageUrls | string[] | Conditional | 1-2 valid URLs | For frame-based generation |
| model | string | No | "veo3", "veo3_fast" | Model version (default: veo3_fast) |
| generationType | string | No | "TEXT_2_VIDEO", "FIRST_AND_LAST_FRAMES_2_VIDEO", "REFERENCE_2_VIDEO" | Generation mode |
| aspectRatio | string | No | "16:9", "9:16", "Auto" | Video dimensions |
| seed | integer | No | 10000-99999 | Random seed for reproducibility |
| callBackUrl | string | No | valid URL | Webhook endpoint for completion |
| enableTranslation | boolean | No | true, false | Auto-translate to English (default: true) |
| watermark | string | No | custom text | Optional watermark text |

### Response
```json
{
  "code": 200,
  "msg": "success",
  "data": {
    "taskId": "veo_task_abcdef123456"
  }
}
```

## Check Status

### Request
```
GET https://api.kie.ai/api/v1/veo/record-info?taskId=veo_task_abcdef123456
Authorization: Bearer YOUR_API_KEY
```

### Response
```json
{
  "code": 200,
  "msg": "success",
  "data": {
    "taskId": "veo_task_abcdef123456",
    "status": 1,
    "videoUrl": "https://storage.kie.ai/videos/veo_task_abcdef123456.mp4",
    "duration": 10,
    "resolution": "1080p",
    "aspectRatio": "16:9",
    "createdAt": "2025-11-15T10:30:00Z",
    "completedAt": "2025-11-15T10:35:00Z"
  }
}
```

## Get 1080P Video

### Request
```
GET https://api.kie.ai/api/v1/veo/get-veo-3-1080-p-video?taskId=veo_task_abcdef123456
Authorization: Bearer YOUR_API_KEY
```

Converts generated video to 1080P native resolution.

## Status Codes
| Code | Status | Description |
|------|--------|-------------|
| 0 | Generating | Task in progress |
| 1 | Success | Video generated successfully |
| 2 | Failed | Generation failed |

## Error Codes
| Code | Description | Cause |
|------|-------------|-------|
| 200 | Success | Request successful |
| 400 | Processing | Task still generating |
| 401 | Unauthorized | Invalid API key |
| 402 | Insufficient credits | Low balance |
| 422 | Validation error | Invalid parameters |
| 429 | Rate limited | Too many requests |
| 500 | Server error | Internal error |

## Models Available
| Model | Quality | Speed | Cost | Best For |
|-------|---------|-------|------|----------|
| Veo 3.1 Quality (veo3) | Excellent | Standard | ~80 credits | Professional, cinematic content |
| Veo 3.1 Fast (veo3_fast) | Very Good | 3× Faster | ~70 credits | Rapid prototyping, high volume |

## Key Features
- **Native Vertical Video**: True 9:16 support without re-framing
- **Audio Sync**: Synchronized dialogue and ambient sound
- **Cinematic Quality**: Professional motion, lighting, and physics
- **Multi-Language Support**: Automatic translation to English
- **Frame Control**: Generate videos between specified start/end frames
- **1080P Native**: Convert to true 1080P resolution
- **Motion Quality**: Advanced motion synthesis and timing

## Specs
| Spec | Value |
|------|-------|
| Duration | 8-12 seconds |
| Max Resolution | 1080p (1920x1080) |
| Aspect Ratios | 16:9, 9:16, Auto |
| Output Format | MP4 |
| Storage Duration | 14 days |
| Download TTL | 20 minutes |
| Max Images | 2 (for frame-based generation) |
| Frame Format | JPEG, PNG, WebP |
| Max Image Size | 10MB |
| Concurrent Tasks | 10 per account |

## Webhook Callback
```json
{
  "taskId": "veo_task_abcdef123456",
  "status": 1,
  "videoUrl": "https://storage.kie.ai/videos/veo_task_abcdef123456.mp4",
  "duration": 10,
  "completedAt": "2025-11-15T10:35:00Z"
}
```

## Pricing
| Model | 10 Seconds | Per Second | Quality |
|-------|------------|-----------|---------|
| Veo 3.1 | ~80 cr | ~8 cr/s | Excellent |
| Veo 3.1 Fast | ~70 cr | ~7 cr/s | Very Good |
| 1080P Upgrade | ~20 cr | Extra | Native 1080p |

## Generation Modes
- **TEXT_2_VIDEO**: Generate from text prompt only
- **FIRST_AND_LAST_FRAMES_2_VIDEO**: Provide start and end frames, video generated between them
- **REFERENCE_2_VIDEO**: Use reference image for style consistency

## Integration Notes
- Image URLs must be publicly accessible
- Prompts auto-translate to English (disable with `enableTranslation: false`)
- Same seed produces identical results
- Max 1000 characters for prompt
- Veo 3.1 Quality best for professional output
- Veo 3.1 Fast optimal for development and testing
- Native vertical (9:16) video no longer requires cropping
- Poll status every 5 seconds or use webhooks
- Download videos before 14-day automatic deletion
- Google DeepMind's latest video model
- 25% cheaper than official Google Veo API pricing
