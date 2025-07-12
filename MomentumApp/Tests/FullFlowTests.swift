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
        
        // 0. Initial state should have preparation destination
        await store.send(.onAppear) {
            $0.destination = .preparation(PreparationFeature.State(
                goal: "Full Flow Test",
                timeInput: "20"
            ))
        }
        
        // Load checklist
        await store.send(.destination(.presented(.preparation(.onAppear))))
        
        await store.receive(.destination(.presented(.preparation(.checklistItemsLoaded(.success([
            ChecklistItem(id: "test-1", text: "Test item 1"),
            ChecklistItem(id: "test-2", text: "Test item 2"),
            ChecklistItem(id: "test-3", text: "Test item 3")
        ])))))) {
            if case .preparation(var preparationState) = $0.destination {
                preparationState.checklist = [
                    ChecklistItem(id: "test-1", text: "Test item 1"),
                    ChecklistItem(id: "test-2", text: "Test item 2"),
                    ChecklistItem(id: "test-3", text: "Test item 3")
                ]
                $0.destination = .preparation(preparationState)
            }
        }
        
        // Complete the checklist items
        await store.send(.destination(.presented(.preparation(.checklistItemToggled("test-1"))))) {
            if case .preparation(var preparationState) = $0.destination {
                preparationState.checklist[id: "test-1"]?.isCompleted = true
                $0.destination = .preparation(preparationState)
            }
        }
        await store.send(.destination(.presented(.preparation(.checklistItemToggled("test-2"))))) {
            if case .preparation(var preparationState) = $0.destination {
                preparationState.checklist[id: "test-2"]?.isCompleted = true
                $0.destination = .preparation(preparationState)
            }
        }
        await store.send(.destination(.presented(.preparation(.checklistItemToggled("test-3"))))) {
            if case .preparation(var preparationState) = $0.destination {
                preparationState.checklist[id: "test-3"]?.isCompleted = true
                $0.destination = .preparation(preparationState)
            }
        }
        
        // 1. Start session
        await store.send(.destination(.presented(.preparation(.startButtonTapped))))
        
        await store.receive(.startSession(goal: "Full Flow Test", minutes: 20)) {
            $0.isLoading = true
            $0.alert = nil
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
            $0.destination = .activeSession(ActiveSessionFeature.State(
                goal: "Full Flow Test",
                startTime: Date(timeIntervalSince1970: TimeInterval(fixedTime)),
                expectedMinutes: 20
            ))
        }
        
        // 2. Stop session - shows confirmation dialog
        await store.send(.destination(.presented(.activeSession(.stopButtonTapped)))) {
            $0.confirmationDialog = .stopSession()
        }
        
        // Confirm stop
        await store.send(.confirmationDialog(.presented(.confirmStopSession))) {
            $0.confirmationDialog = nil
        }
        
        await store.receive(.stopSession) {
            $0.isLoading = true
            $0.alert = nil
        }
        
        await store.receive(.rustCoreResponse(.success(.sessionStopped(reflectionPath: "/tmp/test-reflection.md")))) {
            $0.isLoading = false
            $0.$sessionData.withLock { $0 = nil }
            $0.reflectionPath = "/tmp/test-reflection.md"
            $0.destination = .reflection(ReflectionFeature.State(reflectionPath: "/tmp/test-reflection.md"))
        }
        
        // 3. Analyze reflection
        await store.send(.destination(.presented(.reflection(.analyzeButtonTapped))))
        
        await store.receive(.analyzeReflection(path: "/tmp/test-reflection.md")) {
            $0.isLoading = true
            $0.alert = nil
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
            $0.destination = .analysis(AnalysisFeature.State(analysis: AnalysisResult(
                summary: "Test analysis summary",
                suggestion: "Test suggestion",
                reasoning: "Test reasoning"
            )))
        }
        
        // 4. Reset to preparing - shows confirmation dialog
        await store.send(.destination(.presented(.analysis(.resetButtonTapped)))) {
            $0.confirmationDialog = .resetToIdle()
        }
        
        // Confirm reset
        await store.send(.confirmationDialog(.presented(.confirmReset))) {
            $0.confirmationDialog = nil
        }
        
        await store.receive(.resetToIdle) {
            $0.$sessionData.withLock { $0 = nil }
            $0.reflectionPath = nil
            $0.$analysisHistory.withLock { $0 = [] }
            $0.alert = nil
            $0.isLoading = false
            $0.destination = .preparation(PreparationFeature.State(
                goal: "Full Flow Test",
                timeInput: "20"
            ))
        }
    }
}