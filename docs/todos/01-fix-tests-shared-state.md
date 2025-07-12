# Task 1: Fix Tests to Work with @Shared State Pattern

## Context
We partially implemented @Shared for persistent state management. The implementation works but all tests are failing because @Shared state behaves differently in tests than regular state.

## What Was Completed
- ✅ Created SharedKeys.swift with persistence strategies
- ✅ Refactored AppFeature to use @Shared properties
- ✅ Session data persists to file storage automatically
- ✅ Last goal and time preferences persist to app storage
- ✅ Analysis history kept in memory
- ✅ Models updated to support Codable
- ✅ App builds successfully

## What Needs to be Fixed
All test files are failing with various issues:
1. @Shared state is global and persists between tests
2. TestStore expects state changes to be explicit but @Shared mutates outside of actions
3. AppStorage keys with "." cause warnings (already fixed by changing to "momentumLastGoal" etc)
4. Test setup needs to properly initialize @Shared state before creating TestStore

## Current Test Failures
- ErrorHandlingTests: All tests failing due to @Shared state not being properly initialized
- ChecklistTests: Failing due to derived state from @Shared
- SessionManagementTests: Failing due to @Shared state mutations
- FullFlowTests: Failing due to complex state transitions with @Shared

## Proposed Solutions

### Option 1: Test-Specific Shared State
Create a test-specific pattern for @Shared state:
```swift
@MainActor
class TestSharedState {
    static func reset() {
        @Shared(.sessionData) var sessionData: SessionData? = nil
        @Shared(.lastGoal) var lastGoal = ""
        @Shared(.lastTimeMinutes) var lastTimeMinutes = "30"
        @Shared(.analysisHistory) var analysisHistory: [AnalysisResult] = []
    }
}

// In each test:
override func setUp() {
    super.setUp()
    TestSharedState.reset()
}
```

### Option 2: Mock Shared State Dependencies
Override the shared state in test dependencies:
```swift
withDependencies: {
    $0.defaultAppStorage = .ephemeral()
    $0.defaultFileStorage = .inMemory
}
```

### Option 3: Refactor to Reduce @Shared Usage
Consider if all state needs to be @Shared or if some can remain local to the reducer.

## Test Update Strategy

1. **Update TestHelpers.swift**
   - Add shared state reset functionality
   - Create builders for common test scenarios
   - Add utilities for asserting on @Shared state

2. **Fix ErrorHandlingTests**
   - Set up @Shared state before creating TestStore
   - Update assertions to account for @Shared mutations
   - Use proper initialization patterns

3. **Fix ChecklistTests**
   - Handle preparation state being derived from @Shared
   - Update checklist item toggle tests

4. **Fix SessionManagementTests**
   - Properly initialize session data for active session tests
   - Update assertions for @Shared state mutations

5. **Fix FullFlowTests**
   - Break down into smaller tests if needed
   - Handle complex state transitions with @Shared

## References
- TCA Documentation on @Shared: See sections on "Testing shared state" and "Overriding shared state in tests"
- Current implementation: AppFeature.swift, SharedKeys.swift
- Test files that need updates: All files in MomentumApp/Tests/

## Acceptance Criteria
- [ ] All tests pass without warnings
- [ ] @Shared state properly resets between tests
- [ ] Test coverage remains comprehensive
- [ ] No regression in app functionality
- [ ] Clear patterns established for future tests with @Shared