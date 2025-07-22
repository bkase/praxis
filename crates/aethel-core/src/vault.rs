//! Vault-level operations and atomic file I/O
//!
//! This module handles file system operations, path resolution,
//! and atomic writes for Docs within a vault.

use crate::{
    doc::Doc,
    error::AethelCoreError,
    pack::{load_packs_from_vault_impl, Pack},
    patch::{Patch, PatchMode},
    utils::WriteResult,
    validate::validate_doc_impl,
};
use chrono::Utc;
use once_cell::sync::Lazy;
use parking_lot::Mutex;
use serde_json::Value;
use std::collections::HashMap;
use std::fs;
use std::path::{Path, PathBuf};
use std::sync::Arc;
use tempfile::NamedTempFile;
use uuid::Uuid;
use walkdir::WalkDir;

/// Global lock manager for vaults
static VAULT_LOCKS: Lazy<Mutex<HashMap<PathBuf, Arc<Mutex<()>>>>> =
    Lazy::new(|| Mutex::new(HashMap::new()));

/// Get or create a lock for a vault
fn get_vault_lock(vault_root: &Path) -> Arc<Mutex<()>> {
    let mut locks = VAULT_LOCKS.lock();
    let canonical_path = vault_root
        .canonicalize()
        .unwrap_or_else(|_| vault_root.to_path_buf());
    locks
        .entry(canonical_path)
        .or_insert_with(|| Arc::new(Mutex::new(())))
        .clone()
}

/// Find a Doc file by UUID within the vault
fn find_doc_by_uuid(vault_root: &Path, uuid: &Uuid) -> Result<PathBuf, AethelCoreError> {
    let docs_dir = vault_root.join("docs");
    let uuid_str = uuid.to_string();

    // First try direct path (docs/<uuid>.md)
    let direct_path = docs_dir.join(format!("{uuid_str}.md"));
    if direct_path.exists() {
        return Ok(direct_path);
    }

    // Search recursively if not found directly
    for entry in WalkDir::new(&docs_dir)
        .follow_links(true)
        .into_iter()
        .filter_map(|e| e.ok())
    {
        let path = entry.path();
        if path.is_file() && path.extension().and_then(|s| s.to_str()) == Some("md") {
            if let Some(filename) = path.file_stem().and_then(|s| s.to_str()) {
                if filename == uuid_str {
                    return Ok(path.to_path_buf());
                }
            }
        }
    }

    Err(AethelCoreError::DocNotFound(*uuid, docs_dir))
}

/// Generate a path for a new Doc
fn generate_doc_path(vault_root: &Path, uuid: &Uuid) -> PathBuf {
    vault_root.join("docs").join(format!("{uuid}.md"))
}

/// Write a file atomically (write to temp, then rename)
fn write_file_atomic(path: &Path, content: &[u8]) -> Result<(), AethelCoreError> {
    let dir = path
        .parent()
        .ok_or_else(|| AethelCoreError::Other("Invalid file path".to_string()))?;

    // Ensure directory exists
    fs::create_dir_all(dir).map_err(|e| AethelCoreError::io_error(e, dir))?;

    // Create temp file in same directory (for atomic rename)
    let temp_file = NamedTempFile::new_in(dir).map_err(|e| AethelCoreError::io_error(e, dir))?;

    // Write content
    fs::write(temp_file.path(), content)
        .map_err(|e| AethelCoreError::io_error(e, temp_file.path()))?;

    // Persist (atomic rename)
    temp_file
        .persist(path)
        .map_err(|e| AethelCoreError::AtomicWriteFailed {
            source: Box::new(e),
            path: path.to_path_buf(),
        })?;

    Ok(())
}

/// Read a Doc by UUID (implementation)
pub(crate) fn read_doc_impl(vault_root: &Path, uuid: &Uuid) -> Result<Doc, AethelCoreError> {
    let doc_path = find_doc_by_uuid(vault_root, uuid)?;

    let content =
        fs::read_to_string(&doc_path).map_err(|e| AethelCoreError::io_error(e, &doc_path))?;

    Doc::from_markdown(&content)
}

/// Apply a patch to create or update a Doc (implementation)
pub(crate) fn apply_patch_impl(
    vault_root: &Path,
    patch: Patch,
) -> Result<WriteResult, AethelCoreError> {
    // Validate patch
    patch.validate()?;

    // Get vault lock
    let lock_holder = get_vault_lock(vault_root);
    let _lock = lock_holder.lock();

    // Load packs for validation
    let packs = load_packs_from_vault_impl(vault_root)?;

    // Process based on mode and UUID
    let (doc, is_new) =
        match (patch.uuid, patch.mode) {
            (None, PatchMode::Create) => {
                // Create new Doc
                let doc_type = patch.doc_type.as_ref().ok_or_else(|| {
                    AethelCoreError::MissingRequiredField {
                        field: "type".to_string(),
                        mode: "create".to_string(),
                    }
                })?;

                // Find the pack and type
                let (_pack, type_entry) = find_pack_and_type(&packs, doc_type)?;

                let now = Utc::now();
                let doc = Doc {
                    uuid: crate::utils::generate_uuid(),
                    doc_type: doc_type.clone(),
                    created: now,
                    updated: now,
                    v: type_entry.version.clone(),
                    tags: Vec::new(),
                    frontmatter_extra: patch
                        .frontmatter
                        .clone()
                        .unwrap_or_else(|| Value::Object(serde_json::Map::new())),
                    body: patch.body.clone().unwrap_or_default(),
                };

                (doc, true)
            }
            (Some(uuid), _) => {
                // Update existing Doc
                let mut doc = read_doc_impl(vault_root, &uuid)?;

                // Check type consistency
                if let Some(patch_type) = &patch.doc_type {
                    if patch_type != &doc.doc_type {
                        return Err(AethelCoreError::TypeMismatchOnUpdate {
                            existing_type: doc.doc_type.clone(),
                            patch_type: patch_type.clone(),
                        });
                    }
                }

                // Get current frontmatter as JSON for comparison
                let current_fm = doc.frontmatter_as_json()?;
                let current_body = doc.body.clone();

                // Check if patch would change anything
                if !patch.would_change(&current_fm, &current_body) {
                    // No changes, return success with committed=false
                    let path = find_doc_by_uuid(vault_root, &uuid)?;
                    return Ok(WriteResult {
                        uuid,
                        path: path.to_string_lossy().to_string(),
                        committed: false,
                        warnings: Vec::new(),
                    });
                }

                // Apply frontmatter changes
                patch.apply_frontmatter(&mut doc.frontmatter_extra)?;

                // Apply body changes
                patch.apply_body(&mut doc.body);

                // Update timestamp
                doc.updated = Utc::now();

                (doc, false)
            }
            _ => {
                return Err(AethelCoreError::Other(
                    "Invalid patch mode/uuid combination".to_string(),
                ));
            }
        };

    // Validate the doc against its schema
    validate_doc_impl(vault_root, &doc)?;

    // Determine file path
    let doc_path = if is_new {
        generate_doc_path(vault_root, &doc.uuid)
    } else {
        find_doc_by_uuid(vault_root, &doc.uuid)?
    };

    // Serialize to markdown
    let content = doc.to_markdown()?;

    // Write atomically
    write_file_atomic(&doc_path, content.as_bytes())?;

    Ok(WriteResult {
        uuid: doc.uuid,
        path: doc_path.to_string_lossy().to_string(),
        committed: true,
        warnings: Vec::new(),
    })
}

/// Find a pack and type entry by type ID
fn find_pack_and_type<'a>(
    packs: &'a [Pack],
    type_id: &str,
) -> Result<(&'a Pack, &'a crate::pack::PackTypeEntry), AethelCoreError> {
    // Extract pack name from type ID
    let parts: Vec<&str> = type_id.split('.').collect();
    if parts.len() < 2 {
        return Err(AethelCoreError::Other(format!(
            "Invalid type ID format: {type_id}"
        )));
    }

    let pack_name = parts[0];

    // Find the pack
    let pack = packs.iter().find(|p| p.name == pack_name).ok_or_else(|| {
        AethelCoreError::PackNotFound(pack_name.to_string(), PathBuf::from("packs"))
    })?;

    // Find the type within the pack
    let type_entry = pack.find_type(type_id).ok_or_else(|| {
        AethelCoreError::PackTypeNotFound(type_id.to_string(), pack_name.to_string())
    })?;

    Ok((pack, type_entry))
}

#[cfg(test)]
mod tests {
    use super::*;
    use tempfile::TempDir;

    #[test]
    fn test_atomic_write() {
        let temp_dir = TempDir::new().unwrap();
        let file_path = temp_dir.path().join("test.txt");

        write_file_atomic(&file_path, b"Hello, world!").unwrap();

        let content = fs::read_to_string(&file_path).unwrap();
        assert_eq!(content, "Hello, world!");
    }
}
