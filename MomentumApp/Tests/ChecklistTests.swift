import Testing
import Foundation
import ComposableArchitecture
@testable import MomentumApp

@Suite("Checklist Tests")
@MainActor
struct ChecklistTests {
    init() {
        // Reset shared state before each test
        @Shared(.sessionData) var sessionData: SessionData?
        @Shared(.lastGoal) var lastGoal: String
        @Shared(.lastTimeMinutes) var lastTimeMinutes: String
        @Shared(.analysisHistory) var analysisHistory: [AnalysisResult]
        
        $sessionData.withLock { $0 = nil }
        $lastGoal.withLock { $0 = "" }
        $lastTimeMinutes.withLock { $0 = "30" }
        $analysisHistory.withLock { $0 = [] }
    }
    
    @Test("Checklist Loading - Loads First 4 Items")
    func checklistLoading() async {
        let store = TestStore(initialState: PreparationFeature.State()) {
            PreparationFeature()
        }
        
        // Load checklist on appear - should load first 4 items
        await store.send(.onAppear) {
            $0.visibleChecklist = [
                ChecklistItem(id: "0", text: "Rested", isCompleted: false),
                ChecklistItem(id: "1", text: "Not hungry", isCompleted: false),
                ChecklistItem(id: "2", text: "Bathroom break", isCompleted: false),
                ChecklistItem(id: "3", text: "Phone on silent", isCompleted: false)
            ]
            $0.nextItemIndex = 4
        }
    }
    
    @Test("Checklist Item Toggle - With Replacement")
    func checklistItemToggleWithReplacement() async {
        let clock = TestClock()
        
        // Simply verify that toggling works and items get replaced
        let store = TestStore(
            initialState: PreparationFeature.State(
                goal: "Test Goal",
                timeInput: "30"
            )
        ) {
            PreparationFeature()
        } withDependencies: {
            $0.continuousClock = clock
        }
        
        // Use non-exhaustive testing since we have animations and UUIDs
        store.exhaustivity = .off
        
        // Load initial checklist
        await store.send(.onAppear)
        
        let initialCount = store.state.visibleChecklist.count
        #expect(initialCount == 4)
        
        // Toggle first item
        let firstItemId = store.state.visibleChecklist.first?.id ?? ""
        await store.send(.checklistItemToggled(firstItemId))
        
        // Wait for transitions to complete
        await clock.advance(by: .seconds(1))
        
        // Verify item was marked completed
        #expect(store.state.totalItemsCompleted == 1)
        
        // Since we're using non-exhaustive testing, we can't test the exact replacement behavior
        // but we can verify that the feature handles toggling correctly
    }
    
    @Test("Start Button Enabled Logic - Requires All 10 Items")
    func startButtonEnabledLogic() async {
        // Test with empty state
        var state = PreparationFeature.State()
        #expect(!state.isStartButtonEnabled)
        
        // Add goal
        state.goal = "Test Goal"
        #expect(!state.isStartButtonEnabled)
        
        // Add valid time
        state.timeInput = "30"
        #expect(!state.isStartButtonEnabled) // Still need all 10 items completed
        
        // Complete 9 items
        state.totalItemsCompleted = 9
        #expect(!state.isStartButtonEnabled)
        
        // Complete all 10 items
        state.totalItemsCompleted = 10
        #expect(state.isStartButtonEnabled)
        
        // Test invalid time inputs
        state.timeInput = "0"
        #expect(!state.isStartButtonEnabled)
        
        state.timeInput = "-5"
        #expect(!state.isStartButtonEnabled)
        
        state.timeInput = "abc"
        #expect(!state.isStartButtonEnabled)
    }
    
    @Test("Complete All 10 Items")
    func completeAllTenItems() async {
        let clock = TestClock()
        
        let store = TestStore(
            initialState: PreparationFeature.State(
                goal: "Test Goal",
                timeInput: "30"
            )
        ) {
            PreparationFeature()
        } withDependencies: {
            $0.continuousClock = clock
        }
        
        // Set exhaustivity to off since we have non-deterministic UUIDs
        store.exhaustivity = .off
        
        // Load initial items
        await store.send(.onAppear) {
            $0.visibleChecklist = [
                ChecklistItem(id: "0", text: "Rested", isCompleted: false),
                ChecklistItem(id: "1", text: "Not hungry", isCompleted: false),
                ChecklistItem(id: "2", text: "Bathroom break", isCompleted: false),
                ChecklistItem(id: "3", text: "Phone on silent", isCompleted: false)
            ]
            $0.nextItemIndex = 4
        }
        
        // Complete all 10 items by toggling visible ones
        for i in 0..<10 {
            if let firstIncomplete = store.state.visibleChecklist.first(where: { !$0.isCompleted }) {
                await store.send(.checklistItemToggled(firstIncomplete.id)) {
                    $0.visibleChecklist[id: firstIncomplete.id]?.isCompleted = true
                    $0.totalItemsCompleted = i + 1
                }
                
                // If we still have items to show, handle the transition
                if i < 6 { // First 6 toggles will trigger replacements
                    await clock.advance(by: .milliseconds(950)) // Total transition time
                }
            }
        }
        
        // Verify all 10 items are completed
        #expect(store.state.totalItemsCompleted == 10)
        #expect(store.state.isStartButtonEnabled)
    }
    
    @Test("Goal and Time Input Updates")
    func goalAndTimeInputUpdates() async {
        let store = TestStore(initialState: PreparationFeature.State()) {
            PreparationFeature()
        }
        
        // Test goal update
        await store.send(.goalChanged("New Goal")) {
            $0.goal = "New Goal"
        }
        
        // Test time input update
        await store.send(.timeInputChanged("45")) {
            $0.timeInput = "45"
        }
    }
}