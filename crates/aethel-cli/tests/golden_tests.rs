//! Golden test harness for Aethel CLI

use anyhow::{Context, Result};
use assert_cmd::Command;
use serde_json::Value;
use std::fs;
use std::path::{Path, PathBuf};
use tempfile::TempDir;
use walkdir::WalkDir;

/// Test case configuration
#[derive(Debug)]
struct TestCase {
    name: String,
    dir: PathBuf,
    cli_args: Vec<String>,
    env_vars: std::collections::HashMap<String, String>,
    input_json: Option<String>,
    expect_exit: i32,
    expect_stdout: ExpectedOutput,
    vault_before: PathBuf,
    vault_after: Option<PathBuf>,
    git_after: Option<String>,
}

#[derive(Debug)]
enum ExpectedOutput {
    Json(Value),
    Markdown(String),
}

impl TestCase {
    fn load(case_dir: &Path) -> Result<Self> {
        let name = case_dir
            .file_name()
            .and_then(|s| s.to_str())
            .unwrap_or("unknown")
            .to_string();

        // Read CLI args
        let cli_args_path = case_dir.join("cli-args.txt");
        let cli_args = fs::read_to_string(&cli_args_path)
            .context("Failed to read cli-args.txt")?
            .trim()
            .split_whitespace()
            .map(String::from)
            .collect();

        // Read env vars
        let env_path = case_dir.join("env.json");
        let env_vars: std::collections::HashMap<String, String> = if env_path.exists() {
            let content = fs::read_to_string(&env_path)?;
            serde_json::from_str(&content)?
        } else {
            std::collections::HashMap::new()
        };

        // Read input JSON if exists
        let input_json = if case_dir.join("input.json").exists() {
            Some(fs::read_to_string(case_dir.join("input.json"))?)
        } else {
            None
        };

        // Read expected exit code
        let expect_exit = fs::read_to_string(case_dir.join("expect.exit.txt"))?
            .trim()
            .parse::<i32>()?;

        // Read expected output
        let expect_stdout = if case_dir.join("expect.stdout.json").exists() {
            let content = fs::read_to_string(case_dir.join("expect.stdout.json"))?;
            ExpectedOutput::Json(serde_json::from_str(&content)?)
        } else if case_dir.join("expect.stdout.md").exists() {
            ExpectedOutput::Markdown(fs::read_to_string(case_dir.join("expect.stdout.md"))?)
        } else {
            anyhow::bail!("No expect.stdout.json or expect.stdout.md found");
        };

        // Check paths
        let vault_before = case_dir.join("vault.before");
        if !vault_before.exists() {
            anyhow::bail!("vault.before directory not found");
        }

        let vault_after = if case_dir.join("vault.after").exists() {
            Some(case_dir.join("vault.after"))
        } else {
            None
        };

        let git_after = if case_dir.join("git.after.txt").exists() {
            Some(fs::read_to_string(case_dir.join("git.after.txt"))?)
        } else {
            None
        };

        Ok(TestCase {
            name,
            dir: case_dir.to_path_buf(),
            cli_args,
            env_vars,
            input_json,
            expect_exit,
            expect_stdout,
            vault_before,
            vault_after,
            git_after,
        })
    }

    fn run(&self) -> Result<()> {
        println!("Running test case: {}", self.name);

        // Create temp directory and copy vault.before
        let temp_dir = TempDir::new()?;
        let vault_path = temp_dir.path().join("vault");
        copy_dir_all(&self.vault_before, &vault_path)?;

        // Build command
        let mut cmd = Command::cargo_bin("aethel")?;
        cmd.current_dir(&temp_dir);
        cmd.arg("--vault-root").arg(&vault_path);
        
        // Add CLI args
        for (i, arg) in self.cli_args.iter().enumerate() {
            // Handle relative paths for add command
            if i == 1 && self.cli_args[0] == "add" && !arg.starts_with('-') {
                // This is the pack source path - resolve it relative to the test case directory
                if arg.contains("/pack-to-add") {
                    // Resolve pack path relative to the test case directory
                    let pack_path = self.dir.join("pack-to-add");
                    cmd.arg(pack_path);
                } else {
                    cmd.arg(arg);
                }
            } else {
                cmd.arg(arg);
            }
        }

        // Set env vars
        cmd.env("AETHEL_TEST_MODE", "1");
        for (key, value) in &self.env_vars {
            if key.starts_with("--") {
                // Handle special test mode flags
                match key.as_str() {
                    "--now" => {
                        cmd.arg("--now").arg(value);
                    }
                    "--uuid-seed" => {
                        cmd.arg("--uuid-seed").arg(value);
                    }
                    "--git" => {
                        if value == "false" {
                            cmd.arg("--git=false");
                        }
                    }
                    _ => {}
                };
            } else {
                cmd.env(key, value);
            }
        }

        // Provide input if needed
        if let Some(input) = &self.input_json {
            cmd.write_stdin(input.as_bytes());
        }

        // Run command
        let output = cmd.output()?;
        let exit_code = output.status.code().unwrap_or(-1);
        let stdout = String::from_utf8_lossy(&output.stdout);
        let stderr = String::from_utf8_lossy(&output.stderr);
        
        // Debug output for failing tests
        if stdout.is_empty() && exit_code != 0 {
            eprintln!("Command failed with stderr: {}", stderr);
        }

        // Check if we're updating golden files
        let update_golden = std::env::var("UPDATE_GOLDEN").is_ok();

        if update_golden {
            self.update_golden_files(&vault_path, exit_code, &stdout)?;
            anyhow::bail!("Golden files updated; please review and commit.");
        }

        // Verify exit code
        if exit_code != self.expect_exit {
            anyhow::bail!(
                "Exit code mismatch: expected {}, got {}\nstderr: {}",
                self.expect_exit,
                exit_code,
                stderr
            );
        }

        // Verify stdout
        match &self.expect_stdout {
            ExpectedOutput::Json(expected) => {
                let actual: Value = serde_json::from_str(&stdout)
                    .context("Failed to parse stdout as JSON")?;
                let actual_canonical = canonicalize_json(&actual);
                let expected_canonical = canonicalize_json(expected);
                
                if actual_canonical != expected_canonical {
                    anyhow::bail!(
                        "JSON output mismatch:\nExpected:\n{}\nActual:\n{}",
                        serde_json::to_string_pretty(&expected_canonical)?,
                        serde_json::to_string_pretty(&actual_canonical)?
                    );
                }
            }
            ExpectedOutput::Markdown(expected) => {
                let actual_normalized = normalize_markdown(&stdout);
                let expected_normalized = normalize_markdown(expected);
                
                if actual_normalized != expected_normalized {
                    anyhow::bail!(
                        "Markdown output mismatch:\nExpected:\n{}\nActual:\n{}",
                        expected_normalized,
                        actual_normalized
                    );
                }
            }
        }

        // Verify vault state if expected
        if let Some(vault_after) = &self.vault_after {
            compare_directories(&vault_path, vault_after)?;
        }

        // Verify git state if expected
        if let Some(expected_git) = &self.git_after {
            let git_output = std::process::Command::new("git")
                .arg("-C")
                .arg(&vault_path)
                .arg("log")
                .arg("-n")
                .arg("1")
                .arg("--pretty=oneline")
                .arg("--no-decorate")
                .output()?;
            
            let actual_git = String::from_utf8_lossy(&git_output.stdout).trim().to_string();
            if actual_git != expected_git.trim() {
                anyhow::bail!(
                    "Git state mismatch:\nExpected:\n{}\nActual:\n{}",
                    expected_git.trim(),
                    actual_git
                );
            }
        }

        println!("✓ Test case {} passed", self.name);
        Ok(())
    }

    fn update_golden_files(&self, vault_path: &Path, exit_code: i32, stdout: &str) -> Result<()> {
        // Update exit code
        fs::write(
            self.dir.join("expect.exit.txt"),
            format!("{}\n", exit_code),
        )?;

        // Update stdout
        match &self.expect_stdout {
            ExpectedOutput::Json(_) => {
                let value: Value = serde_json::from_str(stdout)?;
                let canonical = canonicalize_json(&value);
                fs::write(
                    self.dir.join("expect.stdout.json"),
                    serde_json::to_string_pretty(&canonical)?,
                )?;
            }
            ExpectedOutput::Markdown(_) => {
                fs::write(
                    self.dir.join("expect.stdout.md"),
                    normalize_markdown(stdout),
                )?;
            }
        }

        // Update vault.after
        if self.vault_after.is_some() || vault_path.join("docs").exists() {
            let vault_after_path = self.dir.join("vault.after");
            if vault_after_path.exists() {
                fs::remove_dir_all(&vault_after_path)?;
            }
            copy_dir_all(vault_path, &vault_after_path)?;
            
            // Remove .git/objects to avoid bloat
            let git_objects = vault_after_path.join(".git/objects");
            if git_objects.exists() {
                fs::remove_dir_all(git_objects)?;
            }
        }

        // Update git.after.txt if git dir exists
        if vault_path.join(".git").exists() {
            let git_output = std::process::Command::new("git")
                .arg("-C")
                .arg(vault_path)
                .arg("log")
                .arg("-n")
                .arg("1")
                .arg("--pretty=oneline")
                .arg("--no-decorate")
                .output()?;
            
            fs::write(
                self.dir.join("git.after.txt"),
                String::from_utf8_lossy(&git_output.stdout).as_bytes(),
            )?;
        }

        Ok(())
    }
}

/// Canonicalize JSON for comparison
fn canonicalize_json(value: &Value) -> Value {
    match value {
        Value::Object(map) => {
            let mut sorted_map = serde_json::Map::new();
            let mut keys: Vec<_> = map.keys().collect();
            keys.sort();
            for key in keys {
                let mut val = canonicalize_json(&map[key]);
                // Normalize paths to be relative to vault root
                if key == "path" {
                    if let Value::String(path_str) = &val {
                        if let Some(idx) = path_str.rfind("/vault/") {
                            val = Value::String(format!("vault/{}", &path_str[idx + 7..]));
                        }
                    }
                }
                sorted_map.insert(key.clone(), val);
            }
            Value::Object(sorted_map)
        }
        Value::Array(arr) => {
            Value::Array(arr.iter().map(canonicalize_json).collect())
        }
        _ => value.clone(),
    }
}

/// Normalize markdown content
fn normalize_markdown(content: &str) -> String {
    content
        .lines()
        .map(|line| line.trim_end())
        .collect::<Vec<_>>()
        .join("\n")
        .trim()
        .to_string()
}

/// Copy directory recursively
fn copy_dir_all(src: &Path, dst: &Path) -> Result<()> {
    fs::create_dir_all(dst)?;
    
    for entry in fs::read_dir(src)? {
        let entry = entry?;
        let src_path = entry.path();
        let dst_path = dst.join(entry.file_name());
        
        if src_path.is_dir() {
            copy_dir_all(&src_path, &dst_path)?;
        } else {
            fs::copy(&src_path, &dst_path)?;
        }
    }
    
    Ok(())
}

/// Compare two directories
fn compare_directories(actual: &Path, expected: &Path) -> Result<()> {
    let mut actual_files = collect_files(actual)?;
    let mut expected_files = collect_files(expected)?;
    
    actual_files.sort();
    expected_files.sort();
    
    // Check file lists match
    if actual_files != expected_files {
        anyhow::bail!(
            "Directory structure mismatch:\nActual files: {:?}\nExpected files: {:?}",
            actual_files,
            expected_files
        );
    }
    
    // Compare file contents
    for rel_path in &actual_files {
        let actual_path = actual.join(rel_path);
        let expected_path = expected.join(rel_path);
        
        // Skip .git/objects
        if rel_path.starts_with(".git/objects") {
            continue;
        }
        
        let actual_content = fs::read(&actual_path)?;
        let expected_content = fs::read(&expected_path)?;
        
        // Special handling for YAML files
        if rel_path.ends_with(".md") && actual_path.exists() {
            // Parse and compare frontmatter
            let actual_str = String::from_utf8_lossy(&actual_content);
            let expected_str = String::from_utf8_lossy(&expected_content);
            
            if !compare_doc_files(&actual_str, &expected_str)? {
                anyhow::bail!(
                    "File content mismatch for {}:\nActual:\n{}\nExpected:\n{}",
                    rel_path,
                    actual_str,
                    expected_str
                );
            }
        } else if actual_content != expected_content {
            anyhow::bail!(
                "File content mismatch for {}: {} bytes vs {} bytes",
                rel_path,
                actual_content.len(),
                expected_content.len()
            );
        }
    }
    
    Ok(())
}

/// Collect all files in a directory (relative paths)
fn collect_files(dir: &Path) -> Result<Vec<String>> {
    let mut files = Vec::new();
    
    for entry in WalkDir::new(dir) {
        let entry = entry?;
        if entry.file_type().is_file() {
            let rel_path = entry.path().strip_prefix(dir)?;
            let rel_str = rel_path.to_string_lossy().replace('\\', "/");
            
            // Skip .DS_Store
            if rel_str.ends_with(".DS_Store") {
                continue;
            }
            
            files.push(rel_str);
        }
    }
    
    Ok(files)
}

/// Compare two doc files, handling frontmatter normalization
fn compare_doc_files(actual: &str, expected: &str) -> Result<bool> {
    // For now, just compare normalized content
    // In a real implementation, we'd parse YAML frontmatter and compare semantically
    Ok(normalize_markdown(actual) == normalize_markdown(expected))
}

/// Discover and run all test cases
pub fn run_all_tests() -> Result<()> {
    let test_dir = Path::new("../../tests/cases");
    let mut entries: Vec<_> = fs::read_dir(test_dir)?
        .filter_map(|e| e.ok())
        .filter(|e| e.path().is_dir())
        .collect();
    
    entries.sort_by_key(|e| e.file_name());
    
    let mut failed = Vec::new();
    
    for entry in entries {
        let case_dir = entry.path();
        match TestCase::load(&case_dir) {
            Ok(test_case) => {
                if let Err(e) = test_case.run() {
                    failed.push((test_case.name, e));
                }
            }
            Err(e) => {
                let name = case_dir.file_name()
                    .and_then(|s| s.to_str())
                    .unwrap_or("unknown")
                    .to_string();
                failed.push((name, e));
            }
        }
    }
    
    if !failed.is_empty() {
        eprintln!("\n{} test(s) failed:", failed.len());
        for (name, err) in &failed {
            eprintln!("\n{}: {:#}", name, err);
        }
        anyhow::bail!("{} test(s) failed", failed.len());
    }
    
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_golden_suite() {
        if let Err(e) = run_all_tests() {
            panic!("Golden tests failed: {:#}", e);
        }
    }
}