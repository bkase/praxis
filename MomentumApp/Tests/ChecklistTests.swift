import XCTest
import ComposableArchitecture
@testable import MomentumApp

@MainActor
final class ChecklistTests: XCTestCase {
    func testChecklistLoading() async {
        let store = TestStore(initialState: AppFeature.State.test()) {
            AppFeature()
        } withDependencies: {
            $0.checklistClient = .testValue
        }
        
        // Load checklist on appear
        await store.send(.preparation(.onAppear))
        
        await store.receive(.preparation(.checklistItemsLoaded(.success([
            ChecklistItem(id: "test-1", text: "Test item 1"),
            ChecklistItem(id: "test-2", text: "Test item 2"),
            ChecklistItem(id: "test-3", text: "Test item 3")
        ])))) { _ in
            // Checklist is loaded into preparation state
            // The computed session property will reflect this change
        }
    }
    
    func testChecklistInteraction() async {
        let store = TestStore(initialState: AppFeature.State.test(
            lastGoal: "Test Goal",
            lastTimeMinutes: "30"
        )) {
            AppFeature()
        } withDependencies: {
            $0.checklistClient.load = {
                ChecklistItem.mockItems
            }
        }
        
        // Load checklist first
        await store.send(.preparation(.onAppear))
        await store.receive(.preparation(.checklistItemsLoaded(.success(ChecklistItem.mockItems))))
        
        // Toggle first item
        await store.send(.preparation(.checklistItemToggled("test-1")))
        
        // Toggle second item
        await store.send(.preparation(.checklistItemToggled("test-2")))
        
        // Toggle third item
        await store.send(.preparation(.checklistItemToggled("test-3")))
        
        // Verify all items are completed in preparation state
        if let preparationState = store.state.preparation?.preparationState {
            XCTAssertTrue(preparationState.checklist.allSatisfy { $0.isCompleted })
        } else {
            XCTFail("Expected preparation state")
        }
    }
    
    func testStartButtonEnabledLogic() async {
        // Test with empty state
        var state = PreparationState()
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
}