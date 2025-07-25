//! Add a pack from a local path or URL

use crate::{commands::util::handle_result, OutputFormat};
use aethel_core::add_pack;
use anyhow::Result;
use std::path::Path;

pub fn execute(vault_root: &Path, source: &str, output_format: OutputFormat) -> Result<()> {
    // Add the pack
    let pack_result = add_pack(vault_root, source)
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
        .map_err(|e| e.into());

    handle_result(
        pack_result,
        output_format,
        |pack_json: &serde_json::Value| {
            let name = pack_json["name"].as_str().unwrap_or("unknown");
            let version = pack_json["version"].as_str().unwrap_or("unknown");
            let protocol_version = pack_json["protocolVersion"].as_str().unwrap_or("unknown");

            let mut output = format!("✓ Pack '{name}' added successfully\n");
            output.push_str(&format!("  Version: {version}\n"));
            output.push_str(&format!("  Protocol version: {protocol_version}\n"));
            output.push_str("  Types:\n");

            if let Some(types) = pack_json["types"].as_array() {
                for type_entry in types {
                    let id = type_entry["id"].as_str().unwrap_or("unknown");
                    let type_version = type_entry["version"].as_str().unwrap_or("unknown");
                    output.push_str(&format!("    - {id} (v{type_version})\n"));
                }
            }

            output.trim_end().to_string()
        },
    )
}
