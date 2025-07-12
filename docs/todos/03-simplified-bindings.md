# Task 3: Refactor Bindings in PreparationView to be More Idiomatic

## Overview
Simplify the complex binding logic in PreparationView by using TCA's binding patterns more idiomatically, removing computed bindings and leveraging the `BindableAction` protocol properly.

## Current Implementation Issues
- Complex computed bindings for text fields
- Manual binding creation with getters and setters
- Sending actions through bindings instead of direct actions
- Mixing binding logic with business logic
- Less readable and maintainable code

## Current Problematic Code
```swift
// Complex binding
TextField("Goal", text: Binding(
    get: { preparationState.goal },
    set: { store.send(.preparation(.goalChanged($0))) }
))

// Derived state through complex binding
private var preparationState: PreparationState {
    guard case let .preparing(state) = store.session else {
        return PreparationState()
    }
    return state
}
```

## Proposed Solution

### 1. Use ViewStore Bindings
```swift
struct PreparationView: View {
    let store: StoreOf<PreparationFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            TextField("Goal", text: viewStore.$goal)
            TextField("Time", text: viewStore.$timeInput)
        }
    }
}
```

### 2. Leverage BindableAction
```swift
@Reducer
struct PreparationFeature {
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case startSession
        case checklistItemToggled(ChecklistItem.ID)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.goal):
                // React to goal changes if needed
                return .none
            case .binding:
                return .none
            // other cases
            }
        }
    }
}
```

### 3. Simplified Toggle Bindings
```swift
// Before
Toggle(isOn: Binding(
    get: { item.isCompleted },
    set: { _ in store.send(.preparation(.checklistItemToggled(item.id))) }
)) {
    Text(item.text)
}

// After
Toggle(
    item.text,
    isOn: viewStore.binding(
        get: \.checklist[id: item.id]?.isCompleted,
        send: { _ in .checklistItemToggled(item.id) }
    )
)
```

### 4. Use @BindingState
```swift
@ObservableState
struct State {
    @BindingState var goal = ""
    @BindingState var timeInput = ""
    var checklist: IdentifiedArrayOf<ChecklistItem> = []
}
```

## Implementation Steps

1. **Update PreparationFeature State**
   - Add @BindingState to appropriate properties
   - Remove manual binding actions where possible

2. **Simplify PreparationFeature Actions**
   - Remove goalChanged, timeInputChanged actions
   - Keep only meaningful business actions
   - Let BindingReducer handle updates

3. **Refactor PreparationView**
   - Use WithViewStore or @Bindable store
   - Replace manual bindings with viewStore bindings
   - Simplify view logic

4. **Update Parent Integration**
   - Ensure AppFeature properly scopes to child
   - Remove unnecessary state derivation

5. **Test Updates**
   - Update tests to use binding actions
   - Test that bindings update state correctly

## Benefits
- Cleaner, more readable code
- Less boilerplate
- Automatic state updates
- Better performance (less view recomputation)
- More idiomatic TCA usage
- Easier to understand data flow

## Example Implementation
```swift
struct PreparationView: View {
    @Bindable var store: StoreOf<PreparationFeature>
    
    var body: some View {
        Form {
            TextField("Goal", text: $store.goal)
            TextField("Time (minutes)", text: $store.timeInput)
            
            ForEach(store.checklist) { item in
                Toggle(
                    item.text,
                    isOn: $store.checklist[id: item.id].isCompleted
                )
            }
            
            Button("Start Session") {
                store.send(.startSession)
            }
            .disabled(!store.isStartButtonEnabled)
        }
    }
}
```

## Testing Approach
```swift
@Test
func bindingUpdates() async {
    let store = TestStore(initialState: PreparationFeature.State()) {
        PreparationFeature()
    }
    
    await store.send(.binding(.set(\.goal, "New Goal"))) {
        $0.goal = "New Goal"
    }
}
```

## Acceptance Criteria
- [ ] All text fields use proper TCA bindings
- [ ] No manual binding creation
- [ ] BindableAction protocol properly implemented
- [ ] Cleaner view code
- [ ] All tests updated and passing
- [ ] No performance regression
- [ ] Documentation updated with new patterns