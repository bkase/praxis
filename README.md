# Praxis Monorepo

This repository hosts the Praxis projects in a single mono-repo. The layout follows the v1 implementation plan in `spec.md`:

- `apps/` – end-user applications (`momentum`, `tutor`).
- `core/` – shared engines and libraries (currently `aethel`).
- `workflows/` – operational playbooks including the journal and weekly planning assets.
- `integrations/` – external service connectors (Google Calendar MCP).
- `docs/` – loops and architecture notes.

## Development Environment

Use [`devenv`](https://devenv.sh) for all tooling. With Nix installed you can run:

```bash
nix run nixpkgs#devenv -- tasks list
```

Common commands:

```bash
nix run nixpkgs#devenv -- tasks run build:aethel
nix run nixpkgs#devenv -- tasks run build:momentum
```

Momentum tasks call `tuist generate` and `xcodebuild` directly, so make sure Xcode 16+ is installed and available at `/Applications/Xcode.app` before running them.

To open an interactive shell with all tooling available:

```bash
nix run nixpkgs#devenv -- shell
```

To open a shell with multiple profiles:

## Workflows

Weekly planning assets originate from `~/Documents/weekly-plan` and live at `workflows/weekly-plan/`. The journal prompt is copied from `~/.config/nix/dotfiles/claude-commands/journal.md` to `workflows/journal/claude-commands/journal.md`.

## CI

GitHub Actions workflow at `.github/workflows/ci.yml` builds and tests every project on pushes and pull requests.
