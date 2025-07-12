import XCTest
import ComposableArchitecture
@testable import MomentumApp

@MainActor
final class ErrorHandlingTests: XCTestCase {
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
            initialState: AppFeature.State(isLoading: true)
        ) {
            AppFeature()
        }
        
        await store.send(.cancelCurrentOperation) {
            $0.isLoading = false
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