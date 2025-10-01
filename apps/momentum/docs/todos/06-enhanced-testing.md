# Task 6: Enhance Test Coverage with More Exhaustive Testing Patterns

## Overview
Improve test coverage by adding integration tests for full user flows, using `withExhaustivity(.off)` for focused tests, adding snapshot tests for UI states, and following TCA testing best practices.

## Current Testing Gaps
- Limited integration tests
- No snapshot testing
- Exhaustive testing for all cases
- Missing edge case coverage
- No performance tests
- Limited UI state testing

## Proposed Testing Strategy

### 1. Integration Tests for User Flows
```swift
@Test
func completeUserFlow() async {
    let store = TestStore(initialState: AppFeature.State()) {
        AppFeature()
    } withDependencies: {
        $0.continuousClock = ImmediateClock()
        $0.date.now = { Date(timeIntervalSince1970: 1_700_000_000) }
    }
    
    // Load checklist
    await store.send(.preparation(.onAppear))
    await store.receive(.preparation(.checklistItemsLoaded(.success(mockChecklist))))
    
    // Fill preparation
    await store.send(.preparation(.binding(.set(\.goal, "Write tests"))))
    await store.send(.preparation(.binding(.set(\.timeInput, "30"))))
    
    // Complete checklist
    for item in mockChecklist {
        await store.send(.preparation(.checklistItemToggled(item.id)))
    }
    
    // Start session
    await store.send(.startButtonTapped)
    await store.receive(.sessionStarted(sessionData))
    
    // Stop session
    await store.send(.stopButtonTapped)
    await store.receive(.sessionStopped(reflectionPath))
    
    // Analyze
    await store.send(.analyzeButtonTapped)
    await store.receive(.analysisCompleted(analysis))
}
```

### 2. Non-Exhaustive Testing for Focused Scenarios
```swift
@Test
func errorRecovery() async {
    let store = TestStore(initialState: AppFeature.State()) {
        AppFeature()
    }
    store.exhaustivity = .off(showSkippedAssertions: true)
    
    // Only test error scenarios
    await store.send(.startButtonTapped) // Skip intermediate states
    await store.receive(.sessionStartFailed(error)) {
        $0.alert = .error(error)
    }
    
    await store.send(.alert(.presented(.retry)))
    // Continue with recovery flow
}
```

### 3. Snapshot Testing
```swift
import SnapshotTesting

@MainActor
final class AppViewSnapshotTests: XCTestCase {
    func testPreparationState() {
        let store = Store(
            initialState: AppFeature.State(
                session: .preparing(PreparationState(
                    goal: "Test Goal",
                    timeInput: "30",
                    checklist: mockChecklist
                ))
            )
        ) {
            AppFeature()
        }
        
        let view = AppView(store: store)
        
        assertSnapshot(matching: view, as: .image(size: CGSize(width: 300, height: 600)))
    }
    
    func testActiveSessionState() {
        // Test different UI states
    }
    
    func testErrorStates() {
        // Snapshot all error presentations
    }
}
```

### 4. Edge Case Testing
```swift
@Test
func edgeCases() async {
    // Empty goal
    await testInvalidInput(goal: "", time: "30", expectedError: .emptyGoal)
    
    // Invalid time
    await testInvalidInput(goal: "Goal", time: "0", expectedError: .invalidTime)
    await testInvalidInput(goal: "Goal", time: "-10", expectedError: .invalidTime)
    await testInvalidInput(goal: "Goal", time: "abc", expectedError: .invalidTime)
    
    // Extremely long session
    await testValidInput(goal: "Marathon", time: "480") // 8 hours
    
    // Unicode in goal
    await testValidInput(goal: "学习中文 📚", time: "30")
}
```

### 5. Performance Testing
```swift
func testLargeChecklistPerformance() async throws {
    let largeChecklist = (0..<100).map { 
        ChecklistItem(id: "\($0)", text: "Item \($0)")
    }
    
    measure {
        let store = TestStore(
            initialState: PreparationFeature.State(
                checklist: IdentifiedArray(uniqueElements: largeChecklist)
            )
        ) {
            PreparationFeature()
        }
        
        // Toggle all items
        for item in largeChecklist {
            store.send(.checklistItemToggled(item.id))
        }
    }
}
```

### 6. Test Helpers and Utilities
```swift
// TestHelpers.swift
extension AppFeature.State {
    static func mock(
        goal: String = "Test Goal",
        timeMinutes: Int = 30,
        checklist: [ChecklistItem] = mockChecklist
    ) -> Self {
        AppFeature.State(
            session: .preparing(PreparationState(
                goal: goal,
                timeInput: String(timeMinutes),
                checklist: IdentifiedArray(uniqueElements: checklist)
            ))
        )
    }
}

// Common test data
let mockChecklist = [
    ChecklistItem(id: "1", text: "Close distractions"),
    ChecklistItem(id: "2", text: "Set timer"),
    ChecklistItem(id: "3", text: "Review goals")
]
```

## Testing Matrix

### Unit Tests
- [ ] Each reducer action
- [ ] State computed properties
- [ ] Error conversions
- [ ] Dependency behavior

### Integration Tests
- [ ] Complete user flows
- [ ] Error recovery flows
- [ ] Navigation flows
- [ ] State persistence

### UI Tests
- [ ] Snapshot tests for each state
- [ ] Accessibility tests
- [ ] Dark mode support
- [ ] Dynamic type support

### Performance Tests
- [ ] Large data sets
- [ ] Rapid state changes
- [ ] Memory usage
- [ ] App launch time

## Implementation Steps

1. **Set Up Test Infrastructure**
   - Add SnapshotTesting package
   - Create test helpers file
   - Set up mock data

2. **Write Integration Tests**
   - Complete user flows
   - Error scenarios
   - Edge cases

3. **Add Snapshot Tests**
   - Each UI state
   - Error presentations
   - Different configurations

4. **Create Performance Tests**
   - Measure critical paths
   - Identify bottlenecks

5. **Improve Test Organization**
   - Group related tests
   - Share test utilities
   - Document test patterns

## Acceptance Criteria
- [ ] 90%+ code coverage
- [ ] All user flows have integration tests
- [ ] Snapshot tests for all UI states
- [ ] Performance benchmarks established
- [ ] Test utilities documented
- [ ] CI runs all test suites
- [ ] Test execution under 30 seconds