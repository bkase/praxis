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
                checklist: [
                    ChecklistItem(id: "1", text: "Close all distracting browser tabs", isCompleted: false),
                    ChecklistItem(id: "2", text: "Put phone in another room", isCompleted: false),
                    ChecklistItem(id: "3", text: "Clear desk of unnecessary items", isCompleted: false)
                ],
                completedChecklistItemCount: 0,
                totalChecklistItemCount: 3
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
                checklist: [
                    ChecklistItem(id: "1", text: "Close all distracting browser tabs", isCompleted: true),
                    ChecklistItem(id: "2", text: "Put phone in another room", isCompleted: true),
                    ChecklistItem(id: "3", text: "Clear desk of unnecessary items", isCompleted: false)
                ],
                completedChecklistItemCount: 2,
                totalChecklistItemCount: 3
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
                checklist: [
                    ChecklistItem(id: "1", text: "Close all distracting browser tabs", isCompleted: true),
                    ChecklistItem(id: "2", text: "Put phone in another room", isCompleted: true),
                    ChecklistItem(id: "3", text: "Clear desk of unnecessary items", isCompleted: true)
                ],
                completedChecklistItemCount: 3,
                totalChecklistItemCount: 3
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
                checklist: [
                    ChecklistItem(id: "1", text: "Close all distracting browser tabs", isCompleted: true),
                    ChecklistItem(id: "2", text: "Put phone in another room", isCompleted: true),
                    ChecklistItem(id: "3", text: "Clear desk of unnecessary items", isCompleted: true)
                ],
                completedChecklistItemCount: 3,
                totalChecklistItemCount: 3
            )
        ) {
            PreparationFeature()
        }
    )
    .frame(width: 400, height: 500)
}