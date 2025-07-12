import XCTest
import ComposableArchitecture
@testable import MomentumApp

@MainActor
final class SessionManagementTests: XCTestCase {
    func testStartSession() async {
        // Set up shared state before creating store
        @Shared(.lastGoal) var lastGoal: String
        @Shared(.lastTimeMinutes) var lastTimeMinutes: String
        $lastGoal.withLock { $0 = "Test Goal" }
        $lastTimeMinutes.withLock { $0 = "30" }
        
        let store = TestStore(
            initialState: AppFeature.State()
        ) {
            AppFeature()
        } withDependencies: {
            $0.rustCoreClient.start = { goal, minutes in
                SessionData.mock(
                    goal: goal,
                    startTime: Date(timeIntervalSince1970: 1_700_000_000),
                    timeExpected: UInt64(minutes * 60)
                )
            }
            $0.checklistClient.load = { ChecklistItem.mockItems }
        }
        
        // Set up preparation state
        await store.send(.preparation(.onAppear))
        await store.receive(.preparation(.checklistItemsLoaded(.success(ChecklistItem.mockItems))))
        
        // Complete checklist
        for item in ChecklistItem.mockItems {
            await store.send(.preparation(.checklistItemToggled(item.id)))
        }
        
        // Start session
        await store.send(.startButtonTapped) {
            $0.isLoading = true
            $0.error = nil
            $0.$lastGoal.withLock { $0 = "Test Goal" }
            $0.$lastTimeMinutes.withLock { $0 = "30" }
        }
        
        // Receive success response
        await store.receive(.rustCoreResponse(.success(.sessionStarted(SessionData.mock(
            goal: "Test Goal",
            startTime: Date(timeIntervalSince1970: 1_700_000_000),
            timeExpected: 1800
        ))))) {
            $0.isLoading = false
            $0.$sessionData.withLock { 
                $0 = SessionData.mock(
                    goal: "Test Goal",
                    startTime: Date(timeIntervalSince1970: 1_700_000_000),
                    timeExpected: 1800
                )
            }
            $0.reflectionPath = nil
            $0.$analysisHistory.withLock { $0 = [] }
        }
    }
    
    func testStopSession() async {
        let startTime = Date(timeIntervalSince1970: 1_700_000_000)
        let sessionData = SessionData.mock(
            goal: "Test Goal",
            startTime: startTime,
            timeExpected: 1800
        )
        
        // Set up shared state before creating store
        @Shared(.sessionData) var sharedSessionData: SessionData?
        $sharedSessionData.withLock { $0 = sessionData }
        
        let store = TestStore(
            initialState: AppFeature.State()
        ) {
            AppFeature()
        } withDependencies: {
            $0.rustCoreClient.stop = {
                "/tmp/test-reflection.md"
            }
        }
        
        // Stop session
        await store.send(.stopButtonTapped) {
            $0.isLoading = true
            $0.error = nil
        }
        
        // Receive response
        await store.receive(.rustCoreResponse(.success(.sessionStopped(reflectionPath: "/tmp/test-reflection.md")))) {
            $0.isLoading = false
            $0.$sessionData.withLock { $0 = nil }
            $0.reflectionPath = "/tmp/test-reflection.md"
        }
    }
    
    func testAnalyzeReflection() async {
        let store = TestStore(
            initialState: AppFeature.State.test(
                reflectionPath: "/tmp/test-reflection.md"
            )
        ) {
            AppFeature()
        } withDependencies: {
            $0.rustCoreClient.analyze = { _ in
                AnalysisResult.mock
            }
        }
        
        // Analyze reflection
        await store.send(.analyzeButtonTapped) {
            $0.isLoading = true
            $0.error = nil
        }
        
        // Receive analysis result
        await store.receive(.rustCoreResponse(.success(.analysisComplete(AnalysisResult.mock)))) {
            $0.isLoading = false
            $0.reflectionPath = nil
            $0.$analysisHistory.withLock { $0.append(AnalysisResult.mock) }
        }
    }
    
    func testResetToIdle() async {
        let sessionData = SessionData.mock()
        let store = TestStore(
            initialState: AppFeature.State.test(
                sessionData: sessionData,
                analysisHistory: [AnalysisResult.mock],
                reflectionPath: "/tmp/test.md",
                isLoading: true,
                error: .unexpected("Some error")
            )
        ) {
            AppFeature()
        }
        
        await store.send(.resetToIdle) {
            $0.$sessionData.withLock { $0 = nil }
            $0.reflectionPath = nil
            $0.$analysisHistory.withLock { $0 = [] }
            $0.error = nil
            $0.isLoading = false
        }
    }
}