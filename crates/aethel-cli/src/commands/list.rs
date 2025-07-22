//! List installed packs

use crate::{error::AethelCliError, OutputFormat};
use aethel_core::load_packs_from_vault;
use anyhow::Result;
use std::path::Path;

pub fn execute(vault_root: &Path, output_format: OutputFormat) -> Result<()> {
    // Load all packs
    match load_packs_from_vault(vault_root) {
        Ok(packs) => {
            match output_format {
                OutputFormat::Json => {
                    let output: Vec<_> = packs
                        .iter()
                        .map(|pack| {
                            serde_json::json!({
                                "name": pack.name,
                                "version": pack.version.to_string(),
                                "protocolVersion": pack.protocol_version.to_string(),
                                "types": pack.types.iter().map(|t| {
                                    serde_json::json!({
                                        "id": t.id,
                                        "version": t.version.to_string()
                                    })
                                }).collect::<Vec<_>>()
                            })
                        })
                        .collect();
                    println!("{}", serde_json::to_string_pretty(&output)?);
                }
                OutputFormat::Human => {
                    if packs.is_empty() {
                        println!("No packs installed");
                    } else {
                        println!("Installed packs:");
                        println!();
                        for pack in &packs {
                            println!("  {} @ {}", pack.name, pack.version);
                            println!("    Protocol version: {}", pack.protocol_version);
                            println!("    Types:");
                            for type_entry in &pack.types {
                                println!("      - {} (v{})", type_entry.id, type_entry.version);
                            }
                            println!();
                        }
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
