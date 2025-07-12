import XCTest
import ComposableArchitecture
@testable import MomentumApp

@MainActor
final class SessionManagementTests: XCTestCase {
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
    
    func testStartSession() async {
        let store = TestStore(
            initialState: AppFeature.State.test(
                lastGoal: "Test Goal",
                lastTimeMinutes: "30",
                destination: .preparation(PreparationFeature.State(
                    goal: "Test Goal",
                    timeInput: "30"
                ))
            )
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
        
        await store.send(.onAppear)
        
        // Load checklist
        await store.send(.destination(.presented(.preparation(.onAppear))))
        await store.receive(.destination(.presented(.preparation(.checklistItemsLoaded(.success(ChecklistItem.mockItems)))))) {
            if case .preparation(var preparationState) = $0.destination {
                preparationState.checklist = IdentifiedArray(uniqueElements: ChecklistItem.mockItems)
                $0.destination = .preparation(preparationState)
            }
        }
        
        // Complete checklist
        for item in ChecklistItem.mockItems {
            await store.send(.destination(.presented(.preparation(.checklistItemToggled(item.id))))) {
                if case .preparation(var preparationState) = $0.destination {
                    preparationState.checklist[id: item.id]?.isCompleted = true
                    $0.destination = .preparation(preparationState)
                }
            }
        }
        
        // Start session
        await store.send(.destination(.presented(.preparation(.startButtonTapped))))
        
        await store.receive(.startSession(goal: "Test Goal", minutes: 30)) {
            $0.isLoading = true
            $0.alert = nil
        }
        
        // Receive success response
        let sessionData = SessionData.mock(
            goal: "Test Goal",
            startTime: Date(timeIntervalSince1970: 1_700_000_000),
            timeExpected: 1800
        )
        await store.receive(.rustCoreResponse(.success(.sessionStarted(sessionData)))) {
            $0.isLoading = false
            $0.$sessionData.withLock { $0 = sessionData }
            $0.reflectionPath = nil
            $0.$analysisHistory.withLock { $0 = [] }
            $0.destination = .activeSession(ActiveSessionFeature.State(
                goal: "Test Goal",
                startTime: Date(timeIntervalSince1970: 1_700_000_000),
                expectedMinutes: 30
            ))
        }
    }
    
    func testStopSession() async {
        let startTime = Date(timeIntervalSince1970: 1_700_000_000)
        let sessionData = SessionData.mock(
            goal: "Test Goal",
            startTime: startTime,
            timeExpected: 1800
        )
        
        let store = TestStore(
            initialState: AppFeature.State.test(
                sessionData: sessionData,
                destination: .activeSession(ActiveSessionFeature.State(
                    goal: "Test Goal",
                    startTime: startTime,
                    expectedMinutes: 30
                ))
            )
        ) {
            AppFeature()
        } withDependencies: {
            $0.rustCoreClient.stop = {
                "/tmp/test-reflection.md"
            }
        }
        
        // Stop session - shows confirmation dialog
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
        
        // Receive response
        await store.receive(.rustCoreResponse(.success(.sessionStopped(reflectionPath: "/tmp/test-reflection.md")))) {
            $0.isLoading = false
            $0.$sessionData.withLock { $0 = nil }
            $0.reflectionPath = "/tmp/test-reflection.md"
            $0.destination = .reflection(ReflectionFeature.State(reflectionPath: "/tmp/test-reflection.md"))
        }
    }
    
    func testAnalyzeReflection() async {
        let store = TestStore(
            initialState: AppFeature.State.test(
                reflectionPath: "/tmp/test-reflection.md",
                destination: .reflection(ReflectionFeature.State(reflectionPath: "/tmp/test-reflection.md"))
            )
        ) {
            AppFeature()
        } withDependencies: {
            $0.rustCoreClient.analyze = { _ in
                AnalysisResult.mock
            }
        }
        
        // Analyze reflection
        await store.send(.destination(.presented(.reflection(.analyzeButtonTapped))))
        
        await store.receive(.analyzeReflection(path: "/tmp/test-reflection.md")) {
            $0.isLoading = true
            $0.alert = nil
            // analysisHistory remains unchanged at this point
        }
        
        // Receive analysis result
        await store.receive(.rustCoreResponse(.success(.analysisComplete(AnalysisResult.mock)))) {
            $0.isLoading = false
            $0.reflectionPath = nil
            $0.$analysisHistory.withLock { $0.append(AnalysisResult.mock) }
            $0.destination = .analysis(AnalysisFeature.State(analysis: AnalysisResult.mock))
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
                destination: .analysis(AnalysisFeature.State(analysis: AnalysisResult.mock))
            )
        ) {
            AppFeature()
        }
        
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
                goal: "",
                timeInput: "30"
            ))
        }
    }
}