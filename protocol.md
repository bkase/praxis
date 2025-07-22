Below is **`protocol.md` v0.1** — a radically minimal, precise specification for Aethel.
Primitives: **Doc**, **Pack**, **Patch**. Everything else is derived or optional.

---

# Aethel Protocol v0.1

**Status:** Draft
**Date:** 2025‑07‑22
**Editors:** _You (The Maker)_

This document defines the **canonical file format, directory layout, and mutation protocol** for an Aethel vault. It is intentionally small. All capitalized requirement keywords (MUST, SHOULD, MAY, …) follow RFC 2119 semantics.

---

## 0. Scope & Non‑Goals

- **In scope:** How Docs are stored, how Packs declare types, how a Patch mutates a Doc, validation rules, error codes.
- **Out of scope:** UI/UX, SQL indexing strategies, LLM prompt design, cloud sync specifics. These MAY be standardized separately.

---

## 1. Terms & Primitives

### 1.1 Primitives (authoritative state + write operation)

- **Doc** — A single Markdown file (`.md`) whose first block is YAML front‑matter. Identified by a `uuid`.
- **Pack** — A directory that declares one or more **types** (schemas), plus optional templates and migrations.
- **Patch** — A JSON object describing a mutation (“create/append/merge/replace”) to exactly one Doc.

### 1.2 Other terms

- **Vault** — A directory tree containing Docs and Packs, plus optional internal files (lock, cache).
- **Type** — A string `"<packName>.<localTypeName>"` used in a Doc’s front‑matter. Each type is defined by a JSON Schema inside a Pack.
- **Base front‑matter** — Minimal fields every Doc MUST have.
- **Protocol Version** — SemVer string (e.g., `0.1.0`) declared by Packs to state compatibility with this spec.

---

## 2. Repository / Vault Layout

A vault MUST conform to the following minimal structure (names are case‑sensitive):

```
<vault>/
  docs/                 # all Doc files live here (or a substructure—see §2.3)
  packs/                # installed Packs
  .aethel/              # internal state (lock, index, etc.) - optional
```

### 2.1 `docs/`

- Each Doc MUST be stored as a single UTF‑8 file with extension `.md`.
- File name SHOULD be `<uuid>.md`. Implementations MAY shard (e.g., `docs/2025/07/<uuid>.md`), but MUST be able to locate a Doc by UUID without scanning the entire tree (e.g., by mapping `uuid→path`).

### 2.2 `packs/`

- Each Pack is stored under: `packs/<packName>@<version>/`.
- The version MUST be SemVer (`MAJOR.MINOR.PATCH`).
- A Pack MUST contain `pack.json` as described in §4.
- All schema files MUST live under `types/`.
- Templates (optional) under `templates/`.
- Migrations (optional) under `migrations/`.

### 2.3 Alternate layouts

Implementations MAY allow alternative physical layouts (e.g., plugin‑first or chronological). However, logical behavior MUST remain identical, and tools MUST resolve Docs and Packs by UUID/pack name regardless of physical layout.

---

## 3. Doc Specification

A **Doc** is:

```
---\n
<YAML front-matter>\n
---\n
<Markdown body>\n
```

There MUST be exactly one opening and one closing `---` line at top of file. No BOM before the first `-`.

### 3.1 Base Front‑Matter (mandatory keys)

All Docs MUST contain these keys with the specified semantics:

| Key       | Type                   | Description                                                        |
| --------- | ---------------------- | ------------------------------------------------------------------ |
| `uuid`    | string (UUID v4 or v7) | Immutable identifier of this Doc.                                  |
| `type`    | string                 | Fully-qualified type (`packName.localType`).                       |
| `created` | string (ISO 8601 UTC)  | Creation timestamp. Never changes.                                 |
| `updated` | string (ISO 8601 UTC)  | Last mutation timestamp. MUST be updated on each successful Patch. |
| `v`       | string (SemVer)        | Schema version of this Doc’s type.                                 |
| `tags`    | array of strings       | Free-form tags. MAY be empty.                                      |

> **NOTE:** Additional fields are defined by the type’s JSON Schema (see §4.2). Unknown fields MUST be rejected unless the schema explicitly allows them.

### 3.2 YAML Rules

- YAML MUST be valid 1.2.
- Keys MUST be unique.
- Value types MUST match the JSON Schema for the type.
- YAML MUST be encoded in UTF‑8.
- Implementations SHOULD sort keys lexicographically for deterministic diffs.

### 3.3 Body

- Body is arbitrary CommonMark (or GitHub‑Flavoured Markdown).
- Implementations MUST NOT attempt to validate Markdown semantics beyond encoding.
- Binary content MUST NOT be embedded directly; use references or sidecars.

---

## 4. Pack Specification

A **Pack** is a directory with a **`pack.json`** manifest.

### 4.1 `pack.json` (required)

```json
{
  "name": "journal",
  "version": "1.0.0",
  "protocolVersion": "0.1.0",
  "types": [
    {
      "id": "journal.morning",
      "version": "1.0.0",
      "schema": "types/journal.morning.v1.json",
      "template": "templates/journal.morning.md"
    }
  ]
}
```

**Fields:**

| Field             | Type          | Rules                                                                       |
| ----------------- | ------------- | --------------------------------------------------------------------------- |
| `name`            | string        | DNS‑label regex: `^[a-z0-9\-]+$`; globally unique within the vault.         |
| `version`         | SemVer string | Version of the Pack itself.                                                 |
| `protocolVersion` | SemVer string | Version of this protocol the Pack targets. MUST be compatible (same MAJOR). |
| `types`           | array         | Each element defines exactly one Type (below).                              |

**Type Entry Fields:**

| Field      | Type                    | Rules                                                          |
| ---------- | ----------------------- | -------------------------------------------------------------- |
| `id`       | string                  | Must be `"<packName>.<local>"`; `local` uses `^[a-z0-9_\.]+$`. |
| `version`  | SemVer                  | Schema version.                                                |
| `schema`   | string (path)           | Path relative to pack root to a JSON Schema file. MUST exist.  |
| `template` | string (path, optional) | Default Doc body/front-matter template. MAY be omitted.        |

### 4.2 JSON Schema for Types

- MUST be Draft 2020‑12 (or later) JSON Schema.
- MUST reference/extend the **Base Front‑Matter Schema** (Appendix A) and MUST NOT redefine base keys with incompatible types.
- MUST set `"additionalProperties": false` to reject unknown keys unless intentionally open.

### 4.3 Migrations (optional)

- A Pack MAY include scripts or binaries to migrate Docs from one schema version to another.
- Migration entrypoints are out of scope here; implementations MAY define conventions (e.g., `migrations/1.0.0_to_1.1.0.js`).

---

## 5. Patch Specification

A **Patch** is a JSON object describing a single mutation. It is consumed by `writeDoc`.

```json
{
  "uuid": null,
  "type": "journal.morning",
  "frontmatter": { "mood": "🙂" },
  "body": "Today I felt…",
  "mode": "create" // "append", "merge_frontmatter", "replace_body"
}
```

### 5.1 Fields

| Field         | Type           | Required           | Notes                                                                               |
| ------------- | -------------- | ------------------ | ----------------------------------------------------------------------------------- |
| `uuid`        | string or null | optional           | If null, a new Doc is created. If set, selects existing Doc.                        |
| `type`        | string         | required on create | MUST match a known type id. On update, MUST equal existing Doc.type.                |
| `frontmatter` | object         | optional           | Partial map merged into Doc’s front‑matter (not including base keys set by system). |
| `body`        | string         | optional           | Markdown text. Interpretation depends on `mode`.                                    |
| `mode`        | enum           | required           | See §5.2.                                                                           |

### 5.2 `mode` Enum

- `"create"` — `uuid` MUST be null. Creates new Doc with given type/frontmatter/body.
- `"append"` — Appends `body` (if present) to end, separated by two newlines. `frontmatter` merged (new keys/values override).
- `"merge_frontmatter"` — Only front‑matter patch; body unchanged.
- `"replace_body"` — Replaces entire body with `body`; front‑matter merged.

### 5.3 Merge & Validation Rules

1. **UUID Resolution**
   - If `uuid` is null → generate a new UUID (v7 recommended).
   - If `uuid` provided but Doc missing → error `40401` (“Doc not found”).

2. **Type Handling**
   - On create, `type` is required.
   - On update, `type` MUST equal existing `Doc.type`; else error `40902`.

3. **Front‑matter Merge**
   - Base keys (`uuid`, `type`, `created`, `updated`, `v`, `tags`) are controlled by system; user-provided values for these MUST be ignored or raise error `40003`.
   - Plugin keys: shallow merge. Keys in `frontmatter` replace existing; missing keys stay untouched.
   - Unknown keys (not in schema) → error `42201`.

4. **Body Handling**
   - `append`: if `body` is absent/empty → no-op on body.
   - `replace_body`: if `body` missing → error `40004`.
   - Body MUST be valid UTF‑8.

5. **Timestamps**
   - `created` set once on create.
   - `updated` MUST be set to current UTC ISO8601 after successful mutation.

6. **Schema Validation**
   - After merge, full front‑matter MUST validate against the type’s JSON Schema.
   - On failure → error `42200` with details.

7. **Atomic Write**
   - Implementation MUST write to a temp file and rename to ensure atomicity.
   - On success, optional Git commit (see §8).

8. **Idempotency**
   - Implementations SHOULD detect no-ops (hash of front-matter+body unchanged) and return success with `committed=false`.

---

## 6. Error Model

All interfaces (CLI/RPC) MUST return machine-readable errors.

### 6.1 Structure

```json
{
  "code": 42200,
  "message": "Schema validation failed",
  "data": {
    "pointer": "/frontmatter/mood",
    "expected": "string",
    "got": "number"
  }
}
```

### 6.2 Canonical Codes (subset)

| Code  | Meaning                         |
| ----- | ------------------------------- |
| 40000 | Malformed request JSON          |
| 40001 | Unknown mode                    |
| 40003 | Attempt to set system key       |
| 40004 | Missing required field for mode |
| 40401 | Doc not found                   |
| 40902 | Type mismatch on update         |
| 40903 | Concurrent write conflict       |
| 42200 | Schema validation error         |
| 42201 | Unknown front‑matter key        |
| 42601 | Protocol version mismatch       |
| 50000 | Internal error                  |

Implementations MAY extend codes but MUST NOT reuse numbers with different meanings.

---

## 7. Interfaces (CLI / JSON‑RPC)

### 7.1 CLI

- `aethel write --json -` reads Patch from stdin, outputs JSON result.
- `aethel read <uuid> [--format json|md]`
- `aethel check doc <uuid> [--autofix]`
- `aethel list packs`
- `aethel add pack <path|git-url>`
- `aethel remove pack <name>`

All commands MUST support `--output json` for machine consumption.

### 7.2 JSON‑RPC 2.0 (optional transport)

**Methods (names fixed):**

- `writeDoc` (params: Patch) → `WriteResult`
- `readDoc` (params: `{ uuid, format? }`) → `Doc` or `{ frontmatter, body }`
- `checkDoc` (params: `{ uuid, autofix? }`) → `{ valid: bool, errors: [...], fixed: bool }`
- `listPacks` → array of `{ name, version, protocolVersion }`
- `addPack` (params: `{ source }`) → PackInfo
- `removePack` (params: `{ name }`) → `{ removed: bool }`

**Transport options:**

- CLI stdio (`aethel rpc --stdio`)
- Unix domain socket / TCP port (`aethel serve`)
- Implementations MUST guarantee identical semantics regardless of transport.

---

## 8. Git & Concurrency (Recommended Practice)

- Before any write: `git pull --rebase` (if remote configured).
- After successful write: `git commit -m "writeDoc type=X uuid=Y"`; optional `git push`.
- Implementations SHOULD lock `.aethel/lock` to serialize writes.
- On merge conflicts, return `40903`.

---

## 9. Size & Tidy Constraints

- Front‑matter SHOULD NOT exceed 1 KiB. Implementations MAY warn or error above threshold.
- Large or binary data MUST be stored outside docs (e.g., `sources/`), referenced by hash/UUID in front‑matter.
- Keys SHOULD be snake_case. Enums SHOULD be short, lower‑case strings.

---

## 10. Versioning & Compatibility

- **Protocol Version**: Breaking changes bump MAJOR. Packs declare `protocolVersion` and MUST NOT load on incompatible runtime.
- **Pack Version**: Breaking schema changes bump MAJOR.
- **Type Version** (`v` in Doc front‑matter):
  - On schema change, bump `v`.
  - Migration scripts SHOULD exist for MAJOR bumps.

---

## 11. Security & Integrity

- Implementations SHOULD validate UUID format and refuse directory traversal.
- Writes MUST be atomic.
- Optional: store a SHA‑256 of body/front‑matter in `.aethel/index` for corruption detection.
- Encryption at rest/out of scope.

---

## 12. Extensibility Hooks (Non‑Normative)

- **Index Packs** can read Docs and emit SQL/Parquet.
- **Agent Packs** can provide tool specs for LLMs.
- **UI Packs** can provide editor components.

These MUST NOT mutate Docs except via the Patch API.

---

## Appendix A — Base Front‑Matter JSON Schema (Draft 2020‑12)

```json
{
  "$id": "https://aethel.dev/schemas/base-frontmatter.json",
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "type": "object",
  "required": ["uuid", "type", "created", "updated", "v", "tags"],
  "properties": {
    "uuid": {
      "type": "string",
      "pattern": "^[0-9a-fA-F-]{36}$"
    },
    "type": { "type": "string" },
    "created": {
      "type": "string",
      "format": "date-time"
    },
    "updated": {
      "type": "string",
      "format": "date-time"
    },
    "v": {
      "type": "string",
      "pattern": "^[0-9]+\\.[0-9]+\\.[0-9]+$"
    },
    "tags": {
      "type": "array",
      "items": { "type": "string" },
      "default": []
    }
  },
  "additionalProperties": false
}
```

---

## Appendix B — Patch JSON Schema

```json
{
  "$id": "https://aethel.dev/schemas/patch.json",
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "type": "object",
  "required": ["mode"],
  "properties": {
    "uuid": {
      "type": ["string", "null"],
      "pattern": "^[0-9a-fA-F-]{36}$"
    },
    "type": { "type": "string" },
    "frontmatter": { "type": "object" },
    "body": { "type": ["string", "null"] },
    "mode": {
      "type": "string",
      "enum": ["create", "append", "merge_frontmatter", "replace_body"]
    }
  },
  "additionalProperties": false,
  "allOf": [
    {
      "if": { "properties": { "mode": { "const": "create" } } },
      "then": { "required": ["type"] }
    }
  ]
}
```

---

## Appendix C — WriteResult JSON Shape (example)

```json
{
  "$id": "https://aethel.dev/schemas/write-result.json",
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "type": "object",
  "required": ["uuid", "path", "committed", "warnings"],
  "properties": {
    "uuid": { "type": "string" },
    "path": { "type": "string" },
    "committed": { "type": "boolean" },
    "warnings": {
      "type": "array",
      "items": { "type": "string" }
    }
  },
  "additionalProperties": false
}
```

---

## Appendix D — Example Pack Directory

```
packs/journal@1.0.0/
  pack.json
  types/
    journal.morning.v1.json
  templates/
    journal.morning.md
  migrations/
    1.0.0_to_1.1.0.js   (optional)
```

---

**End of protocol v0.1**
