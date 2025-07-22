//! Utility types and functions
//!
//! Common utilities used across the aethel-core crate.

use serde::{Deserialize, Serialize};
use uuid::Uuid;

/// Result of a write operation
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(rename_all = "camelCase")] // Match protocol JSON
pub struct WriteResult {
    pub uuid: Uuid,
    pub path: String,
    pub committed: bool, // True if a change was written to disk
    pub warnings: Vec<String>,
}

/// Generate a new UUID v7
pub fn generate_uuid() -> Uuid {
    Uuid::new_v7(uuid::Timestamp::now(uuid::NoContext))
}

/// Format a timestamp as ISO 8601 UTC string
pub fn format_timestamp(dt: &chrono::DateTime<chrono::Utc>) -> String {
    dt.to_rfc3339()
}

/// Parse an ISO 8601 timestamp
pub fn parse_timestamp(s: &str) -> Result<chrono::DateTime<chrono::Utc>, chrono::ParseError> {
    chrono::DateTime::parse_from_rfc3339(s).map(|dt| dt.with_timezone(&chrono::Utc))
}
