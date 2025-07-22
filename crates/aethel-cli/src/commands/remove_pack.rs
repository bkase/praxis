//! Remove an installed pack

use crate::{error::AethelCliError, OutputFormat};
use aethel_core::remove_pack;
use anyhow::Result;
use std::path::Path;

pub fn execute(vault_root: &Path, name: &str, output_format: OutputFormat) -> Result<()> {
    // Remove the pack
    match remove_pack(vault_root, name) {
        Ok(removed) => {
            match output_format {
                OutputFormat::Json => {
                    let output = serde_json::json!({
                        "removed": removed
                    });
                    println!("{}", serde_json::to_string_pretty(&output)?);
                }
                OutputFormat::Human => {
                    if removed {
                        println!("✓ Pack '{name}' removed successfully");
                    } else {
                        println!("✗ Pack '{name}' not found");
                        std::process::exit(1);
                    }
                }
            }
            Ok(())
        }
        Err(e) => {
            match output_format {
                OutputFormat::Json => {
                    let cli_error = AethelCliError::CoreError(e);
                    eprintln!(
                        "{}",
                        serde_json::to_string_pretty(&cli_error.to_protocol_json())?
                    );
                }
                OutputFormat::Human => {
                    return Err(e.into());
                }
            }
            std::process::exit(1);
        }
    }
}
