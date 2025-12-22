# Sora 2 API (KIE.ai)

## Endpoint
```
POST https://api.kie.ai/api/v1/sora/generate
GET https://api.kie.ai/api/v1/sora/record-info
```

## Authentication
```
Authorization: Bearer YOUR_API_KEY
```

## Create Task

### Request
```json
{
  "prompt": "A cinematic scene of a sunset over mountains with detailed lighting",
  "aspectRatio": "16:9",
  "duration": 10,
  "quality": "high",
  "seed": 12345,
  "callBackUrl": "https://webhook.your-domain.com/sora"
}
```

### Parameters
| Parameter | Type | Required | Values | Description |
|-----------|------|----------|--------|-------------|
| prompt | string | Yes | max 800 chars | Text description of video to generate |
| aspectRatio | string | No | "16:9", "9:16", "1:1" | Video aspect ratio (default: "16:9") |
| duration | number | No | 10, 15 | Video duration in seconds (default: 10) |
| quality | string | No | "standard", "high" | Output quality level |
| seed | number | No | 10000-99999 | Random seed for reproducibility |
| callBackUrl | string | No | valid URL | Webhook URL for task completion notification |

### Response
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "taskId": "sora_abc123xyz",
    "status": 0
  }
}
```

## Check Status

### Request
```
GET https://api.kie.ai/api/v1/sora/record-info?taskId=sora_abc123xyz
Authorization: Bearer YOUR_API_KEY
```

### Response
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "taskId": "sora_abc123xyz",
    "status": 1,
    "videoUrl": "https://storage.kie.ai/videos/sora_abc123xyz.mp4",
    "duration": 10,
    "resolution": "1080p",
    "createdAt": "2025-10-15T10:30:00Z",
    "completedAt": "2025-10-15T10:35:00Z"
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
| Model | Quality | Cost |
|-------|---------|------|
| Sora 2 | Standard | $0.15/10s |
| Sora 2 Pro | High-quality, realistic physics | $0.30/10s |
| Sora 2 Pro Storyboard | Multi-scene, up to 25s | $0.60/25s |

## Key Features
- **Native Audio**: Synchronized dialogue, sound effects, and ambient audio
- **Vertical Video**: Native 9:16 support (no re-framing required)
- **Scene Continuity**: Realistic physics and motion
- **HD Output**: 1080p resolution with watermark removal option

## Specs
| Spec | Value |
|------|-------|
| Max Duration | 15 seconds |
| Max Resolution | 1080p (1920x1080) |
| Aspect Ratios | 16:9, 9:16, 1:1 |
| Output Format | MP4 |
| Storage Duration | 14 days |
| Download Link TTL | 20 minutes |
| Credits per 10s | ~100 (varies by quality) |

## Webhook Callback
When `callBackUrl` is provided, KIE.ai sends a POST request with completion status:

```json
{
  "taskId": "sora_abc123xyz",
  "status": 1,
  "videoUrl": "https://storage.kie.ai/videos/sora_abc123xyz.mp4",
  "duration": 10,
  "completedAt": "2025-10-15T10:35:00Z"
}
```

## Error Codes
| Code | Message | Cause |
|------|---------|-------|
| 1001 | Invalid prompt | Prompt too short or contains banned content |
| 1002 | Insufficient credits | Not enough balance |
| 1003 | Model overloaded | Server busy, retry later |
| 1004 | Invalid parameters | Missing or wrong parameter format |

## Rate Limits
- Max concurrent tasks: 10 per account
- Max tasks per day: 100 per account
- Min interval between requests: 1 second

## Pricing
| Model | Cost | Duration |
|-------|------|----------|
| Sora 2 Standard | $0.15 | 10s video with audio |
| Sora 2 Pro | $0.30 | 10s high-quality video |
| Sora 2 Pro Storyboard | $0.60 | 25s multi-scene video |

## Integration Notes
- Store `taskId` immediately after task creation
- Poll status endpoint every 5-10 seconds or use webhook for real-time updates
- Download videos before 14-day storage expiration
- Use same `seed` value for reproducible results
