//! Add a pack from a local path or URL

use crate::{error::AethelCliError, OutputFormat};
use aethel_core::add_pack;
use anyhow::Result;
use std::path::Path;

pub fn execute(vault_root: &Path, source: &str, output_format: OutputFormat) -> Result<()> {
    // Add the pack
    match add_pack(vault_root, source) {
        Ok(pack) => {
            match output_format {
                OutputFormat::Json => {
                    let output = serde_json::json!({
                        "name": pack.name,
                        "version": pack.version.to_string(),
                        "protocolVersion": pack.protocol_version.to_string(),
                        "types": pack.types.iter().map(|t| {
                            serde_json::json!({
                                "id": t.id,
                                "version": t.version.to_string()
                            })
                        }).collect::<Vec<_>>()
                    });
                    println!("{}", serde_json::to_string_pretty(&output)?);
                }
                OutputFormat::Human => {
                    println!("✓ Pack '{}' added successfully", pack.name);
                    println!("  Version: {}", pack.version);
                    println!("  Protocol version: {}", pack.protocol_version);
                    println!("  Types:");
                    for type_entry in &pack.types {
                        println!("    - {} (v{})", type_entry.id, type_entry.version);
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
                    Err(cli_error.into())
                }
                OutputFormat::Human => {
                    // Human errors are handled by anyhow's default handler in main
                    Err(e.into())
                }
            }
        }
    }
}
