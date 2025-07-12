import Testing
import Foundation
import ComposableArchitecture
@testable import MomentumApp

@Suite("Session Management Tests")
@MainActor
struct SessionManagementTests {
    init() {
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
    
    @Test("Start Session")
    func startSession() async {
        // Set up shared state before creating the store
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
        store.exhaustivity = .off
        
        // Destination already set by init, onAppear should not change anything
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
        
        // Start session - this triggers an effect that runs synchronously in tests
        await store.receive(.startSession(goal: "Test Goal", minutes: 30)) {
            $0.isLoading = true
            $0.alert = nil
        }
        
        // The effect executes immediately and sends the response
        let sessionData = SessionData.mock(
            goal: "Test Goal",
            startTime: Date(timeIntervalSince1970: 1_700_000_000),
            timeExpected: 1800
        )
        await store.receive(.rustCoreResponse(.success(.sessionStarted(sessionData)))) {
            $0.isLoading = false
            // Don't manually update shared state - the reducer handles it
            $0.reflectionPath = nil
            $0.destination = .activeSession(ActiveSessionFeature.State(
                goal: "Test Goal",
                startTime: Date(timeIntervalSince1970: 1_700_000_000),
                expectedMinutes: 30
            ))
        }
    }
    
    @Test("Stop Session")
    func stopSession() async {
        let startTime = Date(timeIntervalSince1970: 1_700_000_000)
        let sessionData = SessionData.mock(
            goal: "Test Goal",
            startTime: startTime,
            timeExpected: 1800
        )
        
        // Set up shared state before creating the store
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
        store.exhaustivity = .off
        
        // Destination already set by init, onAppear should not change anything
        await store.send(.onAppear)
        
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
            // Don't manually update shared state - the reducer handles it
            $0.reflectionPath = "/tmp/test-reflection.md"
            $0.destination = .reflection(ReflectionFeature.State(reflectionPath: "/tmp/test-reflection.md"))
        }
    }
    
    @Test("Analyze Reflection")
    func analyzeReflection() async {
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
        store.exhaustivity = .off
        
        // Analyze reflection
        await store.send(.destination(.presented(.reflection(.analyzeButtonTapped))))
        
        await store.receive(.analyzeReflection(path: "/tmp/test-reflection.md")) {
            $0.isLoading = true
            $0.alert = nil
        }
    }
    
    @Test("Reset to Idle")
    func resetToIdle() async {
        let sessionData = SessionData.mock()
        
        // Set up shared state before creating the store
        @Shared(.sessionData) var sharedSessionData: SessionData?
        @Shared(.analysisHistory) var analysisHistory: [AnalysisResult]
        $sharedSessionData.withLock { $0 = sessionData }
        $analysisHistory.withLock { $0 = [AnalysisResult.mock] }
        
        let store = TestStore(
            initialState: AppFeature.State()
        ) {
            AppFeature()
        }
        store.exhaustivity = .off
        
        // Destination already set by init, onAppear should not change anything
        await store.send(.onAppear)
        
        await store.send(.destination(.presented(.analysis(.resetButtonTapped)))) {
            $0.confirmationDialog = .resetToIdle()
        }
        
        // Confirm reset
        await store.send(.confirmationDialog(.presented(.confirmReset))) {
            $0.confirmationDialog = nil
        }
        
        await store.receive(.resetToIdle) {
            // Don't manually update shared state - the reducer handles it
            $0.reflectionPath = nil
            $0.alert = nil
            $0.isLoading = false
            $0.destination = .preparation(PreparationFeature.State(
                goal: "",
                timeInput: "30"
            ))
        }
    }
}