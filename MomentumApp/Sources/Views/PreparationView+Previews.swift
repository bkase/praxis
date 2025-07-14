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
                checklistSlots: [
                    PreparationFeature.ChecklistSlot(id: 0, item: ChecklistItem(id: "0", text: "Rested", isCompleted: false)),
                    PreparationFeature.ChecklistSlot(id: 1, item: ChecklistItem(id: "1", text: "Not hungry", isCompleted: false)),
                    PreparationFeature.ChecklistSlot(id: 2, item: ChecklistItem(id: "2", text: "Bathroom break", isCompleted: false)),
                    PreparationFeature.ChecklistSlot(id: 3, item: ChecklistItem(id: "3", text: "Phone on silent", isCompleted: false))
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
                checklistSlots: [
                    PreparationFeature.ChecklistSlot(id: 0, item: ChecklistItem(id: "0", text: "Rested", isCompleted: true)),
                    PreparationFeature.ChecklistSlot(id: 1, item: ChecklistItem(id: "1", text: "Not hungry", isCompleted: true)),
                    PreparationFeature.ChecklistSlot(id: 2, item: ChecklistItem(id: "2", text: "Bathroom break", isCompleted: false)),
                    PreparationFeature.ChecklistSlot(id: 3, item: ChecklistItem(id: "3", text: "Phone on silent", isCompleted: false))
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
                checklistSlots: [
                    PreparationFeature.ChecklistSlot(id: 0, item: ChecklistItem(id: "0", text: "Rested", isCompleted: true)),
                    PreparationFeature.ChecklistSlot(id: 1, item: ChecklistItem(id: "1", text: "Not hungry", isCompleted: true)),
                    PreparationFeature.ChecklistSlot(id: 2, item: ChecklistItem(id: "6", text: "Distractions closed", isCompleted: true)),
                    PreparationFeature.ChecklistSlot(id: 3, item: ChecklistItem(id: "9", text: "Mind centered", isCompleted: true))
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
                checklistSlots: [
                    PreparationFeature.ChecklistSlot(id: 0, item: ChecklistItem(id: "0", text: "Rested", isCompleted: true)),
                    PreparationFeature.ChecklistSlot(id: 1, item: ChecklistItem(id: "1", text: "Not hungry", isCompleted: true)),
                    PreparationFeature.ChecklistSlot(id: 2, item: ChecklistItem(id: "2", text: "Bathroom break", isCompleted: true)),
                    PreparationFeature.ChecklistSlot(id: 3, item: ChecklistItem(id: "3", text: "Phone on silent", isCompleted: true))
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