//! Utility functions for command execution

use crate::OutputFormat;
use anyhow::Result;
use serde::Serialize;

/// Handle the result of a core library operation in a uniform way
///
/// This function standardizes the pattern of:
/// 1. Handling success cases by formatting output as JSON or human-readable
/// 2. Handling error cases by printing JSON errors to stderr
/// 3. Properly propagating errors for anyhow to handle
///
/// # Arguments
/// * `result` - The result from a core library operation
/// * `output_format` - Whether to output JSON or human-readable format
/// * `to_human_string` - Function to convert success value to human-readable string
pub fn handle_result<T: Serialize>(
    result: anyhow::Result<T>,
    output_format: OutputFormat,
    to_human_string: impl FnOnce(&T) -> String,
) -> Result<()> {
    match result {
        Ok(value) => {
            match output_format {
                OutputFormat::Json => {
                    println!("{}", serde_json::to_string_pretty(&value)?);
                }
                OutputFormat::Human => {
                    println!("{}", to_human_string(&value));
                }
            }
            Ok(())
        }
        Err(e) => {
            // Note: We can't use downcast_ref for AethelCoreError without Clone,
            // so we need a different approach. For now, we'll create the error
            // from the anyhow error which will preserve the error chain.
            match output_format {
                OutputFormat::Json => {
                    // Check if this is a core error by looking at the source chain
                    let error_json = if e.to_string().contains("Error from core library:") {
                        // Extract the protocol code from the error message if possible
                        // This is a workaround until we can properly downcast
                        serde_json::json!({
                            "code": 50000, // Default to system error
                            "message": e.to_string(),
                            "data": null
                        })
                    } else {
                        serde_json::json!({
                            "code": 50000,
                            "message": e.to_string(),
                            "data": null
                        })
                    };
                    eprintln!("{}", serde_json::to_string_pretty(&error_json)?);
                }
                OutputFormat::Human => {
                    // Human errors are handled by anyhow's default handler in main
                }
            }
            Err(e)
        }
    }
}
