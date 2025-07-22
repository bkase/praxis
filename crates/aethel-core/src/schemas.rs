//! Pre-compiled base JSON schemas
//! 
//! Contains the base schemas defined in the protocol specification
//! for validation of Docs, Patches, and WriteResults.

use jsonschema::Validator;
use once_cell::sync::Lazy;
use serde_json::json;

/// Base front-matter schema (from protocol.md Appendix A)
pub static BASE_FRONTMATTER_SCHEMA: Lazy<Validator> = Lazy::new(|| {
    let schema = json!({
        "$id": "https://aethel.dev/schemas/base-frontmatter.json",
        "$schema": "https://json-schema.org/draft/2020-12/schema",
        "type": "object",
        "required": ["uuid", "type", "created", "updated", "v", "tags"],
        "properties": {
            "uuid": {
                "type": "string",
                "pattern": "^[0-9a-fA-F-]{36}$"
            },
            "type": { "type": "string" },
            "created": {
                "type": "string",
                "format": "date-time"
            },
            "updated": {
                "type": "string",
                "format": "date-time"
            },
            "v": {
                "type": "string",
                "pattern": "^[0-9]+\\.[0-9]+\\.[0-9]+$"
            },
            "tags": {
                "type": "array",
                "items": { "type": "string" },
                "default": []
            }
        },
        "additionalProperties": false
    });
    
    jsonschema::validator_for(&schema).expect("Failed to compile base frontmatter schema")
});

/// Patch schema (from protocol.md Appendix B)
pub static PATCH_SCHEMA: Lazy<Validator> = Lazy::new(|| {
    let schema = json!({
        "$id": "https://aethel.dev/schemas/patch.json",
        "$schema": "https://json-schema.org/draft/2020-12/schema",
        "type": "object",
        "required": ["mode"],
        "properties": {
            "uuid": {
                "type": ["string", "null"],
                "pattern": "^[0-9a-fA-F-]{36}$"
            },
            "type": { "type": "string" },
            "frontmatter": { "type": "object" },
            "body": { "type": ["string", "null"] },
            "mode": {
                "type": "string",
                "enum": ["create", "append", "merge_frontmatter", "replace_body"]
            }
        },
        "additionalProperties": false,
        "allOf": [
            {
                "if": { "properties": { "mode": { "const": "create" } } },
                "then": { "required": ["type"] }
            }
        ]
    });
    
    jsonschema::validator_for(&schema).expect("Failed to compile patch schema")
});

/// WriteResult schema (from protocol.md Appendix C)
pub static WRITE_RESULT_SCHEMA: Lazy<Validator> = Lazy::new(|| {
    let schema = json!({
        "$id": "https://aethel.dev/schemas/write-result.json",
        "$schema": "https://json-schema.org/draft/2020-12/schema",
        "type": "object",
        "required": ["uuid", "path", "committed", "warnings"],
        "properties": {
            "uuid": { "type": "string" },
            "path": { "type": "string" },
            "committed": { "type": "boolean" },
            "warnings": {
                "type": "array",
                "items": { "type": "string" }
            }
        },
        "additionalProperties": false
    });
    
    jsonschema::validator_for(&schema).expect("Failed to compile write result schema")
});