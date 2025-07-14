import SwiftUI
import ComposableArchitecture
import Sharing

// Helper to create states with specific checklist configurations for previews
extension PreparationFeature.State {
    static func preview(
        goal: String = "",
        timeInput: String = "",
        checklistItems: [(text: String, isCompleted: Bool)] = [],
        totalItemsCompleted: Int? = nil,
        nextItemIndex: Int? = nil
    ) -> Self {
        @Shared(.preparationState) var sharedState = PreparationPersistentState.initial
        
        // Reset and configure the shared state for preview
        $sharedState.withLock { state in
            state.checklistSlots = (0..<4).map { PreparationFeature.ChecklistSlot(id: $0) }
            
            for (index, item) in checklistItems.prefix(4).enumerated() {
                state.checklistSlots[index].item = ChecklistItem(
                    id: "\(index)",
                    text: item.text,
                    isCompleted: item.isCompleted
                )
            }
            
            state.totalItemsCompleted = totalItemsCompleted ?? checklistItems.filter { $0.isCompleted }.count
            state.nextItemIndex = nextItemIndex ?? max(4, checklistItems.count)
        }
        
        return Self(goal: goal, timeInput: timeInput)
    }
}

#Preview("Empty State") {
    PreparationView(
        store: Store(initialState: PreparationFeature.State()) {
            PreparationFeature()
        }
    )
    .frame(width: 400, height: 500)
}

#Preview("With Goal") {
    PreparationView(
        store: Store(
            initialState: PreparationFeature.State(
                goal: "Write a comprehensive report on Q4 performance",
                timeInput: ""
            )
        ) {
            PreparationFeature()
        }
    )
    .frame(width: 400, height: 500)
}

#Preview("With Goal and Time") {
    PreparationView(
        store: Store(
            initialState: PreparationFeature.State(
                goal: "Write a comprehensive report on Q4 performance",
                timeInput: "45"
            )
        ) {
            PreparationFeature()
        }
    )
    .frame(width: 400, height: 500)
}

#Preview("With Checklist - Incomplete") {
    PreparationView(
        store: Store(
            initialState: PreparationFeature.State.preview(
                goal: "Write a comprehensive report on Q4 performance",
                timeInput: "45",
                checklistItems: [
                    ("Rested", false),
                    ("Not hungry", false),
                    ("Bathroom break", false),
                    ("Phone on silent", false)
                ]
            )
        ) {
            PreparationFeature()
        }
    )
    .frame(width: 400, height: 500)
}

#Preview("With Checklist - Partially Complete") {
    PreparationView(
        store: Store(
            initialState: PreparationFeature.State.preview(
                goal: "Write a comprehensive report on Q4 performance",
                timeInput: "45",
                checklistItems: [
                    ("Rested", true),
                    ("Not hungry", true),
                    ("Bathroom break", false),
                    ("Phone on silent", false)
                ]
            )
        ) {
            PreparationFeature()
        }
    )
    .frame(width: 400, height: 500)
}

#Preview("Ready to Start") {
    PreparationView(
        store: Store(
            initialState: PreparationFeature.State.preview(
                goal: "Write a comprehensive report on Q4 performance",
                timeInput: "45",
                checklistItems: [
                    ("Rested", true),
                    ("Not hungry", true),
                    ("Distractions closed", true),
                    ("Mind centered", true)
                ],
                totalItemsCompleted: 10,
                nextItemIndex: 10
            )
        ) {
            PreparationFeature()
        }
    )
    .frame(width: 400, height: 500)
}

#Preview("Invalid Time Input") {
    PreparationView(
        store: Store(
            initialState: PreparationFeature.State.preview(
                goal: "Write a comprehensive report on Q4 performance",
                timeInput: "0",
                checklistItems: [
                    ("Rested", true),
                    ("Not hungry", true),
                    ("Bathroom break", true),
                    ("Phone on silent", true)
                ],
                totalItemsCompleted: 10,
                nextItemIndex: 10
            )
        ) {
            PreparationFeature()
        }
    )
    .frame(width: 400, height: 500)
}