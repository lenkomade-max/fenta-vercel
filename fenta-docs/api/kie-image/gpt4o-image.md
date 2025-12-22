# GPT-4o Image API (KIE.ai)

## Endpoint
```
POST https://api.kie.ai/api/v1/gpt4o-image/generate
```

## Authentication
```
Authorization: Bearer YOUR_API_KEY
```

## Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `prompt` | string | Yes | Image description |
| `size` | string | No | `1:1`, `3:2`, `2:3` |
| `filesUrl` | array | No | Input images (up to 5) |
| `maskUrl` | string | No | Mask URL for editing |
| `nVariants` | integer | No | 1, 2, or 4 variants |
| `isEnhance` | boolean | No | Enhance prompt (default: false) |
| `callBackUrl` | string | No | Webhook URL |

## Example Request
```json
{
  "prompt": "A serene mountain landscape at sunset",
  "size": "1:1",
  "nVariants": 2
}
```

## Response
```json
{
  "code": 200,
  "msg": "success",
  "data": {
    "taskId": "gpt4o_task_xyz"
  }
}
```

## Check Status
```
GET https://api.kie.ai/api/v1/gpt4o-image/record-info?taskId=YOUR_TASK_ID
```

## Status (successFlag)
- `0` - Generating
- `1` - Success
- `2` - Failed

## Download URL
```
POST https://api.kie.ai/api/v1/gpt4o-image/download-url
Body: { "imageUrl": "..." }
```

## Specs
- Cost: 10 credits
- Formats: JPG, PNG, WebP
- Storage: 14 days
- Download URL valid: 20 minutes
