# Luma API (KIE.ai)

## Endpoint
```
POST https://api.kie.ai/api/v1/modify/generate
GET https://api.kie.ai/api/v1/modify/record-info
```

## Authentication
```
Authorization: Bearer YOUR_API_KEY
```

## Create Task

### Request - Video Modification
```json
{
  "prompt": "Add cinematic color grading with warm tones and slow motion effect",
  "videoUrl": "https://example.com/video.mp4",
  "model": "luma-modify",
  "callBackUrl": "https://webhook.your-domain.com/luma"
}
```

### Parameters
| Parameter | Type | Required | Values | Description |
|-----------|------|----------|--------|-------------|
| prompt | string | Yes | max 800 chars (English only) | Modification instruction |
| videoUrl | string | Yes | public URL | Input video to modify |
| model | string | No | "luma-modify" | Model version |
| callBackUrl | string | No | valid URL | Webhook endpoint |

### Response
```json
{
  "code": 200,
  "msg": "success",
  "data": {
    "taskId": "luma_task_abc123"
  }
}
```

## Check Status

### Request
```
GET https://api.kie.ai/api/v1/modify/record-info?taskId=luma_task_abc123
Authorization: Bearer YOUR_API_KEY
```

### Response
```json
{
  "code": 200,
  "msg": "success",
  "data": {
    "taskId": "luma_task_abc123",
    "status": 1,
    "videoUrl": "https://storage.kie.ai/videos/luma_task_abc123.mp4",
    "duration": 8,
    "createdAt": "2025-11-15T14:00:00Z",
    "completedAt": "2025-11-15T14:05:30Z"
  }
}
```

## Status Codes
| Code | Status | Description |
|------|--------|-------------|
| 0 | Processing | Task in progress |
| 1 | Success | Video modified successfully |
| 2 | Task creation failed | Invalid request parameters |
| 3 | Generation failed | Processing error |
| 4 | Callback failed | Webhook delivery failed |

## Key Features
- **Non-Destructive Editing**: AI-powered video enhancement
- **Color Grading**: Professional color correction and grading
- **Effects**: Slow motion, speed up, motion blur
- **Enhancement**: Auto-enhance quality and clarity
- **Resolution Upscaling**: Improve video resolution
- **Real-time Preview**: Webhook callbacks for progress

## Supported Modifications
- **Color Grading**: Cinematic, warm, cool, vintage, B&W
- **Effects**: Slow motion, speed up, blur, sharpening
- **Enhancement**: Denoise, upscale, stabilization
- **Lighting**: Brighten, darken, adjust contrast
- **Transitions**: Add transition effects between scenes

## Specs
| Spec | Value |
|------|-------|
| Max Duration | 10 seconds |
| Max File Size | 500MB |
| Input Formats | MP4, MOV, AVI, WebM |
| Output Format | MP4 |
| Storage Duration | 14 days |
| Download TTL | 20 minutes |
| Language | English only |
| Concurrent Tasks | 10 per account |
| Input Type | Public URLs only |

## Webhook Callback
```json
{
  "taskId": "luma_task_abc123",
  "status": 1,
  "videoUrl": "https://storage.kie.ai/videos/luma_task_abc123.mp4",
  "duration": 8,
  "completedAt": "2025-11-15T14:05:30Z"
}
```

## Pricing
| Task | Cost | Speed |
|------|------|-------|
| Standard Modification | 50-70 cr | ~3-5 mins |
| Complex Effects | 70+ cr | ~5-8 mins |
| Upscaling | 60 cr | ~3-4 mins |

## Error Codes
| Code | Description | Cause |
|------|-------------|-------|
| 200 | Success | Request successful |
| 400 | Bad request | Invalid parameters or prompt |
| 401 | Unauthorized | Invalid API key |
| 402 | Insufficient credits | Low balance |
| 403 | Invalid video URL | URL not accessible or invalid format |
| 429 | Rate limited | Too many requests |
| 500 | Server error | Internal error |

## Example Prompts

### Color Grading
```json
{
  "prompt": "Apply warm, cinematic color grading with orange and teal tones",
  "videoUrl": "https://example.com/raw.mp4"
}
```

### Effects
```json
{
  "prompt": "Slow down the video to 0.5x speed and add motion blur",
  "videoUrl": "https://example.com/video.mp4"
}
```

### Enhancement
```json
{
  "prompt": "Upscale to 4K, reduce noise, and enhance clarity",
  "videoUrl": "https://example.com/lowres.mp4"
}
```

### Professional Grade
```json
{
  "prompt": "Professional color grading: lift shadows, crush blacks, add grade with magenta highlights",
  "videoUrl": "https://example.com/footage.mp4"
}
```

## Constraints
- **Language**: English only (prompts auto-translated from other languages may produce unexpected results)
- **Duration**: Maximum 10 seconds input video
- **Size**: Maximum 500MB file size
- **URLs**: Must be publicly accessible (no authentication required)
- **Processing**: Asynchronous, use polling or webhooks

## Integration Notes
- Video URLs must be publicly accessible with no authentication
- Prompts must be in English for best results
- Max 10-second videos (longer videos will fail)
- Max 500MB file size
- Poll status every 5 seconds or use webhooks
- Download modified videos before 14-day automatic deletion
- Luma is designed for post-production and enhancement
- Best used after initial video generation
- Supports multiple modification types in single prompt
- Color grading effects are most reliable feature
- Video stabilization available through prompts

## Luma Characteristics
- **Focus**: Post-production video enhancement and modification
- **Strength**: Color grading, effects, quality enhancement
- **Best For**: Polishing and finalizing generated videos
- **Integration**: Perfect complement to generation APIs
