//! Initialize a new Aethel vault

use crate::error::AethelCliError;
use anyhow::Result;
use std::fs;
use std::path::PathBuf;

pub fn execute(path: Option<PathBuf>) -> Result<()> {
    let vault_path = path.unwrap_or_else(|| PathBuf::from("."));

    // Create vault directories
    let docs_dir = vault_path.join("docs");
    let packs_dir = vault_path.join("packs");
    let aethel_dir = vault_path.join(".aethel");

    // Check if already initialized
    if docs_dir.exists() && packs_dir.exists() {
        println!("Vault already initialized at {}", vault_path.display());
        return Ok(());
    }

    // Create directories
    fs::create_dir_all(&docs_dir).map_err(|e| AethelCliError::VaultInitFailed {
        path: docs_dir.clone(),
        source: e,
    })?;

    fs::create_dir_all(&packs_dir).map_err(|e| AethelCliError::VaultInitFailed {
        path: packs_dir.clone(),
        source: e,
    })?;

    fs::create_dir_all(&aethel_dir).map_err(|e| AethelCliError::VaultInitFailed {
        path: aethel_dir.clone(),
        source: e,
    })?;

    println!("Initialized Aethel vault at {}", vault_path.display());
    Ok(())
}
