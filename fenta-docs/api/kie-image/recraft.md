# Recraft API (KIE.ai)

Recraft provides specialized APIs for image enhancement and processing. On KIE.ai, two main services are available:

## 1. Recraft Crisp Upscale API

### Endpoint
```
POST https://api.kie.ai/api/v1/recraft/upscale
```

### Authentication
```
Authorization: Bearer YOUR_API_KEY
```

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `image_url` | string | Yes | URL of the image to upscale |
| `scale` | integer | No | Upscaling factor (2x, 4x) |
| `format` | string | No | Output format (PNG, JPG) |
| `callBackUrl` | string | No | Webhook URL for async notification |

### Example Request
```json
{
  "image_url": "https://example.com/image.jpg",
  "scale": 4,
  "format": "PNG"
}
```

### Response
```json
{
  "code": 200,
  "msg": "success",
  "data": {
    "taskId": "recraft_upscale_xyz"
  }
}
```

### Check Status
```
GET https://api.kie.ai/api/v1/recraft/upscale/record-info?taskId=YOUR_TASK_ID
```

### Specs (Upscale)
- Cost: 2-4 credits per image
- Supports: 2x, 4x upscaling
- Output: Crystal-clear, high-resolution images
- Quality: AI-enhanced, noise reduction
- Free tier: Available on kie.ai

---

## 2. Recraft Remove Background API

### Endpoint
```
POST https://api.kie.ai/api/v1/recraft/remove-background
```

### Authentication
```
Authorization: Bearer YOUR_API_KEY
```

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `image_url` | string | Yes | URL of the image |
| `output_format` | string | No | Output format (PNG with transparency) |
| `callBackUrl` | string | No | Webhook URL for async notification |

### Example Request
```json
{
  "image_url": "https://example.com/photo.jpg",
  "output_format": "PNG"
}
```

### Response
```json
{
  "code": 200,
  "msg": "success",
  "data": {
    "taskId": "recraft_bg_remove_abc"
  }
}
```

### Check Status
```
GET https://api.kie.ai/api/v1/recraft/remove-background/record-info?taskId=YOUR_TASK_ID
```

### Specs (Remove Background)
- Cost: 1-2 credits per image
- Output: PNG with transparent background
- Accuracy: High-precision subject isolation
- Use cases: eCommerce, product photos, design assets
- Quality: Clean, professional results

---

## General Info

### Status Codes (Both APIs)
- `0` - Processing
- `1` - Success
- `2` - Failed
- `3` - Creation failed

### Model Info
- **Recraft V3** - Latest, most advanced model (#1 on HuggingFace leaderboard)
- **Recraft V2** - Stable, professional-grade
- **Specialized** for designer and professional use

### Overall Recraft Features on KIE.ai
- High precision and accuracy
- Fast processing
- Affordable pricing
- No quality loss in upscaling
- Clean, transparent PNG backgrounds
- Ideal for eCommerce, design, and content creation
