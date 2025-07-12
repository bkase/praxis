# Task 4: Add Proper Alert/Dialog Handling Using TCA Patterns

## Overview
Replace custom error state management with TCA's `@Presents` pattern for alerts, using `AlertState` and `ConfirmationDialogState` for consistent user interactions and better error recovery flows.

## Current Implementation Issues
- Error state mixed with business state
- Manual error message formatting
- No clear error recovery actions
- Inconsistent error presentation
- Difficult to test error scenarios
- No confirmation dialogs for destructive actions

## Current Problematic Code
```swift
struct State {
    var error: AppError?
    var errorMessage: String? { error?.errorDescription }
    var errorRecovery: String? { error?.recoverySuggestion }
}

// In view
.alert(
    "Error",
    isPresented: .constant(store.error != nil),
    presenting: store.error
) { _ in
    Button("OK") { store.send(.clearError) }
} message: { error in
    Text(error.localizedDescription)
}
```

## Proposed Solution

### 1. Alert State Pattern
```swift
@ObservableState
struct State {
    @Presents var alert: AlertState<Action.Alert>?
    // Remove error property
}

enum Action {
    case alert(PresentationAction<Alert>)
    
    enum Alert: Equatable {
        case retry
        case dismiss
        case openSettings
    }
}
```

### 2. Error to Alert Conversion
```swift
extension AlertState where Action == AppFeature.Action.Alert {
    static func error(_ error: AppError) -> Self {
        switch error {
        case .sessionAlreadyActive:
            return AlertState {
                TextState("Session Already Active")
            } actions: {
                ButtonState(action: .dismiss) {
                    TextState("OK")
                }
            } message: {
                TextState("Please stop the current session before starting a new one.")
            }
            
        case .apiKeyMissing:
            return AlertState {
                TextState("API Key Required")
            } actions: {
                ButtonState(action: .openSettings) {
                    TextState("Open Settings")
                }
                ButtonState(role: .cancel, action: .dismiss) {
                    TextState("Cancel")
                }
            } message: {
                TextState("Please set your Anthropic API key in settings.")
            }
        }
    }
}
```

### 3. Confirmation Dialogs
```swift
@ObservableState
struct State {
    @Presents var confirmationDialog: ConfirmationDialogState<Action.Dialog>?
}

// Stop session confirmation
state.confirmationDialog = ConfirmationDialogState {
    TextState("Stop Session?")
} actions: {
    ButtonState(role: .destructive, action: .confirmStop) {
        TextState("Stop Session")
    }
    ButtonState(role: .cancel, action: .cancel) {
        TextState("Continue Working")
    }
} message: {
    TextState("Are you sure you want to stop the current session? You'll be prompted to write a reflection.")
}
```

### 4. View Integration
```swift
struct AppView: View {
    @Bindable var store: StoreOf<AppFeature>
    
    var body: some View {
        ContentView(store: store)
            .alert($store.scope(state: \.alert, action: \.alert))
            .confirmationDialog(
                $store.scope(state: \.confirmationDialog, action: \.dialog)
            )
    }
}
```

## Implementation Steps

1. **Update State Models**
   - Add @Presents for alerts
   - Add @Presents for confirmation dialogs
   - Remove error properties

2. **Create Alert Helpers**
   - Extension for converting errors to alerts
   - Reusable alert configurations
   - Recovery action mapping

3. **Update Reducer Logic**
   - Handle alert presentation actions
   - Implement recovery actions
   - Add confirmation flows

4. **Refactor Error Handling**
   - Convert all error assignments to alert presentations
   - Add appropriate recovery actions
   - Implement confirmation for destructive actions

5. **Update Views**
   - Remove manual alert logic
   - Use TCA alert modifiers
   - Simplify presentation logic

## Benefits
- Consistent error presentation
- Clear recovery actions
- Better user experience
- Fully testable alert flows
- Type-safe alert actions
- Reusable alert patterns

## Testing Example
```swift
@Test
func errorPresentation() async {
    let store = TestStore(initialState: AppFeature.State()) {
        AppFeature()
    }
    
    // Trigger error
    await store.send(.startButtonTapped) {
        $0.alert = .error(.sessionAlreadyActive)
    }
    
    // Dismiss alert
    await store.send(.alert(.presented(.dismiss))) {
        $0.alert = nil
    }
}

@Test
func confirmationFlow() async {
    let store = TestStore(initialState: AppFeature.State()) {
        AppFeature()
    }
    
    await store.send(.stopButtonTapped) {
        $0.confirmationDialog = ConfirmationDialogState { /* ... */ }
    }
    
    await store.send(.dialog(.presented(.confirmStop))) {
        $0.confirmationDialog = nil
        // Stop session logic
    }
}
```

## Alert Inventory
- Session already active
- No active session
- Failed to start session
- Failed to stop session
- API key missing
- Network error
- File system error
- Analysis failed
- Invalid input

## Acceptance Criteria
- [ ] All errors presented as alerts
- [ ] Confirmation dialogs for destructive actions
- [ ] Recovery actions implemented
- [ ] Alert flows fully tested
- [ ] Consistent alert styling
- [ ] No regression in error handling
- [ ] Documentation of alert patterns