# Task 1: Implement @Shared for Persistent State Management

## Overview
Replace manual session.json file handling with TCA's `@Shared` property wrapper for automatic persistence and reactive state updates across the application.

## Current Implementation Issues
- Manual JSON encoding/decoding for session data
- File I/O handled through subprocess calls to Rust CLI
- No automatic UI updates when session data changes
- Complex error handling for file operations
- State not easily shareable between features

## Proposed Solution

### 1. Define Shared State Keys
```swift
extension SharedKey where Self == FileStorageKey<SessionData>.Default {
    static var sessionData: Self {
        fileStorage(.documentsDirectory.appending(component: "session.json"))
    }
}

extension SharedKey where Self == AppStorageKey<String>.Default {
    static var lastGoal: Self { appStorage("lastGoal") }
    static var lastTimeMinutes: Self { appStorage("lastTimeMinutes") }
}
```

### 2. Update State Models
```swift
@ObservableState
struct State {
    @Shared(.sessionData) var sessionData: SessionData?
    @Shared(.lastGoal) var lastGoal = ""
    @Shared(.lastTimeMinutes) var lastTimeMinutes = "30"
    
    var session: SessionState {
        // Derive session state from shared sessionData
    }
}
```

### 3. Refactor RustCoreClient
- Remove session loading/saving logic
- Rust CLI only handles reflection and analysis
- Session management happens entirely in Swift

### 4. Benefits
- Automatic persistence on every state change
- Reactive updates across all features
- Simplified error handling
- Better testability with dependency overrides
- Reduced subprocess calls

## Implementation Steps

1. **Create SharedKeys.swift**
   - Define custom shared keys for session data
   - Define app storage keys for preferences

2. **Update SessionModels.swift**
   - Make SessionData conform to Codable
   - Add helper methods for state derivation

3. **Refactor AppFeature.swift**
   - Replace session enum with @Shared properties
   - Update actions to work with shared state
   - Remove manual file operations

4. **Update RustCoreClient.swift**
   - Remove start/stop session file operations
   - Keep only analyze functionality
   - Simplify error types

5. **Update Tests**
   - Use withDependencies to override shared state
   - Test persistence behavior
   - Verify reactive updates

## Testing Strategy
```swift
@Test
func sharedStatePersistence() async {
    let store = TestStore(initialState: AppFeature.State()) {
        AppFeature()
    } withDependencies: {
        $0.defaultFileStorage = .inMemory
        // Override shared state for testing
    }
    
    // Test that state persists across feature instances
}
```

## Migration Notes
- Existing session.json files will need migration
- Consider backward compatibility for one version
- Document the new persistence location

## Acceptance Criteria
- [ ] Session data automatically persists without subprocess calls
- [ ] Last goal and time preferences are remembered
- [ ] State updates reactively across all features
- [ ] All existing tests pass
- [ ] New tests for persistence behavior
- [ ] No regression in functionality