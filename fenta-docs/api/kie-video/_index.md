# KIE.ai Video Generation APIs

## Base URL
```
https://api.kie.ai
```

## Authentication
```
Authorization: Bearer YOUR_API_KEY
```

## Available Models

| Model | Endpoint | Duration | Credits |
|-------|----------|----------|---------|
| Veo 3.1 | `/api/v1/veo/generate` | 8-12s | ~80 |
| Veo 3.1 Fast | `/api/v1/veo/generate` | 8-12s | ~70 |
| Sora 2 | `/api/v1/sora/generate` | 10-15s | ~100 |
| Kling 2.1 Pro | `/api/v1/kling/generate` | 5-10s | 50-70 |
| Kling 2.5 Turbo | `/api/v1/kling/generate` | 5-10s | 50 |
| Runway Gen-3 | `/api/v1/runway/generate` | 5-10s | 60-80 |
| Runway Aleph | `/api/v1/runway/generate` | - | 50-70 |
| Minimax | `/api/v1/minimax/generate` | 6-10s | 50 |
| Hailuo 02 | `/api/v1/hailuo/generate` | 8-12s | 60 |
| Wan 2.5 | `/api/v1/wan/generate` | 8-12s | 60 |
| Seedance | `/api/v1/seedance/generate` | 8-10s | 55 |
| Luma Modify | `/api/v1/modify/generate` | - | 50-70 |

## Common Pattern

### 1. Create Task
```http
POST /api/v1/{service}/generate
Content-Type: application/json
Authorization: Bearer API_KEY

{
  "prompt": "description",
  "aspectRatio": "16:9",
  "callBackUrl": "https://webhook.url"
}
```

### 2. Check Status
```http
GET /api/v1/{service}/record-info?taskId={taskId}
```

### 3. Status Codes
- `0` - generating
- `1` - success
- `2` - failed

## Storage
- Files stored: 14 days
- Download URL valid: 20 minutes

## Documentation Files

### Generation Models
- [veo.md](./veo.md) - Veo 3.1 (Google DeepMind) - Text & Image-to-Video
- [sora.md](./sora.md) - Sora 2 (OpenAI) - Text & Image-to-Video, Native Audio
- [kling.md](./kling.md) - Kling (Kuaishou) - T2V, I2V, Avatar API
- [runway.md](./runway.md) - Runway - Gen-3 Turbo T2V/I2V + Aleph V2V
- [minimax.md](./minimax.md) - Minimax Hailuo - T2V, I2V, Advanced Physics
- [hailuo.md](./hailuo.md) - Hailuo (MiniMax) - T2V, I2V, Cinematic Quality
- [wan.md](./wan.md) - Wan 2.5 (Alibaba) - T2V, I2V, S2V, Advanced Camera
- [seedance.md](./seedance.md) - Seedance (ByteDance) - T2V, I2V, Multi-shot

### Post-Production
- [luma.md](./luma.md) - Luma Modify - Video Enhancement & Color Grading
