import XCTest
import ComposableArchitecture
@testable import MomentumApp

@MainActor
final class AppFeatureTests: XCTestCase {
    func testChecklistLoading() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.checklistClient = .testValue
        }
        
        // Load checklist on appear
        await store.send(.onAppear)
        
        await store.receive(.checklistItemsLoaded(.success([
            ChecklistItem(id: "test-1", text: "Test item 1"),
            ChecklistItem(id: "test-2", text: "Test item 2"),
            ChecklistItem(id: "test-3", text: "Test item 3")
        ]))) {
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
        XCTAssertFalse(state.isStartButtonEnabled)
        
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
    
    func testStartSession() async {
        let fixedTime: UInt64 = 1700000000 // Fixed timestamp for testing
        let initialState = AppFeature.State(
            session: .preparing(PreparationState(
                goal: "Test Goal",
                timeInput: "30",
                checklist: [
                    ChecklistItem(id: "test-1", text: "Test item 1", isCompleted: true),
                    ChecklistItem(id: "test-2", text: "Test item 2", isCompleted: true)
                ]
            ))
        )
        
        let store = TestStore(initialState: initialState) {
            AppFeature()
        } withDependencies: {
            $0.rustCoreClient = .testValue
        }
        
        // Start a session
        await store.send(.startButtonTapped) {
            $0.isLoading = true
            $0.error = nil
        }
        
        // Receive successful response
        await store.receive(.rustCoreResponse(.success(.sessionStarted(SessionData(
            goal: "Test Goal",
            startTime: fixedTime,
            timeExpected: 30,
            reflectionFilePath: nil
        ))))) {
            $0.isLoading = false
            $0.session = .active(
                goal: "Test Goal",
                startTime: Date(timeIntervalSince1970: TimeInterval(fixedTime)),
                expectedMinutes: 30
            )
        }
    }
    
    func testStopSession() async {
        // Start with an active session
        let startTime = Date()
        let store = TestStore(
            initialState: AppFeature.State(
                session: .active(goal: "Test Goal", startTime: startTime, expectedMinutes: 30)
            )
        ) {
            AppFeature()
        } withDependencies: {
            $0.rustCoreClient = .testValue
        }
        
        // Stop the session
        await store.send(.stopButtonTapped) {
            $0.isLoading = true
            $0.error = nil
        }
        
        // Receive successful response
        await store.receive(.rustCoreResponse(.success(.sessionStopped(reflectionPath: "/tmp/test-reflection.md")))) {
            $0.isLoading = false
            $0.session = .awaitingAnalysis(reflectionPath: "/tmp/test-reflection.md")
        }
    }
    
    func testAnalyzeReflection() async {
        // Start with reflection created
        let store = TestStore(
            initialState: AppFeature.State(
                session: .awaitingAnalysis(reflectionPath: "/tmp/test-reflection.md")
            )
        ) {
            AppFeature()
        } withDependencies: {
            $0.rustCoreClient = .testValue
        }
        
        // Analyze the reflection
        await store.send(.analyzeButtonTapped) {
            $0.isLoading = true
            $0.error = nil
        }
        
        // Receive analysis result
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
    }
    
    func testErrorHandling() async {
        let initialState = AppFeature.State(
            session: .preparing(PreparationState(
                goal: "Test Goal",
                timeInput: "30",
                checklist: []
            ))
        )
        
        let store = TestStore(initialState: initialState) {
            AppFeature()
        } withDependencies: {
            $0.rustCoreClient.start = { _, _ in
                throw RustCoreError.binaryNotFound
            }
        }
        
        // Try to start a session
        await store.send(.startButtonTapped) {
            $0.isLoading = true
            $0.error = nil
        }
        
        // Receive error response
        await store.receive(.rustCoreResponse(.failure(RustCoreError.binaryNotFound))) {
            $0.isLoading = false
            $0.error = .rustCore(.binaryNotFound)
        }
    }
    
    func testStartSessionWhenAlreadyActive() async {
        // Start with an active session
        let store = TestStore(
            initialState: AppFeature.State(
                session: .active(goal: "Existing Goal", startTime: Date(), expectedMinutes: 30)
            )
        ) {
            AppFeature()
        }
        
        // Try to start another session
        await store.send(.startButtonTapped) {
            $0.error = .sessionAlreadyActive
        }
    }
    
    func testStopSessionWhenNotActive() async {
        let store = TestStore(
            initialState: AppFeature.State(
                session: .preparing(PreparationState())
            )
        ) {
            AppFeature()
        }
        
        // Try to stop when no session is active
        await store.send(.stopButtonTapped) {
            $0.error = .noActiveSession
        }
    }
    
    func testAnalyzeWithoutReflection() async {
        let store = TestStore(
            initialState: AppFeature.State(
                session: .preparing(PreparationState())
            )
        ) {
            AppFeature()
        }
        
        // Try to analyze when no reflection exists
        await store.send(.analyzeButtonTapped) {
            $0.error = .noReflectionToAnalyze
        }
    }
    
    func testFullFlow() async {
        let fixedTime: UInt64 = 1700000000
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.rustCoreClient = .testValue
            $0.checklistClient = .testValue
        }
        
        // 0. Load checklist
        await store.send(.onAppear)
        
        await store.receive(.checklistItemsLoaded(.success([
            ChecklistItem(id: "test-1", text: "Test item 1"),
            ChecklistItem(id: "test-2", text: "Test item 2"),
            ChecklistItem(id: "test-3", text: "Test item 3")
        ]))) {
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
        
        // Complete the checklist items by toggling them
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
        
        // Update goal and time
        await store.send(.binding(\.$session)) {
            guard case .preparing(var preparationState) = $0.session else {
                XCTFail("Expected preparing state")
                return
            }
            preparationState.goal = "Full Flow Test"
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
    
    func testClearError() async {
        let store = TestStore(
            initialState: AppFeature.State(error: .unexpected("Some error"))
        ) {
            AppFeature()
        }
        
        await store.send(.clearError) {
            $0.error = nil
        }
    }
    
    func testInvalidTimeInput() async {
        let initialState = AppFeature.State(
            session: .preparing(PreparationState(
                goal: "Test Goal",
                timeInput: "invalid",
                checklist: []
            ))
        )
        
        let store = TestStore(initialState: initialState) {
            AppFeature()
        }
        
        await store.send(.startButtonTapped) {
            $0.error = .invalidInput(reason: "Time must be a positive number")
        }
    }
}

// Helper extension to access active session start time for testing
private extension SessionState {
    var activeStartTime: UInt64 {
        switch self {
        case let .active(_, startTime, _):
            return UInt64(startTime.timeIntervalSince1970)
        default:
            return 0
        }
    }
}