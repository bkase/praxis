//! Write a document using a patch

use crate::{error::AethelCliError, OutputFormat};
use aethel_core::{apply_patch, Patch};
use anyhow::Result;
use std::io::{self, Read};
use std::path::Path;

pub fn execute(
    vault_root: &Path,
    json_arg: Option<&str>,
    output_format: OutputFormat,
) -> Result<()> {
    // Read patch from stdin if --json -
    let patch_json = if json_arg == Some("-") {
        let mut buffer = String::new();
        io::stdin().read_to_string(&mut buffer)?;
        buffer
    } else {
        return Err(anyhow::anyhow!("Expected --json - to read from stdin"));
    };

    // Parse patch
    let patch: Patch = match serde_json::from_str(&patch_json) {
        Ok(p) => p,
        Err(e) => {
            let cli_error = AethelCliError::JsonInputParse(e);
            match output_format {
                OutputFormat::Json => {
                    eprintln!(
                        "{}",
                        serde_json::to_string_pretty(&cli_error.to_protocol_json())?
                    );
                }
                OutputFormat::Human => {
                    // Human errors are handled by anyhow's default handler in main
                }
            }
            return Err(cli_error.into());
        }
    };

    // Apply patch
    match apply_patch(vault_root, patch) {
        Ok(write_result) => {
            match output_format {
                OutputFormat::Json => {
                    println!("{}", serde_json::to_string_pretty(&write_result)?);
                }
                OutputFormat::Human => {
                    if write_result.committed {
                        println!("✓ Document written successfully");
                        println!("  UUID: {}", write_result.uuid);
                        println!("  Path: {}", write_result.path);
                    } else {
                        println!("✓ No changes needed (document already up to date)");
                        println!("  UUID: {}", write_result.uuid);
                    }

                    if !write_result.warnings.is_empty() {
                        println!("\nWarnings:");
                        for warning in &write_result.warnings {
                            println!("  - {warning}");
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
