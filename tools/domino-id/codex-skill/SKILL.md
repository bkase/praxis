---
name: domino-id
description: Generate unique domino IDs for project tasks and manage project work logs. Use when creating new dominoes, logging work done, or listing existing domino IDs.
short-description: Domino ID generator and logger
---

# Domino ID Skill

Generate unique IDs for project domino tasks and manage project work logs.

## Commands

### Generate a new domino ID

When user wants to create a new domino with an ID:

```bash
bin/domino-id generate --project projects/<project-name>.md --task "<task description>"
```

This outputs a unique ID like `d-1w3`.

### List existing domino IDs

```bash
bin/domino-id list --project projects/<project-name>.md
```

### Log work done

When user wants to log work, create a JSONL entry in `projects/<project-name>.log.jsonl`:

```jsonl
{"ts":"<ISO8601-UTC>","what":"<description>"}
{"ts":"<ISO8601-UTC>","what":"<description>","dominoes":["d-xxx"]}
```

Get timestamp with: `date -u +%Y-%m-%dT%H:%M:%SZ`

## Workflow

### Adding a new domino to a project:

1. Generate ID: `bin/domino-id generate -p projects/<name>.md -t "<task>"`
2. Add to project frontmatter:
   ```yaml
   dominoes:
     - id: d-xxx
       task: "<task description>"
   ```

### Completing a domino:

1. Remove from project frontmatter (or mark done)
2. Log completion:
   ```jsonl
   {"ts":"2026-01-20T12:00:00Z","what":"Completed: <what you did>","dominoes":["d-xxx"]}
   ```

### Logging work (no domino):

```jsonl
{"ts":"2026-01-20T12:00:00Z","what":"<what you did>"}
```

## Project file format

```yaml
---
kind: project
created: YYYY-MM-DD
status: active
dominoes:
  - id: d-xxx
    task: "Task description"
  - "Simple task without ID"
---
```

## Log file format

One JSON object per line in `projects/<name>.log.jsonl`:
- `ts` — ISO 8601 UTC timestamp (required)
- `what` — description of work done (required)
- `dominoes` — array of completed domino IDs (optional)
