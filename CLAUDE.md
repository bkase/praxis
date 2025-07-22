# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Aethel is a document management system with a carefully architected design focusing on minimal, precise specifications. The project follows a strict "no overbuilding" philosophy and is currently in the specification phase with no implementation code yet.

## Core Architecture

The system is built around three core primitives:
- **Doc**: A Markdown file with YAML front-matter, identified by UUID
- **Pack**: A directory declaring types (schemas), templates, and migrations  
- **Patch**: A JSON object describing mutations to a Doc

## Implementation Layers

The project follows a strict layered architecture (DO NOT skip layers):
- **L0 - Core Library**: Pure Rust crate with minimal I/O (POSIX FS only)
- **L1 - CLI**: Thin binary wrapper over L0 with JSON-first input/output
- **L2 - Optional Views**: Browse/dump/index capabilities (future)
- **L3 - Transports & Integrations**: RPC/HTTP servers, SDKs (future)

## Development Commands

Since no implementation exists yet, here are the planned commands based on the Software Design Document:

### Build Commands (planned)
```bash
make build          # Build the workspace
make release        # Build in release mode
make check          # Check for compilation errors
make fmt            # Format check
make fmt-fix        # Auto-format code
make lint           # Run clippy linting
make test           # Run all tests
make clean          # Clean build artifacts
```

### CLI Commands (planned for L1)
```bash
aethel init [PATH]                              # Initialize new vault
aethel write doc --json - --output json         # Write doc from JSON patch
aethel read doc <uuid> --output json|md         # Read doc by UUID
aethel check doc <uuid> --output json           # Validate doc
aethel list packs --output json                 # List installed packs
aethel add pack <path> --output json            # Add pack
aethel remove pack <name> --output json         # Remove pack
```

## Project Structure

```
aethel/
├── Cargo.toml              # Workspace definition
├── .mise.toml              # Tool version management
├── Makefile                # Build automation
├── protocol.md             # Core protocol specification
├── implementation-layers.md # Strict implementation sequence
├── sdd.md                  # Software Design Document
└── crates/
    ├── aethel-core/        # L0: Core library
    └── aethel-cli/         # L1: CLI binary
```

## Key Development Principles

1. **JSON-first**: All input/output must support JSON format
2. **No overbuilding**: Implement only L0 and L1 initially
3. **Atomic operations**: All Doc writes use "write to temp, rename" strategy
4. **Protocol compliance**: All errors map to canonical protocol error codes
5. **Schema validation**: Strict JSON Schema (Draft 2020-12) validation

## Error Handling

All errors must map to protocol-defined error codes:
- 400xx: Bad Request / Malformed input
- 404xx: Not Found
- 409xx: Conflict
- 422xx: Validation errors
- 500xx: System errors

## Testing Strategy

- **Unit tests**: For each module in `aethel-core`
- **Conformance tests**: Golden vault fixtures for end-to-end validation
- **Integration tests**: CLI command testing with JSON I/O verification

## Important Constraints

- NO network, JSON-RPC, or SQL in L0/L1
- NO resident processes or sockets in L0/L1  
- NO hidden state outside `.aethel/` directory
- Git operations only via CLI subprocess (not library dependencies)