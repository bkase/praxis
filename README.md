# Praxis Monorepo

This repository hosts the Praxis projects in a single mono-repo. The layout follows the v1 implementation plan in `spec.md`:

- `apps/` – end-user applications (`momentum`, `tutor`).
- `core/` – shared engines and libraries (currently `aethel`).
- `workflows/` – operational playbooks including the journal and weekly planning assets.
- `integrations/` – external service connectors (Google Calendar MCP).
- `docs/` – loops and architecture notes.

## Development Environment

Use [`devenv`](https://devenv.sh) for all tooling. Once devenv is installed, you can run:

```bash
devenv tasks list
```

Common commands:

```bash
devenv tasks run build:aethel
devenv tasks run build:momentum --impure
```

**Note:** Momentum tasks require `--impure` because they need access to Xcode outside the Nix sandbox. Make sure Xcode 16+ is installed at `/Applications/Xcode.app`.

To open an interactive shell with all tooling available:

```bash
devenv shell
```

## Workflows

Weekly planning assets originate from `~/Documents/weekly-plan` and live at `workflows/weekly-plan/`. The journal prompt is copied from `~/.config/nix/dotfiles/claude-commands/journal.md` to `workflows/journal/claude-commands/journal.md`.

## CI

GitHub Actions workflow at `.github/workflows/ci.yml` builds and tests every project on pushes and pull requests.
