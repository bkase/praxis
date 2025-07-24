**golden-tests.md (v0.1)**
_Aethel CLI — deterministic, cross‑platform “golden” test suite_

> This document defines **authoritative conventions, directory layout, and tooling** for golden (“snapshot”) testing of the Aethel CLI (Layer L1).
> Every pull‑request that alters CLI behaviour MUST update or add golden fixtures and pass this suite in CI.

---

## 0  Goals

1. **Protocol compliance** — prove that real file operations (`write`, `read`, `check`, `list packs`, …) exactly match the JSON, filesystem, and exit‑code semantics in `protocol.md`.
2. **Regression safety** — any observable change (stdout, error codes, bytes on disk, Git commit metadata) fails tests unless fixtures are explicitly regenerated.
3. **Cross‑platform determinism** — results identical on Linux, macOS, and Windows runners.

---

## 1  Key Determinism Hooks (CLI test mode)

To make snapshots stable, the CLI **MUST** expose three inputs, usable only under `AETHEL_TEST_MODE=1`:

| Env Var / Flag       | Default in tests       | Purpose                                                                               |
| -------------------- | ---------------------- | ------------------------------------------------------------------------------------- |
| `AETHEL_TEST_MODE=1` | mandatory              | Enables deterministic behaviour; CLI MUST refuse destructive ops outside sandbox dir. |
| `--now <ISO8601>`    | `2000‑01‑01T00:00:00Z` | Overrides `created` / `updated` timestamps and commit dates.                          |
| `--uuid-seed <hex>`  | `00000000`             | Causes UUID (v7 or v4) generation to be reproducible.                                 |
| `--git=false`        | `false` (Git ON)       | Allows tests to toggle Git integration.                                               |

Implementation **SHOULD** parse them early and propagate to underlying helpers.

---

## 2  Fixture Directory Layout

```
tests/
  cases/
    001_write_doc/
      input.json          # Patch fed to stdin  (optional for read/list)
      cli-args.txt        # one-line arg string e.g. "write doc --json - --output json"
      env.json            # { "AETHEL_TEST_MODE":"1", "--now":"2025-07-22T08:00:00Z" }
      expect.stdout.json  # canonicalised JSON (or .md for read --format md)
      expect.exit.txt     # "0\n"  (exit code)
      vault.before/       # initial vault directory  (copied to tmp fs)
      vault.after/        # expected dir state after command
      git.after.txt       # optional: `git log --oneline -n 1` output
    002_invalid_schema/   # ...
  helpers/                # test harness Rust modules
```

- All text files MUST be UTF‑8, LF line endings.
- Paths inside fixtures MUST use forward slashes (`/`).

---

## 3  Canonicalisation Rules

Before diffing, harness MUST apply:

| Artifact              | Normalisation step                                                                           |
| --------------------- | -------------------------------------------------------------------------------------------- |
| **stdout JSON**       | Parse, sort object keys recursively, pretty‑print with `\n` line ends.                       |
| **Error JSON**        | Same as stdout JSON.                                                                         |
| **Markdown**          | Strip trailing whitespace; convert CRLF→LF.                                                  |
| **Front‑matter YAML** | Keys sorted lexicographically; `created` & `updated` normalised via `--now`; UUID remains.   |
| **Git**               | Commit timestamp uses `--now`; author name/email set to constant (`Test Bot <bot@example>`). |
| **Binary files**      | Hex‑dump first 64 bytes to text for diffing.                                                 |

---

## 4  Harness Implementation (Rust, but language‑agnostic spec)

### 4.1 Test runtime steps

1. **Copy** `vault.before/` to a temp dir (`$TMP/vault`).
2. **Apply env vars** from `env.json` (merge with system env).
3. **Spawn CLI** using `assert_cmd` (or equivalent) with arguments in `cli-args.txt`.
   - If `input.json` exists, pipe it to stdin.

4. **Capture** exit code, stdout, stderr.
5. **Canonicalise** stdout / stderr per §3.
6. **Diff** against `expect.stdout.json` (or `.md`) and `expect.exit.txt`.
7. **Snapshot** file tree (`walkdir`, exclude `.git/objects/**`, exclude DS_Store) and diff vs `vault.after/`.
   - For YAML diff, compare parsed DOM; for Markdown diff raw bytes (post‑normalisation).

8. **If** `git.after.txt` exists, run `git -C $TMP/vault log -n 1 --pretty=oneline --no-decorate` and diff.

### 4.2 Update workflow

Developers may regenerate snapshots via:

```bash
UPDATE_GOLDEN=1 cargo test cases::001_write_doc
```

Harness must detect the env var and overwrite `expect.*` + `vault.after/` + `git.after.txt` with current results, then fail with a message:

> “Golden files updated; please review and commit.”

CI MUST run with `UPDATE_GOLDEN` unset; any diff fails.

---

## 5  Test Case Naming & Coverage

### 5.1 Numbering

Numeric prefix `001‑999` + snake‑case description. Gaps allowed; never rename existing dirs (git blame history).

### 5.2 Required coverage (MUST have)

1. **create_success** — minimal Patch creates a Doc.
2. **append_success** — append body + merge front‑matter.
3. **replace_body**.
4. **merge_frontmatter_only**.
5. **invalid_schema** — unexpected key → `42200`.
6. **type_mismatch** — update with wrong type → `40902`.
7. **unknown_mode** — error `40001`.
8. **list_packs** with one pack installed.
9. **add_pack** (local path) then **write_doc** using new type.
10. **git_commit** — verify commit msg & date.

### 5.3 Edge cases (SHOULD add over time)

- Huge body file (>1 MiB).
- YAML at size limit (1 KiB).
- File system sharding (docs/2025/07).
- Concurrent lock attempt (simulate second process).
- Read doc `--format md` vs `--format json`.

---

## 6  Cross‑Platform & CI Matrix

- Run entire suite.
- CI YAML snippet (example):

```yaml
strategy:
  matrix:
    os: [ubuntu-latest, macos-latest]
steps:
  - uses: actions/checkout@v4
  - uses: actions-rs/toolchain@v1
    with: { toolchain: stable, profile: minimal }
  - run: cargo test --all --tests
    env:
      AETHEL_TEST_MODE: "1"
```

---

## 7  Adding a New Test (checklist)

1. Copy a template dir (`tests/template_case/`) to next id `NNN_description`.
2. Populate `vault.before/` with minimal state.
3. Write `input.json` or leave empty for read/list.
4. Write shell args in `cli-args.txt`.
5. Run `UPDATE_GOLDEN=1 cargo test cases::NNN_description`; inspect diff.
6. Commit new fixture dir.

---

## 8  Maintaining Fixtures

- **Never edit generated files by hand** (bespoke comment marker `# AUTOGEN`).
- **Keep fixtures minimal;** drop large bodies (>4 KB) unless test demands.
- **Obsolete cases:** move to `tests/retired/` rather than delete.

---

## 9  Golden Policy Enforcement

- PR template **MUST** ask: “Did you run `cargo test` and update goldens?”
- Any failing diff requires explicit regeneration + code review.
- A CI check named “golden‑consistency” MUST pass before merge.

---

## 10  Future Extensions (non‑blocking)

- **Property tests** on Patch merging invariants.
- **Fuzzing** malformed front‑matter & Patch JSON.
- **Golden SQL snapshots** once the index layer (L2) exists—stored as `.sql` dump per case.

---

### End of `golden-tests.md` v0.1

This document is normative for CLI testing. Deviations require a Sign‑off from the protocol owner.
