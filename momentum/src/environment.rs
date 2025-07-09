use crate::models::AnalysisResult;
use anyhow::Result;
use async_trait::async_trait;
use std::path::{Path, PathBuf};

/// Environment holds all dependencies with side effects
pub struct Environment {
    pub file_system: Box<dyn FileSystem>,
    pub api_client: Box<dyn ApiClient>,
    pub clock: Box<dyn Clock>,
}

impl Environment {
    /// Create a new environment with real implementations
    pub fn new() -> Result<Self> {
        Ok(Environment {
            file_system: Box::new(RealFileSystem),
            api_client: Box::new(RealApiClient::new()?),
            clock: Box::new(RealClock),
        })
    }

    /// Get the path to session.json
    pub fn get_session_path(&self) -> Result<PathBuf> {
        let mut path =
            dirs::data_dir().ok_or_else(|| anyhow::anyhow!("Could not find data directory"))?;
        path.push("Momentum");

        // Ensure directory exists
        std::fs::create_dir_all(&path)?;

        path.push("session.json");
        Ok(path)
    }

    /// Get the directory for reflection files
    pub fn get_reflections_dir(&self) -> Result<PathBuf> {
        let mut path =
            dirs::data_dir().ok_or_else(|| anyhow::anyhow!("Could not find data directory"))?;
        path.push("Momentum");
        path.push("reflections");

        // Ensure directory exists
        std::fs::create_dir_all(&path)?;

        Ok(path)
    }
}

/// File system operations trait
pub trait FileSystem: Send + Sync {
    fn read(&self, path: &Path) -> Result<String>;
    fn write(&self, path: &Path, content: &str) -> Result<()>;
    fn delete(&self, path: &Path) -> Result<()>;
}

/// API client trait for Claude API
#[async_trait]
pub trait ApiClient: Send + Sync {
    async fn analyze(&self, content: &str) -> Result<AnalysisResult>;
}

/// Clock trait for getting current time
pub trait Clock: Send + Sync {
    fn now(&self) -> u64;
}

// Real implementations

struct RealFileSystem;

impl FileSystem for RealFileSystem {
    fn read(&self, path: &Path) -> Result<String> {
        Ok(std::fs::read_to_string(path)?)
    }

    fn write(&self, path: &Path, content: &str) -> Result<()> {
        Ok(std::fs::write(path, content)?)
    }

    fn delete(&self, path: &Path) -> Result<()> {
        Ok(std::fs::remove_file(path)?)
    }
}

struct RealApiClient {
    _client: reqwest::Client,
    _api_key: String,
}

impl RealApiClient {
    fn new() -> Result<Self> {
        let api_key = std::env::var("ANTHROPIC_API_KEY")
            .map_err(|_| anyhow::anyhow!("ANTHROPIC_API_KEY environment variable not set"))?;

        Ok(Self {
            _client: reqwest::Client::new(),
            _api_key: api_key,
        })
    }
}

#[async_trait]
impl ApiClient for RealApiClient {
    async fn analyze(&self, content: &str) -> Result<AnalysisResult> {
        let prompt = format!(
            r#"You are an AI productivity coach analyzing a focus session reflection. 
                
Please analyze the following reflection and provide:
1. A brief summary of what happened during the session
2. A specific, actionable suggestion for improvement
3. Your reasoning for this suggestion

Reflection:
{}

Respond in JSON format with these exact fields:
{{
    "summary": "brief summary of the session",
    "suggestion": "specific actionable suggestion",
    "reasoning": "why this suggestion would help"
}}"#,
            content
        );

        let request_body = serde_json::json!({
            "model": "claude-3-5-sonnet-20241022",
            "max_tokens": 1024,
            "messages": [{
                "role": "user",
                "content": prompt
            }],
            "temperature": 0.7
        });

        let response = self
            ._client
            .post("https://api.anthropic.com/v1/messages")
            .header("x-api-key", &self._api_key)
            .header("anthropic-version", "2023-06-01")
            .header("content-type", "application/json")
            .json(&request_body)
            .send()
            .await?;

        if !response.status().is_success() {
            let error_text = response.text().await?;
            return Err(anyhow::anyhow!("Claude API error: {}", error_text));
        }

        let response_json: serde_json::Value = response.json().await?;

        // Extract the content from Claude's response with safe navigation
        let claude_response = response_json
            .get("content")
            .and_then(|c| c.as_array())
            .and_then(|a| a.first())
            .and_then(|t| t.get("text"))
            .and_then(|s| s.as_str())
            .ok_or_else(|| anyhow::anyhow!("Could not extract text from Claude API response"))?;

        // Parse the JSON response from Claude
        let analysis: AnalysisResult = serde_json::from_str(claude_response)?;

        Ok(analysis)
    }
}

struct RealClock;

impl Clock for RealClock {
    fn now(&self) -> u64 {
        std::time::SystemTime::now()
            .duration_since(std::time::UNIX_EPOCH)
            .expect("System time is set before the UNIX epoch, which is not supported.")
            .as_secs()
    }
}
