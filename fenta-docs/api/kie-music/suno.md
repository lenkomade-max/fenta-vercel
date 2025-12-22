# Suno API (KIE.ai)

## Endpoints

### Generate Music
```
POST https://api.kie.ai/api/v1/generate
```

### Check Status
```
GET https://api.kie.ai/api/v1/generate/record-info?taskId=YOUR_TASK_ID
```

### Extend Music
```
POST https://api.kie.ai/api/v1/generate/extend
```

### Generate Lyrics
```
POST https://api.kie.ai/api/v1/lyrics
```

### Convert to WAV
```
POST https://api.kie.ai/api/v1/wav/generate
```

### Separate Vocals
```
POST https://api.kie.ai/api/v1/separate/vocals
```

### Create Music Video
```
POST https://api.kie.ai/api/v1/video/generate
```

### Generate MIDI
```
POST https://api.kie.ai/api/v1/midi/generate
```

---

## Generate Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `prompt` | string | Yes | Music description (500-5000 chars) |
| `customMode` | boolean | No | false=simple, true=advanced |
| `instrumental` | boolean | No | true=no vocals |
| `model` | string | No | V3_5, V4, V4_5, V4_5PLUS, V4_5ALL, V5 |
| `style` | string | No | Music style (customMode only) |
| `title` | string | No | Track title (max 80 chars) |
| `callBackUrl` | string | No | Webhook URL |

## Models

| Model | Max Length | Features |
|-------|-----------|----------|
| V3_5 | 4 min | Song structure |
| V4 | 4 min | Vocal quality |
| V4_5 | 8 min | Smart prompts |
| V4_5PLUS | 8 min | Richer sound |
| V5 | 8 min | Best quality |

## Example Request
```json
{
  "prompt": "Upbeat electronic dance music with synths",
  "model": "V4_5",
  "instrumental": true,
  "callBackUrl": "https://your-app.com/webhook"
}
```

## Response
```json
{
  "code": 200,
  "msg": "success",
  "data": {
    "taskId": "5c79****be8e"
  }
}
```

## Status Values
- `PENDING` - Processing
- `TEXT_SUCCESS` - Lyrics done
- `FIRST_SUCCESS` - First track done
- `SUCCESS` - Complete
- `CREATE_TASK_FAILED` - Error
- `GENERATE_AUDIO_FAILED` - Error
- `SENSITIVE_WORD_ERROR` - Filtered

## Result Format
```json
{
  "sunoData": [{
    "id": "...",
    "audioUrl": "https://...",
    "imageUrl": "...",
    "title": "...",
    "duration": 198.44
  }]
}
```

## Specs
- Cost: 20-35 credits
- Storage: 14 days
