# База данных — Content (Templates, Workflows, Assets)

## templates

Шаблоны монтажа видео.

```sql
CREATE TABLE templates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID REFERENCES orgs(id) ON DELETE CASCADE,
  project_id UUID REFERENCES projects(id) ON DELETE SET NULL,

  name TEXT NOT NULL,
  description TEXT,

  -- Video settings
  aspect TEXT NOT NULL, -- "9:16", "16:9", "1:1", "4:5"
  resolution TEXT NOT NULL, -- "1080x1920", "1920x1080"

  -- Template specification (JSONB)
  spec JSONB NOT NULL,

  -- Metadata
  is_public BOOLEAN DEFAULT false,
  thumbnail_url TEXT,
  usage_count INTEGER DEFAULT 0,

  created_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  deleted_at TIMESTAMPTZ
);

-- Индексы
CREATE INDEX idx_templates_org ON templates(org_id);
CREATE INDEX idx_templates_project ON templates(project_id);
CREATE INDEX idx_templates_aspect ON templates(aspect);
CREATE INDEX idx_templates_public ON templates(is_public) WHERE is_public = true;
CREATE INDEX idx_templates_spec ON templates USING gin(spec);
```

**Структура spec:**
```json
{
  "tracks": [
    {"type": "video", "id": "main", "z": 0},
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
    {"type": "overlay", "id": "top_text", "z": 20}
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
}
```

---

## workflows

Визуальные workflow графы.

```sql
CREATE TABLE workflows (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID NOT NULL REFERENCES orgs(id) ON DELETE CASCADE,
  project_id UUID REFERENCES projects(id) ON DELETE SET NULL,

  name TEXT NOT NULL,
  description TEXT,

  -- Status
  status TEXT DEFAULT 'draft', -- draft, confirmed, preview, production, archived

  -- Workflow graph (JSONB)
  graph JSONB NOT NULL,

  -- Variables for workflow
  variables JSONB DEFAULT '{}',

  -- Stats
  run_count INTEGER DEFAULT 0,
  last_run_at TIMESTAMPTZ,

  created_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  deleted_at TIMESTAMPTZ
);

-- Индексы
CREATE INDEX idx_workflows_org ON workflows(org_id);
CREATE INDEX idx_workflows_project ON workflows(project_id);
CREATE INDEX idx_workflows_status ON workflows(status);
CREATE INDEX idx_workflows_graph ON workflows USING gin(graph);
```

**Структура graph:**
```json
{
  "nodes": [
    {
      "id": "n1",
      "type": "Input.Stock",
      "params": {
        "provider": "pexels",
        "query": "breaking news city"
      },
      "position": {"x": 100, "y": 100}
    },
    {
      "id": "n2",
      "type": "Script.Generate",
      "params": {
        "genre": "news",
        "lang": "en",
        "prompt": "30s punchy headline + 3 beats"
      },
      "position": {"x": 100, "y": 250}
    },
    {
      "id": "n3",
      "type": "Voice.TTS",
      "params": {
        "voice": "alloy_en",
        "speed": 1.02
      },
      "position": {"x": 100, "y": 400}
    },
    {
      "id": "n4",
      "type": "Edit.Timeline",
      "params": {
        "template_id": "tmpl_shorts_v1"
      },
      "position": {"x": 300, "y": 300}
    },
    {
      "id": "n5",
      "type": "Output.Render",
      "params": {
        "profile": "9x16_1080p"
      },
      "position": {"x": 500, "y": 300}
    }
  ],
  "edges": [
    {"id": "e1", "from": "n1", "to": "n4"},
    {"id": "e2", "from": "n2", "to": "n3"},
    {"id": "e3", "from": "n3", "to": "n4"},
    {"id": "e4", "from": "n4", "to": "n5"}
  ]
}
```

---

## workflow_versions

История версий workflow.

```sql
CREATE TABLE workflow_versions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workflow_id UUID NOT NULL REFERENCES workflows(id) ON DELETE CASCADE,
  version INTEGER NOT NULL,
  graph JSONB NOT NULL,
  variables JSONB DEFAULT '{}',
  created_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(workflow_id, version)
);

CREATE INDEX idx_workflow_versions_workflow ON workflow_versions(workflow_id);
```

---

## assets

Медиа файлы пользователей.

```sql
CREATE TABLE assets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  org_id UUID NOT NULL REFERENCES orgs(id) ON DELETE CASCADE,
  project_id UUID REFERENCES projects(id) ON DELETE SET NULL,

  -- Type & Source
  type TEXT NOT NULL, -- image, video, audio
  source TEXT NOT NULL, -- upload, stock, kai, generated

  -- Storage
  storage_provider TEXT DEFAULT 'supabase', -- supabase, s3, r2
  storage_path TEXT NOT NULL,
  url TEXT,
  thumbnail_url TEXT,

  -- File info
  filename TEXT,
  content_type TEXT,
  size_bytes BIGINT,

  -- Media info
  duration_seconds DECIMAL(10, 2), -- для video/audio
  width INTEGER, -- для image/video
  height INTEGER,
  fps DECIMAL(5, 2), -- для video

  -- Metadata
  metadata JSONB DEFAULT '{}',

  status TEXT DEFAULT 'processing', -- processing, ready, failed

  created_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  deleted_at TIMESTAMPTZ
);

-- Индексы
CREATE INDEX idx_assets_org ON assets(org_id);
CREATE INDEX idx_assets_project ON assets(project_id);
CREATE INDEX idx_assets_type ON assets(type);
CREATE INDEX idx_assets_source ON assets(source);
CREATE INDEX idx_assets_status ON assets(status);
CREATE INDEX idx_assets_metadata ON assets USING gin(metadata);
```

**Пример metadata:**
```json
{
  "source_url": "https://pexels.com/...",
  "provider_id": "pexels_12345",
  "generation_params": {
    "model": "flux-pro",
    "prompt": "cyberpunk city"
  },
  "tags": ["nature", "forest"],
  "extracted_colors": ["#FF6B6B", "#4ECDC4"]
}
```

---

## asset_versions

Версии ассетов (редактирования).

```sql
CREATE TABLE asset_versions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  asset_id UUID NOT NULL REFERENCES assets(id) ON DELETE CASCADE,
  version INTEGER NOT NULL,
  storage_path TEXT NOT NULL,
  url TEXT,
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(asset_id, version)
);

CREATE INDEX idx_asset_versions_asset ON asset_versions(asset_id);
```

---

## RLS Policies

```sql
-- templates
ALTER TABLE templates ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Org members can view templates"
  ON templates FOR SELECT
  USING (
    org_id IN (SELECT org_id FROM org_members WHERE user_id = auth.uid())
    OR is_public = true
  );

CREATE POLICY "Editors can create templates"
  ON templates FOR INSERT
  WITH CHECK (
    org_id IN (
      SELECT org_id FROM org_members
      WHERE user_id = auth.uid()
      AND role IN ('owner', 'admin', 'editor')
    )
  );

-- workflows
ALTER TABLE workflows ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Org members can view workflows"
  ON workflows FOR SELECT
  USING (
    org_id IN (SELECT org_id FROM org_members WHERE user_id = auth.uid())
  );

-- assets
ALTER TABLE assets ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Org members can view assets"
  ON assets FOR SELECT
  USING (
    org_id IN (SELECT org_id FROM org_members WHERE user_id = auth.uid())
  );
```
