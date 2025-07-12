import XCTest
import ComposableArchitecture
@testable import MomentumApp

@MainActor
final class ChecklistTests: XCTestCase {
    override func setUp() {
        super.setUp()
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
    
    func testChecklistLoading() async {
        let store = TestStore(initialState: PreparationFeature.State()) {
            PreparationFeature()
        } withDependencies: {
            $0.checklistClient.load = {
                [
                    ChecklistItem(id: "test-1", text: "Test item 1"),
                    ChecklistItem(id: "test-2", text: "Test item 2"),
                    ChecklistItem(id: "test-3", text: "Test item 3")
                ]
            }
        }
        
                
        // Load checklist on appear
        await store.send(.onAppear)
        
        await store.receive(.checklistItemsLoaded(.success([
            ChecklistItem(id: "test-1", text: "Test item 1"),
            ChecklistItem(id: "test-2", text: "Test item 2"),
            ChecklistItem(id: "test-3", text: "Test item 3")
        ]))) {
            $0.checklist = [
                ChecklistItem(id: "test-1", text: "Test item 1"),
                ChecklistItem(id: "test-2", text: "Test item 2"),
                ChecklistItem(id: "test-3", text: "Test item 3")
            ]
        }
    }
    
    func testChecklistInteraction() async {
        let store = TestStore(initialState: PreparationFeature.State(
            goal: "Test Goal",
            timeInput: "30"
        )) {
            PreparationFeature()
        } withDependencies: {
            $0.checklistClient.load = {
                ChecklistItem.mockItems
            }
        }
        
                
        // Load checklist first
        await store.send(.onAppear)
        await store.receive(.checklistItemsLoaded(.success(ChecklistItem.mockItems))) {
            $0.checklist = IdentifiedArray(uniqueElements: ChecklistItem.mockItems)
        }
        
        // Toggle first item
        await store.send(.checklistItemToggled("test-1")) {
            $0.checklist[id: "test-1"]?.isCompleted = true
        }
        
        // Toggle second item
        await store.send(.checklistItemToggled("test-2")) {
            $0.checklist[id: "test-2"]?.isCompleted = true
        }
        
        // Toggle third item
        await store.send(.checklistItemToggled("test-3")) {
            $0.checklist[id: "test-3"]?.isCompleted = true
        }
        
        // Verify all items are completed
        XCTAssertTrue(store.state.checklist.allSatisfy { $0.isCompleted })
        XCTAssertTrue(store.state.isStartButtonEnabled)
    }
    
    func testStartButtonEnabledLogic() async {
        // Test with empty state
        var state = PreparationFeature.State()
        XCTAssertFalse(state.isStartButtonEnabled)
        
        // Add goal
        state.goal = "Test Goal"
        XCTAssertFalse(state.isStartButtonEnabled)
        
        // Add valid time
        state.timeInput = "30"
        XCTAssertTrue(state.isStartButtonEnabled) // Empty checklist means all items are completed (vacuous truth)
        
        // Add uncompleted checklist items
        state.checklist = [
            ChecklistItem(id: "1", text: "Item 1", isCompleted: false),
            ChecklistItem(id: "2", text: "Item 2", isCompleted: false)
        ]
        XCTAssertFalse(state.isStartButtonEnabled)
        
        // Complete all checklist items
        state.checklist[id: "1"]?.isCompleted = true
        state.checklist[id: "2"]?.isCompleted = true
        XCTAssertTrue(state.isStartButtonEnabled)
        
        // Test invalid time inputs
        state.timeInput = "0"
        XCTAssertFalse(state.isStartButtonEnabled)
        
        state.timeInput = "-5"
        XCTAssertFalse(state.isStartButtonEnabled)
        
        state.timeInput = "abc"
        XCTAssertFalse(state.isStartButtonEnabled)
    }
    
    func testGoalAndTimeInputUpdates() async {
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