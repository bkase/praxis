//! CLI-specific error types

use aethel_core::AethelCoreError;
use std::path::PathBuf;
use thiserror::Error;

#[derive(Error, Debug)]
pub enum AethelCliError {
    #[error("Failed to parse command-line arguments: {0}")]
    CliParse(#[from] clap::Error),

    #[error("I/O error: {source} on {path}")]
    #[allow(dead_code)]
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
    CoreError(#[from] AethelCoreError),

    #[error("Failed to initialize vault at '{path}': {source}")]
    VaultInitFailed {
        path: PathBuf,
        #[source]
        source: std::io::Error,
    },

    #[error("Unknown pack source format: {0}")]
    #[allow(dead_code)]
    UnknownPackSource(String),
}

impl AethelCliError {
    /// Helper for printing structured error output consistent with protocol
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
                AethelCliError::CoreError(AethelCoreError::SchemaValidation { pointer, expected, got, .. }) => {
                    serde_json::json!({
                        "pointer": pointer,
                        "expected": expected,
                        "got": got
                    })
                },
                _ => serde_json::Value::Null,
            }
        })
    }
}
