# KIE.ai Image Generation APIs - Complete Documentation

Welcome! This folder contains **complete documentation** for all **8 image generation models** available on KIE.ai.

---

## 📚 Documentation Structure

### Quick Start (Read These First)
1. **[QUICK_REFERENCE.md](./QUICK_REFERENCE.md)** ⚡ - Copy-paste examples, quick lookup
2. **[comparison.md](./comparison.md)** 🔍 - Model comparison & selection guide

### Full Model Documentation
3. **[gpt4o-image.md](./gpt4o-image.md)** - OpenAI's GPT-4o Image API
4. **[flux.md](./flux.md)** - Black Forest Labs' Flux Kontext (Pro/Max)
5. **[midjourney.md](./midjourney.md)** - Midjourney (v7, 6.1, Niji6)
6. **[seedream.md](./seedream.md)** - ByteDance Seedream V4
7. **[nano-banana.md](./nano-banana.md)** - Google Nano Banana (Gemini)
8. **[qwen.md](./qwen.md)** - Alibaba Qwen Image
9. **[recraft.md](./recraft.md)** - Recraft Tools (Upscale + Remove BG)

### Guides & References
10. **[ghibli-style.md](./ghibli-style.md)** - Studio Ghibli Style Guide
11. **[_index.md](./_index.md)** - Master API reference

---

## 🎯 Models at a Glance

### 💰 Budget Models
- **Seedream V4** - 3.5 credits ($0.0175) - Fastest, 4K resolution
- **Nano Banana** - 4 credits ($0.02) - Great for editing

### ⚖️ Balanced Models
- **Qwen Image** - 6-8 credits ($0.03-0.04) - Bilingual, text-aware
- **Flux Kontext** - 8-12 credits ($0.04-0.06) - Professional editing

### ✨ Premium Models
- **GPT-4o Image** - 10 credits ($0.05) - OpenAI quality, text rendering
- **Midjourney** - 25 credits ($0.125) - Artistic, most creative

### 🛠️ Utility Tools
- **Recraft Upscale** - 2-4 credits - 2x/4x image upscaling
- **Recraft Remove BG** - 1-2 credits - Background removal → PNG

---

## 🚀 Quick Start Examples

### Example 1: Generate an Image (Seedream)
```bash
curl -X POST https://api.kie.ai/api/v1/seedream/generate \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "A beautiful sunset over mountains",
    "image_size": "landscape_16_9",
    "image_resolution": "2K"
  }'

# Response: { "code": 200, "data": { "taskId": "task_xyz" } }
```

### Example 2: Check Status
```bash
curl -X GET "https://api.kie.ai/api/v1/seedream/record-info?taskId=task_xyz" \
  -H "Authorization: Bearer YOUR_API_KEY"

# Response: { "taskId": "task_xyz", "successFlag": 1, "imageUrl": "..." }
```

---

## 📊 Comparison Table

| Model | Cost | Speed | Quality | Best For |
|-------|------|-------|---------|----------|
| Seedream | 3.5 💰 | ⚡⚡⚡ | ★★★★ | Bulk content |
| Nano Banana | 4 💰 | ⚡⚡⚡ | ★★★★ | Editing |
| Qwen | 6-8 | ⚡⚡ | ★★★★ | Chinese text |
| Flux Pro | 8 | ⚡⚡ | ★★★★★ | Speed + quality |
| GPT-4o | 10 | ⚡⚡ | ★★★★★ | Text graphics |
| Flux Max | 12 | ⚡ | ★★★★★ | Complex scenes |
| Midjourney | 25 | ⚡ | ★★★★★ | Artistic |

---

## 🎓 Which Model Should I Use?

### For TikTok/Reels Content
→ **Seedream V4** - Cheapest ($0.0175), fast, good quality

### For Professional Designs
→ **Flux Kontext Max** - Best quality, $0.04-0.06 per image

### For Text-Heavy Graphics (Ads, Posters)
→ **GPT-4o Image** or **Qwen** - Excellent text rendering

### For Quick Edits
→ **Nano Banana** - Fast ($0.02), great for style changes

### For Artistic/Creative
→ **Midjourney** - Most creative, anime support (Niji6)

### For Chinese Market
→ **Seedream** or **Qwen** - Native Chinese language support

### For Background Removal
→ **Recraft Remove Background** - Clean PNG with transparency

### For Upscaling
→ **Recraft Crisp Upscale** - 2x or 4x quality enhancement

---

## 📖 How to Use This Documentation

### Step 1: Understand Your Need
- Check [comparison.md](./comparison.md) to find the right model

### Step 2: Learn the API
- Read the relevant model file (e.g., [seedream.md](./seedream.md))
- Review parameters and examples

### Step 3: Implementation
- Copy example from [QUICK_REFERENCE.md](./QUICK_REFERENCE.md)
- Replace API_KEY and parameters
- Test with a single image

### Step 4: Scale
- Batch multiple requests
- Use webhooks (callBackUrl) for async processing
- Monitor credit usage

---

## 🔑 Common API Pattern (All Models)

### 1. Create Task (POST)
```
POST /api/v1/{service}/generate
Authorization: Bearer API_KEY
Content-Type: application/json

{
  "prompt": "description",
  "model": "variant",  // some models only
  "callBackUrl": "https://webhook.url"
}
```

### 2. Check Status (GET)
```
GET /api/v1/{service}/record-info?taskId={taskId}
Authorization: Bearer API_KEY
```

### 3. Status Codes
- `0` = Generating (keep polling)
- `1` = Success (resultUrls ready)
- `2` = Failed
- `3` = Creation error

---

## 💡 Pro Tips

1. **Use Webhooks** - Don't poll. Set `callBackUrl` for async notifications
2. **Batch Requests** - Send multiple tasks in parallel (KIE.ai handles it)
3. **Cache Results** - Files stored 14 days, download immediately
4. **Seed for Consistency** - Use `seed` parameter for reproducible results
5. **Cost Optimization** - Start with Seedream, upgrade if needed
6. **Language Selection** - Use Seedream/Qwen for Chinese, others for English

---

## 🔗 Resources

### Official Links
- **KIE.ai Home:** https://kie.ai
- **API Docs:** https://docs.kie.ai
- **Models Gallery:** https://kie.ai/market
- **Get API Key:** https://kie.ai (Dashboard)

### Related Documentation
- Main API reference: `/fenta-docs/api/kie-ai-models.md`
- Research summary: `/fenta-docs/api/KIE_IMAGE_RESEARCH.md`

---

## 📋 File Index

| File | Purpose | Lines |
|------|---------|-------|
| `QUICK_REFERENCE.md` | Copy-paste, quick lookup | 300+ |
| `comparison.md` | Model selection guide | 250+ |
| `gpt4o-image.md` | GPT-4o API docs | 60 |
| `flux.md` | Flux Kontext API docs | 65 |
| `midjourney.md` | Midjourney API docs | 100 |
| `seedream.md` | Seedream API docs | 95 |
| `nano-banana.md` | Nano Banana API docs | 95 |
| `qwen.md` | Qwen Image API docs | 85 |
| `recraft.md` | Recraft tools docs | 100 |
| `ghibli-style.md` | Ghibli style guide | 95 |
| `_index.md` | Master reference | 70 |
| `README.md` | This file | 300+ |

---

## ❓ FAQ

**Q: Which model is cheapest?**
A: Seedream V4 at 3.5 credits ($0.0175/image)

**Q: Which is fastest?**
A: Seedream V4 or Nano Banana (~15-30 seconds)

**Q: Which has best quality?**
A: Midjourney or Flux Kontext Max

**Q: Can I use Chinese prompts?**
A: Yes, with Seedream V4 or Qwen Image

**Q: How long are files stored?**
A: 14 days, download URLs valid 20 minutes

**Q: How do I get an API key?**
A: Sign up at https://kie.ai → Dashboard → API Keys

**Q: Can I use webhooks?**
A: Yes, pass `callBackUrl` parameter

**Q: What if a generation fails?**
A: Check successFlag=2 or 3, review error code, retry

---

## 🚨 Support

- **API Issues:** Check status codes in [_index.md](./_index.md)
- **Model Selection:** See [comparison.md](./comparison.md)
- **Code Examples:** See [QUICK_REFERENCE.md](./QUICK_REFERENCE.md)
- **Official Help:** https://docs.kie.ai

---

## 📝 Last Updated

**December 7, 2025** - Complete documentation for all 8 KIE.ai image models

**Total Files:** 11 Markdown documents
**Total Content:** 2000+ lines
**API Coverage:** 100% (all public endpoints)

---

**Start with:** [QUICK_REFERENCE.md](./QUICK_REFERENCE.md) ⚡ or [comparison.md](./comparison.md) 🔍
