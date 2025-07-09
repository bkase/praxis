import XCTest
import ComposableArchitecture
@testable import MomentumApp

@MainActor
final class AppFeatureTests: XCTestCase {
    func testStartSession() async {
        let fixedTime: UInt64 = 1700000000 // Fixed timestamp for testing
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.rustCoreClient = .testValue
        }
        
        // Start a session
        await store.send(.startButtonTapped(goal: "Test Goal", minutes: Minutes(30))) {
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
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.rustCoreClient.start = { _, _ in
                throw RustCoreError.binaryNotFound
            }
        }
        
        // Try to start a session
        await store.send(.startButtonTapped(goal: "Test Goal", minutes: Minutes(30))) {
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
        await store.send(.startButtonTapped(goal: "New Goal", minutes: Minutes(25))) {
            $0.error = .sessionAlreadyActive
        }
    }
    
    func testStopSessionWhenIdle() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }
        
        // Try to stop when no session is active
        await store.send(.stopButtonTapped) {
            $0.error = .noActiveSession
        }
    }
    
    func testAnalyzeWithoutReflection() async {
        let store = TestStore(initialState: AppFeature.State()) {
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
        }
        
        // 1. Start session
        await store.send(.startButtonTapped(goal: "Full Flow Test", minutes: Minutes(20))) {
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
        
        // 4. Reset to idle
        await store.send(.resetToIdle) {
            $0.session = .idle
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