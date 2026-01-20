//! Domino ID generator - generates unique IDs for project domino tasks.
//!
//! Uses beads-style ID generation: SHA256 hash of seed, base36 encoded,
//! with adaptive length and collision checking.

use chrono::{DateTime, Utc};
use clap::{Parser, Subcommand};
use sha2::{Digest, Sha256};
use std::collections::HashSet;
use std::fs;
use std::io::{BufRead, BufReader};
use std::path::Path;

const PREFIX: &str = "d";
const MIN_HASH_LENGTH: usize = 3;
const MAX_HASH_LENGTH: usize = 8;

#[derive(Parser)]
#[command(name = "domino-id")]
#[command(about = "Generate unique domino IDs for project tasks")]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// Generate a new domino ID for a task
    Generate {
        /// Path to the project markdown file
        #[arg(short, long)]
        project: String,

        /// The task description
        #[arg(short, long)]
        task: String,
    },
    /// List existing domino IDs for a project
    List {
        /// Path to the project markdown file
        #[arg(short, long)]
        project: String,
    },
}

fn main() {
    let cli = Cli::parse();

    match cli.command {
        Commands::Generate { project, task } => {
            let project_path = Path::new(&project);
            match generate_domino_id(project_path, &task) {
                Ok(id) => println!("{id}"),
                Err(e) => {
                    eprintln!("Error: {e}");
                    std::process::exit(1);
                }
            }
        }
        Commands::List { project } => {
            let project_path = Path::new(&project);
            match list_existing_ids(project_path) {
                Ok(ids) => {
                    for id in ids {
                        println!("{id}");
                    }
                }
                Err(e) => {
                    eprintln!("Error: {e}");
                    std::process::exit(1);
                }
            }
        }
    }
}

/// Generate a new unique domino ID for a task.
pub fn generate_domino_id(project_path: &Path, task: &str) -> Result<String, String> {
    let existing_ids = list_existing_ids(project_path).unwrap_or_default();
    let project_slug = project_path
        .file_stem()
        .and_then(|s| s.to_str())
        .unwrap_or("unknown");

    let now = Utc::now();
    let count = existing_ids.len();

    generate_id_with_collision_check(project_slug, task, now, count, |id| existing_ids.contains(id))
}

/// Generate ID with collision checking.
fn generate_id_with_collision_check<F>(
    project_slug: &str,
    task: &str,
    created_at: DateTime<Utc>,
    existing_count: usize,
    exists: F,
) -> Result<String, String>
where
    F: Fn(&str) -> bool,
{
    let mut length = optimal_length(existing_count);

    loop {
        // Try nonces 0..10 at this length
        for nonce in 0..10 {
            let id = generate_candidate(project_slug, task, created_at, nonce, length);
            if !exists(&id) {
                return Ok(id);
            }
        }

        // All nonces collided, increase length
        if length < MAX_HASH_LENGTH {
            length += 1;
        } else {
            // Fallback: try more nonces with max length
            for nonce in 10..1000 {
                let id = generate_candidate(project_slug, task, created_at, nonce, MAX_HASH_LENGTH);
                if !exists(&id) {
                    return Ok(id);
                }
            }
            return Err("Could not generate unique ID after 1000 attempts".to_string());
        }
    }
}

/// Compute optimal hash length based on existing count.
/// Uses birthday problem approximation.
fn optimal_length(existing_count: usize) -> usize {
    let n = existing_count as f64;
    let max_prob = 0.25;

    for len in MIN_HASH_LENGTH..=MAX_HASH_LENGTH {
        let space = 36_f64.powi(len as i32);
        // Birthday problem: P(collision) ≈ 1 - e^(-n²/2d)
        let prob = 1.0 - (-n * n / (2.0 * space)).exp();
        if prob < max_prob {
            return len;
        }
    }
    MAX_HASH_LENGTH
}

/// Generate a candidate ID.
fn generate_candidate(
    project_slug: &str,
    task: &str,
    created_at: DateTime<Utc>,
    nonce: u32,
    hash_length: usize,
) -> String {
    let seed = generate_seed(project_slug, task, created_at, nonce);
    let hash = compute_hash(&seed, hash_length);
    format!("{PREFIX}-{hash}")
}

/// Generate seed string for hashing.
fn generate_seed(project_slug: &str, task: &str, created_at: DateTime<Utc>, nonce: u32) -> String {
    format!(
        "{}|{}|{}|{}",
        project_slug,
        task,
        created_at.timestamp_nanos_opt().unwrap_or(0),
        nonce
    )
}

/// Compute base36 hash of input.
fn compute_hash(input: &str, length: usize) -> String {
    let mut hasher = Sha256::new();
    hasher.update(input.as_bytes());
    let result = hasher.finalize();

    // Use first 8 bytes for a 64-bit integer
    let mut num = 0u64;
    for &byte in result.iter().take(8) {
        num = (num << 8) | u64::from(byte);
    }

    let encoded = base36_encode(num);

    // Pad with '0' if too short
    let mut s = encoded;
    while s.len() < length {
        s = format!("0{s}");
    }

    // Take the first `length` chars
    s.chars().take(length).collect()
}

/// Encode a u64 as base36 (0-9, a-z).
fn base36_encode(mut num: u64) -> String {
    const ALPHABET: &[u8] = b"0123456789abcdefghijklmnopqrstuvwxyz";
    if num == 0 {
        return "0".to_string();
    }
    let mut chars = Vec::new();
    while num > 0 {
        chars.push(ALPHABET[(num % 36) as usize] as char);
        num /= 36;
    }
    chars.into_iter().rev().collect()
}

/// List all existing domino IDs for a project.
pub fn list_existing_ids(project_path: &Path) -> Result<HashSet<String>, String> {
    let mut ids = HashSet::new();

    // 1. Parse IDs from project markdown frontmatter
    if project_path.exists() {
        let content = fs::read_to_string(project_path)
            .map_err(|e| format!("Failed to read project file: {e}"))?;
        ids.extend(extract_ids_from_frontmatter(&content));
    }

    // 2. Parse IDs from log.jsonl file (in same directory as project file)
    let log_path = project_path.parent().map(|p| p.join("log.jsonl")).unwrap_or_else(|| "log.jsonl".into());
    if log_path.exists() {
        let file = fs::File::open(&log_path)
            .map_err(|e| format!("Failed to open log file: {e}"))?;
        let reader = BufReader::new(file);

        for line in reader.lines() {
            let line = line.map_err(|e| format!("Failed to read log line: {e}"))?;
            if let Ok(entry) = serde_json::from_str::<LogEntry>(&line) {
                if let Some(dominoes) = entry.dominoes {
                    ids.extend(dominoes);
                }
            }
        }
    }

    Ok(ids)
}

/// Extract domino IDs from YAML frontmatter.
fn extract_ids_from_frontmatter(content: &str) -> Vec<String> {
    let mut ids = Vec::new();

    // Find YAML frontmatter between --- markers
    if !content.starts_with("---") {
        return ids;
    }

    let rest = &content[3..];
    if let Some(end_idx) = rest.find("\n---") {
        let yaml_content = &rest[..end_idx];

        if let Ok(frontmatter) = serde_yaml::from_str::<Frontmatter>(yaml_content) {
            for domino in frontmatter.dominoes.unwrap_or_default() {
                if let Domino::Structured { id, .. } = domino {
                    ids.push(id);
                }
            }
        }
    }

    ids
}

#[derive(Debug, serde::Deserialize)]
struct Frontmatter {
    dominoes: Option<Vec<Domino>>,
}

#[derive(Debug, serde::Deserialize)]
#[serde(untagged)]
enum Domino {
    Simple(String),
    Structured { id: String, task: String },
}

#[derive(Debug, serde::Deserialize)]
struct LogEntry {
    dominoes: Option<Vec<String>>,
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::io::Write;
    use tempfile::TempDir;

    #[test]
    fn test_base36_encode() {
        assert_eq!(base36_encode(0), "0");
        assert_eq!(base36_encode(35), "z");
        assert_eq!(base36_encode(36), "10");
        assert_eq!(base36_encode(1295), "zz");
    }

    #[test]
    fn test_compute_hash_length() {
        let hash = compute_hash("test input", 3);
        assert_eq!(hash.len(), 3);

        let hash = compute_hash("test input", 5);
        assert_eq!(hash.len(), 5);
    }

    #[test]
    fn test_compute_hash_deterministic() {
        let hash1 = compute_hash("same input", 5);
        let hash2 = compute_hash("same input", 5);
        assert_eq!(hash1, hash2);
    }

    #[test]
    fn test_compute_hash_different_inputs() {
        let hash1 = compute_hash("input one", 5);
        let hash2 = compute_hash("input two", 5);
        assert_ne!(hash1, hash2);
    }

    #[test]
    fn test_optimal_length_small_db() {
        assert_eq!(optimal_length(0), MIN_HASH_LENGTH);
        assert_eq!(optimal_length(10), MIN_HASH_LENGTH);
    }

    #[test]
    fn test_optimal_length_grows() {
        let len_small = optimal_length(10);
        let len_large = optimal_length(10000);
        assert!(len_large >= len_small);
    }

    #[test]
    fn test_generate_candidate_format() {
        let now = Utc::now();
        let id = generate_candidate("test-project", "test task", now, 0, 4);
        assert!(id.starts_with("d-"));
        assert_eq!(id.len(), 6); // "d-" + 4 chars
    }

    #[test]
    fn test_generate_id_no_collisions() {
        let now = Utc::now();
        let result = generate_id_with_collision_check(
            "test-project",
            "test task",
            now,
            0,
            |_| false, // No collisions
        );
        assert!(result.is_ok());
        assert!(result.unwrap().starts_with("d-"));
    }

    #[test]
    fn test_generate_id_with_some_collisions() {
        use std::cell::Cell;
        let now = Utc::now();
        let call_count = Cell::new(0);
        let result = generate_id_with_collision_check(
            "test-project",
            "test task",
            now,
            0,
            |_| {
                // First 5 calls collide, then succeed
                let count = call_count.get();
                call_count.set(count + 1);
                count < 5
            },
        );
        assert!(result.is_ok());
    }

    #[test]
    fn test_extract_ids_from_frontmatter_simple() {
        let content = r#"---
kind: project
dominoes:
  - "simple task"
---
# Project
"#;
        let ids = extract_ids_from_frontmatter(content);
        assert!(ids.is_empty()); // Simple strings have no ID
    }

    #[test]
    fn test_extract_ids_from_frontmatter_structured() {
        let content = r#"---
kind: project
dominoes:
  - id: d-abc
    task: "structured task"
  - id: d-xyz
    task: "another task"
---
# Project
"#;
        let ids = extract_ids_from_frontmatter(content);
        assert_eq!(ids.len(), 2);
        assert!(ids.contains(&"d-abc".to_string()));
        assert!(ids.contains(&"d-xyz".to_string()));
    }

    #[test]
    fn test_list_existing_ids_with_log() {
        let tmp_dir = TempDir::new().unwrap();
        let project_dir = tmp_dir.path().join("test-project");
        fs::create_dir(&project_dir).unwrap();
        let project_path = project_dir.join("index.md");
        let log_path = project_dir.join("log.jsonl");

        // Create project file with structured domino
        fs::write(&project_path, r#"---
kind: project
dominoes:
  - id: d-abc
    task: "current task"
---
# Test
"#).unwrap();

        // Create log file with completed domino
        let mut log_file = fs::File::create(&log_path).unwrap();
        writeln!(log_file, r#"{{"ts":"2026-01-19T12:00:00Z","what":"did stuff","dominoes":["d-xyz"]}}"#).unwrap();

        let ids = list_existing_ids(&project_path).unwrap();
        assert!(ids.contains("d-abc"));
        assert!(ids.contains("d-xyz"));
    }

    #[test]
    fn test_generate_domino_id_integration() {
        let tmp_dir = TempDir::new().unwrap();
        let project_dir = tmp_dir.path().join("test-project");
        fs::create_dir(&project_dir).unwrap();
        let project_path = project_dir.join("index.md");

        // Create empty project file
        fs::write(&project_path, r#"---
kind: project
dominoes: []
---
# Test
"#).unwrap();

        let id = generate_domino_id(&project_path, "new task").unwrap();
        assert!(id.starts_with("d-"));
        assert!(id.len() >= 5); // d- + at least 3 chars
    }
}
