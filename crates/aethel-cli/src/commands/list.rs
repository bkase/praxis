//! List installed packs

use crate::{commands::util::handle_result, OutputFormat};
use aethel_core::load_packs_from_vault;
use anyhow::Result;
use std::path::Path;

pub fn execute(vault_root: &Path, output_format: OutputFormat) -> Result<()> {
    // Load all packs
    let packs_result = load_packs_from_vault(vault_root)
        .map(|packs| {
            // Transform packs to JSON representation
            packs
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
                .collect::<Vec<_>>()
        })
        .map_err(|e| e.into());

    handle_result(
        packs_result,
        output_format,
        |packs: &Vec<serde_json::Value>| {
            if packs.is_empty() {
                "No packs installed".to_string()
            } else {
                let mut output = String::from("Installed packs:\n");
                for pack_json in packs {
                    let name = pack_json["name"].as_str().unwrap_or("unknown");
                    let version = pack_json["version"].as_str().unwrap_or("unknown");
                    let protocol_version =
                        pack_json["protocolVersion"].as_str().unwrap_or("unknown");

                    output.push_str(&format!("\n  {name} @ {version}\n"));
                    output.push_str(&format!("    Protocol version: {protocol_version}\n"));
                    output.push_str("    Types:\n");

                    if let Some(types) = pack_json["types"].as_array() {
                        for type_entry in types {
                            let id = type_entry["id"].as_str().unwrap_or("unknown");
                            let type_version = type_entry["version"].as_str().unwrap_or("unknown");
                            output.push_str(&format!("      - {id} (v{type_version})\n"));
                        }
                    }
                }
                output.trim_end().to_string()
            }
        },
    )
}
