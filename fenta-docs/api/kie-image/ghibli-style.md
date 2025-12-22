# Ghibli Style Generation (KIE.ai)

Ghibli-style image generation is not a separate API model on KIE.ai, but rather a style that can be achieved using **GPT-4o Image API** or **Flux Kontext API** with specialized prompts.

## Using GPT-4o Image for Ghibli Style

### Endpoint
```
POST https://api.kie.ai/api/v1/gpt4o-image/generate
```

### Best Parameters for Ghibli Style
```json
{
  "prompt": "A stunning Studio Ghibli-inspired landscape with soft pastel colors, whimsical characters, and magical atmosphere",
  "size": "16:9",
  "nVariants": 1,
  "isEnhance": true
}
```

### Key Techniques
1. **Prompt Engineering**: Include keywords like:
   - "Studio Ghibli style"
   - "Hayao Miyazaki inspired"
   - "Soft watercolor aesthetic"
   - "Japanese animation style"
   - "Whimsical and magical"

2. **Use Flux Kontext for Better Results**:
   - Flux Kontext Pro/Max can handle stylistic requests better for complex scenes
   - Supports aspect ratios like 16:9 for cinematic compositions

### Example Ghibli Prompts
```
"A young girl with large expressive eyes in a lush garden,
soft watercolor style, Studio Ghibli aesthetic,
romantic lighting, magical atmosphere"

"An enchanted forest with floating islands and spiraling towers,
inspired by Howl's Moving Castle, soft color palette,
dreamy and whimsical mood"

"A peaceful Japanese village at sunset with traditional buildings,
cherry blossoms falling, soft pastel colors,
Studio Ghibli illustration style"
```

---

## Using Flux Kontext for Ghibli Style

### Endpoint
```
POST https://api.kie.ai/api/v1/flux/kontext/generate
```

### Recommended Model for Ghibli
```json
{
  "prompt": "A magical landscape in Studio Ghibli art style with ethereal atmosphere",
  "model": "flux-kontext-pro",
  "aspectRatio": "16:9",
  "promptUpsampling": true
}
```

---

## Summary

| Feature | Best Choice |
|---------|------------|
| **Text-to-Ghibli** | Flux Kontext Pro/Max |
| **Quick Generation** | GPT-4o Image with style prompt |
| **Complex Scenes** | Flux Kontext Max |
| **Character Consistency** | Flux Kontext (with seed control) |
| **Artistic Quality** | Flux Kontext Pro/Max |

## Important Notes
- Ghibli style is achieved through **prompt engineering**, not a dedicated model
- **Prompt Upsampling** helps refine the style interpretation
- Use detailed, descriptive prompts for best results
- Aspect ratio selection matters for composition (16:9 for cinematic, 1:1 for portraits)
- Both GPT-4o and Flux Kontext support Ghibli-style generation

## Cost
- GPT-4o Image: 10 credits per generation
- Flux Kontext Pro: 8 credits per generation
- Flux Kontext Max: 12-15 credits per generation
