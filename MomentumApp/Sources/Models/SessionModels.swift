import Foundation
import ComposableArchitecture
import IdentifiedCollections

// MARK: - Session State

enum SessionState: Equatable {
    case preparing(PreparationState)
    case active(goal: String, startTime: Date, expectedMinutes: UInt64)
    case awaitingAnalysis(reflectionPath: String)
    case analyzed(analysis: AnalysisResult)
}

// MARK: - Preparation State

struct PreparationState: Equatable {
    var goal: String = ""
    var timeInput: String = ""
    var checklist: IdentifiedArrayOf<ChecklistItem> = []
    
    var isStartButtonEnabled: Bool {
        !goal.isEmpty &&
        Int(timeInput).map { $0 > 0 } == true &&
        checklist.allSatisfy { $0.isCompleted }
    }
}