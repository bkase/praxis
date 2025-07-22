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