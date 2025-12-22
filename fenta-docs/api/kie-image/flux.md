# Flux Kontext API (KIE.ai)

## Endpoint
```
POST https://api.kie.ai/api/v1/flux/kontext/generate
```

## Authentication
```
Authorization: Bearer YOUR_API_KEY
```

## Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `prompt` | string | Yes | Image description |
| `model` | string | No | `flux-kontext-pro` or `flux-kontext-max` |
| `aspectRatio` | string | No | `16:9`, `1:1`, `9:16`, `21:9` |
| `outputFormat` | string | No | Output format |
| `safetyTolerance` | integer | No | 0-6 (generation), 0-2 (editing) |
| `promptUpsampling` | boolean | No | Enhance prompt |
| `imageUrl` | string | No | Input image for editing |
| `callBackUrl` | string | No | Webhook URL |

## Models
- `flux-kontext-pro` - Standard quality
- `flux-kontext-max` - Complex scenes, higher quality

## Example Request
```json
{
  "prompt": "Cyberpunk city at night with neon lights",
  "model": "flux-kontext-pro",
  "aspectRatio": "16:9"
}
```

## Response
```json
{
  "code": 200,
  "msg": "success",
  "data": {
    "taskId": "task_flux_abc123"
  }
}
```

## Check Status
```
GET https://api.kie.ai/api/v1/flux/kontext/record-info?taskId=YOUR_TASK_ID
```

## Status Codes
- `0` - Generating
- `1` - Success
- `2` - Creation failed
- `3` - Generation failed

## Specs
- Cost: 8 credits
- Storage: 14 days
- URL expires: 10 minutes
