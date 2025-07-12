import XCTest
import ComposableArchitecture
@testable import MomentumApp

@MainActor
final class ChecklistTests: XCTestCase {
    func testChecklistLoading() async {
        let store = TestStore(initialState: AppFeature.State()) {
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
        ])))) {
            guard case .preparing(var preparationState) = $0.session else {
                XCTFail("Expected preparing state")
                return
            }
            preparationState.checklist = [
                ChecklistItem(id: "test-1", text: "Test item 1"),
                ChecklistItem(id: "test-2", text: "Test item 2"),
                ChecklistItem(id: "test-3", text: "Test item 3")
            ]
            $0.session = .preparing(preparationState)
        }
    }
    
    func testChecklistInteraction() async {
        let initialState = AppFeature.State(
            session: .preparing(PreparationState(
                goal: "Test Goal",
                timeInput: "30",
                checklist: [
                    ChecklistItem(id: "test-1", text: "Test item 1", isCompleted: false),
                    ChecklistItem(id: "test-2", text: "Test item 2", isCompleted: false),
                    ChecklistItem(id: "test-3", text: "Test item 3", isCompleted: false)
                ]
            ))
        )
        
        let store = TestStore(initialState: initialState) {
            AppFeature()
        }
        
        // Toggle first item
        await store.send(.preparation(.checklistItemToggled("test-1"))) {
            guard case .preparing(var preparationState) = $0.session else {
                XCTFail("Expected preparing state")
                return
            }
            preparationState.checklist[id: "test-1"]?.isCompleted = true
            $0.session = .preparing(preparationState)
        }
        
        // Toggle second item
        await store.send(.preparation(.checklistItemToggled("test-2"))) {
            guard case .preparing(var preparationState) = $0.session else {
                XCTFail("Expected preparing state")
                return
            }
            preparationState.checklist[id: "test-2"]?.isCompleted = true
            $0.session = .preparing(preparationState)
        }
        
        // Toggle third item
        await store.send(.preparation(.checklistItemToggled("test-3"))) {
            guard case .preparing(var preparationState) = $0.session else {
                XCTFail("Expected preparing state")
                return
            }
            preparationState.checklist[id: "test-3"]?.isCompleted = true
            $0.session = .preparing(preparationState)
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