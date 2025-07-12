# Task 2: Improve Navigation Patterns Using TCA Navigation Tools

## Overview
Replace the current enum-based SessionState with TCA's modern navigation patterns using `@Presents`, `NavigationStack`, and proper destination modeling for better type safety and state management.

## Current Implementation Issues
- Complex enum-based state machine (preparing, active, awaitingAnalysis, analyzed)
- Manual state transitions with lots of boilerplate
- Difficult to test navigation flows
- No clear separation between navigation and business logic
- Alert/error presentation mixed with state management

## Proposed Solution

### 1. Destination-Based Navigation
```swift
@Reducer
struct AppFeature {
    @Reducer(state: .equatable)
    enum Destination {
        case analysis(AnalysisFeature)
        case preparation(PreparationFeature)
        case reflection(ReflectionFeature)
    }
    
    @ObservableState
    struct State {
        @Presents var destination: Destination.State?
        var activeSession: SessionData?
        // Core state without navigation
    }
}
```

### 2. Alert State Pattern
```swift
@ObservableState
struct State {
    @Presents var alert: AlertState<Alert>?
    
    enum Alert: Equatable {
        case failedToStart
        case failedToStop
        case confirmStop
    }
}
```

### 3. Navigation Flow
- Use `@Presents` for modal presentations (analysis results)
- Use path-based navigation for flows
- Separate navigation actions from business logic

### 4. View Layer Updates
```swift
struct AppView: View {
    var body: some View {
        ContentView(store: store)
            .alert($store.scope(state: \.alert, action: \.alert))
            .sheet(item: $store.scope(
                state: \.destination?.analysis,
                action: \.destination.analysis
            )) { store in
                AnalysisView(store: store)
            }
    }
}
```

## Implementation Steps

1. **Create Destination Reducers**
   - AnalysisFeature for showing analysis results
   - ReflectionFeature for reflection input
   - Keep PreparationFeature as is

2. **Refactor AppFeature**
   - Remove SessionState enum
   - Add @Presents for destination
   - Add @Presents for alerts
   - Simplify state to core data only

3. **Update Navigation Actions**
   - Add destination presentation actions
   - Add alert presentation actions
   - Remove state machine transitions

4. **Update Views**
   - Use sheet/navigationDestination modifiers
   - Use alert modifier for errors
   - Simplify view logic

5. **Migration Path**
   - Map old states to new navigation model
   - Preserve existing functionality
   - Update tests incrementally

## Benefits
- Clear separation of concerns
- Easier testing of navigation flows
- Type-safe navigation
- Automatic state management
- Better SwiftUI integration
- Simplified view code

## Testing Example
```swift
@Test
func navigationFlow() async {
    let store = TestStore(initialState: AppFeature.State()) {
        AppFeature()
    }
    
    // Start session shows preparation
    await store.send(.startButtonTapped) {
        $0.destination = .preparation(PreparationFeature.State())
    }
    
    // Complete preparation dismisses and starts session
    await store.send(.destination(.preparation(.startSession))) {
        $0.destination = nil
        $0.activeSession = SessionData(...)
    }
}
```

## Navigation Map
```
App (root)
├── Preparation (sheet/inline)
├── Active Session (main view)
├── Reflection Input (sheet)
└── Analysis Results (sheet)
    └── Alerts (for errors)
```

## Acceptance Criteria
- [ ] All navigation uses TCA patterns
- [ ] No more SessionState enum
- [ ] Cleaner view code
- [ ] All navigation flows testable
- [ ] Alerts use AlertState
- [ ] No regression in UX
- [ ] Migration guide documented