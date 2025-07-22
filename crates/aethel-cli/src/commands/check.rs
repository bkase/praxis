//! Check document validity

use crate::{error::AethelCliError, OutputFormat};
use aethel_core::{read_doc, validate_doc};
use anyhow::Result;
use std::path::Path;
use uuid::Uuid;

pub fn execute(
    vault_root: &Path,
    uuid: Uuid,
    autofix: bool,
    output_format: OutputFormat,
) -> Result<()> {
    // Read the document
    let doc = match read_doc(vault_root, &uuid) {
        Ok(doc) => doc,
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
    };

    // Validate the document
    let validation_result = validate_doc(vault_root, &doc);

    match validation_result {
        Ok(()) => {
            match output_format {
                OutputFormat::Json => {
                    let output = serde_json::json!({
                        "valid": true,
                        "errors": [],
                        "fixed": false // autofix not implemented in L0/L1
                    });
                    println!("{}", serde_json::to_string_pretty(&output)?);
                }
                OutputFormat::Human => {
                    println!("✓ Document {uuid} is valid");
                    if autofix {
                        println!("  (autofix requested but not implemented in L1)");
                    }
                }
            }
            Ok(())
        }
        Err(e) => {
            match output_format {
                OutputFormat::Json => {
                    let output = serde_json::json!({
                        "valid": false,
                        "errors": [{
                            "code": e.protocol_code(),
                            "message": e.to_string()
                        }],
                        "fixed": false
                    });
                    println!("{}", serde_json::to_string_pretty(&output)?);
                }
                OutputFormat::Human => {
                    println!("✗ Document {uuid} is invalid");
                    println!("  Error: {e}");
                    if autofix {
                        println!("  (autofix requested but not implemented in L1)");
                    }
                }
            }
            std::process::exit(1);
        }
    }
}
