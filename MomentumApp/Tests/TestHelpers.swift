import ComposableArchitecture
import Foundation
import Dependencies
@testable import MomentumApp

// MARK: - Test Helpers for Shared State

extension AppFeature.State {
    /// Creates a test state with optional initial values
    static func test(
        sessionData: SessionData? = nil,
        lastGoal: String = "",
        lastTimeMinutes: String = "30",
        analysisHistory: [AnalysisResult] = [],
        reflectionPath: String? = nil,
        isLoading: Bool = false,
        destination: AppFeature.Destination.State? = nil
    ) -> Self {
        var state = AppFeature.State()
        
        // Set shared values
        state.$sessionData.withLock { $0 = sessionData }
        state.$lastGoal.withLock { $0 = lastGoal }
        state.$lastTimeMinutes.withLock { $0 = lastTimeMinutes }
        state.$analysisHistory.withLock { $0 = analysisHistory }
        
        // Set regular values
        state.reflectionPath = reflectionPath
        state.isLoading = isLoading
        state.destination = destination
        
        return state
    }
}

// MARK: - Mock Data

extension SessionData {
    static func mock(
        goal: String = "Test Goal",
        startTime: Date = Date(timeIntervalSince1970: 1_700_000_000),
        timeExpected: UInt64 = 1800,
        reflectionFilePath: String? = nil
    ) -> Self {
        SessionData(
            goal: goal,
            startTime: UInt64(startTime.timeIntervalSince1970),
            timeExpected: timeExpected,
            reflectionFilePath: reflectionFilePath
        )
    }
}

extension AnalysisResult {
    static let mock = AnalysisResult(
        summary: "Test Summary",
        suggestion: "Test Suggestion",
        reasoning: "Test Reasoning"
    )
}

extension ChecklistItem {
    static let mockItems = [
        ChecklistItem(id: "test-1", text: "Close distractions", isCompleted: false),
        ChecklistItem(id: "test-2", text: "Set timer", isCompleted: false),
        ChecklistItem(id: "test-3", text: "Review goals", isCompleted: false)
    ]
}

// MARK: - Preparation State Testing

extension PreparationState {
    static func mock(
        goal: String = "Test Goal",
        timeInput: String = "30",
        checklist: [ChecklistItem] = ChecklistItem.mockItems
    ) -> Self {
        PreparationState(
            goal: goal,
            timeInput: timeInput,
            checklist: IdentifiedArray(uniqueElements: checklist)
        )
    }
}