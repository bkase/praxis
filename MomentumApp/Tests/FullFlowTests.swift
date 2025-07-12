import XCTest
import ComposableArchitecture
@testable import MomentumApp

@MainActor
final class FullFlowTests: XCTestCase {
    func testFullFlow() async {
        let fixedTime: UInt64 = 1700000000
        
        // Set up initial shared state with the values we want
        @Shared(.lastGoal) var lastGoal: String
        @Shared(.lastTimeMinutes) var lastTimeMinutes: String
        $lastGoal.withLock { $0 = "Full Flow Test" }
        $lastTimeMinutes.withLock { $0 = "20" }
        
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        } withDependencies: {
            $0.rustCoreClient.start = { goal, minutes in
                SessionData(
                    goal: goal,
                    startTime: fixedTime,
                    timeExpected: UInt64(minutes * 60),
                    reflectionFilePath: nil
                )
            }
            $0.rustCoreClient.stop = {
                "/tmp/test-reflection.md"
            }
            $0.rustCoreClient.analyze = { _ in
                AnalysisResult(
                    summary: "Test analysis summary",
                    suggestion: "Test suggestion",
                    reasoning: "Test reasoning"
                )
            }
            $0.checklistClient = .testValue
        }
        
        // 0. Load checklist
        await store.send(.preparation(.onAppear))
        
        await store.receive(.preparation(.checklistItemsLoaded(.success([
            ChecklistItem(id: "test-1", text: "Test item 1"),
            ChecklistItem(id: "test-2", text: "Test item 2"),
            ChecklistItem(id: "test-3", text: "Test item 3")
        ]))))
        
        // Complete the checklist items
        await store.send(.preparation(.checklistItemToggled("test-1")))
        await store.send(.preparation(.checklistItemToggled("test-2")))
        await store.send(.preparation(.checklistItemToggled("test-3")))
        
        // 1. Start session
        await store.send(.startButtonTapped) {
            $0.isLoading = true
            $0.error = nil
            $0.$lastGoal.withLock { $0 = "Full Flow Test" }
            $0.$lastTimeMinutes.withLock { $0 = "20" }
        }
        
        await store.receive(.rustCoreResponse(.success(.sessionStarted(SessionData(
            goal: "Full Flow Test",
            startTime: fixedTime,
            timeExpected: 1200,  // 20 minutes in seconds
            reflectionFilePath: nil
        ))))) {
            $0.isLoading = false
            $0.$sessionData.withLock {
                $0 = SessionData(
                    goal: "Full Flow Test",
                    startTime: fixedTime,
                    timeExpected: 1200,
                    reflectionFilePath: nil
                )
            }
            $0.reflectionPath = nil
            $0.$analysisHistory.withLock { $0 = [] }
        }
        
        // 2. Stop session
        await store.send(.stopButtonTapped) {
            $0.isLoading = true
            $0.error = nil
        }
        
        await store.receive(.rustCoreResponse(.success(.sessionStopped(reflectionPath: "/tmp/test-reflection.md")))) {
            $0.isLoading = false
            $0.$sessionData.withLock { $0 = nil }
            $0.reflectionPath = "/tmp/test-reflection.md"
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
            $0.reflectionPath = nil
            $0.$analysisHistory.withLock {
                $0.append(AnalysisResult(
                    summary: "Test analysis summary",
                    suggestion: "Test suggestion",
                    reasoning: "Test reasoning"
                ))
            }
        }
        
        // 4. Reset to preparing
        await store.send(.resetToIdle) {
            $0.$sessionData.withLock { $0 = nil }
            $0.reflectionPath = nil
            $0.$analysisHistory.withLock { $0 = [] }
            $0.error = nil
            $0.isLoading = false
        }
    }
}