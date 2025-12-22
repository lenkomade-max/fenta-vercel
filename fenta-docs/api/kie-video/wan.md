# Wan 2.5 API (KIE.ai)

## Endpoint
```
POST https://api.kie.ai/api/v1/wan/generate
GET https://api.kie.ai/api/v1/wan/record-info
```

## Authentication
```
Authorization: Bearer YOUR_API_KEY
```

## Create Task

### Request - Text to Video
```json
{
  "prompt": "一个人在现代办公室里工作，光线温暖，细节清晰",
  "prompt_en": "A person working in a modern office with warm lighting and detailed surroundings",
  "model": "wan/2-5-text-to-video",
  "duration": 10,
  "resolution": "1080p",
  "aspectRatio": "16:9",
  "fps": 24,
  "seed": 98765,
  "callBackUrl": "https://webhook.your-domain.com/wan"
}
```

### Request - Image to Video
```json
{
  "imageUrl": "https://example.com/photo.jpg",
  "prompt": "The person starts smiling and turns their head slowly",
  "model": "wan/2-5-image-to-video",
  "duration": 8,
  "resolution": "1080p",
  "callBackUrl": "https://webhook.your-domain.com/wan"
}
```

### Request - Audio to Video (Speech-to-Video)
```json
{
  "audioUrl": "https://example.com/speech.mp3",
  "prompt": "Professional news broadcast setting with ambient details",
  "model": "wan/2-5-speech-to-video",
  "duration": 10,
  "resolution": "1080p",
  "callBackUrl": "https://webhook.your-domain.com/wan"
}
```

### Parameters
| Parameter | Type | Required | Values | Description |
|-----------|------|----------|--------|-------------|
| prompt | string | Yes | max 800 chars | Video description (Chinese or English) |
| imageUrl | string | Conditional | valid URL | For image-to-video mode |
| audioUrl | string | Conditional | valid URL | For speech-to-video mode |
| model | string | No | "wan/2-5-text-to-video", "wan/2-5-image-to-video", "wan/2-5-speech-to-video" | Model type |
| duration | number | No | 5, 10 | Video length in seconds |
| resolution | string | No | "720p", "1080p" | Output quality |
| aspectRatio | string | No | "16:9", "9:16", "1:1" | Frame format |
| fps | number | No | 24, 30 | Frames per second (default: 24) |
| seed | number | No | 10000-99999 | Reproducibility seed |
| negativePrompt | string | No | max 500 chars | Content to avoid |
| callBackUrl | string | No | valid URL | Webhook endpoint |

### Response
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "taskId": "wan_mno012pqr",
    "status": 0
  }
}
```

## Check Status

### Request
```
GET https://api.kie.ai/api/v1/wan/record-info?taskId=wan_mno012pqr
Authorization: Bearer YOUR_API_KEY
```

### Response
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "taskId": "wan_mno012pqr",
    "status": 1,
    "videoUrl": "https://storage.kie.ai/videos/wan_mno012pqr.mp4",
    "duration": 10,
    "resolution": "1080p",
    "fps": 24,
    "createdAt": "2025-09-29T08:15:00Z",
    "completedAt": "2025-09-29T08:18:20Z"
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
| Model | Type | Features | Cost | Quality |
|-------|------|----------|------|---------|
| Wan 2.5 T2V | Text-to-Video | High quality, cinema style | $0.06/s (720p), $0.10/s (1080p) | Excellent |
| Wan 2.5 I2V | Image-to-Video | Animate images with motion | $0.06/s (720p), $0.10/s (1080p) | Excellent |
| Wan 2.5 S2V | Speech-to-Video | Generate from audio clips | $0.06/s (720p), $0.10/s (1080p) | Excellent |
| Wan 2.2 A14B | Older version | Text & image input | Lower cost | Good |

## Key Features
- **Advanced Camera Control**: Smooth pans, zooms, tilts, dolly shots
- **Native Audio Sync**: Dialogue and sound effects automatically synchronized
- **Cinematic Quality**: 1080p at 24fps (48fps option available)
- **Multilingual**: Chinese and English prompt support
- **Speech-to-Video**: Generate videos from audio input directly
- **Detailed Motion**: Complex character animations and environmental details

## Specs
| Spec | Value |
|------|-------|
| Max Duration | 10 seconds |
| Max Resolution | 1080p (1920x1080) |
| Frame Rates | 24fps, 30fps |
| Aspect Ratios | 16:9, 9:16, 1:1 |
| Output Format | MP4 |
| Storage Duration | 14 days |
| Download TTL | 20 minutes |
| Max Image Size | 10MB |
| Max Audio Size | 10MB |
| Concurrent Tasks | 10 per account |

## Webhook Callback
```json
{
  "taskId": "wan_mno012pqr",
  "status": 1,
  "videoUrl": "https://storage.kie.ai/videos/wan_mno012pqr.mp4",
  "duration": 10,
  "resolution": "1080p",
  "completedAt": "2025-09-29T08:18:20Z"
}
```

## Pricing
| Model | 720p (5s) | 720p (10s) | 1080p (5s) | 1080p (10s) | Per Second |
|-------|-----------|------------|------------|------------|-----------|
| Wan 2.5 | $0.30 | $0.60 | $0.50 | $1.00 | $0.06/s (720p), $0.10/s (1080p) |
| Wan 2.2 A14B | $0.20 | $0.40 | $0.35 | $0.70 | Lower cost |

## Error Codes
| Code | Message | Cause |
|------|---------|-------|
| 1001 | Invalid prompt | Prompt too short, empty, or banned content |
| 1002 | Invalid image/audio | Unsupported format or corrupted file |
| 1003 | Insufficient credits | Insufficient balance |
| 1004 | Invalid parameters | Wrong values for duration, resolution, fps |
| 1005 | Rate limit exceeded | Too many requests |
| 1006 | Image/Audio too large | File exceeds 10MB limit |

## Language Support
- **Chinese**: Full support for detailed Chinese prompts (supports classical and modern Chinese)
- **English**: Full support for English prompts
- **Mixed**: Can mix Chinese and English in same prompt

## Camera Control Example
For advanced camera movements in prompts:
- "Camera pans smoothly from left to right"
- "Dolly shot moving forward into the scene"
- "Zoom in on subject with slow motion"
- "360-degree camera rotation around object"

## Integration Notes
- Image and audio URLs must be publicly accessible
- Same seed produces identical videos
- Negative prompts help avoid unwanted elements
- 10-second videos only at 720p resolution (for 1080p use 5s)
- Speech-to-video audio should be clear and natural
- Poll status every 5 seconds or use webhooks
- Download videos before 14-day automatic deletion
- Wan 2.5 is Alibaba's latest model with best prompt adherence
- Supports both simplified and traditional Chinese characters
