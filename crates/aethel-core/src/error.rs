//! Error types for aethel-core
//! 
//! All fallible operations in aethel-core return Result<T, AethelCoreError>.
//! Each error variant maps to a protocol error code as defined in protocol.md.

use thiserror::Error;
use std::path::PathBuf;
use uuid::Uuid;
use semver::Version;

#[derive(Error, Debug)]
#[non_exhaustive] // Allow adding new error variants without breaking consumers
pub enum AethelCoreError {
    // 400xx: Bad Request / Malformed input
    #[error("Malformed request JSON: {0}")]
    MalformedRequestJson(#[source] serde_json::Error),
    
    #[error("Unknown patch mode '{0}'")]
    UnknownPatchMode(String),
    
    #[error("Attempted to set system-controlled key '{key}' in frontmatter.")]
    AttemptToSetSystemKey { key: String },
    
    #[error("Missing required field '{field}' for patch mode '{mode}'")]
    MissingRequiredField { field: String, mode: String },
    
    #[error("Invalid UUID format: {0}")]
    InvalidUuidFormat(#[source] uuid::Error),
    
    #[error("Invalid SemVer format: {0}")]
    InvalidSemVerFormat(#[source] semver::Error),
    
    #[error("Invalid ISO 8601 UTC timestamp format: {0}")]
    InvalidTimestampFormat(#[source] chrono::ParseError),
    
    #[error("Malformed YAML frontmatter: {0}")]
    MalformedYaml(#[source] serde_yaml::Error),
    
    #[error("Malformed Doc file: {0}")]
    MalformedDocFile(String), // e.g., missing '---' delimiters

    // 404xx: Not Found
    #[error("Doc with UUID '{0}' not found at '{1}'")]
    DocNotFound(Uuid, PathBuf),
    
    #[error("Pack '{0}' not found at '{1}'")]
    PackNotFound(String, PathBuf),
    
    #[error("Pack type '{0}' not found within pack '{1}'")]
    PackTypeNotFound(String, String),
    
    #[error("Schema file '{0}' not found for pack type '{1}'")]
    SchemaFileNotFound(PathBuf, String),

    // 409xx: Conflict
    #[error("Type mismatch: Doc has type '{existing_type}', patch specified '{patch_type}'")]
    TypeMismatchOnUpdate { existing_type: String, patch_type: String },
    
    #[error("Concurrent write conflict detected.")]
    ConcurrentWriteConflict, // Requires file locking mechanism

    // 422xx: Unprocessable Entity (Validation)
    #[error("Schema validation failed: {message}. Pointer: {pointer:?}, Expected: {expected:?}, Got: {got:?}")]
    SchemaValidation {
        message: String,
        pointer: Option<String>,
        expected: Option<String>,
        got: Option<String>,
        #[source]
        source: Option<Box<dyn std::error::Error + Send + Sync>>,
    },
    
    #[error("Unknown frontmatter key '{key}' not allowed by schema for type '{doc_type}'")]
    UnknownFrontmatterKey { key: String, doc_type: String },
    
    #[error("Pack '{pack_name}' protocol version '{pack_protocol_version}' is incompatible with current protocol version '{current_protocol_version}' (major version mismatch).")]
    ProtocolVersionMismatch {
        pack_name: String,
        pack_protocol_version: Version,
        current_protocol_version: Version,
    },

    // 500xx: Internal Server Error (System)
    #[error("File system I/O error on path '{path}': {source}")]
    Io {
        #[source]
        source: std::io::Error,
        path: PathBuf,
    },
    
    #[error("Atomic file write failed for '{path}': {source}")]
    AtomicWriteFailed {
        #[source]
        source: Box<dyn std::error::Error + Send + Sync>, // Can be tempfile::PersistError, etc.
        path: PathBuf,
    },
    
    #[error("Internal schema compilation error: {0}")]
    SchemaCompilationError(String),
    
    #[error("Internal JSON processing error: {0}")]
    JsonProcessingError(#[source] serde_json::Error),
    
    #[error("Internal lock file error: {0}")]
    LockFileError(String), // For .aethel/lock

    // Catch-all for unexpected errors
    #[error("An unexpected internal error occurred: {0}")]
    Other(String),
}

impl AethelCoreError {
    /// Maps error variants to protocol error codes as defined in protocol.md
    pub fn protocol_code(&self) -> u16 {
        match self {
            AethelCoreError::MalformedRequestJson(_) => 40000,
            AethelCoreError::UnknownPatchMode(_) => 40001,
            AethelCoreError::AttemptToSetSystemKey { .. } => 40003,
            AethelCoreError::MissingRequiredField { .. } => 40004,
            AethelCoreError::InvalidUuidFormat(_) => 40005,
            AethelCoreError::InvalidSemVerFormat(_) => 40006,
            AethelCoreError::InvalidTimestampFormat(_) => 40007,
            AethelCoreError::MalformedYaml(_) => 40008,
            AethelCoreError::MalformedDocFile(_) => 40009,
            AethelCoreError::DocNotFound(_, _) => 40401,
            AethelCoreError::PackNotFound(_, _) => 40402,
            AethelCoreError::PackTypeNotFound(_, _) => 40403,
            AethelCoreError::SchemaFileNotFound(_, _) => 40404,
            AethelCoreError::TypeMismatchOnUpdate { .. } => 40902,
            AethelCoreError::ConcurrentWriteConflict => 40903,
            AethelCoreError::SchemaValidation { .. } => 42200,
            AethelCoreError::UnknownFrontmatterKey { .. } => 42201,
            AethelCoreError::ProtocolVersionMismatch { .. } => 42601,
            AethelCoreError::Io { .. } => 50000,
            AethelCoreError::AtomicWriteFailed { .. } => 50001,
            AethelCoreError::SchemaCompilationError(_) => 50002,
            AethelCoreError::JsonProcessingError(_) => 50003,
            AethelCoreError::LockFileError(_) => 50004,
            AethelCoreError::Other(_) => 50099,
        }
    }

    /// Helper to construct SchemaValidation error from jsonschema::ValidationError
    pub fn from_json_schema_error(err: jsonschema::ValidationError<'_>) -> Self {
        AethelCoreError::SchemaValidation {
            message: err.to_string(),
            pointer: Some(err.instance_path.to_string()),
            expected: None, // Schema path not easily accessible
            got: Some(err.instance.to_string()),
            source: None, // Can't clone ValidationError
        }
    }

    /// Helper to construct Io error with path context
    pub fn io_error(err: std::io::Error, path: impl Into<PathBuf>) -> Self {
        AethelCoreError::Io { source: err, path: path.into() }
    }
}