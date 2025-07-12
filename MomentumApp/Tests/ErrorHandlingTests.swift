import XCTest
import ComposableArchitecture
@testable import MomentumApp

@MainActor
final class ErrorHandlingTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Reset shared state before each test
        @Shared(.sessionData) var sessionData: SessionData? = nil
        @Shared(.lastGoal) var lastGoal = ""
        @Shared(.lastTimeMinutes) var lastTimeMinutes = "30"
        @Shared(.analysisHistory) var analysisHistory: [AnalysisResult] = []
    }
    
    func testErrorHandling() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.rustCoreClient.start = { _, _ in
                throw RustCoreError.binaryNotFound
            }
        }
        
        // Set up initial values
        @Shared(.lastGoal) var lastGoal = "Test Goal"
        @Shared(.lastTimeMinutes) var lastTimeMinutes = "30"
        
        // Try to start a session
        await store.send(.startButtonTapped) {
            $0.isLoading = true
            $0.error = nil
            // Save last used values
            $0.$lastGoal.withLock { $0 = "Test Goal" }
            $0.$lastTimeMinutes.withLock { $0 = "30" }
        }
        
        // Receive error response
        await store.receive(.rustCoreResponse(.failure(RustCoreError.binaryNotFound))) {
            $0.isLoading = false
            $0.error = .rustCore(.binaryNotFound)
        }
    }
    
    func testStartSessionWhenAlreadyActive() async {
        // Start with an active session
        @Shared(.sessionData) var sessionData: SessionData? = SessionData.mock(goal: "Existing Goal")
        
        let store = TestStore(
            initialState: AppFeature.State()
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
            initialState: AppFeature.State()
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
            initialState: AppFeature.State()
        ) {
            AppFeature()
        }
        
        // Try to analyze when no reflection exists
        await store.send(.analyzeButtonTapped) {
            $0.error = .noReflectionToAnalyze
        }
    }
    
    func testClearError() async {
        let store = TestStore(
            initialState: AppFeature.State()
        ) {
            AppFeature()
        }
        
        // Manually set an error
        store.state.error = .unexpected("Some error")
        
        await store.send(.clearError) {
            $0.error = nil
        }
    }
    
    func testInvalidTimeInput() async {
        // Set up state with invalid time
        @Shared(.lastGoal) var lastGoal = "Test Goal"
        @Shared(.lastTimeMinutes) var lastTimeMinutes = "invalid"
        
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }
        
        await store.send(.startButtonTapped) {
            $0.error = .invalidInput(reason: "Time must be a positive number")
        }
    }
    
    func testChecklistLoadingError() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.checklistClient.load = {
                throw AppError.other("Failed to load checklist")
            }
        }
        
        await store.send(.preparation(.onAppear))
        
        await store.receive(.preparation(.checklistItemsLoaded(.failure(AppError.other("Failed to load checklist"))))) {
            $0.error = .other("Failed to load checklist")
        }
    }
    
    func testCancelCurrentOperation() async {
        let store = TestStore(
            initialState: AppFeature.State()
        ) {
            AppFeature()
        }
        
        store.state.isLoading = true
        
        await store.send(.cancelCurrentOperation) {
            $0.isLoading = false
        }
    }
}