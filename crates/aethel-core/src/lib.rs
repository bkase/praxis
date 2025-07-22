//! Aethel Core Library
//!
//! This crate provides the core functionality for the Aethel document management system,
//! including Doc parsing/serialization, Pack loading, Patch application, and validation.

pub mod doc;
pub mod error;
pub mod pack;
pub mod patch;
pub mod schemas;
pub mod utils;
pub mod validate;
pub mod vault;

#[cfg(test)]
mod tests;

pub use doc::Doc;
pub use error::AethelCoreError;
pub use pack::{Pack, PackTypeEntry};
pub use patch::{Patch, PatchMode};
pub use utils::WriteResult;

use std::path::Path;
use uuid::Uuid;

/// Main entry point for mutating Docs.
///
/// Handles UUID resolution/generation, loads existing Doc if UUID is present,
/// applies changes based on PatchMode, updates timestamp, performs schema validation,
/// writes Doc atomically to disk, detects no-op changes, and emits errors for any failures.
pub fn apply_patch(vault_root: &Path, patch: Patch) -> Result<WriteResult, AethelCoreError> {
    vault::apply_patch_impl(vault_root, patch)
}

/// Locates and reads a Doc file by UUID.
///
/// Parses front-matter and body, returning a Doc struct.
pub fn read_doc(vault_root: &Path, uuid: &Uuid) -> Result<Doc, AethelCoreError> {
    vault::read_doc_impl(vault_root, uuid)
}

/// Validates a Doc against its associated Pack schema.
///
/// Loads the associated Pack and schema for the Doc's type,
/// performs full JSON Schema validation on the Doc's front-matter,
/// returns Ok(()) on success or SchemaValidation error on failure.
pub fn validate_doc(vault_root: &Path, doc: &Doc) -> Result<(), AethelCoreError> {
    validate::validate_doc_impl(vault_root, doc)
}

/// Loads a Pack from a directory.
///
/// Parses pack.json, loads and compiles all type schemas,
/// returns Pack struct.
pub fn load_pack(pack_path: &Path) -> Result<Pack, AethelCoreError> {
    pack::load_pack_impl(pack_path)
}

/// Scans vault for all installed Packs.
///
/// Scans vault_root/packs/ directory, loads all valid Pack definitions found,
/// returns a vector of Packs.
pub fn load_packs_from_vault(vault_root: &Path) -> Result<Vec<Pack>, AethelCoreError> {
    pack::load_packs_from_vault_impl(vault_root)
}

/// Adds a Pack to the vault.
///
/// For L0/L1, primarily supports local paths (copying pack directory).
/// Validates pack structure, copies the pack to vault_root/packs/,
/// returns the loaded Pack.
pub fn add_pack(vault_root: &Path, source: &str) -> Result<Pack, AethelCoreError> {
    pack::add_pack_impl(vault_root, source)
}

/// Removes a Pack from the vault.
///
/// Locates the pack directory by name in vault_root/packs/,
/// removes the directory, returns true if removed, false if not found.
pub fn remove_pack(vault_root: &Path, pack_name: &str) -> Result<bool, AethelCoreError> {
    pack::remove_pack_impl(vault_root, pack_name)
}
