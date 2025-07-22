The following document provides a precise and detailed Software Design Document (SDD) for the Aethel project, focusing specifically on the implementation of Layer 0 (Core Library) and Layer 1 (CLI) as defined by `implementation-layers.md` and `protocol.md`. This SDD is intended for the engineering team, providing clear guidance on architecture, design choices, error handling, testing, and development workflow.

---

# Aethel Project: Software Design Document (SDD) — L0 & L1 Implementation

*   **Document Version:** 1.0.0
*   **Status:** Draft
*   **Date:** 2024-07-29
*   **Authors:** Your Engineering Architect Team

---

## Table of Contents

1.  Introduction
    1.1. Purpose
    1.2. Scope
    1.3. Audience
2.  High-Level Architecture
    2.1. Layered Design
    2.2. Workspace Structure
3.  Design Principles
    3.1. Rust Best Practices
    3.2. Error Handling Philosophy
    3.3. Modularity and Reusability
    3.4. Performance and Safety
4.  L0: `aethel-core` Crate Specification
    4.1. Responsibilities
    4.2. Core Data Structures
    4.3. Core Functionality
    4.4. Error Model (`aethel-core::error`)
    4.5. Dependencies
    4.6. Internal Module Structure
    4.7. Testing Strategy
5.  L1: `aethel-cli` Crate Specification
    5.1. Responsibilities
    5.2. Command Line Interface Design
    5.3. Input and Output Formats
    5.4. Interaction with L0
    5.5. Error Model (`aethel-cli::error`)
    5.6. Dependencies
    5.7. Internal Module Structure
    5.8. Testing Strategy
6.  Common Components and Utilities
    6.1. UUID Generation
    6.2. Timestamp Handling
    6.3. JSON Schema Validation
    6.4. YAML Parsing
    6.5. File System Operations
    6.6. Git Interaction (Minimal)
7.  Development Workflow
    7.1. Tooling (Mise, Rustup)
    7.2. Makefile Definitions
    7.3. Continuous Integration (GitHub Actions)
8.  Deliverables & Milestone Gates (L0 & L1)
    8.1. L0 Deliverables
    8.2. L1 Deliverables
    8.3. Milestone Gates
9.  Appendices
    9.1. `aethel-core::error::AethelCoreError` Details
    9.2. `aethel-cli::error::AethelCliError` Details
    9.3. Base Front-Matter JSON Schema (for internal struct derivation)
    9.4. Patch JSON Schema (for internal struct derivation)
    9.5. WriteResult JSON Schema (for internal struct derivation)

---

## 1. Introduction

### 1.1. Purpose

This document serves as the authoritative Software Design Document (SDD) for the implementation of Aethel's Layer 0 (Core Library) and Layer 1 (CLI). It aims to provide the engineering team with a precise, detailed, and actionable blueprint, ensuring a consistent approach to development, error handling, testing, and CI/CD. Adherence to this SDD is mandatory for all team members involved in building L0 and L1.

### 1.2. Scope

This SDD details the design and implementation steps for:
*   **L0 (`aethel-core`):** A pure Rust crate encapsulating the core logic for Doc, Pack, and Patch primitives, including parsing, validation, and mutation, with file system interactions limited to POSIX FS.
*   **L1 (`aethel-cli`):** A thin Rust binary built on top of `aethel-core`, providing command-line utilities for interacting with Aethel vaults, adhering to JSON-first input/output principles.

This document explicitly excludes design details for L2, L3, or any features beyond the strict definitions of L0 and L1 as per `implementation-layers.md`.

### 1.3. Audience

This document is primarily for:
*   Engineering Team Leads
*   Rust Developers
*   QA Engineers
*   DevOps Engineers

## 2. High-Level Architecture

### 2.1. Layered Design

Aethel's architecture is strictly layered, as defined in `implementation-layers.md`. L0 forms the bedrock, `aethel-cli` (L1) builds directly on L0, and no higher layers will be implemented until L0 and L1 are stable and pass all exit criteria.

```mermaid
graph TD
    subgraph Aethel Vault
        A[File System (Vault Root)]
    end

    subgraph L0: aethel-core
        B[Doc Parsing & Serialization]
        C[Pack Loading & Schema Registry]
        D[Patch Application Logic]
        E[Doc & Pack Validation]
        F[Atomic File I/O]
    end

    subgraph L1: aethel-cli
        G[Command Line Interface (clap)]
        H[JSON Input/Output Handling]
        I[CLI-Specific Error Reporting]
    end

    I -- Calls --> D
    I -- Calls --> C
    I -- Calls --> B
    H -- Passes Data --> G
    G -- Calls --> I
    A <--> F
```

### 2.2. Workspace Structure

The project will be organized as a Rust workspace to manage multiple crates efficiently.

```
aethel/
├── Cargo.toml                  # Workspace definition
├── .mise.toml                  # Mise tool version declaration
├── Makefile                    # Build, test, format, lint commands
├── .github/
│   └── workflows/
│       └── ci.yml              # GitHub Actions CI workflow
├── implementation-layers.md    # Protocol Layering Document (reference)
├── protocol.md                 # Aethel Protocol Specification (reference)
└── crates/
    ├── aethel-core/            # L0: Core Library
    │   ├── Cargo.toml
    │   └── src/
    │       ├── lib.rs
    │       └── ... (internal modules)
    └── aethel-cli/             # L1: Command Line Interface
        ├── Cargo.toml
        └── src/
            ├── main.rs
            └── ... (internal modules)
```

## 3. Design Principles

### 3.1. Rust Best Practices

*   **Ownership & Borrowing:** Leverage Rust's ownership system for memory safety and concurrency without a garbage collector.
*   **Trait-based Design:** Prefer traits for polymorphism and extensibility where appropriate.
*   **Explicit Error Handling:** Use `Result` and custom error types (`thiserror`) for all fallible operations.
*   **Zero-cost Abstractions:** Ensure abstractions do not incur unnecessary runtime overhead.
*   **Fearless Concurrency:** Design for thread safety from the ground up, though heavy multi-threading is not a primary concern for L0/L1.

### 3.2. Error Handling Philosophy

We will be extremely precise with errors to facilitate debugging, machine parsing, and user feedback.

*   **`thiserror` for Library Errors:** All custom error types within `aethel-core` and `aethel-cli` will derive `thiserror::Error`. This provides clear, idiomatic error definitions and automatic `From` implementations for error chaining.
*   **`anyhow` for Application Errors:** `anyhow::Result` will be used in `aethel-cli`'s `main` function and top-level command handlers for simplified error propagation and contextual error reporting to the user, wrapping `aethel-core` errors.
*   **Protocol Error Codes:** Every relevant error variant in `aethel-core` will map directly to one of the canonical error codes defined in `protocol.md` (§6.2). This mapping will be exposed via a method on the error enum.
*   **Detailed Error Data:** Errors will carry structured data (`pointer`, `expected`, `got` for validation errors) where beneficial, to aid in machine processing and debugging.

### 3.3. Modularity and Reusability

*   **Clear Crate Boundaries:** `aethel-core` will be a standalone library with no knowledge of the CLI or networking. `aethel-cli` will be a thin wrapper.
*   **Internal Module Organization:** Within each crate, logical components will be separated into distinct modules (`doc.rs`, `pack.rs`, `patch.rs`, `error.rs`, etc.).
*   **Data Structures over Shared Logic:** Core data structures will be clearly defined and passed between functions, minimizing global state.

### 3.4. Performance and Safety

*   **Memory Efficiency:** Avoid unnecessary allocations and copies. Prefer references (`&str`, `&[u8]`) where data ownership is not required.
*   **Atomic File Operations:** All write operations impacting Doc files will utilize a "write to temp, rename" strategy to ensure atomicity and prevent data corruption during crashes or interruptions.
*   **Input Validation:** Strict input validation will be performed at API boundaries (e.g., `Patch` struct deserialization, Doc parsing) and against JSON Schemas.

## 4. L0: `aethel-core` Crate Specification

### 4.1. Responsibilities

The `aethel-core` crate is the foundational library. Its responsibilities include:
*   Defining the canonical Rust representations for `Doc`, `Pack`, `Patch`, and `WriteResult`.
*   Parsing Markdown files into `Doc` structs (including YAML front-matter).
*   Serializing `Doc` structs back into Markdown files.
*   Loading `Pack` definitions from `pack.json` and its associated schema files.
*   Maintaining a registry of loaded `Pack`s and their associated JSON Schemas.
*   Applying `Patch` objects to `Doc`s, handling all defined `mode`s (`create`, `append`, `merge_frontmatter`, `replace_body`).
*   Enforcing all protocol validation rules:
    *   Base Front-Matter presence and types.
    *   JSON Schema validation for Doc front-matter.
    *   UUID and type consistency.
    *   Atomic file writes.
*   Generating UUIDs (v7 recommended).
*   Managing timestamps (`created`, `updated`).
*   Resolving Doc and Pack paths within a given vault root.

### 4.2. Core Data Structures

All data structures will be designed for efficient serialization/deserialization using `serde`.

*   `Doc`:
    ```rust
    // In src/doc.rs
    #[derive(Debug, Clone, Serialize, Deserialize)]
    pub struct Doc {
        // Base front-matter fields
        pub uuid: uuid::Uuid,
        #[serde(rename = "type")]
        pub doc_type: String, // Use doc_type to avoid keyword conflict
        pub created: chrono::DateTime<chrono::Utc>,
        pub updated: chrono::DateTime<chrono::Utc>,
        pub v: semver::Version,
        pub tags: Vec<String>,
        // Additional front-matter fields, validated by Pack's schema
        #[serde(flatten)]
        pub frontmatter_extra: serde_json::Value, // Will be an Object
        pub body: String,
    }
    ```
*   `Pack`:
    ```rust
    // In src/pack.rs
    #[derive(Debug, Clone, Serialize, Deserialize)]
    pub struct Pack {
        pub name: String,
        pub version: semver::Version,
        #[serde(rename = "protocolVersion")]
        pub protocol_version: semver::Version,
        pub types: Vec<PackTypeEntry>,
        // Internal: path to the pack directory
        #[serde(skip)]
        pub path: std::path::PathBuf,
    }

    #[derive(Debug, Clone, Serialize, Deserialize)]
    pub struct PackTypeEntry {
        pub id: String, // e.g., "journal.morning"
        pub version: semver::Version,
        pub schema: std::path::PathBuf, // Relative path to schema file
        pub template: Option<std::path::PathBuf>, // Relative path to template file
        // Internal: compiled schema object
        #[serde(skip)]
        pub compiled_schema: Option<jsonschema::JSONSchema>,
    }
    ```
*   `Patch`:
    ```rust
    // In src/patch.rs
    #[derive(Debug, Clone, Serialize, Deserialize)]
    #[serde(rename_all = "camelCase")] // Match protocol JSON
    pub struct Patch {
        pub uuid: Option<uuid::Uuid>,
        #[serde(rename = "type")]
        pub doc_type: Option<String>,
        pub frontmatter: Option<serde_json::Value>, // Will be an Object
        pub body: Option<String>,
        pub mode: PatchMode,
    }

    #[derive(Debug, Clone, Serialize, Deserialize)]
    #[serde(rename_all = "snake_case")] // Match protocol enum values
    pub enum PatchMode {
        Create,
        Append,
        MergeFrontmatter,
        ReplaceBody,
    }
    ```
*   `WriteResult`:
    ```rust
    // In src/write_result.rs
    #[derive(Debug, Clone, Serialize, Deserialize)]
    #[serde(rename_all = "camelCase")] // Match protocol JSON
    pub struct WriteResult {
        pub uuid: uuid::Uuid,
        pub path: std::path::PathBuf,
        pub committed: bool, // True if a change was written to disk
        pub warnings: Vec<String>,
    }
    ```

### 4.3. Core Functionality

**Public API (exposed from `aethel_core::lib.rs`):**

*   `apply_patch(vault_root: &Path, patch: Patch) -> Result<WriteResult, AethelCoreError>`:
    *   Main entry point for mutating Docs.
    *   Handles UUID resolution/generation.
    *   Loads existing Doc if `uuid` is present.
    *   Applies changes based on `PatchMode`.
    *   Updates `updated` timestamp.
    *   Performs schema validation post-merge.
    *   Writes Doc atomically to disk.
    *   Detects no-op changes for `committed` flag.
    *   Emits `AethelCoreError` for any failures.
*   `read_doc(vault_root: &Path, uuid: &Uuid) -> Result<Doc, AethelCoreError>`:
    *   Locates and reads a Doc file.
    *   Parses front-matter and body.
    *   Returns `Doc` struct.
*   `validate_doc(vault_root: &Path, doc: &Doc) -> Result<(), AethelCoreError>`:
    *   Loads the associated Pack and schema for the Doc's `doc_type`.
    *   Performs full JSON Schema validation on the Doc's front-matter.
    *   Returns `Ok(())` on success, `Err(AethelCoreError::SchemaValidation)` on failure.
*   `load_pack(pack_path: &Path) -> Result<Pack, AethelCoreError>`:
    *   Parses `pack.json`.
    *   Loads and compiles all type schemas.
    *   Returns `Pack` struct.
*   `load_packs_from_vault(vault_root: &Path) -> Result<Vec<Pack>, AethelCoreError>`:
    *   Scans `vault_root/packs/` directory.
    *   Loads all valid Pack definitions found.
    *   Returns a vector of `Pack`s.
*   `add_pack(vault_root: &Path, source: &str) -> Result<Pack, AethelCoreError>`:
    *   Supports adding packs from local paths or potentially remote (Git, though Git cloning itself would likely be an L2/L3 consideration or rely on `git` CLI, keeping L0 pure). For L0/L1, we will primarily support local paths, mirroring `cp -r`.
    *   Validates pack structure.
    *   Copies the pack to `vault_root/packs/`.
    *   Returns the loaded `Pack`.
*   `remove_pack(vault_root: &Path, pack_name: &str) -> Result<bool, AethelCoreError>`:
    *   Locates the pack directory by name in `vault_root/packs/`.
    *   Removes the directory.
    *   Returns `true` if removed, `false` if not found.

### 4.4. Error Model (`aethel-core::error`)

All fallible operations in `aethel-core` will return `Result<T, AethelCoreError>`.

```rust
// In crates/aethel-core/src/error.rs
use thiserror::Error;
use std::path::PathBuf;
use uuid::Uuid;
use semver::Version;
use serde_json::Value;

#[derive(Error, Debug)]
#[non_exhaustive] // Allow adding new error variants without breaking consumers
pub enum AethelCoreError {
    // 400xx: Bad Request / Malformed input
    #[error("Malformed request JSON: {0}")]
    #[protocol_code(40000)]
    MalformedRequestJson(#[source] serde_json::Error),
    #[error("Unknown patch mode '{0}'")]
    #[protocol_code(40001)]
    UnknownPatchMode(String),
    #[error("Attempted to set system-controlled key '{key}' in frontmatter.")]
    #[protocol_code(40003)]
    AttemptToSetSystemKey { key: String },
    #[error("Missing required field '{field}' for patch mode '{mode}'")]
    #[protocol_code(40004)]
    MissingRequiredField { field: String, mode: String },
    #[error("Invalid UUID format: {0}")]
    #[protocol_code(40005)]
    InvalidUuidFormat(#[source] uuid::Error),
    #[error("Invalid SemVer format: {0}")]
    #[protocol_code(40006)]
    InvalidSemVerFormat(#[source] semver::Error),
    #[error("Invalid ISO 8601 UTC timestamp format: {0}")]
    #[protocol_code(40007)]
    InvalidTimestampFormat(#[source] chrono::ParseError),
    #[error("Malformed YAML frontmatter: {0}")]
    #[protocol_code(40008)]
    MalformedYaml(#[source] serde_yaml::Error),
    #[error("Malformed Doc file: {0}")]
    #[protocol_code(40009)]
    MalformedDocFile(String), // e.g., missing '---' delimiters

    // 404xx: Not Found
    #[error("Doc with UUID '{0}' not found at '{1}'")]
    #[protocol_code(40401)]
    DocNotFound(Uuid, PathBuf),
    #[error("Pack '{0}' not found at '{1}'")]
    #[protocol_code(40402)]
    PackNotFound(String, PathBuf),
    #[error("Pack type '{0}' not found within pack '{1}'")]
    #[protocol_code(40403)]
    PackTypeNotFound(String, String),
    #[error("Schema file '{0}' not found for pack type '{1}'")]
    #[protocol_code(40404)]
    SchemaFileNotFound(PathBuf, String),

    // 409xx: Conflict
    #[error("Type mismatch: Doc has type '{existing_type}', patch specified '{patch_type}'")]
    #[protocol_code(40902)]
    TypeMismatchOnUpdate { existing_type: String, patch_type: String },
    #[error("Concurrent write conflict detected.")]
    #[protocol_code(40903)]
    ConcurrentWriteConflict, // Requires file locking mechanism

    // 422xx: Unprocessable Entity (Validation)
    #[error("Schema validation failed: {message}. Pointer: {pointer}, Expected: {expected}, Got: {got}. Original error: {source}")]
    #[protocol_code(42200)]
    SchemaValidation {
        message: String,
        pointer: Option<String>,
        expected: Option<String>,
        got: Option<String>,
        #[source]
        source: Option<Box<dyn std::error::Error + Send + Sync>>,
    },
    #[error("Unknown frontmatter key '{key}' not allowed by schema for type '{doc_type}'")]
    #[protocol_code(42201)]
    UnknownFrontmatterKey { key: String, doc_type: String },
    #[error("Pack '{pack_name}' protocol version '{pack_protocol_version}' is incompatible with current protocol version '{current_protocol_version}' (major version mismatch).")]
    #[protocol_code(42601)]
    ProtocolVersionMismatch {
        pack_name: String,
        pack_protocol_version: Version,
        current_protocol_version: Version,
    },

    // 500xx: Internal Server Error (System)
    #[error("File system I/O error on path '{path}': {source}")]
    #[protocol_code(50000)]
    Io {
        #[source]
        source: std::io::Error,
        path: PathBuf,
    },
    #[error("Atomic file write failed for '{path}': {source}")]
    #[protocol_code(50001)]
    AtomicWriteFailed {
        #[source]
        source: Box<dyn std::error::Error + Send + Sync>, // Can be tempfile::PersistError, etc.
        path: PathBuf,
    },
    #[error("Internal schema compilation error: {0}")]
    #[protocol_code(50002)]
    SchemaCompilationError(String),
    #[error("Internal JSON processing error: {0}")]
    #[protocol_code(50003)]
    JsonProcessingError(#[source] serde_json::Error),
    #[error("Internal lock file error: {0}")]
    #[protocol_code(50004)]
    LockFileError(String), // For .aethel/lock

    // Catch-all for unexpected errors
    #[error("An unexpected internal error occurred: {0}")]
    #[protocol_code(50099)]
    Other(String),
}

// Macro to attach protocol codes to error variants
// This will be a custom attribute macro or a simple function
impl AethelCoreError {
    pub fn protocol_code(&self) -> u16 {
        match self {
            AethelCoreError::MalformedRequestJson(_) => 40000,
            AethelCoreError::UnknownPatchMode(_) => 40001,
            AethelCoreError::AttemptToSetSystemKey { .. } => 40003,
            AethelCoreError::MissingRequiredField { .. } => 40004,
            AethelCoreError::InvalidUuidFormat(_) => 40005,
            AethelCoreError::InvalidSemVerFormat(_) => 40006,
            AethelCoreError::InvalidTimestampFormat(_) => 40007,
            AethelCoreError::MalformedYaml(_) => 40008,
            AethelCoreError::MalformedDocFile(_) => 40009,
            AethelCoreError::DocNotFound(_, _) => 40401,
            AethelCoreError::PackNotFound(_, _) => 40402,
            AethelCoreError::PackTypeNotFound(_, _) => 40403,
            AethelCoreError::SchemaFileNotFound(_, _) => 40404,
            AethelCoreError::TypeMismatchOnUpdate { .. } => 40902,
            AethelCoreError::ConcurrentWriteConflict => 40903,
            AethelCoreError::SchemaValidation { .. } => 42200,
            AethelCoreError::UnknownFrontmatterKey { .. } => 42201,
            AethelCoreError::ProtocolVersionMismatch { .. } => 42601,
            AethelCoreError::Io { .. } => 50000,
            AethelCoreError::AtomicWriteFailed { .. } => 50001,
            AethelCoreError::SchemaCompilationError(_) => 50002,
            AethelCoreError::JsonProcessingError(_) => 50003,
            AethelCoreError::LockFileError(_) => 50004,
            AethelCoreError::Other(_) => 50099,
        }
    }

    // Helper to construct SchemaValidation error from jsonschema::ValidationError
    pub fn from_json_schema_error(err: &jsonschema::ValidationError) -> Self {
        AethelCoreError::SchemaValidation {
            message: err.to_string(),
            pointer: err.instance_path.as_deref().map(String::from),
            expected: err.schema_url.as_deref().map(String::from), // Example mapping, adjust as needed
            got: err.instance.as_ref().map(|v| v.to_string()),
            source: Some(Box::new(err.clone())), // Clone for source, if possible
        }
    }

    // Helper to construct Io error with path context
    pub fn io_error(err: std::io::Error, path: impl Into<PathBuf>) -> Self {
        AethelCoreError::Io { source: err, path: path.into() }
    }
}
```

### 4.5. Dependencies

*   `serde`: For (de)serialization of structs to/from JSON/YAML.
*   `serde_json`: For JSON manipulation and `serde_json::Value`.
*   `serde_yaml`: For YAML parsing of front-matter.
*   `uuid`: For UUID v4/v7 generation and parsing.
*   `chrono`: For `DateTime` and ISO 8601 timestamp handling.
*   `semver`: For `Version` and version range handling.
*   `jsonschema`: For JSON Schema validation (Draft 2020-12).
*   `thiserror`: For declarative error types.
*   `tempfile`: For atomic file writes (write to temp, rename).
*   `glob`: For discovering packs in `packs/` directory.
*   `walkdir`: For efficient directory traversal for Docs and Packs.
*   `once_cell`: For lazy static initialization of common schemas (e.g., base front-matter).
*   `parking_lot`: For lightweight mutexes/rwlocks for concurrent access to in-memory resources (e.g., Pack registry, `.aethel/lock` file).

### 4.6. Internal Module Structure

```
crates/aethel-core/src/
├── lib.rs
├── error.rs                # Custom error types and protocol code mapping
├── doc.rs                  # Doc struct, parsing (from md), serialization (to md)
├── pack.rs                 # Pack struct, loading, schema compilation, Pack registry
├── patch.rs                # Patch struct, PatchMode enum, core `apply_patch` logic
├── vault.rs                # Vault-level operations: path resolution, atomic file I/O, lock management
├── schemas.rs              # Contains pre-compiled base JSON schemas, e.g., for `base-frontmatter.json`
├── validate.rs             # Helper functions for `Doc` and `Patch` validation against schemas
└── utils.rs                # General utilities: UUID generation, timestamp formatting
```

### 4.7. Testing Strategy

*   **Unit Tests:**
    *   For each module (`doc.rs`, `pack.rs`, `patch.rs`, etc.), `#[cfg(test)]` modules will contain unit tests.
    *   Focus on isolated component logic: parsing specific YAML, applying a single patch mode, validating a schema.
    *   Use `assert_matches!` from `assert_matches` crate for robust error matching.
    *   Use `rstest` for parameterized tests, especially for various `PatchMode` scenarios or different schema variations.
*   **Fixtures (`tests/fixtures/`):**
    *   A dedicated `tests/fixtures/` directory will contain sample `*.md` Docs, `*.json` Patches, and `pack.json` definitions.
    *   These will serve as "golden files" for conformance tests.
    *   Examples: `tests/fixtures/valid_doc_1.md`, `tests/fixtures/patch_create_journal.json`, `tests/fixtures/pack_journal@1.0.0/`.
*   **Conformance Tests (Integration):**
    *   Located in `crates/aethel-core/tests/` (outside `src/`).
    *   Mimic the `protocol.md`'s "Golden vault" concept.
    *   Tests will set up a temporary vault (using `tempfile::tempdir()`).
    *   Apply sequences of `Patch`es from fixtures.
    *   Assert on the final file bytes of the Doc (after `apply_patch`), using `insta::assert_snapshot!` for stable, deterministic outputs.
    *   Assert on `WriteResult` JSON output.
    *   Test error conditions: attempt invalid patches, expect specific `AethelCoreError` variants and protocol codes.
    *   Schema evolution tests: simulate migrations by applying patches for new schema versions and validating against updated schemas. (Though migration logic itself is L2, the ability of L0 to *validate* against new schemas is crucial).

## 5. L1: `aethel-cli` Crate Specification

### 5.1. Responsibilities

The `aethel-cli` crate provides the command-line interface for Aethel. Its responsibilities include:
*   Parsing command-line arguments and flags using `clap`.
*   Orchestrating calls to `aethel-core` functions based on user commands.
*   Handling JSON input from stdin (`--json -`).
*   Producing JSON output (`--output json`) for machine consumption, including error objects.
*   Providing user-friendly, human-readable output by default.
*   Mapping `aethel-core` errors to CLI-specific error representations for display.
*   Managing the vault context (e.g., current directory or explicit `--vault-root` flag).

### 5.2. Command Line Interface Design

The CLI will strictly adhere to the `protocol.md`'s specified commands and flags.

*   `aethel [OPTIONS] <COMMAND>`
*   Global options:
    *   `--vault-root <PATH>`: Explicitly specify the vault root. Defaults to current directory or ancestor with `docs/` and `packs/`.
*   Commands:
    *   `init [PATH]`: Initializes a new Aethel vault at `PATH` (or current directory), creating `docs/`, `packs/`, `.aethel/`.
    *   `write doc [--json -] [--output json]`:
        *   Accepts `Patch` JSON from stdin (`--json -`).
        *   Outputs `WriteResult` JSON if `--output json`.
        *   Otherwise, prints human-readable success message.
    *   `read doc <uuid> [--output json | --output md]`:
        *   Reads a Doc by UUID.
        *   Outputs raw Markdown if `--output md` (default).
        *   Outputs JSON representation of Doc (front-matter + body) if `--output json`.
    *   `check doc <uuid> [--autofix] [--output json]`:
        *   Validates a Doc by UUID.
        *   `--autofix`: (Stretch goal for L1, mostly L2 related but basic fixes like sorting keys could be here) Attempts to fix minor issues like YAML key sorting.
        *   Outputs validation result (validity, errors, fixed status) in JSON if `--output json`. Otherwise, human-readable summary.
    *   `list packs [--output json]`:
        *   Lists all installed packs.
        *   Outputs list of pack info in JSON if `--output json`.
        *   Otherwise, human-readable table.
    *   `add pack <path-or-url> [--output json]`:
        *   Adds a pack from a local path (or potentially a Git URL, though this might involve shelling out to `git` for L1).
        *   Outputs `PackInfo` in JSON if `--output json`.
    *   `remove pack <name> [--output json]`:
        *   Removes an installed pack by name.
        *   Outputs `{ removed: bool }` in JSON if `--output json`.

### 5.3. Input and Output Formats

*   **JSON First:**
    *   For commands expecting structured input (e.g., `write doc`), `--json -` will signal that input (a `Patch` object) should be read from stdin.
    *   For all commands, `--output json` will serialize the primary command result (e.g., `WriteResult`, `Doc`, list of packs, error object) to stdout as JSON.
*   **Human-readable Default:** If `--output json` is not specified, CLI will print concise, human-readable messages or formatted text (e.g., raw Markdown for `read doc`).
*   **Error Output:** When an error occurs and `--output json` is active, a structured error JSON object (`{ code, message, data }`) will be emitted to `stderr` (or `stdout` if design dictates for tool calls). Otherwise, human-readable error messages will be printed to `stderr`.

### 5.4. Interaction with L0

`aethel-cli` will act as a direct caller of `aethel-core`'s public API.
Example for `write doc`:
1.  Parse CLI arguments with `clap`.
2.  Read `Patch` JSON from stdin if `--json -`.
3.  Determine `vault_root`.
4.  Call `aethel_core::apply_patch(vault_root, patch)`.
5.  Handle `Result`:
    *   If `Ok(write_result)`, print `write_result` (JSON or human-readable).
    *   If `Err(core_error)`, wrap in `AethelCliError` and print (JSON or human-readable).

### 5.5. Error Model (`aethel-cli::error`)

`aethel-cli` will have its own error type, `AethelCliError`, primarily for CLI-specific issues (e.g., argument parsing, I/O on stdin/stdout), and for wrapping `AethelCoreError` for presentation.

```rust
// In crates/aethel-cli/src/error.rs
use thiserror::Error;
use std::path::PathBuf;
use aethel_core::AethelCoreError; // Import L0's error type

#[derive(Error, Debug)]
pub enum AethelCliError {
    #[error("Failed to parse command-line arguments: {0}")]
    CliParse(#[from] clap::Error),
    #[error("I/O error: {source} on {path}")]
    Io {
        #[source]
        source: std::io::Error,
        path: String,
    },
    #[error("Failed to parse JSON input from stdin: {0}")]
    JsonInputParse(#[from] serde_json::Error),
    #[error("Vault root not found or invalid: '{0}'")]
    VaultRootNotFound(PathBuf),
    #[error("Error from core library: {0}")]
    #[from] // Automatically convert AethelCoreError to AethelCliError
    CoreError(AethelCoreError),
    #[error("Failed to initialize vault at '{path}': {source}")]
    VaultInitFailed {
        path: PathBuf,
        #[source]
        source: std::io::Error,
    },
    #[error("Unknown pack source format: {0}")]
    UnknownPackSource(String),
    // ... potentially other CLI-specific errors
}

impl AethelCliError {
    // Helper for printing structured error output consistent with protocol
    pub fn to_protocol_json(&self) -> serde_json::Value {
        let code = match self {
            AethelCliError::CoreError(e) => e.protocol_code(),
            AethelCliError::CliParse(_) => 40000, // Generic bad request for CLI args
            AethelCliError::JsonInputParse(_) => 40000,
            AethelCliError::Io { .. } => 50000,
            AethelCliError::VaultRootNotFound(_) => 40401, // Map to DocNotFound if more specific not possible
            AethelCliError::VaultInitFailed { .. } => 50000,
            AethelCliError::UnknownPackSource(_) => 40000,
        };
        serde_json::json!({
            "code": code,
            "message": self.to_string(),
            "data": match self {
                AethelCliError::CoreError(e) => {
                    // Extract structured data from CoreError if available
                    match e {
                        AethelCoreError::SchemaValidation { pointer, expected, got, .. } => {
                            serde_json::json!({
                                "pointer": pointer,
                                "expected": expected,
                                "got": got
                            })
                        },
                        _ => serde_json::Value::Null,
                    }
                },
                _ => serde_json::Value::Null,
            }
        })
    }
}
```

### 5.6. Dependencies

*   `clap`: For command-line argument parsing.
*   `serde`: For (de)serialization.
*   `serde_json`: For JSON input/output.
*   `anyhow`: For simplified error handling in `main`.
*   `aethel-core`: The core library, as a dependency.
*   `thiserror`: For declarative error types for CLI-specific errors.
*   `tracing` / `tracing-subscriber`: For structured logging, valuable for debugging CLI applications.

### 5.7. Internal Module Structure

```
crates/aethel-cli/src/
├── main.rs                 # CLI entry point, argument parsing, command dispatch
├── error.rs                # CLI-specific error types, error presentation logic
└── commands/               # Module for each CLI command
    ├── mod.rs
    ├── init.rs
    ├── write.rs
    ├── read.rs
    ├── check.rs
    ├── list.rs
    ├── add_pack.rs
    └── remove_pack.rs
```

### 5.8. Testing Strategy

*   **Integration Tests (`crates/aethel-cli/tests/`):**
    *   These tests will interact with the compiled `aethel-cli` binary.
    *   Use `assert_cmd` crate to run CLI commands and assert on stdout/stderr and exit codes.
    *   Use `tempfile::tempdir()` to create isolated temporary vault environments for each test.
    *   Test end-to-end flows: `init` -> `add pack` -> `write doc` -> `read doc` -> `check doc`.
    *   Verify JSON output formats using `serde_json::from_str` and assertions on the deserialized `Value`.
    *   Verify human-readable output for defaults.
    *   Test error cases: invalid arguments, non-existent UUIDs, schema validation failures (expecting correct error codes and messages).
    *   The "Golden vault" concept from L0 will be extended here, but tests will invoke the CLI binary instead of directly calling core functions.
    *   **GitHub Actions:** These integration tests will be run as part of the CI/CD pipeline.

## 6. Common Components and Utilities

These are shared principles or helpers that might live in `aethel-core/src/utils.rs` or be internal functions.

### 6.1. UUID Generation

*   Use `uuid::Uuid::new_v7()` for new Doc creation.
*   Ensure UUID parsing is robust for both v4 and v7 as per protocol.

### 6.2. Timestamp Handling

*   Use `chrono::Utc::now()` for `created` and `updated` timestamps.
*   Format all timestamps to ISO 8601 UTC strings (`YYYY-MM-DDTHH:MM:SSZ` or with milliseconds `YYYY-MM-DDTHH:MM:SS.SSSZ`) using `chrono::DateTime::to_rfc3339()`.
*   Parse incoming timestamps using `chrono::DateTime::parse_from_rfc3339()`.

### 6.3. JSON Schema Validation

*   `jsonschema` crate will be used for schema compilation and validation.
*   The `protocol.md` appendices provide the base schemas. These will be loaded once at application startup (or lazily) and compiled into `jsonschema::JSONSchema` objects.
*   Custom `jsonschema::CompilationOptions` might be needed for Draft 2020-12 support.
*   Schema validation errors from `jsonschema` will be carefully mapped to `AethelCoreError::SchemaValidation` with detailed `pointer`, `expected`, `got` fields.

### 6.4. YAML Parsing

*   `serde_yaml` will be used for deserializing Doc front-matter.
*   It supports YAML 1.2.
*   Error handling for malformed YAML will map to `AethelCoreError::MalformedYaml`.

### 6.5. File System Operations

*   All file paths will be handled using `std::path::PathBuf` and `std::path::Path`.
*   `std::fs` for basic reads.
*   `tempfile` crate for atomic writes: create a temporary file in the target directory, write content, then atomically rename it to the final destination. This prevents data loss or corruption if the process crashes during a write.
*   Vault path resolution: The `vault_root` will be resolved by searching for `docs/` and `packs/` directories upwards from the current working directory, or by using an explicit `--vault-root` argument.
*   `fs_extra` (optional, for `copy_dir_all` for `add pack` source) or manually walking and copying. For L0, simple `std::fs` operations will be preferred.

### 6.6. Git Interaction (Minimal for L0/L1)

*   The protocol recommends `git pull --rebase` and `git commit` for concurrency.
*   For L0/L1, this will be handled by shelling out to the `git` CLI using `std::process::Command`. This keeps `aethel-core` free of Git-specific dependencies and simplifies implementation for now.
*   The responsibility for these `git` calls will reside in `aethel-cli` or an internal utility called by `aethel-cli` *after* `aethel-core::apply_patch` completes successfully.
*   An *optional* `.aethel/lock` file will be implemented using `fslock` or similar crate/manual file locking to serialize writes within the `aethel-core` logic, returning `40903` on conflict. This is distinct from Git-level concurrency.

## 7. Development Workflow

### 7.1. Tooling (Mise, Rustup)

*   **Rust Toolchain:** Managed via `mise`. The `.mise.toml` at the project root will specify the exact Rust toolchain version.
    ```toml
    # .mise.toml
    [tools]
    rust = "1.79.0" # Specify a precise stable version
    # Potentially other tools if needed for specific dev tasks
    ```
*   **Mise Usage:** Developers will be instructed to run `mise use` in the project root to ensure they are using the correct toolchain and dependencies.
*   **Rustup:** Will be the underlying mechanism for installing Rust toolchains used by `mise`.

### 7.2. Makefile Definitions

A `Makefile` will serve as the single source of truth for common development tasks, usable by developers and CI.

```makefile
.PHONY: all build release check fmt lint test clean

# Default target: build, format check, lint, test
all: build fmt lint test

# Build the workspace
build:
	cargo build --workspace

# Build the workspace in release mode
release:
	cargo build --workspace --release

# Check for compilation errors without building binaries
check:
	cargo check --workspace

# Format code. `check` ensures no unformatted files, `fix` fixes them.
fmt:
	cargo fmt --all -- --check
.PHONY: fmt-fix
fmt-fix:
	cargo fmt --all

# Run clippy for linting. `-D warnings` treats warnings as errors.
lint:
	cargo clippy --workspace --all-targets --all-features -- -D warnings

# Run all tests in the workspace
test:
	cargo test --workspace

# Clean build artifacts
clean:
	cargo clean

# Run cargo-nextest (if installed via mise) for faster testing (optional but recommended)
.PHONY: nextest
nextest:
	cargo nextest run --workspace

# Run cargo audit for security vulnerabilities (if installed via mise)
.PHONY: audit
audit:
	cargo audit

# Run cargo udeps to find unused dependencies
.PHONY: udeps
udeps:
	cargo udeps --workspace

```

### 7.3. Continuous Integration (GitHub Actions)

A GitHub Actions workflow will automate build, lint, format, and test steps on every push and pull request.

```yaml
# .github/workflows/ci.yml
name: Rust CI

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

env:
  CARGO_TERM_COLOR: always

jobs:
  build_and_test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      # Setup Mise (or directly Rustup) for toolchain management
      - name: Setup Mise
        uses: jdxcode/mise@v1 # Or specific version
        with:
          version: 'latest' # Ensure mise is available

      - name: Use project-defined tools with Mise
        run: mise use --install

      - name: Check formatting
        run: make fmt

      - name: Run clippy lints
        run: make lint

      - name: Run tests
        run: make test

      - name: Build project (debug)
        run: make build

      - name: Build project (release)
        run: make release

      # Optional: Run security audit
      - name: Run cargo audit
        run: mise run -- cargo audit --deny warnings || true # Allow audit to fail without breaking CI temporarily
        continue-on-error: true # For initial implementation, can be changed later
```

## 8. Deliverables & Milestone Gates (L0 & L1)

### 8.1. L0 Deliverables

*   `crates/aethel-core/`: Complete and functional Rust library.
*   `crates/aethel-core/src/doc.rs`, `pack.rs`, `patch.rs`, `error.rs`, `vault.rs`, `schemas.rs`, `validate.rs`, `utils.rs` with full implementation of structures and logic.
*   `crates/aethel-core/Cargo.toml`: Correct dependencies declared.
*   `tests/fixtures/*.md`, `*.json`: Comprehensive set of unit and integration test fixtures.
*   Documentation: Inline `rustdoc` for all public API items; README.md for the `aethel-core` crate providing an overview.
*   All `aethel-core` unit and conformance tests pass.

### 8.2. L1 Deliverables

*   `crates/aethel-cli/`: Complete and functional Rust binary.
*   `crates/aethel-cli/src/main.rs` and `commands/*.rs` fully implementing all specified CLI commands.
*   `crates/aethel-cli/Cargo.toml`: Correct dependencies declared, including `aethel-core`.
*   CLI documentation (`aethel --help`, `aethel <command> --help`).
*   JSON samples for `Patch` input and `WriteResult`/`Doc` output, matching protocol specifications.
*   All `aethel-cli` integration tests pass (end-to-end flows via shell & JSON).
*   The `aethel-cli` binary successfully runs and functions in the CI environment.

### 8.3. Milestone Gates

*   **M0 → M1 (Core Crate Stable):**
    *   **Must be true:** `aethel-core` crate passes all unit and conformance tests. All protocol error codes are correctly emitted. JSON Schemas for `base-frontmatter`, `patch`, and `write-result` are locked for v0.1 and mirrored in internal Rust types.
    *   **Verification:** CI passes for `aethel-core` tests. Manual review of `aethel-core` API and error handling.
*   **M1 → M2 (CLI Adopted):**
    *   **Must be true:** `aethel-cli` implements all specified commands (`init`, `write doc`, `read doc`, `check doc`, `list packs`, `add pack`, `remove pack`). All commands support `--json -` for input and `--output json` for output. End-to-end flows work via shell commands and JSON I/O, as verified by integration tests. No feature gaps in `write` and `validate` operations via the CLI.
    *   **Verification:** CI passes for `aethel-cli` integration tests. Manual end-to-end testing by team members for usability. JSON samples are generated and match protocol spec.

## 9. Appendices

### 9.1. `aethel-core::error::AethelCoreError` Details

(See section 4.4 for `AethelCoreError` enum definition and `protocol_code()` mapping)

### 9.2. `aethel-cli::error::AethelCliError` Details

(See section 5.5 for `AethelCliError` enum definition and `to_protocol_json()` method)

### 9.3. Base Front-Matter JSON Schema (for internal struct derivation)

This schema from `protocol.md` Appendix A will be used internally to ensure correct parsing and validation of the base fields. A Rust struct, potentially internal to `doc.rs`, will reflect this.

```json
{
  "$id": "https://aethel.dev/schemas/base-frontmatter.json",
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "type": "object",
  "required": ["uuid", "type", "created", "updated", "v", "tags"],
  "properties": {
    "uuid": { "type": "string", "pattern": "^[0-9a-fA-F-]{36}$" },
    "type": { "type": "string" },
    "created": { "type": "string", "format": "date-time" },
    "updated": { "type": "string", "format": "date-time" },
    "v": { "type": "string", "pattern": "^[0-9]+\\.[0-9]+\\.[0-9]+$" },
    "tags": { "type": "array", "items": { "type": "string" }, "default": [] }
  },
  "additionalProperties": false
}
```

### 9.4. Patch JSON Schema (for internal struct derivation)

This schema from `protocol.md` Appendix B will directly inform the `Patch` struct definition in `patch.rs`.

```json
{
  "$id": "https://aethel.dev/schemas/patch.json",
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "type": "object",
  "required": ["mode"],
  "properties": {
    "uuid": { "type": ["string", "null"], "pattern": "^[0-9a-fA-F-]{36}$" },
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

### 9.5. WriteResult JSON Schema (for internal struct derivation)

This schema from `protocol.md` Appendix C will inform the `WriteResult` struct definition in `write_result.rs`.

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
    "warnings": { "type": "array", "items": { "type": "string" } }
  },
  "additionalProperties": false
}
```

---