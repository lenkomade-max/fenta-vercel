# JSON Schemas

This document provides complete JSON schemas for all major entities in the Fenta Web system.

## Table of Contents

1. [Template Schema](#template-schema)
2. [Workflow Schema](#workflow-schema)
3. [Job Schema](#job-schema)
4. [Asset Schema](#asset-schema)
5. [Render Schema](#render-schema)
6. [Usage Record Schema](#usage-record-schema)

---

## Template Schema

Complete template specification with all tracks, overlays, and rules.

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "Template",
  "type": "object",
  "required": ["id", "name", "aspect", "resolution", "spec"],
  "properties": {
    "id": {
      "type": "string",
      "pattern": "^tmpl_[a-zA-Z0-9]+$",
      "example": "tmpl_shorts_v1"
    },
    "name": {
      "type": "string",
      "minLength": 1,
      "maxLength": 255,
      "example": "Shorts Clean Bold"
    },
    "description": {
      "type": "string",
      "maxLength": 1000
    },
    "aspect": {
      "type": "string",
      "enum": ["9:16", "16:9", "1:1", "4:5"],
      "example": "9:16"
    },
    "resolution": {
      "type": "string",
      "pattern": "^\\d+x\\d+$",
      "example": "1080x1920"
    },
    "is_public": {
      "type": "boolean",
      "default": false
    },
    "thumbnail_url": {
      "type": "string",
      "format": "uri"
    },
    "spec": {
      "type": "object",
      "required": ["tracks"],
      "properties": {
        "tracks": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/Track"
          }
        },
        "overlays": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/Overlay"
          }
        },
        "placeholders": {
          "type": "object",
          "additionalProperties": {
            "type": "string",
            "enum": ["image", "image_optional", "video", "video_optional", "audio", "audio_optional"]
          }
        },
        "rules": {
          "$ref": "#/definitions/Rules"
        },
        "subtitle_style_presets": {
          "type": "array",
          "items": {
            "type": "string"
          }
        }
      }
    },
    "usage_count": {
      "type": "integer",
      "minimum": 0
    },
    "created_at": {
      "type": "string",
      "format": "date-time"
    },
    "updated_at": {
      "type": "string",
      "format": "date-time"
    }
  },
  "definitions": {
    "Track": {
      "type": "object",
      "required": ["type", "id", "z"],
      "properties": {
        "type": {
          "type": "string",
          "enum": ["video", "subtitle", "overlay", "audio"]
        },
        "id": {
          "type": "string"
        },
        "z": {
          "type": "integer",
          "description": "Z-index for layering"
        },
        "style": {
          "type": "object",
          "properties": {
            "font": {
              "type": "string"
            },
            "size": {
              "type": "integer"
            },
            "shadow": {
              "type": "boolean"
            },
            "bg": {
              "type": "string",
              "enum": ["none", "box", "gradient"]
            },
            "position": {
              "type": "string",
              "enum": ["top", "center", "bottom"]
            },
            "margin": {
              "type": "integer"
            }
          }
        }
      }
    },
    "Overlay": {
      "type": "object",
      "required": ["track", "from", "to", "content"],
      "properties": {
        "track": {
          "type": "string",
          "description": "Track ID to place overlay on"
        },
        "from": {
          "type": "number",
          "description": "Start time in seconds"
        },
        "to": {
          "type": "number",
          "description": "End time in seconds (999 = end of video)"
        },
        "content": {
          "type": "object",
          "required": ["type"],
          "properties": {
            "type": {
              "type": "string",
              "enum": ["text", "image", "shape"]
            },
            "text": {
              "type": "string"
            },
            "pos": {
              "type": "string",
              "enum": ["top", "center", "bottom", "top-left", "top-right", "bottom-left", "bottom-right"]
            },
            "anim": {
              "type": "string",
              "enum": ["none", "slide-down", "slide-up", "fade-in", "zoom-in"]
            }
          }
        }
      }
    },
    "Rules": {
      "type": "object",
      "properties": {
        "cuts": {
          "type": "string",
          "enum": ["auto_by_beats_or_speech", "manual", "fixed_interval"]
        },
        "min_scene": {
          "type": "number",
          "minimum": 0.5
        },
        "max_scene": {
          "type": "number",
          "minimum": 1
        }
      }
    }
  }
}
```

**Example Instance:**

```json
{
  "id": "tmpl_shorts_v1",
  "name": "Shorts Clean Bold",
  "description": "Clean, bold template for short-form content",
  "aspect": "9:16",
  "resolution": "1080x1920",
  "is_public": true,
  "thumbnail_url": "https://cdn.fentaweb.com/templates/tmpl_shorts_v1_thumb.jpg",
  "spec": {
    "tracks": [
      {
        "type": "video",
        "id": "main",
        "z": 0
      },
      {
        "type": "subtitle",
        "id": "subs",
        "z": 10,
        "style": {
          "font": "Inter",
          "size": 44,
          "shadow": true,
          "bg": "box",
          "position": "bottom",
          "margin": 120
        }
      },
      {
        "type": "overlay",
        "id": "top_text",
        "z": 20
      }
    ],
    "overlays": [
      {
        "track": "top_text",
        "from": 0,
        "to": 3,
        "content": {
          "type": "text",
          "text": "BREAKING STORY",
          "pos": "top",
          "anim": "slide-down"
        }
      }
    ],
    "placeholders": {
      "cover": "image",
      "logo": "image_optional",
      "music": "audio_optional"
    },
    "rules": {
      "cuts": "auto_by_beats_or_speech",
      "min_scene": 1.2,
      "max_scene": 4.0
    },
    "subtitle_style_presets": ["karaoke_bounce", "clean_box"]
  },
  "usage_count": 142,
  "created_at": "2024-01-10T08:00:00Z",
  "updated_at": "2024-01-15T10:30:00Z"
}
```

---

## Workflow Schema

Complete workflow graph with nodes and edges.

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "Workflow",
  "type": "object",
  "required": ["id", "name", "graph"],
  "properties": {
    "id": {
      "type": "string",
      "pattern": "^wf_[a-zA-Z0-9]+$",
      "example": "wf_daily_news_01"
    },
    "name": {
      "type": "string",
      "minLength": 1,
      "maxLength": 255,
      "example": "Daily News Shorts"
    },
    "description": {
      "type": "string",
      "maxLength": 1000
    },
    "status": {
      "type": "string",
      "enum": ["draft", "confirmed", "preview", "production", "archived"],
      "default": "draft"
    },
    "graph": {
      "type": "object",
      "required": ["nodes", "edges"],
      "properties": {
        "nodes": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/Node"
          }
        },
        "edges": {
          "type": "array",
          "items": {
            "$ref": "#/definitions/Edge"
          }
        }
      }
    },
    "variables": {
      "type": "object",
      "additionalProperties": true
    },
    "run_count": {
      "type": "integer",
      "minimum": 0,
      "default": 0
    },
    "last_run_at": {
      "type": "string",
      "format": "date-time"
    },
    "created_at": {
      "type": "string",
      "format": "date-time"
    },
    "updated_at": {
      "type": "string",
      "format": "date-time"
    }
  },
  "definitions": {
    "Node": {
      "type": "object",
      "required": ["id", "type", "params"],
      "properties": {
        "id": {
          "type": "string",
          "pattern": "^[a-zA-Z0-9_-]+$"
        },
        "type": {
          "type": "string",
          "enum": [
            "Input.Upload",
            "Input.Stock",
            "Input.KAI.GenerateImage",
            "Input.KAI.GenerateVideo",
            "Input.KAI.EditVideo",
            "Script.Generate",
            "Script.Transform",
            "Voice.TTS",
            "Audio.Mix",
            "Subtitle.Auto",
            "Edit.Timeline",
            "Output.Render",
            "Output.Download",
            "Schedule.Cron"
          ]
        },
        "params": {
          "type": "object",
          "additionalProperties": true
        },
        "position": {
          "type": "object",
          "properties": {
            "x": {
              "type": "number"
            },
            "y": {
              "type": "number"
            }
          }
        },
        "label": {
          "type": "string"
        },
        "disabled": {
          "type": "boolean",
          "default": false
        }
      }
    },
    "Edge": {
      "type": "object",
      "required": ["from", "to"],
      "properties": {
        "id": {
          "type": "string"
        },
        "from": {
          "type": "string",
          "description": "Source node ID"
        },
        "to": {
          "type": "string",
          "description": "Target node ID"
        },
        "fromPort": {
          "type": "string"
        },
        "toPort": {
          "type": "string"
        }
      }
    }
  }
}
```

**Example Instance:**

```json
{
  "id": "wf_daily_news_01",
  "name": "Daily News Shorts",
  "description": "Automated daily news video generation",
  "status": "production",
  "graph": {
    "nodes": [
      {
        "id": "n1",
        "type": "Input.Stock",
        "params": {
          "provider": "pexels",
          "query": "breaking news city",
          "type": "video",
          "count": 3
        },
        "position": {"x": 100, "y": 100}
      },
      {
        "id": "n2",
        "type": "Script.Generate",
        "params": {
          "genre": "news",
          "lang": "en",
          "prompt": "30s punchy headline + 3 beats",
          "targetDuration": 30,
          "tone": "energetic"
        },
        "position": {"x": 100, "y": 250}
      },
      {
        "id": "n3",
        "type": "Voice.TTS",
        "params": {
          "engine": "kokoro",
          "voice": "alloy_en",
          "speed": 1.02
        },
        "position": {"x": 100, "y": 400}
      },
      {
        "id": "n4",
        "type": "Subtitle.Auto",
        "params": {
          "source": "audio",
          "style": "clean_box",
          "karaoke": true
        },
        "position": {"x": 300, "y": 400}
      },
      {
        "id": "n5",
        "type": "Edit.Timeline",
        "params": {
          "templateId": "tmpl_shorts_v1",
          "autoTiming": true
        },
        "position": {"x": 500, "y": 300}
      },
      {
        "id": "n6",
        "type": "Output.Render",
        "params": {
          "profile": "9x16_1080p",
          "preset": "balanced"
        },
        "position": {"x": 700, "y": 300}
      },
      {
        "id": "n7",
        "type": "Output.Download",
        "params": {
          "generateThumbnail": true,
          "includeSrt": true
        },
        "position": {"x": 900, "y": 300}
      }
    ],
    "edges": [
      {"id": "e1", "from": "n1", "to": "n5"},
      {"id": "e2", "from": "n2", "to": "n3"},
      {"id": "e3", "from": "n3", "to": "n4"},
      {"id": "e4", "from": "n4", "to": "n5"},
      {"id": "e5", "from": "n5", "to": "n6"},
      {"id": "e6", "from": "n6", "to": "n7"}
    ]
  },
  "variables": {
    "default_query": "breaking news",
    "default_voice": "alloy_en"
  },
  "run_count": 28,
  "last_run_at": "2024-01-15T10:00:00Z",
  "created_at": "2024-01-01T09:00:00Z",
  "updated_at": "2024-01-15T09:00:00Z"
}
```

---

## Job Schema

Job configuration and execution result.

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "Job",
  "type": "object",
  "required": ["id", "status", "config"],
  "properties": {
    "id": {
      "type": "string",
      "pattern": "^job_[a-zA-Z0-9]+$",
      "example": "job_abc123xyz"
    },
    "status": {
      "type": "string",
      "enum": ["queued", "processing", "completed", "failed", "cancelled"]
    },
    "progress": {
      "type": "integer",
      "minimum": 0,
      "maximum": 100
    },
    "workflow_id": {
      "type": "string",
      "pattern": "^wf_[a-zA-Z0-9]+$"
    },
    "template_id": {
      "type": "string",
      "pattern": "^tmpl_[a-zA-Z0-9]+$"
    },
    "config": {
      "$ref": "#/definitions/JobConfig"
    },
    "result": {
      "$ref": "#/definitions/JobResult"
    },
    "cost": {
      "$ref": "#/definitions/Cost"
    },
    "timing": {
      "$ref": "#/definitions/Timing"
    },
    "error": {
      "type": "object",
      "properties": {
        "code": {
          "type": "string"
        },
        "message": {
          "type": "string"
        },
        "details": {
          "type": "object"
        }
      }
    },
    "retry_count": {
      "type": "integer",
      "minimum": 0,
      "default": 0
    },
    "created_at": {
      "type": "string",
      "format": "date-time"
    },
    "updated_at": {
      "type": "string",
      "format": "date-time"
    }
  },
  "definitions": {
    "JobConfig": {
      "type": "object",
      "properties": {
        "sources": {
          "type": "array",
          "items": {
            "type": "object",
            "required": ["type"],
            "properties": {
              "type": {
                "type": "string",
                "enum": ["upload", "stock", "kai"]
              },
              "uri": {
                "type": "string"
              },
              "provider": {
                "type": "string"
              },
              "query": {
                "type": "string"
              }
            }
          }
        },
        "script": {
          "type": "object",
          "properties": {
            "lang": {
              "type": "string"
            },
            "text": {
              "type": "string"
            }
          }
        },
        "tts": {
          "type": "object",
          "properties": {
            "engine": {
              "type": "string"
            },
            "voice": {
              "type": "string"
            },
            "speed": {
              "type": "number"
            }
          }
        },
        "subtitles": {
          "type": "object",
          "properties": {
            "style": {
              "type": "string"
            }
          }
        },
        "output": {
          "type": "object",
          "required": ["profile"],
          "properties": {
            "profile": {
              "type": "string",
              "enum": ["9x16_1080p", "16x9_1080p", "1x1_1080p", "9x16_720p"]
            }
          }
        }
      }
    },
    "JobResult": {
      "type": "object",
      "properties": {
        "video_url": {
          "type": "string",
          "format": "uri"
        },
        "thumbnail_url": {
          "type": "string",
          "format": "uri"
        },
        "srt_url": {
          "type": "string",
          "format": "uri"
        },
        "duration": {
          "type": "number"
        }
      }
    },
    "Cost": {
      "type": "object",
      "properties": {
        "tokens": {
          "type": "integer"
        },
        "render_seconds": {
          "type": "number"
        },
        "kai_credits": {
          "type": "integer"
        },
        "total_usd": {
          "type": "number"
        }
      }
    },
    "Timing": {
      "type": "object",
      "properties": {
        "queued_at": {
          "type": "string",
          "format": "date-time"
        },
        "started_at": {
          "type": "string",
          "format": "date-time"
        },
        "completed_at": {
          "type": "string",
          "format": "date-time"
        }
      }
    }
  }
}
```

**Example Instance:**

```json
{
  "id": "job_abc123xyz",
  "status": "completed",
  "progress": 100,
  "workflow_id": "wf_daily_news_01",
  "template_id": "tmpl_shorts_v1",
  "config": {
    "sources": [
      {
        "type": "stock",
        "provider": "pexels",
        "query": "storm city night",
        "count": 3
      }
    ],
    "script": {
      "lang": "en",
      "text": "Breaking: Massive storm hits downtown..."
    },
    "tts": {
      "engine": "kokoro",
      "voice": "alloy_en",
      "speed": 1.02
    },
    "subtitles": {
      "style": "clean_box"
    },
    "output": {
      "profile": "9x16_1080p"
    }
  },
  "result": {
    "video_url": "https://cdn.fentaweb.com/renders/job_abc123xyz.mp4",
    "thumbnail_url": "https://cdn.fentaweb.com/renders/job_abc123xyz_thumb.jpg",
    "srt_url": "https://cdn.fentaweb.com/renders/job_abc123xyz.srt",
    "duration": 30.5
  },
  "cost": {
    "tokens": 1500,
    "render_seconds": 45,
    "kai_credits": 0,
    "total_usd": 0.72
  },
  "timing": {
    "queued_at": "2024-01-15T14:20:00Z",
    "started_at": "2024-01-15T14:21:00Z",
    "completed_at": "2024-01-15T14:26:00Z"
  },
  "retry_count": 0,
  "created_at": "2024-01-15T14:20:00Z",
  "updated_at": "2024-01-15T14:26:00Z"
}
```

---

## Asset Schema

Asset metadata and storage information.

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "Asset",
  "type": "object",
  "required": ["id", "type", "source", "url"],
  "properties": {
    "id": {
      "type": "string",
      "pattern": "^asset_[a-zA-Z0-9]+$",
      "example": "asset_abc123"
    },
    "type": {
      "type": "string",
      "enum": ["image", "video", "audio"]
    },
    "source": {
      "type": "string",
      "enum": ["upload", "stock", "kai", "generated"]
    },
    "url": {
      "type": "string",
      "format": "uri"
    },
    "thumbnail_url": {
      "type": "string",
      "format": "uri"
    },
    "metadata": {
      "type": "object",
      "properties": {
        "filename": {
          "type": "string"
        },
        "size": {
          "type": "integer",
          "description": "Size in bytes"
        },
        "duration": {
          "type": "number",
          "description": "Duration in seconds (video/audio)"
        },
        "width": {
          "type": "integer"
        },
        "height": {
          "type": "integer"
        },
        "fps": {
          "type": "number"
        },
        "codec": {
          "type": "string"
        },
        "format": {
          "type": "string"
        },
        "source_url": {
          "type": "string",
          "format": "uri"
        },
        "provider_id": {
          "type": "string"
        },
        "generation_params": {
          "type": "object"
        },
        "tags": {
          "type": "array",
          "items": {
            "type": "string"
          }
        },
        "extracted_colors": {
          "type": "array",
          "items": {
            "type": "string",
            "pattern": "^#[0-9A-Fa-f]{6}$"
          }
        }
      }
    },
    "status": {
      "type": "string",
      "enum": ["processing", "ready", "failed"],
      "default": "processing"
    },
    "created_at": {
      "type": "string",
      "format": "date-time"
    },
    "updated_at": {
      "type": "string",
      "format": "date-time"
    }
  }
}
```

**Example Instance:**

```json
{
  "id": "asset_abc123",
  "type": "video",
  "source": "upload",
  "url": "https://cdn.fentaweb.com/assets/asset_abc123.mp4",
  "thumbnail_url": "https://cdn.fentaweb.com/assets/asset_abc123_thumb.jpg",
  "metadata": {
    "filename": "my-video.mp4",
    "size": 52428800,
    "duration": 45.5,
    "width": 1080,
    "height": 1920,
    "fps": 30,
    "codec": "h264",
    "format": "mp4",
    "tags": ["nature", "sunset"],
    "extracted_colors": ["#FF6B6B", "#4ECDC4", "#45B7D1"]
  },
  "status": "ready",
  "created_at": "2024-01-15T11:00:00Z",
  "updated_at": "2024-01-15T11:05:00Z"
}
```

---

## Render Schema

Final render output specification.

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "Render",
  "type": "object",
  "required": ["id", "job_id", "video_url"],
  "properties": {
    "id": {
      "type": "string",
      "pattern": "^render_[a-zA-Z0-9]+$"
    },
    "job_id": {
      "type": "string",
      "pattern": "^job_[a-zA-Z0-9]+$"
    },
    "video_url": {
      "type": "string",
      "format": "uri"
    },
    "thumbnail_url": {
      "type": "string",
      "format": "uri"
    },
    "srt_url": {
      "type": "string",
      "format": "uri"
    },
    "duration_seconds": {
      "type": "number"
    },
    "resolution": {
      "type": "string",
      "pattern": "^\\d+x\\d+$"
    },
    "file_size_bytes": {
      "type": "integer"
    },
    "codec": {
      "type": "string"
    },
    "bitrate_kbps": {
      "type": "integer"
    },
    "metadata": {
      "type": "object",
      "additionalProperties": true
    },
    "created_at": {
      "type": "string",
      "format": "date-time"
    }
  }
}
```

---

## Usage Record Schema

Billing and usage tracking record.

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "UsageRecord",
  "type": "object",
  "required": ["id", "org_id", "resource_type", "cost_usd"],
  "properties": {
    "id": {
      "type": "string",
      "pattern": "^usage_[a-zA-Z0-9]+$"
    },
    "org_id": {
      "type": "string",
      "pattern": "^org_[a-zA-Z0-9]+$"
    },
    "user_id": {
      "type": "string",
      "pattern": "^user_[a-zA-Z0-9]+$"
    },
    "job_id": {
      "type": "string",
      "pattern": "^job_[a-zA-Z0-9]+$"
    },
    "resource_type": {
      "type": "string",
      "enum": ["llm_tokens", "kai_credits", "render_seconds", "storage"]
    },
    "llm_tokens_prompt": {
      "type": "integer",
      "minimum": 0
    },
    "llm_tokens_output": {
      "type": "integer",
      "minimum": 0
    },
    "llm_model": {
      "type": "string"
    },
    "kai_credits": {
      "type": "integer",
      "minimum": 0
    },
    "kai_model": {
      "type": "string"
    },
    "render_seconds": {
      "type": "number",
      "minimum": 0
    },
    "render_profile": {
      "type": "string"
    },
    "storage_bytes": {
      "type": "integer",
      "minimum": 0
    },
    "cost_usd": {
      "type": "number",
      "minimum": 0
    },
    "created_at": {
      "type": "string",
      "format": "date-time"
    }
  }
}
```

**Example Instance:**

```json
{
  "id": "usage_xyz789",
  "org_id": "org_abc123",
  "user_id": "user_def456",
  "job_id": "job_ghi789",
  "resource_type": "llm_tokens",
  "llm_tokens_prompt": 500,
  "llm_tokens_output": 1200,
  "llm_model": "gpt-4",
  "kai_credits": 0,
  "render_seconds": 0,
  "storage_bytes": 0,
  "cost_usd": 0.102,
  "created_at": "2024-01-15T14:25:00Z"
}
```

---

## Webhook Payload Schema

Webhook event payload structure.

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "WebhookPayload",
  "type": "object",
  "required": ["event", "timestamp", "data"],
  "properties": {
    "event": {
      "type": "string",
      "enum": [
        "render.succeeded",
        "render.failed",
        "workflow.run.started",
        "workflow.run.finished",
        "job.completed",
        "job.failed"
      ]
    },
    "timestamp": {
      "type": "string",
      "format": "date-time"
    },
    "data": {
      "type": "object",
      "additionalProperties": true
    }
  }
}
```

**Example - Render Succeeded:**

```json
{
  "event": "render.succeeded",
  "timestamp": "2024-01-15T14:30:00Z",
  "data": {
    "jobId": "job_abc123",
    "workflowId": "wf_xyz789",
    "result": {
      "videoUrl": "https://cdn.fentaweb.com/renders/video_abc123.mp4",
      "thumbnailUrl": "https://cdn.fentaweb.com/renders/video_abc123_thumb.jpg",
      "srtUrl": "https://cdn.fentaweb.com/renders/video_abc123.srt",
      "duration": 60.5
    },
    "cost": {
      "tokens": 5000,
      "renderSeconds": 90,
      "kaiCredits": 100,
      "totalUsd": 0.87
    },
    "timing": {
      "queuedAt": "2024-01-15T14:20:00Z",
      "startedAt": "2024-01-15T14:21:00Z",
      "completedAt": "2024-01-15T14:30:00Z"
    }
  }
}
```
