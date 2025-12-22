# JSON Schemas — Схемы данных

Формальные JSON Schema для валидации всех сущностей системы.

---

## Template Schema

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "Template",
  "type": "object",
  "required": ["name", "aspect", "resolution", "spec"],
  "properties": {
    "id": {
      "type": "string",
      "pattern": "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$",
      "description": "UUID идентификатор"
    },
    "org_id": {
      "type": "string",
      "description": "UUID организации"
    },
    "name": {
      "type": "string",
      "minLength": 1,
      "maxLength": 255
    },
    "description": {
      "type": "string",
      "maxLength": 1000
    },
    "aspect": {
      "type": "string",
      "enum": ["9:16", "16:9", "1:1", "4:5"]
    },
    "resolution": {
      "type": "string",
      "pattern": "^\\d+x\\d+$",
      "examples": ["1080x1920", "1920x1080", "1080x1080"]
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
      "$ref": "#/definitions/TemplateSpec"
    },
    "usage_count": {
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
    "TemplateSpec": {
      "type": "object",
      "required": ["tracks"],
      "properties": {
        "tracks": {
          "type": "array",
          "items": {"$ref": "#/definitions/Track"}
        },
        "overlays": {
          "type": "array",
          "items": {"$ref": "#/definitions/Overlay"}
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
          "items": {"type": "string"}
        }
      }
    },
    "Track": {
      "type": "object",
      "required": ["type", "id", "z"],
      "properties": {
        "type": {
          "type": "string",
          "enum": ["video", "audio", "subtitle", "overlay"]
        },
        "id": {
          "type": "string"
        },
        "z": {
          "type": "integer"
        },
        "style": {
          "type": "object"
        },
        "config": {
          "type": "object"
        }
      }
    },
    "Overlay": {
      "type": "object",
      "required": ["track", "from", "to", "content"],
      "properties": {
        "track": {"type": "string"},
        "from": {"type": "number"},
        "to": {"type": "number"},
        "content": {
          "type": "object",
          "required": ["type"],
          "properties": {
            "type": {
              "type": "string",
              "enum": ["text", "image", "video"]
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
          "enum": ["auto_by_beats_or_speech", "by_script_beats", "by_audio_silence", "fixed_duration", "manual"]
        },
        "min_scene": {"type": "number", "minimum": 0.5},
        "max_scene": {"type": "number", "maximum": 30},
        "transitions": {
          "type": "object",
          "properties": {
            "default": {"type": "string"},
            "duration": {"type": "number"}
          }
        }
      }
    }
  }
}
```

---

## Workflow Schema

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "Workflow",
  "type": "object",
  "required": ["name", "graph"],
  "properties": {
    "id": {
      "type": "string"
    },
    "org_id": {
      "type": "string"
    },
    "project_id": {
      "type": ["string", "null"]
    },
    "name": {
      "type": "string",
      "minLength": 1,
      "maxLength": 255
    },
    "description": {
      "type": "string"
    },
    "status": {
      "type": "string",
      "enum": ["draft", "confirmed", "preview", "production", "archived"],
      "default": "draft"
    },
    "graph": {
      "$ref": "#/definitions/WorkflowGraph"
    },
    "variables": {
      "type": "object",
      "additionalProperties": true
    },
    "run_count": {
      "type": "integer",
      "default": 0
    },
    "last_run_at": {
      "type": ["string", "null"],
      "format": "date-time"
    },
    "created_at": {
      "type": "string",
      "format": "date-time"
    }
  },
  "definitions": {
    "WorkflowGraph": {
      "type": "object",
      "required": ["nodes", "edges"],
      "properties": {
        "nodes": {
          "type": "array",
          "items": {"$ref": "#/definitions/Node"}
        },
        "edges": {
          "type": "array",
          "items": {"$ref": "#/definitions/Edge"}
        }
      }
    },
    "Node": {
      "type": "object",
      "required": ["id", "type", "params", "position"],
      "properties": {
        "id": {
          "type": "string",
          "pattern": "^[a-zA-Z0-9_]+$"
        },
        "type": {
          "type": "string",
          "enum": [
            "Input.Upload", "Input.Stock", "Input.URL",
            "Input.KAI.GenerateImage", "Input.KAI.GenerateVideo", "Input.KAI.EditVideo",
            "Input.KAI.GenerateMusic", "Input.KAI.GenerateVoice",
            "Script.Generate", "Script.Transform", "Script.Split", "Script.Enhance",
            "Voice.TTS", "Audio.Mix", "Audio.SoundEffects", "Audio.Normalize",
            "Subtitle.Auto", "Subtitle.Style", "Subtitle.Edit", "Subtitle.Translate",
            "Edit.Timeline", "Edit.Overlay", "Edit.Trim", "Edit.Speed", "Edit.Crop", "Edit.Filter", "Edit.Concat",
            "Output.Render", "Output.Download", "Output.Webhook",
            "Schedule.Cron"
          ]
        },
        "params": {
          "type": "object"
        },
        "position": {
          "type": "object",
          "required": ["x", "y"],
          "properties": {
            "x": {"type": "number"},
            "y": {"type": "number"}
          }
        },
        "label": {
          "type": "string"
        },
        "disabled": {
          "type": ["boolean", "string"],
          "default": false
        }
      }
    },
    "Edge": {
      "type": "object",
      "required": ["id", "from", "to"],
      "properties": {
        "id": {"type": "string"},
        "from": {"type": "string"},
        "to": {"type": "string"},
        "fromPort": {"type": "string"},
        "toPort": {"type": "string"}
      }
    }
  }
}
```

---

## Job Schema

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "Job",
  "type": "object",
  "required": ["org_id", "config"],
  "properties": {
    "id": {
      "type": "string"
    },
    "org_id": {
      "type": "string"
    },
    "project_id": {
      "type": ["string", "null"]
    },
    "workflow_id": {
      "type": ["string", "null"]
    },
    "template_id": {
      "type": ["string", "null"]
    },
    "status": {
      "type": "string",
      "enum": ["queued", "processing", "completed", "failed", "cancelled"],
      "default": "queued"
    },
    "progress": {
      "type": "integer",
      "minimum": 0,
      "maximum": 100,
      "default": 0
    },
    "config": {
      "$ref": "#/definitions/JobConfig"
    },
    "result": {
      "$ref": "#/definitions/JobResult"
    },
    "error": {
      "$ref": "#/definitions/JobError"
    },
    "cost_tokens": {
      "type": "integer",
      "default": 0
    },
    "cost_render_seconds": {
      "type": "number",
      "default": 0
    },
    "cost_kai_credits": {
      "type": "integer",
      "default": 0
    },
    "cost_total_usd": {
      "type": "number",
      "default": 0
    },
    "queued_at": {
      "type": "string",
      "format": "date-time"
    },
    "started_at": {
      "type": ["string", "null"],
      "format": "date-time"
    },
    "completed_at": {
      "type": ["string", "null"],
      "format": "date-time"
    },
    "retry_count": {
      "type": "integer",
      "default": 0
    }
  },
  "definitions": {
    "JobConfig": {
      "type": "object",
      "properties": {
        "sources": {
          "type": "array",
          "items": {"$ref": "#/definitions/Source"}
        },
        "script": {
          "type": "object",
          "properties": {
            "lang": {"type": "string"},
            "text": {"type": "string"}
          }
        },
        "tts": {
          "type": "object",
          "properties": {
            "engine": {"type": "string", "enum": ["kokoro", "openai", "elevenlabs"]},
            "voice": {"type": "string"},
            "speed": {"type": "number", "minimum": 0.5, "maximum": 2.0}
          }
        },
        "subtitles": {
          "type": "object",
          "properties": {
            "style": {"type": "string"}
          }
        },
        "output": {
          "type": "object",
          "properties": {
            "profile": {"type": "string", "enum": ["9x16_1080p", "16x9_1080p", "1x1_1080p", "9x16_720p"]}
          }
        },
        "budget": {
          "type": "object",
          "properties": {
            "max_cost_usd": {"type": "number"},
            "max_tokens": {"type": "integer"},
            "max_kai_credits": {"type": "integer"},
            "max_render_seconds": {"type": "number"}
          }
        }
      }
    },
    "Source": {
      "type": "object",
      "required": ["type"],
      "properties": {
        "type": {
          "type": "string",
          "enum": ["upload", "stock", "url", "kai"]
        },
        "uri": {"type": "string"},
        "provider": {"type": "string"},
        "query": {"type": "string"}
      }
    },
    "JobResult": {
      "type": "object",
      "properties": {
        "video_url": {"type": "string", "format": "uri"},
        "thumbnail_url": {"type": "string", "format": "uri"},
        "srt_url": {"type": "string", "format": "uri"},
        "duration": {"type": "number"},
        "resolution": {"type": "string"},
        "file_size": {"type": "integer"}
      }
    },
    "JobError": {
      "type": "object",
      "properties": {
        "code": {"type": "string"},
        "message": {"type": "string"},
        "stage": {"type": "string"},
        "retryable": {"type": "boolean"},
        "details": {"type": "object"}
      }
    }
  }
}
```

---

## Asset Schema

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "Asset",
  "type": "object",
  "required": ["org_id", "type", "source", "storage_path"],
  "properties": {
    "id": {
      "type": "string"
    },
    "org_id": {
      "type": "string"
    },
    "project_id": {
      "type": ["string", "null"]
    },
    "type": {
      "type": "string",
      "enum": ["image", "video", "audio"]
    },
    "source": {
      "type": "string",
      "enum": ["upload", "stock", "kai", "generated"]
    },
    "storage_provider": {
      "type": "string",
      "enum": ["supabase", "s3", "r2"],
      "default": "supabase"
    },
    "storage_path": {
      "type": "string"
    },
    "url": {
      "type": "string",
      "format": "uri"
    },
    "thumbnail_url": {
      "type": "string",
      "format": "uri"
    },
    "filename": {
      "type": "string"
    },
    "content_type": {
      "type": "string"
    },
    "size_bytes": {
      "type": "integer"
    },
    "duration_seconds": {
      "type": ["number", "null"]
    },
    "width": {
      "type": ["integer", "null"]
    },
    "height": {
      "type": ["integer", "null"]
    },
    "fps": {
      "type": ["number", "null"]
    },
    "metadata": {
      "type": "object",
      "additionalProperties": true
    },
    "status": {
      "type": "string",
      "enum": ["processing", "ready", "failed"],
      "default": "processing"
    },
    "created_at": {
      "type": "string",
      "format": "date-time"
    }
  }
}
```

---

## Scene Schema (FantaProjekt)

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "Scene",
  "type": "object",
  "properties": {
    "text": {
      "type": "string",
      "description": "Текст для озвучки"
    },
    "media": {
      "$ref": "#/definitions/MediaSource"
    },
    "mediaDuration": {
      "type": "number",
      "description": "Длительность каждого медиа-элемента в секундах"
    },
    "effects": {
      "type": "array",
      "items": {"$ref": "#/definitions/Effect"}
    },
    "textOverlays": {
      "type": "array",
      "items": {"$ref": "#/definitions/TextOverlay"}
    },
    "advancedTextOverlays": {
      "type": "array",
      "items": {"$ref": "#/definitions/AdvancedTextOverlay"}
    },
    "voiceInstructions": {
      "type": "string"
    },
    "sceneDuration": {
      "type": "number",
      "description": "Фиксированная длительность сцены (для skipVoiceover)"
    }
  },
  "definitions": {
    "MediaSource": {
      "oneOf": [
        {
          "type": "object",
          "required": ["type", "searchTerms"],
          "properties": {
            "type": {"const": "pexels"},
            "searchTerms": {"type": "array", "items": {"type": "string"}}
          }
        },
        {
          "type": "object",
          "required": ["type", "urls"],
          "properties": {
            "type": {"const": "url"},
            "urls": {"type": "array", "items": {"type": "string", "format": "uri"}}
          }
        },
        {
          "type": "object",
          "required": ["type", "files"],
          "properties": {
            "type": {"const": "files"},
            "files": {
              "type": "array",
              "items": {
                "type": "object",
                "required": ["filename", "data", "mimeType"],
                "properties": {
                  "filename": {"type": "string"},
                  "data": {"type": "string", "description": "Base64 encoded"},
                  "mimeType": {"type": "string"}
                }
              }
            }
          }
        }
      ]
    },
    "Effect": {
      "oneOf": [
        {
          "type": "object",
          "required": ["type", "staticEffectPath"],
          "properties": {
            "type": {"const": "blend"},
            "staticEffectPath": {"type": "string"},
            "blendMode": {
              "type": "string",
              "enum": ["normal", "addition", "screen", "multiply", "overlay", "average", "lighten", "darken", "hardlight"]
            },
            "opacity": {"type": "number", "minimum": 0, "maximum": 1},
            "duration": {"type": ["number", "string"]}
          }
        },
        {
          "type": "object",
          "required": ["type", "staticBannerPath"],
          "properties": {
            "type": {"const": "banner_overlay"},
            "staticBannerPath": {"type": "string"},
            "chromakey": {
              "type": "object",
              "properties": {
                "color": {"type": "string"},
                "similarity": {"type": "number"},
                "blend": {"type": "number"}
              }
            },
            "position": {"type": "object"},
            "duration": {"type": ["number", "string"]}
          }
        }
      ]
    },
    "TextOverlay": {
      "type": "object",
      "required": ["text"],
      "properties": {
        "text": {"type": "string"},
        "position": {
          "type": "object",
          "properties": {
            "x": {"type": ["string", "number"]},
            "y": {"type": ["string", "number"]}
          }
        },
        "style": {
          "type": "object",
          "properties": {
            "fontSize": {"type": "number"},
            "fontFamily": {"type": "string"},
            "color": {"type": "string"},
            "backgroundColor": {"type": "string"},
            "padding": {"type": "number"},
            "opacity": {"type": "number"}
          }
        },
        "animation": {
          "type": "string",
          "enum": ["fadeIn", "slideIn", "typewriter", "bounce", "pulse", "none"]
        },
        "timing": {
          "type": "object",
          "properties": {
            "start": {"type": "number"},
            "end": {"type": "number"}
          }
        }
      }
    },
    "AdvancedTextOverlay": {
      "type": "object",
      "required": ["segments"],
      "properties": {
        "segments": {
          "type": "array",
          "items": {
            "type": "object",
            "required": ["text"],
            "properties": {
              "text": {"type": "string"},
              "style": {"type": "object"}
            }
          }
        },
        "position": {"type": "object"},
        "baseStyle": {"type": "object"},
        "animation": {"type": "string"}
      }
    }
  }
}
```

---

## RenderConfig Schema (FantaProjekt)

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "RenderConfig",
  "type": "object",
  "properties": {
    "voice": {
      "type": "string",
      "description": "Voice ID для TTS"
    },
    "voiceSpeed": {
      "type": "number",
      "minimum": 0.5,
      "maximum": 2.0,
      "default": 1.0
    },
    "music": {
      "type": "string",
      "description": "Music tag или asset ID"
    },
    "musicVolume": {
      "type": "string",
      "enum": ["muted", "low", "medium", "high", "very_high", "ultra"]
    },
    "orientation": {
      "type": "string",
      "enum": ["portrait", "landscape"]
    },
    "captionPosition": {
      "type": ["string", "number"],
      "description": "top, center, bottom, pixels, или процент"
    },
    "captionBackgroundColor": {
      "type": "string",
      "pattern": "^#[0-9A-Fa-f]{6}$"
    },
    "paddingBack": {
      "type": "number",
      "description": "Padding в миллисекундах"
    },
    "skipSubtitles": {
      "type": "boolean",
      "default": false
    },
    "skipVoiceover": {
      "type": "boolean",
      "default": false
    },
    "voiceInstructions": {
      "type": "string",
      "description": "Инструкции для TTS"
    }
  }
}
```

---

## Usage Record Schema

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "UsageRecord",
  "type": "object",
  "required": ["org_id", "resource_type", "cost_usd"],
  "properties": {
    "id": {"type": "string"},
    "org_id": {"type": "string"},
    "user_id": {"type": ["string", "null"]},
    "job_id": {"type": ["string", "null"]},
    "resource_type": {
      "type": "string",
      "enum": ["llm_tokens", "kai_credits", "render_seconds", "storage"]
    },
    "llm_tokens_prompt": {"type": ["integer", "null"]},
    "llm_tokens_output": {"type": ["integer", "null"]},
    "llm_model": {"type": ["string", "null"]},
    "kai_credits": {"type": ["integer", "null"]},
    "kai_model": {"type": ["string", "null"]},
    "render_seconds": {"type": ["number", "null"]},
    "render_profile": {"type": ["string", "null"]},
    "storage_bytes": {"type": ["integer", "null"]},
    "cost_usd": {"type": "number"},
    "created_at": {"type": "string", "format": "date-time"}
  }
}
```

---

## Quota Limits Schema

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "QuotaLimits",
  "type": "object",
  "required": ["org_id", "reset_at"],
  "properties": {
    "id": {"type": "string"},
    "org_id": {"type": "string"},
    "tokens_limit": {"type": ["integer", "null"]},
    "render_seconds_limit": {"type": ["integer", "null"]},
    "kai_credits_limit": {"type": ["integer", "null"]},
    "storage_bytes_limit": {"type": ["integer", "null"]},
    "tokens_used": {"type": "integer", "default": 0},
    "render_seconds_used": {"type": "number", "default": 0},
    "kai_credits_used": {"type": "integer", "default": 0},
    "storage_bytes_used": {"type": "integer", "default": 0},
    "allow_overage": {"type": "boolean", "default": true},
    "overage_cap_usd": {"type": ["number", "null"]},
    "reset_at": {"type": "string", "format": "date-time"},
    "updated_at": {"type": "string", "format": "date-time"}
  }
}
```
