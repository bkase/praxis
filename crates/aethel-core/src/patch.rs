//! Patch structure and application logic
//!
//! A Patch describes a mutation to a Doc, supporting various
//! modes: create, append, merge_frontmatter, and replace_body.

use crate::error::AethelCoreError;
use serde::{Deserialize, Serialize};
use serde_json::Value;
use uuid::Uuid;

/// A Patch describes a single mutation to a Doc
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")] // Match protocol JSON
pub struct Patch {
    pub uuid: Option<Uuid>,
    #[serde(rename = "type")]
    pub doc_type: Option<String>,
    pub frontmatter: Option<Value>, // Will be an Object
    pub body: Option<String>,
    pub mode: PatchMode,
}

/// The mode of operation for a Patch
#[derive(Debug, Clone, Copy, Serialize, Deserialize, PartialEq, Eq)]
#[serde(rename_all = "snake_case")] // Match protocol enum values
pub enum PatchMode {
    Create,
    Append,
    MergeFrontmatter,
    ReplaceBody,
}

/// System-controlled keys that cannot be set by user patches
const SYSTEM_KEYS: &[&str] = &["uuid", "type", "created", "updated", "v", "tags"];

impl Patch {
    /// Validate the patch has required fields for its mode
    pub fn validate(&self) -> Result<(), AethelCoreError> {
        match self.mode {
            PatchMode::Create => {
                // Create mode requires type
                if self.doc_type.is_none() {
                    return Err(AethelCoreError::MissingRequiredField {
                        field: "type".to_string(),
                        mode: "create".to_string(),
                    });
                }
                // Create mode requires uuid to be null
                if self.uuid.is_some() {
                    return Err(AethelCoreError::Other(
                        "UUID must be null for create mode".to_string(),
                    ));
                }
            }
            PatchMode::ReplaceBody => {
                // Replace body mode requires body
                if self.body.is_none() {
                    return Err(AethelCoreError::MissingRequiredField {
                        field: "body".to_string(),
                        mode: "replace_body".to_string(),
                    });
                }
            }
            _ => {
                // Other modes have no specific requirements
            }
        }

        // Check for system keys in frontmatter
        if let Some(Value::Object(map)) = &self.frontmatter {
            for key in map.keys() {
                if SYSTEM_KEYS.contains(&key.as_str()) {
                    return Err(AethelCoreError::AttemptToSetSystemKey { key: key.clone() });
                }
            }
        }

        Ok(())
    }

    /// Check if this patch would result in any changes to the given doc
    pub fn would_change(&self, current_frontmatter: &Value, current_body: &str) -> bool {
        // Check frontmatter changes
        if let Some(patch_fm) = &self.frontmatter {
            if let (Value::Object(patch_map), Value::Object(current_map)) =
                (patch_fm, current_frontmatter)
            {
                for (key, value) in patch_map {
                    if current_map.get(key) != Some(value) {
                        return true;
                    }
                }
            }
        }

        // Check body changes
        match self.mode {
            PatchMode::Append => {
                if let Some(body) = &self.body {
                    if !body.is_empty() {
                        return true;
                    }
                }
            }
            PatchMode::ReplaceBody => {
                if let Some(body) = &self.body {
                    if body != current_body {
                        return true;
                    }
                }
            }
            _ => {}
        }

        false
    }

    /// Apply frontmatter changes to existing frontmatter
    pub fn apply_frontmatter(&self, current: &mut Value) -> Result<(), AethelCoreError> {
        if let Some(patch_fm) = &self.frontmatter {
            if let (Value::Object(patch_map), Value::Object(current_map)) = (patch_fm, current) {
                // Shallow merge: patch keys override existing ones
                for (key, value) in patch_map {
                    // Skip system keys (already validated)
                    if !SYSTEM_KEYS.contains(&key.as_str()) {
                        current_map.insert(key.clone(), value.clone());
                    }
                }
            }
        }
        Ok(())
    }

    /// Apply body changes according to mode
    pub fn apply_body(&self, current_body: &mut String) {
        match self.mode {
            PatchMode::Append => {
                if let Some(body) = &self.body {
                    if !body.is_empty() {
                        if !current_body.is_empty() {
                            current_body.push_str("\n\n");
                        }
                        current_body.push_str(body);
                    }
                }
            }
            PatchMode::ReplaceBody => {
                if let Some(body) = &self.body {
                    *current_body = body.clone();
                }
            }
            _ => {
                // Other modes don't modify body
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use serde_json::json;

    #[test]
    fn test_patch_validation() {
        // Valid create patch
        let patch = Patch {
            uuid: None,
            doc_type: Some("journal.morning".to_string()),
            frontmatter: Some(json!({"mood": "happy"})),
            body: Some("Today was good".to_string()),
            mode: PatchMode::Create,
        };
        assert!(patch.validate().is_ok());

        // Invalid create patch (missing type)
        let patch = Patch {
            uuid: None,
            doc_type: None,
            frontmatter: None,
            body: None,
            mode: PatchMode::Create,
        };
        assert!(matches!(
            patch.validate(),
            Err(AethelCoreError::MissingRequiredField { .. })
        ));

        // Invalid patch (system key)
        let patch = Patch {
            uuid: Some(Uuid::new_v4()),
            doc_type: None,
            frontmatter: Some(json!({"uuid": "12345"})),
            body: None,
            mode: PatchMode::MergeFrontmatter,
        };
        assert!(matches!(
            patch.validate(),
            Err(AethelCoreError::AttemptToSetSystemKey { .. })
        ));
    }

    #[test]
    fn test_would_change() {
        let current_fm = json!({"mood": "happy", "weather": "sunny"});
        let current_body = "Original content";

        // No change
        let patch = Patch {
            uuid: Some(Uuid::new_v4()),
            doc_type: None,
            frontmatter: Some(json!({"mood": "happy"})),
            body: None,
            mode: PatchMode::MergeFrontmatter,
        };
        assert!(!patch.would_change(&current_fm, current_body));

        // Frontmatter change
        let patch = Patch {
            uuid: Some(Uuid::new_v4()),
            doc_type: None,
            frontmatter: Some(json!({"mood": "sad"})),
            body: None,
            mode: PatchMode::MergeFrontmatter,
        };
        assert!(patch.would_change(&current_fm, current_body));

        // Body append
        let patch = Patch {
            uuid: Some(Uuid::new_v4()),
            doc_type: None,
            frontmatter: None,
            body: Some("New content".to_string()),
            mode: PatchMode::Append,
        };
        assert!(patch.would_change(&current_fm, current_body));
    }
}
