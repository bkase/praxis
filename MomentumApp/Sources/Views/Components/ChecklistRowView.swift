import SwiftUI

struct ChecklistRowView: View {
    let item: ChecklistItem
    let onToggle: () -> Void
    
    var body: some View {
        Toggle(
            item.text,
            isOn: .init(
                get: { item.isCompleted },
                set: { _ in onToggle() }
            )
        )
        .toggleStyle(.checklist)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(item.isCompleted ? Color.completedRowBackground : Color.white)
        .cornerRadius(3)
        .overlay(
            RoundedRectangle(cornerRadius: 3)
                .stroke(item.isCompleted ? Color.accentGold : Color.borderNeutral, lineWidth: 1)
        )
        .animation(.interactiveSpring(duration: 0.2), value: item.isCompleted)
    }
}