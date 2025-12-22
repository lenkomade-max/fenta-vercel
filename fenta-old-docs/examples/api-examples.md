# API Usage Examples

## Authentication

### Register New User

```bash
curl -X POST https://api.fentaweb.com/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "SecurePassword123!",
    "name": "John Doe"
  }'
```

**Response:**
```json
{
  "user": {
    "id": "user_abc123",
    "email": "user@example.com",
    "name": "John Doe",
    "role": "user",
    "createdAt": "2024-01-15T10:30:00Z"
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

### Login

```bash
curl -X POST https://api.fentaweb.com/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "SecurePassword123!"
  }'
```

## Templates

### Create Template

```bash
curl -X POST https://api.fentaweb.com/v1/templates \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "News Shorts Template",
    "aspect": "9:16",
    "resolution": "1080x1920",
    "tracks": [
      {
        "type": "video",
        "id": "main",
        "z": 0
      },
      {
        "type": "subtitle",
        "id": "subs",
        "z": 10,
        "style": {
          "font": "Inter",
          "size": 44,
          "shadow": true,
          "bg": "box",
          "position": "bottom",
          "margin": 120
        }
      },
      {
        "type": "overlay",
        "id": "logo",
        "z": 20
      }
    ],
    "overlays": [
      {
        "track": "logo",
        "from": 0,
        "to": 999,
        "content": {
          "type": "image",
          "position": "top-right",
          "size": {"width": 100, "height": 100},
          "margin": {"top": 20, "right": 20}
        }
      }
    ],
    "placeholders": {
      "logo": "image_optional",
      "music": "audio_optional"
    },
    "rules": {
      "cuts": "auto_by_beats_or_speech",
      "min_scene": 1.2,
      "max_scene": 4.0
    },
    "subtitle_style_presets": ["clean_box", "karaoke_bounce"]
  }'
```

### Get All Templates

```bash
curl -X GET "https://api.fentaweb.com/v1/templates?aspect=9:16&page=1&limit=20" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

## Workflows

### Create Workflow - Daily News Shorts

```bash
curl -X POST https://api.fentaweb.com/v1/workflows \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Daily News Shorts",
    "description": "Automated news video generation",
    "nodes": [
      {
        "id": "n1",
        "type": "Input.Stock",
        "params": {
          "provider": "pexels",
          "query": "breaking news city",
          "type": "video",
          "count": 3
        },
        "position": {"x": 100, "y": 100}
      },
      {
        "id": "n2",
        "type": "Script.Generate",
        "params": {
          "genre": "news",
          "lang": "en",
          "prompt": "30s punchy headline + 3 beats",
          "targetDuration": 30,
          "tone": "energetic"
        },
        "position": {"x": 100, "y": 250}
      },
      {
        "id": "n3",
        "type": "Voice.TTS",
        "params": {
          "engine": "kokoro",
          "voice": "alloy_en",
          "speed": 1.02
        },
        "position": {"x": 100, "y": 400}
      },
      {
        "id": "n4",
        "type": "Subtitle.Auto",
        "params": {
          "source": "audio",
          "style": "clean_box",
          "karaoke": true
        },
        "position": {"x": 300, "y": 400}
      },
      {
        "id": "n5",
        "type": "Edit.Timeline",
        "params": {
          "templateId": "tmpl_shorts_v1",
          "autoTiming": true
        },
        "position": {"x": 500, "y": 300}
      },
      {
        "id": "n6",
        "type": "Output.Render",
        "params": {
          "profile": "9x16_1080p",
          "preset": "balanced"
        },
        "position": {"x": 700, "y": 300}
      },
      {
        "id": "n7",
        "type": "Output.Download",
        "params": {
          "generateThumbnail": true,
          "includeSrt": true
        },
        "position": {"x": 900, "y": 300}
      }
    ],
    "edges": [
      {"id": "e1", "from": "n1", "to": "n5"},
      {"id": "e2", "from": "n2", "to": "n3"},
      {"id": "e3", "from": "n3", "to": "n4"},
      {"id": "e4", "from": "n4", "to": "n5"},
      {"id": "e5", "from": "n5", "to": "n6"},
      {"id": "e6", "from": "n6", "to": "n7"}
    ]
  }'
```

### Create Workflow - AI Story with Generated Clips

```bash
curl -X POST https://api.fentaweb.com/v1/workflows \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "AI Story Generator",
    "description": "Generate story with AI-generated video clips",
    "nodes": [
      {
        "id": "script",
        "type": "Script.Generate",
        "params": {
          "genre": "story",
          "lang": "en",
          "prompt": "60s mysterious urban legend",
          "beats": 6,
          "tone": "mysterious"
        }
      },
      {
        "id": "clip1",
        "type": "Input.KAI.GenerateVideo",
        "params": {
          "prompt": "Dark alley at night, fog rolling in",
          "model": "sora",
          "duration": 10,
          "aspect": "9:16"
        }
      },
      {
        "id": "clip2",
        "type": "Input.KAI.GenerateVideo",
        "params": {
          "prompt": "Mysterious figure in shadows",
          "model": "sora",
          "duration": 10,
          "aspect": "9:16"
        }
      },
      {
        "id": "clip3",
        "type": "Input.KAI.GenerateVideo",
        "params": {
          "prompt": "Old abandoned building, eerie atmosphere",
          "model": "sora",
          "duration": 10,
          "aspect": "9:16"
        }
      },
      {
        "id": "voiceover",
        "type": "Voice.TTS",
        "params": {
          "engine": "kokoro",
          "voice": "onyx_en",
          "speed": 0.95
        }
      },
      {
        "id": "subtitles",
        "type": "Subtitle.Auto",
        "params": {
          "source": "audio",
          "style": "neon_glow"
        }
      },
      {
        "id": "timeline",
        "type": "Edit.Timeline",
        "params": {
          "templateId": "tmpl_story_dark"
        }
      },
      {
        "id": "render",
        "type": "Output.Render",
        "params": {
          "profile": "9x16_1080p"
        }
      }
    ],
    "edges": [
      {"from": "script", "to": "voiceover"},
      {"from": "voiceover", "to": "subtitles"},
      {"from": "clip1", "to": "timeline"},
      {"from": "clip2", "to": "timeline"},
      {"from": "clip3", "to": "timeline"},
      {"from": "subtitles", "to": "timeline"},
      {"from": "timeline", "to": "render"}
    ]
  }'
```

### Execute Workflow

```bash
# Full render
curl -X POST https://api.fentaweb.com/v1/workflows/wf_abc123/run \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "mode": "full"
  }'

# Test render (first 10-15 seconds)
curl -X POST https://api.fentaweb.com/v1/workflows/wf_abc123/run \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "mode": "test"
  }'
```

### Get Cost Estimate

```bash
curl -X POST https://api.fentaweb.com/v1/workflows/wf_abc123/estimate \
  -H "Authorization: Bearer YOUR_TOKEN"
```

**Response:**
```json
{
  "estimated": {
    "tokens": 8500,
    "renderSeconds": 90,
    "kaiCredits": 300,
    "totalUsd": 1.25,
    "duration": "3-7 minutes"
  },
  "breakdown": [
    {
      "component": "Script Generation",
      "resource": "llm_tokens",
      "quantity": 800,
      "cost": 0.05
    },
    {
      "component": "Video Generation (3x Sora clips)",
      "resource": "kai_credits",
      "quantity": 300,
      "cost": 1.20
    },
    {
      "component": "Voice Synthesis",
      "resource": "llm_tokens",
      "quantity": 1500,
      "cost": 0.08
    },
    {
      "component": "Final Render (60s @ 1080p)",
      "resource": "render_seconds",
      "quantity": 90,
      "cost": 1.35
    }
  ],
  "quotaStatus": {
    "tokens": {
      "available": 980000,
      "required": 8500,
      "sufficient": true
    },
    "kaiCredits": {
      "available": 450,
      "required": 300,
      "sufficient": true
    },
    "renderSeconds": {
      "available": 3200,
      "required": 90,
      "sufficient": true
    }
  }
}
```

## Direct Jobs (No Workflow)

### Simple Render with Uploaded Video

```bash
curl -X POST https://api.fentaweb.com/v1/jobs \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "template_id": "tmpl_shorts_v1",
    "sources": [
      {
        "type": "upload",
        "uri": "s3://bucket/user/my-video.mp4"
      }
    ],
    "script": {
      "lang": "en",
      "text": "This is my amazing video about travel adventures"
    },
    "tts": {
      "engine": "kokoro",
      "voice": "nova_en",
      "speed": 1.0
    },
    "subtitles": {
      "style": "karaoke_bounce"
    },
    "output": {
      "profile": "9x16_1080p"
    },
    "webhook_url": "https://myapp.com/webhooks/render"
  }'
```

### Render with Stock Footage

```bash
curl -X POST https://api.fentaweb.com/v1/jobs \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "template_id": "tmpl_news_v2",
    "sources": [
      {
        "type": "stock",
        "provider": "pexels",
        "query": "storm city night",
        "count": 5
      }
    ],
    "script": {
      "lang": "en",
      "text": "Breaking: Massive storm hits downtown. Residents urged to stay indoors as authorities respond."
    },
    "tts": {
      "engine": "kokoro",
      "voice": "alloy_en",
      "speed": 1.05
    },
    "subtitles": {
      "style": "clean_box"
    },
    "output": {
      "profile": "9x16_1080p"
    },
    "budget": {
      "max_cost_usd": 0.50,
      "max_tokens": 10000
    }
  }'
```

## Asset Management

### Initialize Upload

```bash
curl -X POST https://api.fentaweb.com/v1/assets/init \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "filename": "my-video.mp4",
    "contentType": "video/mp4",
    "size": 52428800
  }'
```

**Response:**
```json
{
  "assetId": "asset_abc123",
  "uploadUrl": "https://s3.amazonaws.com/bucket/path?signature=...",
  "expiresIn": 3600
}
```

### Upload File to S3

```bash
curl -X PUT "PRESIGNED_UPLOAD_URL" \
  -H "Content-Type: video/mp4" \
  --data-binary @my-video.mp4
```

### Complete Upload

```bash
curl -X POST https://api.fentaweb.com/v1/assets/complete \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "assetId": "asset_abc123"
  }'
```

**Response:**
```json
{
  "id": "asset_abc123",
  "type": "video",
  "source": "upload",
  "url": "https://cdn.fentaweb.com/assets/asset_abc123.mp4",
  "thumbnailUrl": "https://cdn.fentaweb.com/assets/asset_abc123_thumb.jpg",
  "metadata": {
    "filename": "my-video.mp4",
    "size": 52428800,
    "duration": 45.5,
    "width": 1080,
    "height": 1920,
    "fps": 30,
    "codec": "h264"
  },
  "status": "ready",
  "createdAt": "2024-01-15T11:00:00Z"
}
```

### Search Stock Assets

```bash
curl -X GET "https://api.fentaweb.com/v1/assets/stock/search?query=sunset+beach&provider=pexels&type=video&limit=10" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

**Response:**
```json
{
  "results": [
    {
      "id": "pexels_12345",
      "provider": "pexels",
      "type": "video",
      "url": "https://player.vimeo.com/...",
      "thumbnailUrl": "https://images.pexels.com/...",
      "width": 1920,
      "height": 1080,
      "duration": 15.2
    }
  ]
}
```

## KAI Integration

### Generate Image

```bash
curl -X POST https://api.fentaweb.com/v1/kai/generate-image \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "A futuristic city at sunset, cyberpunk style, neon lights, highly detailed",
    "model": "flux-pro",
    "width": 1024,
    "height": 1024,
    "variations": 3,
    "seed": 42
  }'
```

**Response:**
```json
{
  "generationId": "gen_xyz789",
  "status": "processing",
  "estimatedCost": 0.12
}
```

### Check Generation Status

```bash
curl -X GET https://api.fentaweb.com/v1/kai/generations/gen_xyz789 \
  -H "Authorization: Bearer YOUR_TOKEN"
```

**Response:**
```json
{
  "id": "gen_xyz789",
  "status": "completed",
  "progress": 100,
  "results": [
    {
      "assetId": "asset_img_001",
      "url": "https://cdn.fentaweb.com/assets/asset_img_001.png"
    },
    {
      "assetId": "asset_img_002",
      "url": "https://cdn.fentaweb.com/assets/asset_img_002.png"
    },
    {
      "assetId": "asset_img_003",
      "url": "https://cdn.fentaweb.com/assets/asset_img_003.png"
    }
  ],
  "cost": 0.12
}
```

### Generate Video

```bash
curl -X POST https://api.fentaweb.com/v1/kai/generate-video \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "A cat walking through a neon-lit alley at night, cinematic lighting",
    "model": "sora",
    "duration": 10,
    "aspect": "9:16",
    "seed": 123
  }'
```

**Response:**
```json
{
  "generationId": "gen_video_456",
  "status": "queued",
  "estimatedCost": 0.40
}
```

## Scheduling

### Create Schedule

```bash
curl -X POST https://api.fentaweb.com/v1/schedules \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "workflowId": "wf_abc123",
    "cron": "0 10 * * *",
    "timezone": "America/New_York",
    "enabled": true
  }'
```

**Response:**
```json
{
  "id": "sched_xyz789",
  "workflowId": "wf_abc123",
  "cron": "0 10 * * *",
  "timezone": "America/New_York",
  "enabled": true,
  "lastRun": null,
  "nextRun": "2024-01-16T10:00:00-05:00",
  "createdAt": "2024-01-15T12:00:00Z"
}
```

### Update Schedule

```bash
curl -X PATCH https://api.fentaweb.com/v1/schedules/sched_xyz789 \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "cron": "0 8,16 * * *",
    "enabled": true
  }'
```

## Usage & Billing

### Get Current Quota

```bash
curl -X GET https://api.fentaweb.com/v1/usage/quota \
  -H "Authorization: Bearer YOUR_TOKEN"
```

**Response:**
```json
{
  "plan": "pro",
  "limits": {
    "tokens": 5000000,
    "renderSeconds": 10800,
    "kaiCredits": 2000,
    "storage": 214748364800
  },
  "used": {
    "tokens": 2350000,
    "renderSeconds": 8950,
    "kaiCredits": 1850,
    "storage": 185000000000
  },
  "remaining": {
    "tokens": 2650000,
    "renderSeconds": 1850,
    "kaiCredits": 150,
    "storage": 29748364800
  },
  "resetAt": "2024-02-01T00:00:00Z"
}
```

### Get Usage Statistics

```bash
curl -X GET "https://api.fentaweb.com/v1/usage?startDate=2024-01-01&endDate=2024-01-31&groupBy=day" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

## Webhooks

### Create Webhook

```bash
curl -X POST https://api.fentaweb.com/v1/webhooks \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://myapp.com/webhooks/fenta",
    "events": [
      "render.succeeded",
      "render.failed",
      "workflow.run.finished"
    ],
    "enabled": true
  }'
```

**Response:**
```json
{
  "id": "hook_abc123",
  "url": "https://myapp.com/webhooks/fenta",
  "events": [
    "render.succeeded",
    "render.failed",
    "workflow.run.finished"
  ],
  "enabled": true,
  "secret": "whsec_xyz789...",
  "createdAt": "2024-01-15T13:00:00Z"
}
```

### Webhook Payload Example

When a render completes:

```json
{
  "event": "render.succeeded",
  "timestamp": "2024-01-15T14:30:00Z",
  "data": {
    "jobId": "job_abc123",
    "workflowId": "wf_xyz789",
    "result": {
      "videoUrl": "https://cdn.fentaweb.com/renders/video_abc123.mp4",
      "thumbnailUrl": "https://cdn.fentaweb.com/renders/video_abc123_thumb.jpg",
      "srtUrl": "https://cdn.fentaweb.com/renders/video_abc123.srt",
      "duration": 60.5
    },
    "cost": {
      "tokens": 5000,
      "renderSeconds": 90,
      "kaiCredits": 100,
      "totalUsd": 0.87
    },
    "timing": {
      "queuedAt": "2024-01-15T14:20:00Z",
      "startedAt": "2024-01-15T14:21:00Z",
      "completedAt": "2024-01-15T14:30:00Z"
    }
  }
}
```

### Verify Webhook Signature

```python
import hmac
import hashlib

def verify_webhook(payload, signature, secret):
    expected = hmac.new(
        secret.encode('utf-8'),
        payload.encode('utf-8'),
        hashlib.sha256
    ).hexdigest()

    return hmac.compare_digest(expected, signature)

# In your webhook handler
signature = request.headers.get('X-Fenta-Signature')
payload = request.body
secret = 'whsec_xyz789...'

if verify_webhook(payload, signature, secret):
    # Process webhook
    pass
else:
    # Invalid signature
    return 401
```

## Error Handling

### Error Response Format

```json
{
  "error": {
    "code": "QUOTA_EXCEEDED",
    "message": "Monthly token quota exceeded",
    "details": {
      "resource": "llm_tokens",
      "used": 5100000,
      "limit": 5000000,
      "overage": 100000
    }
  }
}
```

### Common Error Codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| VALIDATION_ERROR | 400 | Invalid request parameters |
| UNAUTHORIZED | 401 | Missing or invalid authentication |
| FORBIDDEN | 403 | Insufficient permissions |
| NOT_FOUND | 404 | Resource not found |
| QUOTA_EXCEEDED | 429 | Usage quota exceeded |
| RATE_LIMITED | 429 | Too many requests |
| API_ERROR | 502 | External API failure |
| PROCESSING_FAILED | 500 | Internal processing error |

### Retry Strategy

```javascript
async function callAPIWithRetry(endpoint, options, maxRetries = 3) {
  for (let i = 0; i < maxRetries; i++) {
    try {
      const response = await fetch(endpoint, options);

      if (response.ok) {
        return await response.json();
      }

      if (response.status >= 500) {
        // Retry on server errors
        await sleep(Math.pow(2, i) * 1000); // Exponential backoff
        continue;
      }

      // Don't retry on client errors
      throw new Error(await response.text());
    } catch (error) {
      if (i === maxRetries - 1) throw error;
    }
  }
}
```

## Rate Limits

**Per User:**
- 100 requests per minute
- 1000 requests per hour

**Headers:**
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 85
X-RateLimit-Reset: 1642257600
```

**When rate limited:**
```
HTTP/1.1 429 Too Many Requests
Retry-After: 45

{
  "error": {
    "code": "RATE_LIMITED",
    "message": "Rate limit exceeded. Retry after 45 seconds."
  }
}
```
