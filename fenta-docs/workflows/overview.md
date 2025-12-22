# Workflows — Обзор системы

## Концепция

Workflow Builder — визуальный редактор пайплайнов видеопроизводства. Пользователи создают графы из узлов (nodes), соединяют их ребрами (edges) и запускают автоматический рендер.

---

## Категории узлов

| Категория | Описание | Файл |
|-----------|----------|------|
| **Input** | Получение исходных материалов | `nodes-input.md` |
| **Script** | Генерация и трансформация текста | `nodes-script.md` |
| **Audio** | TTS и аудио-микширование | `nodes-audio.md` |
| **Subtitle** | Автоматические субтитры | `nodes-subtitle.md` |
| **Edit** | Сборка таймлайна | `nodes-edit.md` |
| **Output** | Рендер и экспорт | `nodes-output.md` |

---

## Архитектура выполнения

### Топологический порядок

Узлы выполняются в **топологическом порядке** на основе графа зависимостей:

```
1. Найти узлы без входящих ребер
2. Выполнить их параллельно
3. Пометить как завершенные
4. Повторить для следующего уровня
5. Продолжать до Output.Render
```

### Жизненный цикл узла

```
┌─────────────────────────────────────────────────────┐
│                     NODE LIFECYCLE                   │
├─────────────────────────────────────────────────────┤
│                                                      │
│  WAITING ──► VALIDATING ──► EXECUTING ──► COMPLETED │
│      │            │              │             │     │
│      │            ▼              ▼             │     │
│      │         FAILED         FAILED           │     │
│      │            │              │             │     │
│      └────────────┴──────────────┴─────────────┘     │
│                                                      │
└─────────────────────────────────────────────────────┘
```

1. **WAITING** — ожидание входных данных
2. **VALIDATING** — проверка параметров
3. **EXECUTING** — выполнение операции
4. **COMPLETED** — передача результатов downstream
5. **FAILED** — ошибка (retry если retryable)

---

## Базовая структура узла

```typescript
interface BaseNode {
  id: string;                    // Уникальный ID (e.g., "n1", "stock_broll")
  type: NodeType;                // Тип узла (e.g., "Input.Stock")
  params: Record<string, any>;   // Параметры узла
  position: {                    // Позиция на canvas (UI)
    x: number;
    y: number;
  };
  label?: string;                // Кастомная метка
  disabled?: boolean;            // Пропустить при выполнении
}
```

---

## Порты ввода/вывода

```typescript
interface NodePort {
  id: string;          // Идентификатор порта
  type: PortDataType;  // 'text', 'image', 'video', 'audio', 'array', 'object'
  required: boolean;   // Обязательное подключение
  label: string;       // Отображаемое имя
}
```

**Типы данных портов:**

| Тип | Описание | Примеры |
|-----|----------|---------|
| `text` | Строка/текст | script, prompt |
| `image` | Изображение | generated image, stock photo |
| `video` | Видео | clip, rendered segment |
| `audio` | Аудио | voice, music |
| `array` | Массив любого типа | [video, video, video] |
| `object` | Сложный объект | timeline, subtitles |

---

## Структура графа

```json
{
  "nodes": [
    {
      "id": "n1",
      "type": "Input.Stock",
      "params": {"provider": "pexels", "query": "city night"},
      "position": {"x": 100, "y": 100}
    },
    {
      "id": "n2",
      "type": "Script.Generate",
      "params": {"genre": "news", "lang": "en"},
      "position": {"x": 100, "y": 250}
    },
    {
      "id": "n3",
      "type": "Voice.TTS",
      "params": {"voice": "alloy_en", "speed": 1.0},
      "position": {"x": 100, "y": 400}
    },
    {
      "id": "n4",
      "type": "Edit.Timeline",
      "params": {"templateId": "tmpl_shorts"},
      "position": {"x": 300, "y": 300}
    },
    {
      "id": "n5",
      "type": "Output.Render",
      "params": {"profile": "9x16_1080p"},
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

**Визуализация:**

```
┌─────────────┐     ┌─────────────┐
│ Input.Stock │     │Script.Generate
│  (n1)       │     │  (n2)       │
└──────┬──────┘     └──────┬──────┘
       │                   │
       │            ┌──────▼──────┐
       │            │ Voice.TTS   │
       │            │  (n3)       │
       │            └──────┬──────┘
       │                   │
       └────────┬──────────┘
                │
         ┌──────▼──────┐
         │Edit.Timeline│
         │  (n4)       │
         └──────┬──────┘
                │
         ┌──────▼──────┐
         │Output.Render│
         │  (n5)       │
         └─────────────┘
```

---

## Параллельное выполнение

Узлы без зависимостей выполняются параллельно:

```json
{
  "nodes": [
    {"id": "n1", "type": "Input.Stock"},
    {"id": "n2", "type": "Script.Generate"},
    {"id": "n3", "type": "Input.KAI.GenerateImage"}
  ],
  "edges": [
    {"from": "n1", "to": "n4"},
    {"from": "n2", "to": "n4"},
    {"from": "n3", "to": "n4"}
  ]
}
```

n1, n2, n3 запускаются одновременно, n4 ждет всех трех.

---

## Условное выполнение

Используйте `disabled` с переменными:

```json
{
  "id": "n5",
  "type": "Input.Stock",
  "params": {"query": "{{fallback_query}}"},
  "disabled": "{{use_generated_video}}"
}
```

---

## Переменные workflow

```json
{
  "variables": {
    "topic": "breaking news story",
    "target_duration": 30,
    "voice": "alloy_en",
    "use_kai": true
  }
}
```

Использование в параметрах:

```json
{
  "params": {
    "prompt": "Create a {{topic}} script",
    "targetDuration": "{{target_duration}}"
  }
}
```

---

## Обработка ошибок

```typescript
interface NodeError {
  code: string;
  message: string;
  details?: any;
  retryable: boolean;
}
```

**Коды ошибок:**

| Код | Описание | Retryable |
|-----|----------|-----------|
| `INVALID_PARAMS` | Неверные параметры | No |
| `MISSING_INPUT` | Отсутствует вход | No |
| `QUOTA_EXCEEDED` | Превышена квота | No |
| `API_ERROR` | Ошибка внешнего API | Yes |
| `PROCESSING_FAILED` | Внутренняя ошибка | Yes |
| `TIMEOUT` | Таймаут выполнения | Yes |

**Стратегия retry:**
- Retryable: 3 попытки с exponential backoff
- Таймаут: 5 минут на узел (настраивается)

---

## Оценка стоимости

```http
POST /v1/workflows/{id}/estimate
```

**Response:**
```json
{
  "estimated": {
    "tokens": 5000,
    "renderSeconds": 45.0,
    "kaiCredits": 120,
    "totalUsd": 0.87,
    "duration": "2-5 minutes"
  },
  "breakdown": [
    {"node": "n2", "type": "Script.Generate", "cost": 0.02},
    {"node": "n3", "type": "Input.KAI.GenerateVideo", "cost": 0.40},
    {"node": "n6", "type": "Voice.TTS", "cost": 0.05},
    {"node": "n10", "type": "Output.Render", "cost": 0.40}
  ]
}
```

---

## Режимы запуска

### Production

```http
POST /v1/workflows/{id}/run
{"mode": "production"}
```

Полный рендер всего видео.

### Test

```http
POST /v1/workflows/{id}/run
{"mode": "test"}
```

Рендер только первых 10-15 секунд для проверки.

### Preview

```http
POST /v1/workflows/{id}/run
{"mode": "preview"}
```

Быстрый preview низкого качества (720p, low bitrate).

---

## Отслеживание прогресса

```json
{
  "status": "processing",
  "progress": 65,
  "currentNode": "n8",
  "completedNodes": ["n1", "n2", "n3", "n4", "n5", "n6", "n7"],
  "failedNodes": [],
  "estimatedRemaining": "45 seconds"
}
```

---

## Best Practices

### 1. Именование узлов

Используйте описательные ID:
```json
{"id": "stock_broll", "type": "Input.Stock"}
{"id": "generate_script", "type": "Script.Generate"}
{"id": "render_final", "type": "Output.Render"}
```

### 2. Валидация параметров

Проверяйте параметры до отправки чтобы избежать runtime ошибок.

### 3. Группировка узлов

Логически группируйте узлы на canvas для читаемости.

### 4. Тестирование

Всегда используйте test mode перед production для экономии ресурсов.

### 5. Мониторинг стоимости

Проверяйте estimate перед запуском дорогих workflow.
