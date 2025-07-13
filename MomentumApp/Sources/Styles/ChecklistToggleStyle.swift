import SwiftUI

struct ChecklistToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 2)
                .fill(configuration.isOn ? Color.checkboxFill : Color.clear)
                .frame(width: 16, height: 16)
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(configuration.isOn ? Color.checkboxFill : Color.borderNeutral, lineWidth: 1)
                )
                .overlay(
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .opacity(configuration.isOn ? 1 : 0)
                        .scaleEffect(configuration.isOn ? 1 : 0.5)
                )
                .animation(.interactiveSpring(duration: 0.2), value: configuration.isOn)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            
            configuration.label
                .font(.checklistItem)
                .foregroundStyle(configuration.isOn ? Color.textSecondary : Color.textPrimary)
                .strikethrough(configuration.isOn, color: Color.textSecondary)
                .animation(.interactiveSpring(duration: 0.2), value: configuration.isOn)
            
            Spacer()
        }
    }
}

extension ToggleStyle where Self == ChecklistToggleStyle {
    static var checklist: ChecklistToggleStyle {
        ChecklistToggleStyle()
    }
}