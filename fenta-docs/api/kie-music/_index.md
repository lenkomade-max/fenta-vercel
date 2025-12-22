# KIE.ai Music Generation APIs

## Base URL
```
https://api.kie.ai
```

## Authentication
```
Authorization: Bearer YOUR_API_KEY
```

## Available Models

| Model | Endpoint | Max Duration | Credits |
|-------|----------|--------------|---------|
| Suno V4 | `/api/v1/generate` | 4 min | 20-30 |
| Suno V4.5 | `/api/v1/generate` | 8 min | 20-30 |
| Suno V5 | `/api/v1/generate` | 8 min | 25-35 |

## Additional Endpoints

| Function | Endpoint |
|----------|----------|
| Extend Music | `/api/v1/generate/extend` |
| Generate Lyrics | `/api/v1/lyrics` |
| Convert to WAV | `/api/v1/wav/generate` |
| Separate Vocals | `/api/v1/separate/vocals` |
| Create Music Video | `/api/v1/video/generate` |
| Generate MIDI | `/api/v1/midi/generate` |

## Documentation Files
- [suno.md](./suno.md) - Suno V4/V4.5/V5
