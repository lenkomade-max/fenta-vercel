# Потоки данных

## 1. Создание видео (простой путь)

Пользователь создаёт видео через UI без workflow.

```
┌─────┐    ┌──────────┐    ┌────────────┐    ┌───────────────┐
│User │───▶│fenta-web │───▶│ Supabase   │───▶│ FantaProjekt  │
│     │    │  (UI)    │    │ (job)      │    │ (render)      │
└─────┘    └──────────┘    └────────────┘    └───────┬───────┘
                                                     │
                                                     ▼
┌─────┐    ┌──────────┐    ┌────────────┐    ┌───────────────┐
│User │◀───│fenta-web │◀───│ Supabase   │◀───│ MP4 + Storage │
│     │    │  (UI)    │    │ (status)   │    │               │
└─────┘    └──────────┘    └────────────┘    └───────────────┘
```

**Шаги:**
1. User заполняет форму (текст, медиа, настройки)
2. fenta-web создаёт job в Supabase
3. Edge Function вызывает FantaProjekt API
4. FantaProjekt рендерит видео
5. Результат сохраняется в Supabase Storage
6. User получает уведомление и скачивает

---

## 2. Создание видео с AI генерацией

Пользователь использует KIE.ai для генерации медиа.

```
┌─────┐    ┌──────────┐    ┌────────────┐
│User │───▶│fenta-web │───▶│  KIE.ai    │
│     │    │  (UI)    │    │ (generate) │
└─────┘    └──────────┘    └─────┬──────┘
                                 │
                                 ▼ callback/poll
┌──────────┐    ┌────────────┐    ┌───────────────┐
│fenta-web │◀───│  assets    │◀───│ generated     │
│          │    │ (Supabase) │    │ media         │
└────┬─────┘    └────────────┘    └───────────────┘
     │
     ▼
┌───────────────┐    ┌───────────────┐
│ FantaProjekt  │───▶│  Final MP4    │
│ (render)      │    │               │
└───────────────┘    └───────────────┘
```

**Шаги:**
1. User запрашивает генерацию (промпт, модель)
2. fenta-web вызывает KIE.ai API
3. KIE.ai возвращает taskId
4. Polling/callback для получения результата
5. Результат сохраняется как asset
6. Asset используется в рендере FantaProjekt

---

## 3. Workflow (автоматический конвейер)

Workflow выполняется по расписанию или вручную.

```
┌──────────────┐
│  Schedule    │
│  (cron)      │
└──────┬───────┘
       │ trigger
       ▼
┌──────────────┐    ┌──────────────────────────────────────┐
│  Workflow    │───▶│          Node Execution              │
│  (graph)     │    │                                      │
└──────────────┘    │  n1: Input.Stock ──┐                 │
                    │  n2: Script.Gen ───┼──▶ n5: Timeline │
                    │  n3: Voice.TTS ────┤                 │
                    │  n4: Subtitle ─────┘                 │
                    │                        │             │
                    │                        ▼             │
                    │                   n6: Render ───▶ MP4│
                    └──────────────────────────────────────┘
```

**Шаги:**
1. Schedule триггерит workflow
2. Workflow graph парсится
3. Ноды выполняются в топологическом порядке
4. Параллельные ноды выполняются одновременно
5. Финальная нода Render вызывает FantaProjekt
6. Результат сохраняется, webhook отправляется

---

## 4. Realtime обновления

Supabase Realtime для live статусов.

```
┌─────────────────┐         ┌──────────────┐
│   FantaProjekt  │────────▶│   Supabase   │
│   (updates)     │  INSERT │   (jobs)     │
└─────────────────┘         └──────┬───────┘
                                   │
                                   │ realtime
                                   ▼
                            ┌──────────────┐
                            │   fenta-web  │
                            │   (UI)       │
                            └──────┬───────┘
                                   │
                                   ▼
                            ┌──────────────┐
                            │    User      │
                            │  (progress)  │
                            └──────────────┘
```

---

## 5. Биллинг и usage tracking

```
┌─────────────────┐
│   Job Start     │
└────────┬────────┘
         │
         ▼
┌─────────────────┐    ┌─────────────────┐
│  Check Quota    │───▶│ quota_limits    │
│                 │    │ (Supabase)      │
└────────┬────────┘    └─────────────────┘
         │
         │ allowed
         ▼
┌─────────────────┐
│  Execute Job    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐    ┌─────────────────┐
│  Track Usage    │───▶│ usage_records   │
│                 │    │ (Supabase)      │
└────────┬────────┘    └─────────────────┘
         │
         ▼
┌─────────────────┐
│ Update Quota    │
└─────────────────┘
```

---

## Webhooks

### Исходящие (от fenta-web)

| Event | Payload |
|-------|---------|
| `job.started` | `{jobId, workflowId, timestamp}` |
| `job.completed` | `{jobId, videoUrl, duration, cost}` |
| `job.failed` | `{jobId, error, retryable}` |
| `quota.warning` | `{orgId, resource, percentage}` |

### Входящие (от KIE.ai)

| Event | Action |
|-------|--------|
| KIE.ai callback | Update asset, continue workflow |

---

## Error Handling

```
┌─────────────────┐
│   Job Failed    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐     ┌─────────────────┐
│  Retryable?     │─No─▶│  Mark Failed    │
└────────┬────────┘     │  Notify User    │
         │              └─────────────────┘
         │ Yes
         ▼
┌─────────────────┐
│  Retry Queue    │
│  (max 3x)       │
│  exponential    │
│  backoff        │
└─────────────────┘
```
