# Aethel

A radically minimal, precise document management system built on three core primitives: **Doc**, **Pack**, and **Patch**.

[![CI](https://github.com/aethel/aethel/actions/workflows/ci.yml/badge.svg)](https://github.com/aethel/aethel/actions/workflows/ci.yml)
[![License](https://img.shields.io/badge/license-MIT%2FApache--2.0-blue.svg)](LICENSE)
[![Rust Version](https://img.shields.io/badge/rust-1.88.0-orange.svg)](https://www.rust-lang.org)

## Overview

Aethel is a document management system with a carefully architected design focusing on minimal, precise specifications. It provides a powerful foundation for managing structured documents with schema validation, type safety, and atomic operations—all through a simple CLI interface.

### Core Primitives

- **Doc**: A Markdown file with YAML front-matter, identified by UUID
- **Pack**: A directory declaring types (schemas), templates, and migrations  
- **Patch**: A JSON object describing mutations to a Doc

## Key Features

- **Protocol-first design**: Everything operates through well-defined JSON schemas and protocols
- **Atomic operations**: All document writes use "write to temp, rename" strategy for safety
- **Schema validation**: Strict JSON Schema (Draft 2020-12) validation for all documents
- **Git-friendly**: Designed to work seamlessly with version control
- **JSON-first I/O**: Machine-readable input/output for automation and integrations
- **No overbuilding**: Minimal dependencies, no daemons, no databases—just files

## Quick Start

### Installation

```bash
# Clone the repository
git clone https://github.com/aethel/aethel.git
cd aethel

# Install Rust toolchain via mise
mise use

# Build the project
make build

# Run tests
make test
```

### Basic Usage

```bash
# Initialize a new vault
aethel init

# Add a pack (e.g., a journal pack)
aethel add pack ./examples/packs/journal@1.0.0

# Create a new document
echo '{
  "type": "journal.morning",
  "frontmatter": {"mood": "🙂"},
  "body": "Today I learned about Aethel!",
  "mode": "create"
}' | aethel write doc --json - --output json

# Read a document
aethel read doc <uuid>

# List installed packs
aethel list packs --output json
```

## Architecture

Aethel follows a strict layered architecture:

### L0 - Core Library (`aethel-core`)
Pure Rust crate with minimal I/O (POSIX FS only). Provides:
- Doc parsing and serialization
- Pack loading and schema registry
- Patch application logic
- Atomic file operations

### L1 - CLI (`aethel-cli`)
Thin binary wrapper over L0 with JSON-first input/output:
- `init` - Initialize new vault
- `write doc` - Apply patches to documents
- `read doc` - Read documents by UUID
- `check doc` - Validate document schemas
- `list packs` - List installed packs
- `add pack` - Install new packs
- `remove pack` - Uninstall packs

### Future Layers (Not Yet Implemented)
- **L2** - Optional Views: Browse/dump/index capabilities
- **L3** - Transports & Integrations: RPC/HTTP servers, SDKs

## Document Format

Documents are Markdown files with YAML front-matter:

```markdown
---
uuid: 123e4567-e89b-12d3-a456-426614174000
type: journal.morning
created: 2025-07-22T08:00:00Z
updated: 2025-07-22T08:00:00Z
v: 1.0.0
tags: [personal, reflection]
mood: 🙂
---

# My Morning Entry

Today I learned about Aethel!
```

## Pack Structure

Packs define document types and their schemas:

```
packs/journal@1.0.0/
├── pack.json              # Pack manifest
├── types/
│   └── journal.morning.v1.json  # JSON Schema
└── templates/
    └── journal.morning.md       # Document template
```

## Error Handling

Aethel uses a comprehensive error model with protocol-defined error codes:

- **400xx**: Bad Request / Malformed input
- **404xx**: Not Found
- **409xx**: Conflict
- **422xx**: Validation errors
- **500xx**: System errors

All errors include structured data for machine parsing:

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

## Development

### Prerequisites

- Rust 1.88.0 (managed via [mise](https://mise.jdx.dev/))
- Git

### Building

```bash
# Development build
make build

# Release build
make release

# Run all checks (format, lint, test)
make all
```

### Testing

The project includes comprehensive test suites:

- **Unit tests**: Test individual components
- **Integration tests**: Test CLI commands end-to-end
- **Golden tests**: Deterministic snapshot testing

```bash
# Run all tests
make test

# Run with nextest (faster, if installed)
make nextest

# Update golden test snapshots
UPDATE_GOLDEN=1 cargo test
```

### Code Quality

```bash
# Format code
make fmt-fix

# Run linter
make lint

# Security audit
make audit
```

## Documentation

- [Protocol Specification](docs/protocol.md) - Core protocol definition
- [Implementation Layers](docs/implementation-layers.md) - Architectural layers
- [Software Design Document](docs/sdd.md) - Detailed implementation guide
- [Golden Tests](docs/golden-tests.md) - Testing methodology

## Contributing

We welcome contributions! Please ensure:

1. All tests pass (`make test`)
2. Code is formatted (`make fmt`)
3. No clippy warnings (`make lint`)
4. Golden tests are updated if CLI behavior changes

## Philosophy

Aethel embraces radical minimalism:

- **No overbuilding**: We implement only what's needed
- **Protocol-first**: Specifications drive implementation
- **JSON everywhere**: Machine-readable by default
- **Files are the database**: No hidden state, everything in plain files
- **Git-native**: Works perfectly with version control

## License

Licensed under either of:

- Apache License, Version 2.0 ([LICENSE-APACHE](LICENSE-APACHE))
- MIT license ([LICENSE-MIT](LICENSE-MIT))

at your option.

## Status

Currently in active development. L0 (Core Library) and L1 (CLI) are implemented and functional. The project follows semantic versioning, with the current focus on stabilizing the v0.1 protocol.