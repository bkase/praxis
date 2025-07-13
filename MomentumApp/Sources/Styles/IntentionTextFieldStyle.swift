import SwiftUI

struct IntentionTextFieldStyle: TextFieldStyle {
    @FocusState private var isFocused: Bool
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .textFieldStyle(.plain)
            .font(.intentionField)
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .frame(height: 44)
            .background(isFocused ? Color.hoverFill : Color.clear)
            .cornerRadius(3)
            .overlay(
                RoundedRectangle(cornerRadius: 3)
                    .stroke(Color.accentGold, lineWidth: 1)
            )
            .shadow(
                color: isFocused ? Color.accentGold.opacity(0.3) : Color.clear,
                radius: isFocused ? 2 : 0,
                x: 0,
                y: 0
            )
            .focused($isFocused)
            .animation(.interactiveSpring(duration: 0.2), value: isFocused)
    }
}

extension TextFieldStyle where Self == IntentionTextFieldStyle {
    static var intention: IntentionTextFieldStyle {
        IntentionTextFieldStyle()
    }
}