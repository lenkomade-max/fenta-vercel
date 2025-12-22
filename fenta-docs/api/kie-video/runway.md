# Runway API (KIE.ai)

## Endpoint
```
POST https://api.kie.ai/api/v1/runway/generate
POST https://api.kie.ai/api/v1/aleph/generate
GET https://api.kie.ai/api/v1/runway/record-info
GET https://api.kie.ai/api/v1/runway/record-detail
```

## Authentication
```
Authorization: Bearer YOUR_API_KEY
```

## Create Task

### Request - Text to Video (Gen-3 Alpha Turbo)
```json
{
  "prompt": "Ocean waves crashing on rocks at sunset, cinematic lighting",
  "model": "runway-gen3-turbo",
  "duration": 5,
  "resolution": "1080p",
  "aspectRatio": "16:9",
  "seed": 11111,
  "callBackUrl": "https://webhook.your-domain.com/runway"
}
```

### Request - Image to Video
```json
{
  "imageUrl": "https://example.com/image.jpg",
  "prompt": "The landscape slowly transforms with dynamic lighting changes",
  "model": "runway-gen3-turbo",
  "duration": 5,
  "resolution": "1080p",
  "callBackUrl": "https://webhook.your-domain.com/runway"
}
```

### Request - Video to Video (Aleph - Style Transfer)
```json
{
  "videoUrl": "https://example.com/video.mp4",
  "prompt": "Transform to oil painting style with warm colors",
  "model": "runway-aleph",
  "callBackUrl": "https://webhook.your-domain.com/runway"
}
```

### Parameters
| Parameter | Type | Required | Values | Description |
|-----------|------|----------|--------|-------------|
| prompt | string | Yes | max 800 chars | Video description or editing instruction |
| imageUrl | string | Conditional | valid URL | For image-to-video generation |
| videoUrl | string | Conditional | valid URL | For video-to-video (Aleph) editing |
| model | string | No | "runway-gen3-turbo", "runway-aleph" | Model version |
| duration | number | No | 5, 10 | Video length (10s only at 720p) |
| resolution | string | No | "720p", "1080p" | Output quality |
| aspectRatio | string | No | "16:9", "9:16", "1:1", "4:3", "3:4" | Frame format |
| seed | number | No | 10000-99999 | Reproducibility seed |
| callBackUrl | string | No | valid URL | Webhook endpoint |

### Response
```json
{
  "code": 200,
  "msg": "success",
  "data": {
    "taskId": "runway_task_xyz789"
  }
}
```

## Check Status

### Request
```
GET https://api.kie.ai/api/v1/runway/record-info?taskId=runway_task_xyz789
Authorization: Bearer YOUR_API_KEY
```

### Response
```json
{
  "code": 200,
  "msg": "success",
  "data": {
    "taskId": "runway_task_xyz789",
    "status": "success",
    "videoUrl": "https://storage.kie.ai/videos/runway_task_xyz789.mp4",
    "duration": 5,
    "resolution": "1080p",
    "createdAt": "2025-11-15T12:00:00Z",
    "completedAt": "2025-11-15T12:02:45Z"
  }
}
```

## Status Values
| Status | Description |
|--------|-------------|
| wait | Waiting in queue |
| queueing | Queued for processing |
| generating | Currently processing |
| success | Video generated successfully |
| fail | Generation failed |

## Models Available
| Model | Type | Features | Cost | Best For |
|-------|------|----------|------|----------|
| Runway Gen-3 Turbo | T2V, I2V | Fast, high-quality | 60-70 cr | General video creation |
| Runway Aleph | V2V | Style transfer, in-context editing | 50-70 cr | Professional video editing |

## Key Features

### Runway Gen-3 Turbo
- **Advanced Motion**: Fluid, realistic motion synthesis
- **Visual Coherence**: Maintains consistency throughout video
- **Multiple Aspect Ratios**: Flexible format support
- **Fast Generation**: Quick turnaround for standard videos
- **1080P Support**: High-resolution output at 5s duration

### Runway Aleph (Video-to-Video)
- **In-Context Editing**: Text-driven transformations preserving motion
- **Style Transfer**: Apply artistic styles to existing videos
- **Professional Grade**: Designed for VFX and video editing
- **Motion Preservation**: Maintains original timing and motion
- **Add/Remove Objects**: Use text prompts to edit scenes
- **Relighting**: Change lighting and colors with text
- **Camera Angle**: Modify viewing angles via prompts

## Specs
| Spec | Value |
|------|-------|
| Max Duration | 10 seconds (720p), 5 seconds (1080p) |
| Max Resolution | 1080p (5s only), 720p (5-10s) |
| Aspect Ratios | 16:9, 9:16, 1:1, 4:3, 3:4 |
| Output Format | MP4 |
| Storage Duration | 14 days |
| Download TTL | 20 minutes |
| Max Image Size | 10MB |
| Max Video Size | 50MB |
| Concurrent Tasks | 10 per account |

## Webhook Callback
```json
{
  "taskId": "runway_task_xyz789",
  "status": "success",
  "videoUrl": "https://storage.kie.ai/videos/runway_task_xyz789.mp4",
  "duration": 5,
  "completedAt": "2025-11-15T12:02:45Z"
}
```

## Pricing
| Model | 5 Seconds | 10 Seconds | Per Second | Type |
|-------|-----------|------------|-----------|------|
| Gen-3 Turbo | 60-70 cr | 100+ cr | ~12-14 cr/s | T2V, I2V |
| Aleph | 50-70 cr | - | ~10-14 cr/s | V2V editing |

## Error Codes
| Code | Description | Cause |
|------|-------------|-------|
| 200 | Success | Request successful |
| 400 | Bad request | Invalid parameters |
| 401 | Unauthorized | Invalid API key |
| 402 | Insufficient credits | Low balance |
| 429 | Rate limited | Too many requests |
| 500 | Server error | Internal error |

## Runway Aleph Examples

### Style Transfer
```json
{
  "videoUrl": "https://example.com/nature.mp4",
  "prompt": "Transform to Van Gogh painting style with vivid colors"
}
```

### Object Removal
```json
{
  "videoUrl": "https://example.com/scene.mp4",
  "prompt": "Remove the person walking in the foreground"
}
```

### Relighting
```json
{
  "videoUrl": "https://example.com/indoor.mp4",
  "prompt": "Make it golden hour lighting with warm tones"
}
```

### Camera Angle Change
```json
{
  "videoUrl": "https://example.com/subject.mp4",
  "prompt": "Shift camera angle 45 degrees to the left"
}
```

## Integration Notes
- Image and video URLs must be publicly accessible
- 1080p only available for 5-second videos
- 10-second videos max out at 720p resolution
- Same seed produces identical results
- Runway Gen-3 Turbo best for standard T2V/I2V
- Runway Aleph specialized for professional video editing
- Aleph preserves motion and timing from original video
- Poll status every 3-5 seconds or use webhooks
- Download videos before 14-day automatic deletion
- Gen-3 Turbo supports multiple aspect ratios for flexibility
- Aleph is ideal for post-production and creative edits
