**implementation-layers.md (v0.1)**
_Aethel: from zero to powerful—without overbuilding_

---

## 0. Purpose

Give the team a **strict sequence of layers** and deliverables so no one “helpfully” builds a daemon, server, or indexer before we need it. Each higher layer may only depend on the one(s) below it.

---

## 1. Layer Stack (must-build order)

### **L0 – Core Library (Doc · Pack · Patch)**

- **What it is:** Pure Rust crate. No I/O beyond POSIX FS + optional git.
- **Exports:**
  - `Doc` struct (frontmatter + body)
  - `Pack` loader & schema registry
  - `apply_patch(patch: Patch) -> WriteResult`
  - `validate_doc(doc) -> Result<()>`

- **No network, no JSON-RPC, no SQL.**

**Exit criteria:** Can create, read, patch, and validate Docs on disk with unit tests & fixtures.

---

### **L1 – CLI (std(in|out), flags are sugar)**

- **What it is:** Thin binary over L0.
- **Commands:** `init`, `write doc`, `read doc`, `check doc`, `list packs`, `add pack`, `remove pack`.
- **JSON first:** Every command accepts `--json -` for input and `--output json` for output.
- **No resident process, no sockets.**

**Exit criteria:** End-to-end flow via shell & JSON; works in CI; usable by LLM tool-calls.

---

### **L2 – Optional Views (Browse / Dump / Index)**

- **Browse view generator** (`aethel browse refresh`) producing symlinks/stubs or MOC docs.
- **Dump** (`aethel dump --format ndjson|jsonl`) for external tools.
- **Index (SQLite/DuckDB)** is **optional** and lives in a separate crate or “index pack”.

**Exit criteria:** Users can comfortably browse/edit with Obsidian; power users can query via external tools. Core untouched if we delete this layer.

---

### **L3 – Transports & Integrations (when needed)**

- **StdIO JSON‑RPC server** (`aethel rpc --stdio`) for editors/agents that want persistent sessions.
- **Local socket/http daemon** only if performance demands it.
- **Language SDKs** (TS/Swift/Python) generated from schemas & Patch JSON.

**Exit criteria:** Only built after an actual integration needs it (e.g., VSCode plugin, agent loop).

---

## 2. Rules of Engagement

- **One source of truth:** JSON Schema for types, Patch, and base front‑matter. All codegen derives from it.
- **No skipping layers:** You cannot implement L2/L3 without L0/L1 completed & stable.
- **No new primitives:** Any feature must be expressed via Doc, Pack, Patch or as a derived view.
- **No hidden state:** Anything cached (indexes, locks) goes under `.aethel/`, is disposable, and never required by L0/L1.

---

## 3. Do / Don’t (cheat sheet)

| ✅ Do now                                     | ❌ Don’t now                           |
| --------------------------------------------- | -------------------------------------- |
| Build the Rust lib & CLI                      | Build a JSON-RPC server/daemon         |
| Implement Patch JSON stdin/out                | Add gRPC, WebSocket, or HTTP APIs      |
| Add pack loading & schema validation          | Add per-pack SQL mappings or an ORM    |
| Write fixtures & conformance tests            | Design a full-blown plugin marketplace |
| Generate TS/Rust types from schema (optional) | Hand-write type defs in every language |

---

## 4. Deliverables per Layer

**L0**

- `crates/aethel-core/`
- Fixtures: `tests/fixtures/*.md`, `*.json`
- Doc: README + rustdoc inline

**L1**

- `crates/aethel-cli/`
- CLI docs (`aethel --help`, man page)
- JSON samples for Patch, WriteResult

**L2 (optional)**

- `crates/aethel-browse/` or `aethel browse` subcommand
- `examples/notebooks/duckdb.ipynb` using `dump`
- No changes to core API

**L3 (optional)**

- `crates/aethel-rpc/` (wraps core)
- `packages/ts-sdk/`, `Sources/AethelSDK` (generated)
- Integration tests with editor/agent

---

## 5. Milestone Gates

| Gate    | Must be true before proceeding                                   |
| ------- | ---------------------------------------------------------------- |
| M0 → M1 | Core crate passes conformance tests; schema locked for v0.1      |
| M1 → M2 | CLI adopted in daily workflow; no feature gaps in write/validate |
| M2 → M3 | A real user story requires persistent RPC or heavy indexing      |

---

## 6. Conformance & Testing

- **Golden vault**: repo of sample Docs/Packs and expected outputs from `read`, `check`.
- **Protocol tests**: apply Patches → assert final file bytes & JSON output.
- **Schema evolution tests**: ensure migration scripts run & validate.

---

## 7. Communication to Team

> “We are shipping **L0 and L1 only** in v0.1. Do not build servers, daemons, or databases unless a written RFC is approved after v0.1. The CLI + JSON stdin/out is our API.”

Include this doc in the repo root as `implementation-layers.md`, link it from `protocol.md`.
