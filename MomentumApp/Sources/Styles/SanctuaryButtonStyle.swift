import SwiftUI

struct SanctuaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    @State private var isHovered = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.sanctuaryButtonFont)
            .foregroundStyle(isEnabled ? Color.textPrimary : Color.disabledText)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(isEnabled ? Color.white : Color.disabledBackground)
            )
            .overlay(
                Capsule()
                    .stroke(
                        isEnabled ? Color.accentGold : Color.disabledBorder,
                        lineWidth: 2
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .shadow(
                color: isEnabled && isHovered ? Color.accentGold.opacity(0.3) : Color.clear,
                radius: isEnabled && isHovered ? 4 : 0,
                x: 0,
                y: isEnabled && isHovered ? 2 : 0
            )
            .onHover { hovering in
                isHovered = hovering
            }
            .animation(.interactiveSpring(duration: 0.15), value: isHovered)
            .animation(.interactiveSpring(duration: 0.15), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == SanctuaryButtonStyle {
    static var sanctuary: SanctuaryButtonStyle {
        SanctuaryButtonStyle()
    }
}