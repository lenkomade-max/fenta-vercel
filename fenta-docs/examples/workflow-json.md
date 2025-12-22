# Примеры — Workflow JSON

## Минимальный workflow

Самый простой workflow для создания короткого видео:

```json
{
  "id": "wf_minimal",
  "name": "Minimal Workflow",
  "graph": {
    "nodes": [
      {
        "id": "stock",
        "type": "Input.Stock",
        "params": {
          "provider": "pexels",
          "query": "ocean waves sunset",
          "count": 3,
          "orientation": "portrait"
        },
        "position": {"x": 100, "y": 100}
      },
      {
        "id": "script",
        "type": "Script.Generate",
        "params": {
          "genre": "facts",
          "prompt": "3 amazing facts about the ocean",
          "targetDuration": 30,
          "lang": "en"
        },
        "position": {"x": 100, "y": 250}
      },
      {
        "id": "voice",
        "type": "Voice.TTS",
        "params": {
          "engine": "kokoro",
          "voice": "af_heart",
          "speed": 1.0
        },
        "position": {"x": 100, "y": 400}
      },
      {
        "id": "subs",
        "type": "Subtitle.Auto",
        "params": {
          "source": "audio",
          "style": "karaoke_bounce"
        },
        "position": {"x": 300, "y": 400}
      },
      {
        "id": "timeline",
        "type": "Edit.Timeline",
        "params": {
          "templateId": "tmpl_shorts_v1",
          "autoTiming": true
        },
        "position": {"x": 300, "y": 250}
      },
      {
        "id": "render",
        "type": "Output.Render",
        "params": {
          "profile": "9x16_1080p"
        },
        "position": {"x": 500, "y": 250}
      }
    ],
    "edges": [
      {"id": "e1", "from": "stock", "to": "timeline"},
      {"id": "e2", "from": "script", "to": "voice"},
      {"id": "e3", "from": "voice", "to": "subs"},
      {"id": "e4", "from": "voice", "to": "timeline"},
      {"id": "e5", "from": "subs", "to": "timeline"},
      {"id": "e6", "from": "timeline", "to": "render"}
    ]
  }
}
```

**Оценочная стоимость:** ~$0.50

---

## Crime Story Workflow

Полноценный workflow для криминального контента:

```json
{
  "id": "wf_crime_story",
  "name": "Crime Story Generator",
  "graph": {
    "nodes": [
      {
        "id": "stock_intro",
        "type": "Input.Stock",
        "params": {
          "provider": "pexels",
          "query": "police lights night city",
          "count": 2,
          "orientation": "portrait",
          "minDuration": 5
        },
        "position": {"x": 100, "y": 100}
      },
      {
        "id": "stock_main",
        "type": "Input.Stock",
        "params": {
          "provider": "pexels",
          "query": "investigation crime scene dark",
          "count": 5,
          "orientation": "portrait"
        },
        "position": {"x": 100, "y": 200}
      },
      {
        "id": "script",
        "type": "Script.Generate",
        "params": {
          "genre": "crime",
          "prompt": "True crime story about mysterious disappearance, shocking twist at the end",
          "targetDuration": 60,
          "tone": "energetic",
          "beats": 4,
          "model": "gpt-4"
        },
        "position": {"x": 300, "y": 100}
      },
      {
        "id": "voice",
        "type": "Voice.TTS",
        "params": {
          "engine": "kokoro",
          "voice": "am_onyx",
          "speed": 1.05,
          "voiceInstructions": "Speak dramatically, with suspenseful pauses"
        },
        "position": {"x": 300, "y": 250}
      },
      {
        "id": "music",
        "type": "Audio.Mix",
        "params": {
          "musicTag": "crime_darkhorror",
          "musicVolume": 0.25,
          "ducking": true,
          "duckingLevel": 0.08,
          "fadeIn": 1.5,
          "fadeOut": 2.0
        },
        "position": {"x": 300, "y": 400}
      },
      {
        "id": "subs",
        "type": "Subtitle.Auto",
        "params": {
          "source": "audio",
          "style": "bold_shadow",
          "font": "Oswald",
          "fontSize": 52,
          "fontColor": "#FFFFFF",
          "position": "85%",
          "karaoke": true
        },
        "position": {"x": 500, "y": 400}
      },
      {
        "id": "timeline",
        "type": "Edit.Timeline",
        "params": {
          "templateId": "tmpl_crime_v1",
          "transitionStyle": "crossfade",
          "transitionDuration": 0.4,
          "autoTiming": true,
          "minSceneDuration": 1.5,
          "maxSceneDuration": 3.5
        },
        "position": {"x": 500, "y": 250}
      },
      {
        "id": "render",
        "type": "Output.Render",
        "params": {
          "profile": "9x16_1080p",
          "fps": 30,
          "preset": "balanced"
        },
        "position": {"x": 700, "y": 250}
      },
      {
        "id": "download",
        "type": "Output.Download",
        "params": {
          "generateThumbnail": true,
          "thumbnailTime": 2.0,
          "includeSrt": true
        },
        "position": {"x": 700, "y": 400}
      }
    ],
    "edges": [
      {"id": "e1", "from": "stock_intro", "to": "timeline"},
      {"id": "e2", "from": "stock_main", "to": "timeline"},
      {"id": "e3", "from": "script", "to": "voice"},
      {"id": "e4", "from": "voice", "to": "music"},
      {"id": "e5", "from": "music", "to": "subs"},
      {"id": "e6", "from": "music", "to": "timeline"},
      {"id": "e7", "from": "subs", "to": "timeline"},
      {"id": "e8", "from": "timeline", "to": "render"},
      {"id": "e9", "from": "render", "to": "download"}
    ]
  }
}
```

**Оценочная стоимость:** ~$2.50

---

## AI Video Generation Workflow

Workflow с AI генерацией видео:

```json
{
  "id": "wf_ai_video",
  "name": "AI Generated Video",
  "graph": {
    "nodes": [
      {
        "id": "gen_video_1",
        "type": "Input.KAI.GenerateVideo",
        "params": {
          "prompt": "Cinematic aerial view of a futuristic city at night, neon lights, flying cars, 8k quality",
          "model": "sora",
          "duration": 10,
          "aspect": "9:16"
        },
        "position": {"x": 100, "y": 100}
      },
      {
        "id": "gen_video_2",
        "type": "Input.KAI.GenerateVideo",
        "params": {
          "prompt": "Close-up of a person looking at holographic display, cyberpunk style, dramatic lighting",
          "model": "veo3",
          "duration": 8,
          "aspect": "9:16"
        },
        "position": {"x": 100, "y": 200}
      },
      {
        "id": "stock_filler",
        "type": "Input.Stock",
        "params": {
          "provider": "pexels",
          "query": "technology abstract",
          "count": 3,
          "orientation": "portrait"
        },
        "position": {"x": 100, "y": 300}
      },
      {
        "id": "script",
        "type": "Script.Generate",
        "params": {
          "genre": "explainer",
          "prompt": "The future of technology in 2050, mind-blowing predictions",
          "targetDuration": 45,
          "tone": "energetic"
        },
        "position": {"x": 300, "y": 100}
      },
      {
        "id": "voice",
        "type": "Voice.TTS",
        "params": {
          "engine": "kokoro",
          "voice": "af_alloy",
          "speed": 1.1
        },
        "position": {"x": 300, "y": 250}
      },
      {
        "id": "music",
        "type": "Audio.Mix",
        "params": {
          "musicTag": "excited",
          "musicVolume": 0.3,
          "ducking": true
        },
        "position": {"x": 300, "y": 400}
      },
      {
        "id": "subs",
        "type": "Subtitle.Auto",
        "params": {
          "source": "audio",
          "style": "neon_glow",
          "font": "Montserrat",
          "fontSize": 48,
          "karaoke": true
        },
        "position": {"x": 500, "y": 400}
      },
      {
        "id": "timeline",
        "type": "Edit.Timeline",
        "params": {
          "templateId": "tmpl_tech_v1",
          "transitionStyle": "zoom_in",
          "autoTiming": true
        },
        "position": {"x": 500, "y": 250}
      },
      {
        "id": "render",
        "type": "Output.Render",
        "params": {
          "profile": "9x16_1080p",
          "preset": "quality"
        },
        "position": {"x": 700, "y": 250}
      }
    ],
    "edges": [
      {"id": "e1", "from": "gen_video_1", "to": "timeline"},
      {"id": "e2", "from": "gen_video_2", "to": "timeline"},
      {"id": "e3", "from": "stock_filler", "to": "timeline"},
      {"id": "e4", "from": "script", "to": "voice"},
      {"id": "e5", "from": "voice", "to": "music"},
      {"id": "e6", "from": "music", "to": "subs"},
      {"id": "e7", "from": "music", "to": "timeline"},
      {"id": "e8", "from": "subs", "to": "timeline"},
      {"id": "e9", "from": "timeline", "to": "render"}
    ]
  }
}
```

**Оценочная стоимость:** ~$8.50 (180 KAI credits)

---

## News Bulletin Workflow

Workflow для новостного контента:

```json
{
  "id": "wf_news",
  "name": "Breaking News Generator",
  "variables": {
    "headline": "Scientists discover New type of star",
    "topic": "astronomy breakthrough"
  },
  "graph": {
    "nodes": [
      {
        "id": "stock",
        "type": "Input.Stock",
        "params": {
          "provider": "pexels",
          "query": "{{topic}} space stars",
          "count": 4,
          "orientation": "portrait"
        },
        "position": {"x": 100, "y": 100}
      },
      {
        "id": "script",
        "type": "Script.Generate",
        "params": {
          "genre": "news",
          "prompt": "Breaking news: {{headline}}. 30 seconds, 3 key points, hook at start",
          "targetDuration": 30,
          "tone": "energetic",
          "model": "gpt-4"
        },
        "position": {"x": 100, "y": 250}
      },
      {
        "id": "voice",
        "type": "Voice.TTS",
        "params": {
          "engine": "kokoro",
          "voice": "am_michael",
          "speed": 1.05,
          "voiceInstructions": "News anchor tone, professional and clear"
        },
        "position": {"x": 100, "y": 400}
      },
      {
        "id": "music",
        "type": "Audio.Mix",
        "params": {
          "musicTag": "crime_new_report",
          "musicVolume": 0.2,
          "ducking": true,
          "fadeIn": 0.5
        },
        "position": {"x": 300, "y": 400}
      },
      {
        "id": "subs",
        "type": "Subtitle.Auto",
        "params": {
          "source": "audio",
          "style": "clean_box",
          "font": "Roboto",
          "fontSize": 44,
          "position": "bottom"
        },
        "position": {"x": 300, "y": 550}
      },
      {
        "id": "overlay_headline",
        "type": "Edit.Overlay",
        "params": {
          "overlays": [
            {
              "type": "text",
              "content": "BREAKING",
              "position": {"x": "center", "y": "8%"},
              "timing": {"start": 0, "end": 4},
              "animation": "slideIn",
              "style": {
                "fontSize": 64,
                "fontFamily": "Bebas Neue",
                "color": "#FFFFFF",
                "backgroundColor": "#FF0000",
                "padding": 15
              }
            }
          ]
        },
        "position": {"x": 500, "y": 250}
      },
      {
        "id": "timeline",
        "type": "Edit.Timeline",
        "params": {
          "templateId": "tmpl_news_v1",
          "transitionStyle": "cut",
          "autoTiming": true,
          "minSceneDuration": 2.0,
          "maxSceneDuration": 5.0
        },
        "position": {"x": 500, "y": 400}
      },
      {
        "id": "render",
        "type": "Output.Render",
        "params": {
          "profile": "9x16_1080p"
        },
        "position": {"x": 700, "y": 400}
      }
    ],
    "edges": [
      {"id": "e1", "from": "stock", "to": "timeline"},
      {"id": "e2", "from": "script", "to": "voice"},
      {"id": "e3", "from": "voice", "to": "music"},
      {"id": "e4", "from": "music", "to": "subs"},
      {"id": "e5", "from": "music", "to": "timeline"},
      {"id": "e6", "from": "subs", "to": "timeline"},
      {"id": "e7", "from": "overlay_headline", "to": "timeline"},
      {"id": "e8", "from": "timeline", "to": "render"}
    ]
  }
}
```

**Оценочная стоимость:** ~$0.80

---

## Scheduled Workflow

Workflow с автоматическим расписанием:

```json
{
  "id": "wf_daily_facts",
  "name": "Daily Facts Video",
  "graph": {
    "nodes": [
      {
        "id": "schedule",
        "type": "Schedule.Cron",
        "params": {
          "cron": "0 10 * * *",
          "timezone": "America/New_York",
          "enabled": true
        },
        "position": {"x": 0, "y": 200}
      },
      {
        "id": "stock",
        "type": "Input.Stock",
        "params": {
          "provider": "pexels",
          "query": "nature amazing wildlife",
          "count": 5,
          "orientation": "portrait"
        },
        "position": {"x": 200, "y": 100}
      },
      {
        "id": "script",
        "type": "Script.Generate",
        "params": {
          "genre": "facts",
          "prompt": "5 amazing facts about nature that will blow your mind",
          "targetDuration": 45
        },
        "position": {"x": 200, "y": 250}
      },
      {
        "id": "voice",
        "type": "Voice.TTS",
        "params": {
          "engine": "kokoro",
          "voice": "af_bella",
          "speed": 1.0
        },
        "position": {"x": 200, "y": 400}
      },
      {
        "id": "subs",
        "type": "Subtitle.Auto",
        "params": {
          "source": "audio",
          "style": "karaoke_bounce"
        },
        "position": {"x": 400, "y": 400}
      },
      {
        "id": "timeline",
        "type": "Edit.Timeline",
        "params": {
          "templateId": "tmpl_facts_v1",
          "autoTiming": true
        },
        "position": {"x": 400, "y": 250}
      },
      {
        "id": "render",
        "type": "Output.Render",
        "params": {
          "profile": "9x16_1080p"
        },
        "position": {"x": 600, "y": 250}
      },
      {
        "id": "webhook",
        "type": "Output.Webhook",
        "params": {
          "url": "https://api.mysite.com/video-ready",
          "events": ["completed", "failed"]
        },
        "position": {"x": 600, "y": 400}
      }
    ],
    "edges": [
      {"id": "e1", "from": "stock", "to": "timeline"},
      {"id": "e2", "from": "script", "to": "voice"},
      {"id": "e3", "from": "voice", "to": "subs"},
      {"id": "e4", "from": "voice", "to": "timeline"},
      {"id": "e5", "from": "subs", "to": "timeline"},
      {"id": "e6", "from": "timeline", "to": "render"},
      {"id": "e7", "from": "render", "to": "webhook"}
    ]
  }
}
```

**Оценочная стоимость за запуск:** ~$1.20
