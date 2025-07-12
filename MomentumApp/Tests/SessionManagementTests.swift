import XCTest
import ComposableArchitecture
@testable import MomentumApp

@MainActor
final class SessionManagementTests: XCTestCase {
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
}