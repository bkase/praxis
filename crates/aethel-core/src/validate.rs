//! Validation functions for Docs and Patches
//! 
//! Handles JSON Schema validation against Pack-defined schemas.

use crate::{
    doc::Doc,
    error::AethelCoreError,
    pack::load_packs_from_vault_impl,
    schemas::BASE_FRONTMATTER_SCHEMA,
};
use jsonschema::Validator;
use serde_json::Value;
use std::path::Path;

/// Validate a Doc against its associated Pack schema (implementation)
pub(crate) fn validate_doc_impl(vault_root: &Path, doc: &Doc) -> Result<(), AethelCoreError> {
    // Load packs from vault
    let packs = load_packs_from_vault_impl(vault_root)?;
    
    // Find the pack and type for this doc
    let pack_name = doc.doc_type.split('.').next()
        .ok_or_else(|| AethelCoreError::Other(
            format!("Invalid type format: {}", doc.doc_type)
        ))?;
    
    let pack = packs.iter()
        .find(|p| p.name == pack_name)
        .ok_or_else(|| AethelCoreError::PackNotFound(
            pack_name.to_string(),
            vault_root.join("packs"),
        ))?;
    
    let type_entry = pack.find_type(&doc.doc_type)
        .ok_or_else(|| AethelCoreError::PackTypeNotFound(
            doc.doc_type.clone(),
            pack_name.to_string(),
        ))?;
    
    // Get the compiled schema
    let schema = type_entry.compiled_schema.as_ref()
        .ok_or_else(|| AethelCoreError::SchemaCompilationError(
            "Schema not compiled".to_string()
        ))?;
    
    // Get frontmatter as JSON for validation
    let frontmatter = doc.frontmatter_as_json()?;
    
    // First validate against base schema
    validate_against_base_schema(&frontmatter)?;
    
    // Then validate against type-specific schema
    let mut errors = schema.iter_errors(&frontmatter);
    if let Some(error) = errors.next() {
        return Err(AethelCoreError::from_json_schema_error(error));
    }
    
    // Check for unknown keys if schema has additionalProperties: false
    check_unknown_keys(&frontmatter, schema, &doc.doc_type)?;
    
    Ok(())
}

/// Validate frontmatter against base schema
fn validate_against_base_schema(frontmatter: &Value) -> Result<(), AethelCoreError> {
    let mut errors = BASE_FRONTMATTER_SCHEMA.iter_errors(frontmatter);
    if let Some(error) = errors.next() {
        return Err(AethelCoreError::from_json_schema_error(error));
    }
    
    Ok(())
}

/// Check for unknown keys in frontmatter
fn check_unknown_keys(
    _frontmatter: &Value,
    _schema: &Validator,
    _doc_type: &str,
) -> Result<(), AethelCoreError> {
    // This is a simplified check - in a real implementation,
    // we'd parse the schema to determine if additionalProperties is false
    // and what properties are allowed
    
    // For now, we'll trust that the schema validation handles this
    // since we're using additionalProperties: false in our schemas
    
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::schemas::PATCH_SCHEMA;
    use serde_json::json;
    
    #[test]
    fn test_validate_patch_schema() {
        let valid_patch = json!({
            "uuid": null,
            "type": "journal.morning",
            "frontmatter": {"mood": "happy"},
            "body": "Test",
            "mode": "create"
        });
        
        assert!(PATCH_SCHEMA.validate(&valid_patch).is_ok());
        
        let invalid_patch = json!({
            "mode": "create"
            // Missing required "type" field
        });
        
        assert!(PATCH_SCHEMA.validate(&invalid_patch).is_err());
    }
}