import XCTest
import ComposableArchitecture
@testable import MomentumApp

@MainActor
final class FullFlowTests: XCTestCase {
    func testFullFlow() async {
        let fixedTime: UInt64 = 1700000000
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.rustCoreClient = .testValue
            $0.checklistClient = .testValue
        }
        
        // 0. Load checklist
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
        
        // Complete the checklist items and set goal/time
        await store.send(.preparation(.checklistItemToggled("test-1"))) {
            guard case .preparing(var preparationState) = $0.session else {
                XCTFail("Expected preparing state")
                return
            }
            preparationState.checklist[id: "test-1"]?.isCompleted = true
            $0.session = .preparing(preparationState)
        }
        
        await store.send(.preparation(.checklistItemToggled("test-2"))) {
            guard case .preparing(var preparationState) = $0.session else {
                XCTFail("Expected preparing state")
                return
            }
            preparationState.checklist[id: "test-2"]?.isCompleted = true
            $0.session = .preparing(preparationState)
        }
        
        await store.send(.preparation(.checklistItemToggled("test-3"))) {
            guard case .preparing(var preparationState) = $0.session else {
                XCTFail("Expected preparing state")
                return
            }
            preparationState.checklist[id: "test-3"]?.isCompleted = true
            $0.session = .preparing(preparationState)
        }
        
        // Update goal and time through actions
        await store.send(.preparation(.goalChanged("Full Flow Test"))) {
            guard case .preparing(var preparationState) = $0.session else {
                XCTFail("Expected preparing state")
                return
            }
            preparationState.goal = "Full Flow Test"
            $0.session = .preparing(preparationState)
        }
        
        await store.send(.preparation(.timeInputChanged("20"))) {
            guard case .preparing(var preparationState) = $0.session else {
                XCTFail("Expected preparing state")
                return
            }
            preparationState.timeInput = "20"
            $0.session = .preparing(preparationState)
        }
        
        // 1. Start session
        await store.send(.startButtonTapped) {
            $0.isLoading = true
            $0.error = nil
        }
        
        await store.receive(.rustCoreResponse(.success(.sessionStarted(SessionData(
            goal: "Full Flow Test",
            startTime: fixedTime,
            timeExpected: 20,
            reflectionFilePath: nil
        ))))) {
            $0.isLoading = false
            $0.session = .active(
                goal: "Full Flow Test",
                startTime: Date(timeIntervalSince1970: TimeInterval(fixedTime)),
                expectedMinutes: 20
            )
        }
        
        // 2. Stop session
        await store.send(.stopButtonTapped) {
            $0.isLoading = true
            $0.error = nil
        }
        
        await store.receive(.rustCoreResponse(.success(.sessionStopped(reflectionPath: "/tmp/test-reflection.md")))) {
            $0.isLoading = false
            $0.session = .awaitingAnalysis(reflectionPath: "/tmp/test-reflection.md")
        }
        
        // 3. Analyze reflection
        await store.send(.analyzeButtonTapped) {
            $0.isLoading = true
            $0.error = nil
        }
        
        await store.receive(.rustCoreResponse(.success(.analysisComplete(AnalysisResult(
            summary: "Test analysis summary",
            suggestion: "Test suggestion",
            reasoning: "Test reasoning"
        ))))) {
            $0.isLoading = false
            $0.session = .analyzed(analysis: AnalysisResult(
                summary: "Test analysis summary",
                suggestion: "Test suggestion",
                reasoning: "Test reasoning"
            ))
        }
        
        // 4. Reset to preparing
        await store.send(.resetToIdle) {
            $0.session = .preparing(PreparationState())
            $0.error = nil
            $0.isLoading = false
        }
    }
}