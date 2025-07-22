//! Pack structure and loading
//!
//! A Pack is a directory containing type definitions (schemas),
//! templates, and optional migrations.

use crate::error::AethelCoreError;
use jsonschema::Validator;
use semver::Version;
use serde::{Deserialize, Serialize};
use std::fs;
use std::path::{Path, PathBuf};

/// Current protocol version
const PROTOCOL_VERSION: &str = "0.1.0";

/// A Pack defines one or more document types with their schemas
#[derive(Debug, Serialize, Deserialize)]
pub struct Pack {
    pub name: String,
    pub version: Version,
    #[serde(rename = "protocolVersion")]
    pub protocol_version: Version,
    pub types: Vec<PackTypeEntry>,
    // Internal: path to the pack directory
    #[serde(skip)]
    pub path: PathBuf,
}

/// A single type definition within a Pack
#[derive(Debug, Serialize, Deserialize)]
pub struct PackTypeEntry {
    pub id: String, // e.g., "journal.morning"
    pub version: Version,
    pub schema: PathBuf,           // Relative path to schema file
    pub template: Option<PathBuf>, // Relative path to template file
    // Internal: compiled schema object
    #[serde(skip)]
    pub compiled_schema: Option<Validator>,
}

/// Pack manifest structure (pack.json)
#[derive(Debug, Deserialize)]
struct PackManifest {
    name: String,
    version: Version,
    #[serde(rename = "protocolVersion")]
    protocol_version: Version,
    types: Vec<PackTypeManifestEntry>,
}

/// Type entry in pack manifest
#[derive(Debug, Deserialize)]
struct PackTypeManifestEntry {
    id: String,
    version: Version,
    schema: String,
    template: Option<String>,
}

impl Pack {
    /// Load a Pack from a directory
    pub fn load(pack_path: &Path) -> Result<Self, AethelCoreError> {
        let manifest_path = pack_path.join("pack.json");

        // Read and parse pack.json
        let manifest_content = fs::read_to_string(&manifest_path)
            .map_err(|e| AethelCoreError::io_error(e, &manifest_path))?;

        let manifest: PackManifest = serde_json::from_str(&manifest_content)
            .map_err(AethelCoreError::MalformedRequestJson)?;

        // Check protocol version compatibility
        let current_version = Version::parse(PROTOCOL_VERSION).unwrap();
        if manifest.protocol_version.major != current_version.major {
            return Err(AethelCoreError::ProtocolVersionMismatch {
                pack_name: manifest.name.clone(),
                pack_protocol_version: manifest.protocol_version.clone(),
                current_protocol_version: current_version,
            });
        }

        // Validate pack name format
        if !is_valid_pack_name(&manifest.name) {
            return Err(AethelCoreError::Other(format!(
                "Invalid pack name '{}': must match ^[a-z0-9\\-]+$",
                manifest.name
            )));
        }

        // Load type entries
        let mut types = Vec::new();
        for type_entry in manifest.types {
            // Validate type ID format
            let expected_prefix = format!("{}.", manifest.name);
            if !type_entry.id.starts_with(&expected_prefix) {
                return Err(AethelCoreError::Other(format!(
                    "Type ID '{}' must start with '{}'",
                    type_entry.id, expected_prefix
                )));
            }

            let schema_path = PathBuf::from(&type_entry.schema);
            let template_path = type_entry.template.map(PathBuf::from);

            // Verify schema file exists
            let full_schema_path = pack_path.join(&schema_path);
            if !full_schema_path.exists() {
                return Err(AethelCoreError::SchemaFileNotFound(
                    full_schema_path,
                    type_entry.id.clone(),
                ));
            }

            // Load and compile schema
            let schema_content = fs::read_to_string(&full_schema_path)
                .map_err(|e| AethelCoreError::io_error(e, &full_schema_path))?;

            let schema_value: serde_json::Value = serde_json::from_str(&schema_content)
                .map_err(AethelCoreError::JsonProcessingError)?;

            let compiled_schema = jsonschema::validator_for(&schema_value)
                .map_err(|e| AethelCoreError::SchemaCompilationError(e.to_string()))?;

            types.push(PackTypeEntry {
                id: type_entry.id,
                version: type_entry.version,
                schema: schema_path,
                template: template_path,
                compiled_schema: Some(compiled_schema),
            });
        }

        Ok(Pack {
            name: manifest.name,
            version: manifest.version,
            protocol_version: manifest.protocol_version,
            types,
            path: pack_path.to_path_buf(),
        })
    }

    /// Find a type entry by ID
    pub fn find_type(&self, type_id: &str) -> Option<&PackTypeEntry> {
        self.types.iter().find(|t| t.id == type_id)
    }
}

/// Validate pack name format (DNS label regex)
fn is_valid_pack_name(name: &str) -> bool {
    !name.is_empty()
        && name
            .chars()
            .all(|c| c.is_ascii_lowercase() || c.is_ascii_digit() || c == '-')
        && !name.starts_with('-')
        && !name.ends_with('-')
}

/// Load a Pack from a directory (implementation for lib.rs)
pub(crate) fn load_pack_impl(pack_path: &Path) -> Result<Pack, AethelCoreError> {
    Pack::load(pack_path)
}

/// Load all Packs from a vault
pub(crate) fn load_packs_from_vault_impl(vault_root: &Path) -> Result<Vec<Pack>, AethelCoreError> {
    let packs_dir = vault_root.join("packs");

    if !packs_dir.exists() {
        return Ok(Vec::new());
    }

    let mut packs = Vec::new();

    for entry in fs::read_dir(&packs_dir).map_err(|e| AethelCoreError::io_error(e, &packs_dir))? {
        let entry = entry.map_err(|e| AethelCoreError::io_error(e, &packs_dir))?;
        let path = entry.path();

        if path.is_dir() {
            // Try to load as a pack, ignore if it fails
            match Pack::load(&path) {
                Ok(pack) => packs.push(pack),
                Err(_) => {
                    // Skip invalid pack directories
                    continue;
                }
            }
        }
    }

    Ok(packs)
}

/// Add a Pack to the vault
pub(crate) fn add_pack_impl(vault_root: &Path, source: &str) -> Result<Pack, AethelCoreError> {
    let source_path = Path::new(source);

    // For L0/L1, only support local paths
    if !source_path.exists() {
        return Err(AethelCoreError::PackNotFound(
            source.to_string(),
            source_path.to_path_buf(),
        ));
    }

    // Load the pack to validate it
    let pack = Pack::load(source_path)?;

    // Create destination path
    let dest_name = format!("{}@{}", pack.name, pack.version);
    let dest_path = vault_root.join("packs").join(&dest_name);

    // Check if already exists
    if dest_path.exists() {
        return Err(AethelCoreError::Other(format!(
            "Pack '{dest_name}' already exists"
        )));
    }

    // Create packs directory if needed
    let packs_dir = vault_root.join("packs");
    fs::create_dir_all(&packs_dir).map_err(|e| AethelCoreError::io_error(e, &packs_dir))?;

    // Copy the pack directory
    copy_dir_recursive(source_path, &dest_path)?;

    // Reload from destination to get correct path
    Pack::load(&dest_path)
}

/// Remove a Pack from the vault
pub(crate) fn remove_pack_impl(
    vault_root: &Path,
    pack_name: &str,
) -> Result<bool, AethelCoreError> {
    let packs_dir = vault_root.join("packs");

    // Look for pack directory
    for entry in fs::read_dir(&packs_dir).map_err(|e| AethelCoreError::io_error(e, &packs_dir))? {
        let entry = entry.map_err(|e| AethelCoreError::io_error(e, &packs_dir))?;
        let path = entry.path();

        if path.is_dir() {
            if let Some(dir_name) = path.file_name().and_then(|n| n.to_str()) {
                // Check if directory name starts with pack_name@
                if dir_name.starts_with(&format!("{pack_name}@")) {
                    // Remove the directory
                    fs::remove_dir_all(&path).map_err(|e| AethelCoreError::io_error(e, &path))?;
                    return Ok(true);
                }
            }
        }
    }

    Ok(false)
}

/// Copy a directory recursively
fn copy_dir_recursive(src: &Path, dst: &Path) -> Result<(), AethelCoreError> {
    fs::create_dir_all(dst).map_err(|e| AethelCoreError::io_error(e, dst))?;

    for entry in fs::read_dir(src).map_err(|e| AethelCoreError::io_error(e, src))? {
        let entry = entry.map_err(|e| AethelCoreError::io_error(e, src))?;
        let src_path = entry.path();
        let dst_path = dst.join(entry.file_name());

        if src_path.is_dir() {
            copy_dir_recursive(&src_path, &dst_path)?;
        } else {
            fs::copy(&src_path, &dst_path).map_err(|e| AethelCoreError::io_error(e, &src_path))?;
        }
    }

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_valid_pack_names() {
        assert!(is_valid_pack_name("journal"));
        assert!(is_valid_pack_name("my-pack"));
        assert!(is_valid_pack_name("pack123"));
        assert!(!is_valid_pack_name(""));
        assert!(!is_valid_pack_name("My-Pack")); // uppercase
        assert!(!is_valid_pack_name("-pack")); // starts with dash
        assert!(!is_valid_pack_name("pack-")); // ends with dash
        assert!(!is_valid_pack_name("pack_name")); // underscore
    }
}
