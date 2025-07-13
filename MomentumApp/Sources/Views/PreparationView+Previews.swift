import SwiftUI
import ComposableArchitecture

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
            initialState: PreparationFeature.State(
                goal: "Write a comprehensive report on Q4 performance",
                timeInput: "45",
                visibleChecklist: [
                    ChecklistItem(id: "0", text: "Rested", isCompleted: false),
                    ChecklistItem(id: "1", text: "Not hungry", isCompleted: false),
                    ChecklistItem(id: "2", text: "Bathroom break", isCompleted: false),
                    ChecklistItem(id: "3", text: "Phone on silent", isCompleted: false)
                ],
                totalItemsCompleted: 0,
                nextItemIndex: 4
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
            initialState: PreparationFeature.State(
                goal: "Write a comprehensive report on Q4 performance",
                timeInput: "45",
                visibleChecklist: [
                    ChecklistItem(id: "0", text: "Rested", isCompleted: true),
                    ChecklistItem(id: "1", text: "Not hungry", isCompleted: true),
                    ChecklistItem(id: "2", text: "Bathroom break", isCompleted: false),
                    ChecklistItem(id: "3", text: "Phone on silent", isCompleted: false)
                ],
                totalItemsCompleted: 2,
                nextItemIndex: 4
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
            initialState: PreparationFeature.State(
                goal: "Write a comprehensive report on Q4 performance",
                timeInput: "45",
                visibleChecklist: [
                    ChecklistItem(id: "0", text: "Rested", isCompleted: true),
                    ChecklistItem(id: "1", text: "Not hungry", isCompleted: true),
                    ChecklistItem(id: "6", text: "Distractions closed", isCompleted: true),
                    ChecklistItem(id: "9", text: "Mind centered", isCompleted: true)
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
            initialState: PreparationFeature.State(
                goal: "Write a comprehensive report on Q4 performance",
                timeInput: "0",
                visibleChecklist: [
                    ChecklistItem(id: "0", text: "Rested", isCompleted: true),
                    ChecklistItem(id: "1", text: "Not hungry", isCompleted: true),
                    ChecklistItem(id: "2", text: "Bathroom break", isCompleted: true),
                    ChecklistItem(id: "3", text: "Phone on silent", isCompleted: true)
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