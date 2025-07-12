# Task 5: Optimize Dependency Injection and Remove @MainActor from Process Execution

## Overview
Improve dependency design by removing `@MainActor` requirements from process execution helpers, using structured concurrency properly, and creating testable dependencies for date generation and other system interactions.

## Current Implementation Issues
- `@MainActor` requirement on process execution limits concurrency
- No dependency injection for system time (Date())
- Process execution mixed with business logic
- Hard to test time-based features
- Subprocess handling not following TCA patterns

## Current Problematic Code
```swift
@MainActor
func executeCommand(_ command: String, arguments: [String]) async throws -> (output: String?, error: String?) {
    // Entire function runs on main actor
}

// Direct Date usage
let startTime = Date()

// No dependency injection for process execution
try await executeCommand("momentum", arguments: ["start"])
```

## Proposed Solution

### 1. Remove @MainActor from Process Helpers
```swift
// ProcessHelpers.swift
func executeCommand(_ command: String, arguments: [String]) async throws -> ProcessResult {
    // No @MainActor - runs on cooperative thread pool
    try await withCheckedThrowingContinuation { continuation in
        Task.detached {
            // Process execution without blocking main thread
        }
    }
}
```

### 2. Create Date Dependency
```swift
struct DateGenerator: DependencyKey {
    var now: @Sendable () -> Date
    var timestamp: @Sendable () -> TimeInterval
    
    static let liveValue = Self(
        now: { Date() },
        timestamp: { Date().timeIntervalSince1970 }
    )
    
    static let testValue = Self(
        now: { Date(timeIntervalSince1970: 1_700_000_000) },
        timestamp: { 1_700_000_000 }
    )
}

extension DependencyValues {
    var date: DateGenerator {
        get { self[DateGenerator.self] }
        set { self[DateGenerator.self] = newValue }
    }
}
```

### 3. Process Execution Dependency
```swift
struct ProcessRunner: DependencyKey {
    var run: @Sendable (String, [String]) async throws -> ProcessResult
    
    static let liveValue = Self { command, arguments in
        try await executeCommand(command, arguments: arguments)
    }
    
    static let testValue = Self { command, arguments in
        // Return mock responses based on command
        switch command {
        case "start":
            return ProcessResult(output: "Session started", exitCode: 0)
        default:
            return ProcessResult(output: "", exitCode: 0)
        }
    }
}
```

### 4. Refactor RustCoreClient
```swift
struct RustCoreClient {
    @Dependency(\.processRunner) var processRunner
    @Dependency(\.date) var date
    
    var start: @Sendable (String, Int) async throws -> SessionData {
        return { goal, minutes in
            let result = try await processRunner.run("momentum", [
                "start",
                "--goal", goal,
                "--time", String(minutes)
            ])
            
            return SessionData(
                goal: goal,
                startTime: UInt64(date.timestamp()),
                timeExpected: UInt64(minutes * 60),
                reflectionFilePath: nil
            )
        }
    }
}
```

### 5. Structured Concurrency Patterns
```swift
// Use TaskGroup for parallel operations
func loadMultipleResources() async throws -> Resources {
    try await withThrowingTaskGroup(of: Resource.self) { group in
        group.addTask { try await loadResource1() }
        group.addTask { try await loadResource2() }
        
        var resources = Resources()
        for try await resource in group {
            resources.add(resource)
        }
        return resources
    }
}
```

## Implementation Steps

1. **Refactor ProcessHelpers.swift**
   - Remove @MainActor annotation
   - Use Task.detached for process execution
   - Improve error handling

2. **Create System Dependencies**
   - DateGenerator for time operations
   - ProcessRunner for subprocess execution
   - FileManager wrapper if needed

3. **Update RustCoreClient**
   - Inject dependencies
   - Remove direct system calls
   - Improve testability

4. **Optimize Async Operations**
   - Use proper structured concurrency
   - Avoid unnecessary main actor hops
   - Parallelize independent operations

5. **Update Tests**
   - Use test dependencies
   - Control time in tests
   - Mock process execution

## Benefits
- Better performance (no main thread blocking)
- Fully testable system interactions
- Deterministic time-based tests
- Follows TCA dependency patterns
- Improved concurrency
- Easier to mock external systems

## Testing Example
```swift
@Test
func sessionStartUsesProvidedTime() async {
    let store = TestStore(initialState: AppFeature.State()) {
        AppFeature()
    } withDependencies: {
        $0.date.timestamp = { 1_700_000_000 }
        $0.processRunner.run = { _, _ in
            ProcessResult(output: "Started", exitCode: 0)
        }
    }
    
    await store.send(.startSession("Goal", 30)) {
        $0.activeSession = SessionData(
            goal: "Goal",
            startTime: 1_700_000_000,
            timeExpected: 1800,
            reflectionFilePath: nil
        )
    }
}
```

## Performance Considerations
- Process execution off main thread
- Parallel dependency resolution
- Lazy dependency initialization
- Avoid unnecessary actor hops

## Acceptance Criteria
- [ ] No @MainActor on process helpers
- [ ] All system interactions through dependencies
- [ ] Time-based features fully testable
- [ ] No performance regression
- [ ] Clean dependency injection
- [ ] Tests control all external interactions
- [ ] Documentation of dependency patterns