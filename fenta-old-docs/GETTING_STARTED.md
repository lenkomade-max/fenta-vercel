# Getting Started with Fenta Web API

This guide will help you get started with the Fenta Web API in 5 minutes.

## Step 1: Create an Account

Register via API or web interface:

```bash
curl -X POST https://api.fentaweb.com/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "you@example.com",
    "password": "SecurePassword123!",
    "name": "Your Name"
  }'
```

**Response:**
```json
{
  "user": {
    "id": "user_abc123",
    "email": "you@example.com",
    "name": "Your Name"
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

Save your token - you'll need it for all API requests.

## Step 2: Your First Video

Let's create a simple video using stock footage and text-to-speech.

```bash
curl -X POST https://api.fentaweb.com/v1/jobs \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "template_id": "tmpl_shorts_v1",
    "sources": [
      {
        "type": "stock",
        "provider": "pexels",
        "query": "sunset beach",
        "count": 3
      }
    ],
    "script": {
      "lang": "en",
      "text": "Discover the beauty of nature. Stunning sunsets await you."
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
    }
  }'
```

**Response:**
```json
{
  "id": "job_abc123",
  "status": "queued",
  "progress": 0,
  "created_at": "2024-01-15T14:20:00Z"
}
```

## Step 3: Check Job Status

Poll the job status endpoint:

```bash
curl -X GET https://api.fentaweb.com/v1/jobs/job_abc123 \
  -H "Authorization: Bearer YOUR_TOKEN"
```

**Response (completed):**
```json
{
  "id": "job_abc123",
  "status": "completed",
  "progress": 100,
  "result": {
    "video_url": "https://cdn.fentaweb.com/renders/job_abc123.mp4",
    "thumbnail_url": "https://cdn.fentaweb.com/renders/job_abc123_thumb.jpg",
    "srt_url": "https://cdn.fentaweb.com/renders/job_abc123.srt",
    "duration": 15.5
  },
  "cost": {
    "tokens": 150,
    "render_seconds": 23,
    "kai_credits": 0,
    "total_usd": 0.35
  }
}
```

## Step 4: Download Your Video

Download the video from the provided URL:

```bash
curl -o my-video.mp4 "https://cdn.fentaweb.com/renders/job_abc123.mp4"
```

## Next Steps

### Create a Workflow

For more complex videos, create a reusable workflow:

```bash
curl -X POST https://api.fentaweb.com/v1/workflows \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "My First Workflow",
    "nodes": [
      {
        "id": "stock",
        "type": "Input.Stock",
        "params": {
          "provider": "pexels",
          "query": "nature",
          "count": 5
        }
      },
      {
        "id": "script",
        "type": "Script.Generate",
        "params": {
          "genre": "facts",
          "targetDuration": 30
        }
      },
      {
        "id": "voice",
        "type": "Voice.TTS",
        "params": {
          "engine": "kokoro",
          "voice": "alloy_en"
        }
      },
      {
        "id": "subs",
        "type": "Subtitle.Auto",
        "params": {
          "source": "audio",
          "style": "clean_box"
        }
      },
      {
        "id": "timeline",
        "type": "Edit.Timeline",
        "params": {
          "templateId": "tmpl_shorts_v1"
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
      {"from": "stock", "to": "timeline"},
      {"from": "script", "to": "voice"},
      {"from": "voice", "to": "subs"},
      {"from": "subs", "to": "timeline"},
      {"from": "timeline", "to": "render"}
    ]
  }'
```

### Execute Workflow

```bash
curl -X POST https://api.fentaweb.com/v1/workflows/wf_abc123/run \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"mode": "full"}'
```

### Schedule Daily Runs

```bash
curl -X POST https://api.fentaweb.com/v1/schedules \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "workflowId": "wf_abc123",
    "cron": "0 10 * * *",
    "timezone": "America/New_York"
  }'
```

### Use AI-Generated Content

Generate custom video clips with AI:

```bash
curl -X POST https://api.fentaweb.com/v1/kai/generate-video \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "A cyberpunk city at night with neon lights",
    "model": "sora",
    "duration": 10,
    "aspect": "9:16"
  }'
```

## Common Use Cases

### 1. Daily News Shorts

```javascript
const workflow = {
  name: "Daily News",
  nodes: [
    {id: "stock", type: "Input.Stock", params: {query: "breaking news"}},
    {id: "script", type: "Script.Generate", params: {genre: "news", targetDuration: 30}},
    {id: "tts", type: "Voice.TTS", params: {voice: "alloy_en", speed: 1.05}},
    {id: "subs", type: "Subtitle.Auto", params: {style: "clean_box"}},
    {id: "timeline", type: "Edit.Timeline", params: {templateId: "tmpl_news"}},
    {id: "render", type: "Output.Render", params: {profile: "9x16_1080p"}}
  ],
  edges: [
    {from: "stock", to: "timeline"},
    {from: "script", to: "tts"},
    {from: "tts", to: "subs"},
    {from: "subs", to: "timeline"},
    {from: "timeline", to: "render"}
  ]
};
```

### 2. AI Story with Generated Clips

```javascript
const workflow = {
  name: "AI Story",
  nodes: [
    {id: "script", type: "Script.Generate", params: {genre: "story", beats: 6}},
    {id: "clip1", type: "Input.KAI.GenerateVideo", params: {prompt: "Scene 1", model: "sora", duration: 10}},
    {id: "clip2", type: "Input.KAI.GenerateVideo", params: {prompt: "Scene 2", model: "sora", duration: 10}},
    {id: "clip3", type: "Input.KAI.GenerateVideo", params: {prompt: "Scene 3", model: "sora", duration: 10}},
    {id: "tts", type: "Voice.TTS", params: {voice: "onyx_en", speed: 0.95}},
    {id: "subs", type: "Subtitle.Auto", params: {style: "neon_glow"}},
    {id: "timeline", type: "Edit.Timeline", params: {templateId: "tmpl_story"}},
    {id: "render", type: "Output.Render", params: {profile: "9x16_1080p"}}
  ],
  edges: [
    {from: "script", to: "tts"},
    {from: "tts", to: "subs"},
    {from: "clip1", to: "timeline"},
    {from: "clip2", to: "timeline"},
    {from: "clip3", to: "timeline"},
    {from: "subs", to: "timeline"},
    {from: "timeline", to: "render"}
  ]
};
```

### 3. Product Review Video

```javascript
const job = {
  template_id: "tmpl_review",
  sources: [
    {type: "upload", uri: "s3://bucket/product-demo.mp4"}
  ],
  script: {
    lang: "en",
    text: "This product changed my life. Here are 3 reasons why you need it."
  },
  tts: {
    engine: "kokoro",
    voice: "nova_en",
    speed: 1.0
  },
  subtitles: {
    style: "bold_shadow"
  },
  output: {
    profile: "9x16_1080p"
  }
};
```

## Best Practices

### 1. Estimate Costs First

Always check cost before executing:

```bash
curl -X POST https://api.fentaweb.com/v1/workflows/wf_abc123/estimate \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### 2. Use Test Mode

Test first 10-15 seconds before full render:

```bash
curl -X POST https://api.fentaweb.com/v1/workflows/wf_abc123/run \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{"mode": "test"}'
```

### 3. Set Budget Limits

Prevent overspending:

```javascript
{
  "budget": {
    "max_cost_usd": 1.00,
    "max_tokens": 10000,
    "max_render_seconds": 120
  }
}
```

### 4. Use Webhooks

Get notified when jobs complete:

```bash
curl -X POST https://api.fentaweb.com/v1/webhooks \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "url": "https://myapp.com/webhooks/fenta",
    "events": ["render.succeeded", "render.failed"]
  }'
```

### 5. Monitor Usage

Check your quota regularly:

```bash
curl -X GET https://api.fentaweb.com/v1/usage/quota \
  -H "Authorization: Bearer YOUR_TOKEN"
```

## SDKs and Libraries

### JavaScript/TypeScript

```bash
npm install @fentaweb/sdk
```

```javascript
import { FentaWeb } from '@fentaweb/sdk';

const client = new FentaWeb({
  apiKey: 'YOUR_API_KEY'
});

// Create job
const job = await client.jobs.create({
  template_id: 'tmpl_shorts_v1',
  sources: [{type: 'stock', provider: 'pexels', query: 'sunset'}],
  script: {text: 'Beautiful sunset'},
  tts: {voice: 'nova_en'},
  output: {profile: '9x16_1080p'}
});

// Wait for completion
const result = await client.jobs.waitForCompletion(job.id);
console.log('Video URL:', result.video_url);
```

### Python

```bash
pip install fentaweb
```

```python
from fentaweb import FentaWeb

client = FentaWeb(api_key='YOUR_API_KEY')

# Create job
job = client.jobs.create(
    template_id='tmpl_shorts_v1',
    sources=[{'type': 'stock', 'provider': 'pexels', 'query': 'sunset'}],
    script={'text': 'Beautiful sunset'},
    tts={'voice': 'nova_en'},
    output={'profile': '9x16_1080p'}
)

# Wait for completion
result = client.jobs.wait_for_completion(job['id'])
print('Video URL:', result['video_url'])
```

## Troubleshooting

### Common Errors

**401 Unauthorized**
- Check your API token is valid
- Ensure `Authorization: Bearer YOUR_TOKEN` header is set

**429 Rate Limited**
- You've exceeded rate limits (100 req/min)
- Wait for `Retry-After` seconds
- Consider upgrading plan

**400 Validation Error**
- Check request parameters match schema
- Validate required fields are present
- Ensure enum values are correct

**QUOTA_EXCEEDED**
- You've reached monthly quota limits
- Upgrade plan or wait for quota reset
- Set budget limits to prevent overages

### Getting Help

- **Documentation**: https://docs.fentaweb.com
- **API Reference**: [OpenAPI Spec](./api/openapi.yaml)
- **Discord**: https://discord.gg/fentaweb
- **Email**: support@fentaweb.com

## Next Steps

1. Explore full [API documentation](./api/openapi.yaml)
2. Learn about [workflow nodes](./workflows/node-reference.md)
3. Understand [billing system](./billing/billing-system.md)
4. Check out [examples](./examples/api-examples.md)
5. Review [database schema](./database/schema.md)

Happy video creating!
