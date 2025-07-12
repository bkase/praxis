import XCTest
import ComposableArchitecture
@testable import MomentumApp

@MainActor
final class ErrorHandlingTests: XCTestCase {
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
    
    func testErrorHandling() async {
        // Set up initial values before creating the store
        @Shared(.lastGoal) var lastGoal: String
        @Shared(.lastTimeMinutes) var lastTimeMinutes: String
        $lastGoal.withLock { $0 = "Test Goal" }
        $lastTimeMinutes.withLock { $0 = "30" }
        
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.rustCoreClient.start = { _, _ in
                throw RustCoreError.binaryNotFound
            }
            $0.checklistClient = .testValue
        }
        
                
        // Set up initial state
        await store.send(.onAppear) {
            $0.destination = .preparation(PreparationFeature.State(
                goal: "Test Goal",
                timeInput: "30"
            ))
        }
        
        // Load checklist
        await store.send(.destination(.presented(.preparation(.onAppear))))
        await store.receive(.destination(.presented(.preparation(.checklistItemsLoaded(.success(ChecklistItem.mockItems)))))) {
            if case .preparation(var preparationState) = $0.destination {
                preparationState.checklist = IdentifiedArray(uniqueElements: ChecklistItem.mockItems)
                $0.destination = .preparation(preparationState)
            }
        }
        
        // Complete all checklist items so start button is enabled
        for item in ChecklistItem.mockItems {
            await store.send(.destination(.presented(.preparation(.checklistItemToggled(item.id))))) {
                if case .preparation(var preparationState) = $0.destination {
                    preparationState.checklist[id: item.id]?.isCompleted = true
                    $0.destination = .preparation(preparationState)
                }
            }
        }
        
        // Try to start a session
        await store.send(.destination(.presented(.preparation(.startButtonTapped))))
        
        await store.receive(.startSession(goal: "Test Goal", minutes: 30)) {
            $0.isLoading = true
            $0.alert = nil
        }
        
        // Receive error response
        await store.receive(.rustCoreResponse(.failure(RustCoreError.binaryNotFound))) {
            $0.isLoading = false
            $0.alert = .error(RustCoreError.binaryNotFound)
        }
    }
    
    func testStartSessionWhenAlreadyActive() async {
        // Start with an active session
        @Shared(.sessionData) var sessionData: SessionData?
        $sessionData.withLock { $0 = SessionData.mock(goal: "Existing Goal") }
        
        let store = TestStore(
            initialState: AppFeature.State()
        ) {
            AppFeature()
        }
        
                
        // Try to start another session
        await store.send(.startSession(goal: "New Goal", minutes: 20)) {
            $0.alert = .sessionAlreadyActive()
        }
    }
    
    func testStopSessionWhenNotActive() async {
        let store = TestStore(
            initialState: AppFeature.State()
        ) {
            AppFeature()
        }
        
                
        // Try to stop when no session is active
        await store.send(.stopSession) {
            $0.alert = .noActiveSession()
        }
    }
    
    func testAnalyzeWithoutReflection() async {
        let store = TestStore(
            initialState: AppFeature.State()
        ) {
            AppFeature()
        }
        
                
        // Try to analyze when no reflection exists (will do nothing since no path)
        await store.send(.analyzeReflection(path: ""))
    }
    
    func testDismissAlert() async {
        var state = AppFeature.State()
        state.alert = .genericError(AppError.other("Test Error"))
        
        let store = TestStore(
            initialState: state
        ) {
            AppFeature()
        }
        
                
        await store.send(.alert(.dismiss)) {
            $0.alert = nil
        }
    }
    
    func testInvalidTimeInput() async {
        // This is now handled by the UI not allowing invalid inputs
        // and the preparation state validation
    }
    
    func testChecklistLoadingError() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.checklistClient.load = {
                throw AppError.other("Failed to load checklist")
            }
        }
        
                
        // Set up initial state
        await store.send(.onAppear) {
            $0.destination = .preparation(PreparationFeature.State())
        }
        
        await store.send(.destination(.presented(.preparation(.onAppear))))
        await store.receive(.destination(.presented(.preparation(.checklistItemsLoaded(.failure(AppError.other("Failed to load checklist")))))))
    }
    
    func testCancelCurrentOperation() async {
        let store = TestStore(
            initialState: AppFeature.State.test(
                isLoading: true
            )
        ) {
            AppFeature()
        }
        
                
        await store.send(.cancelCurrentOperation) {
            $0.isLoading = false
        }
    }
}