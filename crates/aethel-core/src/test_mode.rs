//! Test mode utilities for deterministic behavior

use chrono::{DateTime, Utc};
use once_cell::sync::Lazy;
use parking_lot::Mutex;
use std::sync::Arc;
use uuid::Uuid;

/// Global test mode configuration
static TEST_MODE_CONFIG: Lazy<Arc<Mutex<Option<TestModeConfig>>>> =
    Lazy::new(|| Arc::new(Mutex::new(None)));

#[derive(Debug, Clone)]
pub struct TestModeConfig {
    pub now: Option<DateTime<Utc>>,
    pub uuid_seed: Option<u64>,
    pub git_enabled: bool,
}

/// Initialize test mode configuration
pub fn init_test_mode(now: Option<&str>, uuid_seed: Option<&str>, git_enabled: bool) {
    let config = TestModeConfig {
        now: now.and_then(|s| s.parse().ok()),
        uuid_seed: uuid_seed.and_then(|s| u64::from_str_radix(s, 16).ok()),
        git_enabled,
    };

    let mut guard = TEST_MODE_CONFIG.lock();
    *guard = Some(config);
}

/// Check if test mode is enabled
pub fn is_test_mode() -> bool {
    TEST_MODE_CONFIG.lock().is_some()
}

/// Get current timestamp (respects test mode)
pub fn now() -> DateTime<Utc> {
    let guard = TEST_MODE_CONFIG.lock();
    if let Some(config) = guard.as_ref() {
        if let Some(now) = config.now {
            return now;
        }
    }
    Utc::now()
}

/// Generate UUID (respects test mode seed)
pub fn generate_uuid() -> Uuid {
    let guard = TEST_MODE_CONFIG.lock();
    if let Some(config) = guard.as_ref() {
        if let Some(seed) = config.uuid_seed {
            // Use a deterministic UUID based on seed and counter
            static COUNTER: Lazy<Mutex<u64>> = Lazy::new(|| Mutex::new(0));
            let mut counter = COUNTER.lock();
            let value = seed.wrapping_add(*counter);
            *counter += 1;

            // Create deterministic UUID v4
            let bytes = [
                (value >> 56) as u8,
                (value >> 48) as u8,
                (value >> 40) as u8,
                (value >> 32) as u8,
                (value >> 24) as u8,
                (value >> 16) as u8,
                0x40 | ((value >> 8) & 0x0f) as u8, // Version 4
                (value & 0xff) as u8,
                0x80 | ((seed >> 56) & 0x3f) as u8, // Variant
                (seed >> 48) as u8,
                (seed >> 40) as u8,
                (seed >> 32) as u8,
                (seed >> 24) as u8,
                (seed >> 16) as u8,
                (seed >> 8) as u8,
                (seed & 0xff) as u8,
            ];
            return Uuid::from_bytes(bytes);
        }
    }

    // Normal UUID v7 generation
    Uuid::new_v7(uuid::Timestamp::now(uuid::NoContext))
}

/// Check if git operations are enabled (respects test mode)
pub fn is_git_enabled() -> bool {
    let guard = TEST_MODE_CONFIG.lock();
    if let Some(config) = guard.as_ref() {
        return config.git_enabled;
    }
    true
}
