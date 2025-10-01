# Task 7: Add Performance Optimizations Using WithPerceptionTracking

## Overview
Optimize app performance by adding `WithPerceptionTracking` for debugging observation issues, using `@ObservableState` more effectively, and optimizing child reducer scoping to minimize unnecessary view updates.

## Current Performance Issues
- Potential over-rendering of views
- Unclear observation dependencies
- Inefficient child reducer scoping
- No performance monitoring
- Possible retain cycles
- Unnecessary state computations

## Proposed Optimizations

### 1. Add Perception Tracking
```swift
#if DEBUG
import Perception

struct AppView: View {
    let store: StoreOf<AppFeature>
    
    var body: some View {
        WithPerceptionTracking {
            AppContentView(store: store)
        } onChange: { trackedProperties in
            print("🔍 Tracked properties changed: \(trackedProperties)")
        }
    }
}
#endif
```

### 2. Optimize State Observation
```swift
// Before - observes entire state
struct PreparationView: View {
    @Bindable var store: StoreOf<AppFeature>
    
    var body: some View {
        // View recomputes on any state change
    }
}

// After - observe only needed properties
struct PreparationView: View {
    let store: StoreOf<PreparationFeature>
    
    var body: some View {
        WithViewStore(store, observe: \.isStartButtonEnabled) { viewStore in
            Button("Start") {
                viewStore.send(.startButtonTapped)
            }
            .disabled(!viewStore.state)
        }
    }
}
```

### 3. Lazy Child Reducer Scoping
```swift
// Before - always computes child state
var preparation: PreparationFeature.State? {
    get {
        guard case let .preparing(preparationState) = session else { return nil }
        return PreparationFeature.State(preparationState: preparationState)
    }
    set { /* ... */ }
}

// After - use IfLetReducer with lazy evaluation
.ifLet(\.$destination, action: \.destination) {
    Scope(state: \.preparation, action: \.preparation) {
        PreparationFeature()
    }
}
```

### 4. Memoize Expensive Computations
```swift
@ObservableState
struct State {
    var items: IdentifiedArrayOf<Item> = []
    
    // Expensive computation
    @EquatableNoop
    private var _sortedItems: [Item]?
    
    var sortedItems: [Item] {
        if let cached = _sortedItems {
            return cached
        }
        let sorted = items.sorted { $0.priority > $1.priority }
        _sortedItems = sorted
        return sorted
    }
    
    mutating func invalidateCache() {
        _sortedItems = nil
    }
}
```

### 5. View Performance Patterns
```swift
// Use task cancellation
struct ContentView: View {
    let store: StoreOf<Feature>
    @State private var loadTask: Task<Void, Never>?
    
    var body: some View {
        List { /* ... */ }
            .task {
                loadTask?.cancel()
                loadTask = Task {
                    await store.send(.loadData).finish()
                }
            }
    }
}

// Optimize list rendering
List {
    ForEach(viewStore.items) { item in
        ItemRow(item: item)
            .id(item.id) // Stable identity
    }
}
.listStyle(.plain) // Better performance than grouped
```

### 6. Memory Management
```swift
// Avoid retain cycles in effects
return .run { send in
    let stream = AsyncStream { continuation in
        let cancellable = dependency.subscribe { value in
            continuation.yield(value)
        }
        
        continuation.onTermination = { _ in
            cancellable.cancel()
        }
    }
    
    for await value in stream {
        await send(.received(value))
    }
}
```

## Implementation Steps

1. **Add Debug Tools**
   - Integrate WithPerceptionTracking
   - Add performance logging
   - Create debug menu

2. **Audit State Observation**
   - Identify over-observed properties
   - Optimize ViewStore usage
   - Minimize state dependencies

3. **Optimize Reducers**
   - Lazy child reducer evaluation
   - Memoize expensive operations
   - Reduce state mutations

4. **Profile and Measure**
   - Use Instruments
   - Measure view body calls
   - Track memory usage

5. **Apply Optimizations**
   - Fix identified bottlenecks
   - Optimize hot paths
   - Reduce allocations

## Performance Metrics

### Metrics to Track
- View body execution count
- State mutation frequency
- Memory allocations
- Time to interactive
- Frame drops

### Debug Helpers
```swift
#if DEBUG
struct PerformanceView: View {
    @State private var renderCount = 0
    
    var body: some View {
        let _ = Self._printChanges()
        let _ = (renderCount += 1)
        
        Text("Renders: \(renderCount)")
    }
}
#endif
```

## Common Performance Patterns

### 1. Equatable Conformance
```swift
// Ensure proper Equatable implementation
struct State: Equatable {
    var items: IdentifiedArrayOf<Item>
    var selection: Set<Item.ID>
    
    // Manual Equatable if needed for performance
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.selection == rhs.selection &&
        lhs.items.ids == rhs.items.ids // Compare IDs first
    }
}
```

### 2. Effect Optimization
```swift
// Debounce rapid actions
case .textChanged(let text):
    return .run { send in
        try await clock.sleep(for: .milliseconds(300))
        await send(.search(text))
    }
    .cancellable(id: CancelID.search)
```

## Testing Performance

```swift
func testPerformance() throws {
    measure(metrics: [XCTClockMetric(), XCTMemoryMetric()]) {
        let store = TestStore(initialState: Feature.State()) {
            Feature()
        }
        
        // Perform expensive operations
        store.send(.loadLargeDataSet)
        store.receive(.dataLoaded)
    }
}
```

## Acceptance Criteria
- [ ] WithPerceptionTracking integrated in debug builds
- [ ] No unnecessary view updates
- [ ] Memory usage remains stable
- [ ] 60 FPS maintained during interactions
- [ ] Performance regression tests added
- [ ] Debug tools documented
- [ ] Optimization guide created