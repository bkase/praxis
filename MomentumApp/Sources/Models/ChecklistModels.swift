import Foundation
import ComposableArchitecture

struct ChecklistItemPool {
    static let allItems = [
        "Rested",
        "Not hungry",
        "Bathroom break",
        "Phone on silent",
        "Desk cleared",
        "Water bottle filled",
        "Distractions closed",
        "Notes prepared",
        "Environment comfortable",
        "Mind centered"
    ]
    
    static func createInitialItems() -> IdentifiedArrayOf<ChecklistItem> {
        IdentifiedArray(uniqueElements: allItems.prefix(4).enumerated().map { index, text in
            ChecklistItem(id: "\(index)", text: text, isCompleted: false)
        })
    }
}