//! Doc structure and parsing/serialization
//!
//! A Doc is a Markdown file with YAML front-matter containing
//! required base fields and optional type-specific fields.

use crate::error::AethelCoreError;
use chrono::{DateTime, Utc};
use semver::Version;
use serde::{Deserialize, Serialize};
use serde_json::Value;
use std::collections::BTreeMap;
use uuid::Uuid;

/// State for parsing markdown front-matter
#[derive(Debug)]
enum ParseState {
    ExpectingFirstDelimiter,
    InFrontMatter,
    InBody,
}

/// A Doc represents a single document in the Aethel system
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Doc {
    // Base front-matter fields
    pub uuid: Uuid,
    #[serde(rename = "type")]
    pub doc_type: String, // Use doc_type to avoid keyword conflict
    pub created: DateTime<Utc>,
    pub updated: DateTime<Utc>,
    pub v: Version,
    pub tags: Vec<String>,
    // Additional front-matter fields, validated by Pack's schema
    #[serde(flatten)]
    pub frontmatter_extra: Value, // Will be an Object
    // The markdown body content
    #[serde(skip)]
    pub body: String,
}

/// Intermediate structure for deserializing front-matter
#[derive(Debug, Deserialize)]
struct FrontMatter {
    uuid: Uuid,
    #[serde(rename = "type")]
    doc_type: String,
    created: DateTime<Utc>,
    updated: DateTime<Utc>,
    v: Version,
    #[serde(default)]
    tags: Vec<String>,
    #[serde(flatten)]
    extra: BTreeMap<String, Value>,
}

/// Intermediate structure for serializing front-matter
#[derive(Debug, Serialize)]
struct FrontMatterOut {
    uuid: Uuid,
    #[serde(rename = "type")]
    doc_type: String,
    created: DateTime<Utc>,
    updated: DateTime<Utc>,
    v: Version,
    tags: Vec<String>,
    #[serde(flatten)]
    extra: BTreeMap<String, Value>,
}

impl Doc {
    /// Parse a Doc from markdown content
    pub fn from_markdown(content: &str) -> Result<Self, AethelCoreError> {
        // Parse using line-based state machine for robustness
        let lines = content.lines();
        let mut state = ParseState::ExpectingFirstDelimiter;
        let mut yaml_lines = Vec::new();
        let mut body_lines = Vec::new();

        for line in lines {
            match state {
                ParseState::ExpectingFirstDelimiter => {
                    if line.trim() == "---" {
                        state = ParseState::InFrontMatter;
                    } else if !line.trim().is_empty() {
                        return Err(AethelCoreError::MalformedDocFile(
                            "Content before first '---' delimiter".to_string(),
                        ));
                    }
                }
                ParseState::InFrontMatter => {
                    if line.trim() == "---" {
                        state = ParseState::InBody;
                    } else {
                        yaml_lines.push(line);
                    }
                }
                ParseState::InBody => {
                    body_lines.push(line);
                }
            }
        }

        // Validate we found both delimiters
        if matches!(state, ParseState::ExpectingFirstDelimiter) {
            return Err(AethelCoreError::MalformedDocFile(
                "Missing opening '---' delimiter".to_string(),
            ));
        }
        if matches!(state, ParseState::InFrontMatter) {
            return Err(AethelCoreError::MalformedDocFile(
                "Missing closing '---' delimiter".to_string(),
            ));
        }

        let yaml_content = yaml_lines.join("\n");
        let body = body_lines.join("\n");

        // Parse YAML front-matter
        let front_matter: FrontMatter =
            serde_yaml::from_str(&yaml_content).map_err(AethelCoreError::MalformedYaml)?;

        // Convert extra fields to JSON Value
        let frontmatter_extra = serde_json::to_value(front_matter.extra)
            .map_err(AethelCoreError::JsonProcessingError)?;

        Ok(Doc {
            uuid: front_matter.uuid,
            doc_type: front_matter.doc_type,
            created: front_matter.created,
            updated: front_matter.updated,
            v: front_matter.v,
            tags: front_matter.tags,
            frontmatter_extra,
            body,
        })
    }

    /// Serialize a Doc to markdown format
    pub fn to_markdown(&self) -> Result<String, AethelCoreError> {
        // Extract extra fields from JSON Value
        let extra: BTreeMap<String, Value> = match &self.frontmatter_extra {
            Value::Object(map) => map.iter().map(|(k, v)| (k.clone(), v.clone())).collect(),
            _ => BTreeMap::new(),
        };

        // Create front-matter structure for serialization
        let front_matter = FrontMatterOut {
            uuid: self.uuid,
            doc_type: self.doc_type.clone(),
            created: self.created,
            updated: self.updated,
            v: self.v.clone(),
            tags: self.tags.clone(),
            extra,
        };

        // Serialize to YAML
        let yaml = serde_yaml::to_string(&front_matter)
            .map_err(|e| AethelCoreError::Other(format!("Failed to serialize YAML: {e}")))?;

        // Combine with body
        Ok(format!("---\n{}---\n{}", yaml, self.body))
    }

    /// Get all front-matter fields as a JSON object (for validation)
    pub fn frontmatter_as_json(&self) -> Result<Value, AethelCoreError> {
        let mut map = serde_json::Map::new();

        // Add base fields
        map.insert(
            "uuid".to_string(),
            serde_json::to_value(self.uuid).map_err(AethelCoreError::JsonProcessingError)?,
        );
        map.insert(
            "type".to_string(),
            serde_json::to_value(&self.doc_type).map_err(AethelCoreError::JsonProcessingError)?,
        );
        map.insert(
            "created".to_string(),
            serde_json::to_value(self.created).map_err(AethelCoreError::JsonProcessingError)?,
        );
        map.insert(
            "updated".to_string(),
            serde_json::to_value(self.updated).map_err(AethelCoreError::JsonProcessingError)?,
        );
        map.insert(
            "v".to_string(),
            serde_json::to_value(&self.v).map_err(AethelCoreError::JsonProcessingError)?,
        );
        map.insert(
            "tags".to_string(),
            serde_json::to_value(&self.tags).map_err(AethelCoreError::JsonProcessingError)?,
        );

        // Add extra fields
        if let Value::Object(extra) = &self.frontmatter_extra {
            for (key, value) in extra {
                map.insert(key.clone(), value.clone());
            }
        }

        Ok(Value::Object(map))
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse_valid_doc() {
        let content = r#"---
uuid: 550e8400-e29b-41d4-a716-446655440000
type: journal.morning
created: 2024-07-29T10:00:00Z
updated: 2024-07-29T10:00:00Z
v: 1.0.0
tags: []
mood: happy
---
Today was a good day!"#;

        let doc = Doc::from_markdown(content).unwrap();
        assert_eq!(doc.doc_type, "journal.morning");
        assert_eq!(doc.body, "Today was a good day!");
        assert_eq!(doc.frontmatter_extra["mood"], "happy");
    }

    #[test]
    fn test_serialize_doc() {
        let doc = Doc {
            uuid: Uuid::parse_str("550e8400-e29b-41d4-a716-446655440000").unwrap(),
            doc_type: "journal.morning".to_string(),
            created: "2024-07-29T10:00:00Z".parse().unwrap(),
            updated: "2024-07-29T10:00:00Z".parse().unwrap(),
            v: Version::parse("1.0.0").unwrap(),
            tags: vec![],
            frontmatter_extra: serde_json::json!({ "mood": "happy" }),
            body: "Today was a good day!".to_string(),
        };

        let markdown = doc.to_markdown().unwrap();
        assert!(markdown.contains("uuid: 550e8400-e29b-41d4-a716-446655440000"));
        assert!(markdown.contains("type: journal.morning"));
        assert!(markdown.contains("Today was a good day!"));
    }

    #[test]
    fn test_parse_crlf_line_endings() {
        let content = "---\r\nuuid: 550e8400-e29b-41d4-a716-446655440000\r\ntype: journal.morning\r\ncreated: 2024-07-29T10:00:00Z\r\nupdated: 2024-07-29T10:00:00Z\r\nv: 1.0.0\r\ntags: []\r\n---\r\nToday was a good day!";

        let doc = Doc::from_markdown(content).unwrap();
        assert_eq!(doc.doc_type, "journal.morning");
        assert_eq!(doc.body, "Today was a good day!");
    }

    #[test]
    fn test_parse_with_whitespace() {
        let content = "---   \nuuid: 550e8400-e29b-41d4-a716-446655440000\ntype: journal.morning\ncreated: 2024-07-29T10:00:00Z\nupdated: 2024-07-29T10:00:00Z\nv: 1.0.0\ntags: []\n---  \nToday was a good day!";

        let doc = Doc::from_markdown(content).unwrap();
        assert_eq!(doc.doc_type, "journal.morning");
        assert_eq!(doc.body, "Today was a good day!");
    }

    #[test]
    fn test_parse_missing_opening_delimiter() {
        let content =
            "uuid: 550e8400-e29b-41d4-a716-446655440000\ntype: journal.morning\n---\nBody";

        let err = Doc::from_markdown(content).unwrap_err();
        match err {
            AethelCoreError::MalformedDocFile(msg) => {
                assert!(msg.contains("Content before first '---' delimiter"));
            }
            _ => panic!("Expected MalformedDocFile error"),
        }
    }

    #[test]
    fn test_parse_missing_closing_delimiter() {
        let content = "---\nuuid: 550e8400-e29b-41d4-a716-446655440000\ntype: journal.morning\ncreated: 2024-07-29T10:00:00Z\nupdated: 2024-07-29T10:00:00Z\nv: 1.0.0\ntags: []";

        let err = Doc::from_markdown(content).unwrap_err();
        match err {
            AethelCoreError::MalformedDocFile(msg) => {
                assert!(msg.contains("Missing closing '---' delimiter"));
            }
            _ => panic!("Expected MalformedDocFile error"),
        }
    }

    #[test]
    fn test_parse_body_contains_triple_dash() {
        let content = "---\nuuid: 550e8400-e29b-41d4-a716-446655440000\ntype: journal.morning\ncreated: 2024-07-29T10:00:00Z\nupdated: 2024-07-29T10:00:00Z\nv: 1.0.0\ntags: []\n---\nToday was a good day!\n---\nThis is still part of the body.";

        let doc = Doc::from_markdown(content).unwrap();
        assert_eq!(doc.doc_type, "journal.morning");
        assert_eq!(
            doc.body,
            "Today was a good day!\n---\nThis is still part of the body."
        );
    }
}
