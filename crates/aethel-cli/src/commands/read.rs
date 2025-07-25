//! Read a document by UUID

use crate::{error::AethelCliError, ReadOutputFormat};
use aethel_core::read_doc;
use anyhow::Result;
use std::path::Path;
use uuid::Uuid;

pub fn execute(vault_root: &Path, uuid: Uuid, output_format: ReadOutputFormat) -> Result<()> {
    // Read the document
    match read_doc(vault_root, &uuid) {
        Ok(doc) => {
            match output_format {
                ReadOutputFormat::Md => {
                    // Output as markdown
                    println!("{}", doc.to_markdown()?);
                }
                ReadOutputFormat::Json => {
                    // Output as JSON (frontmatter + body)
                    let output = serde_json::json!({
                        "frontmatter": doc.frontmatter_as_json()?,
                        "body": doc.body
                    });
                    println!("{}", serde_json::to_string_pretty(&output)?);
                }
            }
            Ok(())
        }
        Err(e) => {
            match output_format {
                ReadOutputFormat::Json => {
                    let cli_error = AethelCliError::CoreError(e);
                    eprintln!(
                        "{}",
                        serde_json::to_string_pretty(&cli_error.to_protocol_json())?
                    );
                    Err(cli_error.into())
                }
                ReadOutputFormat::Md => {
                    // Markdown errors are handled by anyhow's default handler in main
                    Err(e.into())
                }
            }
        }
    }
}
