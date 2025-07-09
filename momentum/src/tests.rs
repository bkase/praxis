#[cfg(test)]
mod tests {
    use crate::{action::Action, environment::*, models::*, state::State, update::update};
    use std::collections::HashMap;
    use std::sync::Mutex;
    use async_trait::async_trait;

    // Mock implementations for testing
    struct MockFileSystem {
        files: Mutex<HashMap<String, String>>,
    }

    impl MockFileSystem {
        fn new() -> Self {
            Self {
                files: Mutex::new(HashMap::new()),
            }
        }
    }

    impl FileSystem for MockFileSystem {
        fn read(&self, path: &std::path::PathBuf) -> anyhow::Result<String> {
            let files = self.files.lock().unwrap();
            files
                .get(&path.to_string_lossy().to_string())
                .cloned()
                .ok_or_else(|| anyhow::anyhow!("File not found"))
        }

        fn write(&self, path: &std::path::PathBuf, content: &str) -> anyhow::Result<()> {
            let mut files = self.files.lock().unwrap();
            files.insert(path.to_string_lossy().to_string(), content.to_string());
            Ok(())
        }

        fn delete(&self, path: &std::path::PathBuf) -> anyhow::Result<()> {
            let mut files = self.files.lock().unwrap();
            files.remove(&path.to_string_lossy().to_string());
            Ok(())
        }
    }

    struct MockClock {
        time: u64,
    }

    impl Clock for MockClock {
        fn now(&self) -> u64 {
            self.time
        }
    }

    struct MockApiClient;

    #[async_trait]
    impl ApiClient for MockApiClient {
        async fn analyze(&self, _content: &str) -> anyhow::Result<AnalysisResult> {
            Ok(AnalysisResult {
                summary: "Test summary".to_string(),
                suggestion: "Test suggestion".to_string(),
                reasoning: "Test reasoning".to_string(),
            })
        }
    }

    #[test]
    fn test_start_session_when_idle() {
        let env = Environment {
            file_system: Box::new(MockFileSystem::new()),
            api_client: Box::new(MockApiClient),
            clock: Box::new(MockClock { time: 1000 }),
        };

        let state = State::Idle;
        let action = Action::Start {
            goal: "Test goal".to_string(),
            time: 30,
        };

        let (new_state, effect) = update(state, action, &env);

        match new_state {
            State::SessionActive { session } => {
                assert_eq!(session.goal, "Test goal");
                assert_eq!(session.start_time, 1000);
                assert_eq!(session.time_expected, 30);
                assert_eq!(session.reflection_file_path, None);
            }
            _ => panic!("Expected SessionActive state"),
        }

        assert!(matches!(
            effect,
            Some(crate::effects::Effect::CreateSession { .. })
        ));
    }

    #[test]
    fn test_cannot_start_session_when_active() {
        let env = Environment {
            file_system: Box::new(MockFileSystem::new()),
            api_client: Box::new(MockApiClient),
            clock: Box::new(MockClock { time: 1000 }),
        };

        let state = State::SessionActive {
            session: Session {
                goal: "Existing goal".to_string(),
                start_time: 900,
                time_expected: 25,
                reflection_file_path: None,
            },
        };

        let action = Action::Start {
            goal: "New goal".to_string(),
            time: 30,
        };

        let (new_state, effect) = update(state.clone(), action, &env);

        // State should remain unchanged
        assert_eq!(new_state, state);

        // Should produce an error effect
        assert!(matches!(
            effect,
            Some(crate::effects::Effect::PrintError { .. })
        ));
    }

    #[test]
    fn test_stop_active_session() {
        let env = Environment {
            file_system: Box::new(MockFileSystem::new()),
            api_client: Box::new(MockApiClient),
            clock: Box::new(MockClock { time: 1500 }),
        };

        let state = State::SessionActive {
            session: Session {
                goal: "Test goal".to_string(),
                start_time: 1000,
                time_expected: 30,
                reflection_file_path: None,
            },
        };

        let action = Action::Stop;

        let (new_state, effect) = update(state, action, &env);

        // Should transition to Idle
        assert_eq!(new_state, State::Idle);

        // Should create composite effect with CreateReflection and ClearState
        match effect {
            Some(crate::effects::Effect::Composite(effects)) => {
                assert_eq!(effects.len(), 2);
                assert!(matches!(effects[0], crate::effects::Effect::CreateReflection { .. }));
                assert!(matches!(effects[1], crate::effects::Effect::ClearState));
            }
            _ => panic!("Expected Composite effect with CreateReflection and ClearState"),
        }
    }

    #[test]
    fn test_cannot_stop_when_idle() {
        let env = Environment {
            file_system: Box::new(MockFileSystem::new()),
            api_client: Box::new(MockApiClient),
            clock: Box::new(MockClock { time: 1000 }),
        };

        let state = State::Idle;
        let action = Action::Stop;

        let (new_state, effect) = update(state, action, &env);

        // State should remain idle
        assert_eq!(new_state, State::Idle);

        // Should produce an error effect
        assert!(matches!(
            effect,
            Some(crate::effects::Effect::PrintError { .. })
        ));
    }

    #[test]
    fn test_analyze_action() {
        let env = Environment {
            file_system: Box::new(MockFileSystem::new()),
            api_client: Box::new(MockApiClient),
            clock: Box::new(MockClock { time: 1000 }),
        };

        let state = State::Idle;
        let path = std::path::PathBuf::from("/test/reflection.md");
        let action = Action::Analyze { path: path.clone() };

        let (new_state, effect) = update(state, action, &env);

        // State should remain idle
        assert_eq!(new_state, State::Idle);

        // Should produce analyze effect
        match effect {
            Some(crate::effects::Effect::AnalyzeReflection { path: effect_path }) => {
                assert_eq!(effect_path, path);
            }
            _ => panic!("Expected AnalyzeReflection effect"),
        }
    }

    #[test]
    fn test_state_load_no_session() {
        let env = Environment {
            file_system: Box::new(MockFileSystem::new()),
            api_client: Box::new(MockApiClient),
            clock: Box::new(MockClock { time: 1000 }),
        };

        // When no session file exists, should return Idle
        let state = State::load(&env).unwrap();
        assert!(matches!(state, State::Idle));
    }

    #[test]
    fn test_state_load_with_session() {
        let env = Environment {
            file_system: Box::new(MockFileSystem::new()),
            api_client: Box::new(MockApiClient),
            clock: Box::new(MockClock { time: 1000 }),
        };

        let session = Session {
            goal: "test goal".to_string(),
            start_time: 1000,
            time_expected: 30,
            reflection_file_path: None,
        };

        // Write session to mock file system
        let session_path = env.get_session_path().unwrap();
        let content = serde_json::to_string(&session).unwrap();
        env.file_system.write(&session_path, &content).unwrap();

        // Load should return SessionActive
        let state = State::load(&env).unwrap();
        match state {
            State::SessionActive { session: loaded } => {
                assert_eq!(loaded.goal, session.goal);
                assert_eq!(loaded.start_time, session.start_time);
            }
            _ => panic!("Expected SessionActive state"),
        }
    }

    // Test for effect execution
    #[tokio::test]
    async fn test_effect_clear_state() {
        let env = Environment {
            file_system: Box::new(MockFileSystem::new()),
            api_client: Box::new(MockApiClient),
            clock: Box::new(MockClock { time: 1000 }),
        };

        let session = Session {
            goal: "test goal".to_string(),
            start_time: 1000,
            time_expected: 30,
            reflection_file_path: None,
        };

        // First, save a session
        let session_path = env.get_session_path().unwrap();
        let content = serde_json::to_string(&session).unwrap();
        env.file_system.write(&session_path, &content).unwrap();

        // Execute clear effect
        let effect = crate::effects::Effect::ClearState;
        crate::effects::execute(effect, &env).await.unwrap();

        // Verify file was deleted
        let result = env.file_system.read(&session_path);
        assert!(result.is_err());
    }

    #[tokio::test]
    async fn test_effect_composite() {
        let env = Environment {
            file_system: Box::new(MockFileSystem::new()),
            api_client: Box::new(MockApiClient),
            clock: Box::new(MockClock { time: 1000 }),
        };

        let effect = crate::effects::Effect::Composite(vec![
            crate::effects::Effect::PrintError {
                message: "Error 1".to_string(),
            },
            crate::effects::Effect::PrintError {
                message: "Error 2".to_string(),
            },
        ]);

        // Should execute without errors
        crate::effects::execute(effect, &env).await.unwrap();
    }
}