import SwiftUI

/// A reusable button component based on Penpot design system
public struct DSButton: View {
    let style: DSButtonStyle
    let icon: String?
    let label: String
    let action: () -> Void
    
    @State private var isPressed = false
    
    public init(_ style: DSButtonStyle = .primary,
                icon: String? = nil,
                label: String,
                action: @escaping () -> Void) {
        self.style = style
        self.icon = icon
        self.label = label
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            #if canImport(UIKit)
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            #endif
            action()
        }) {
            HStack(spacing: DSTokens.Spacing.buttonIconTextGap) {
                if let iconName = icon {
                    Image(systemName: iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: DSTokens.Sizing.iconSize,
                               height: DSTokens.Sizing.iconSize)
                }
                
                Text(label)
                    .font(.system(size: DSTokens.Typography.buttonSize,
                                  weight: DSTokens.Typography.buttonWeight))
            }
            .foregroundColor(style.foregroundColor)
            .frame(minWidth: DSTokens.Sizing.buttonMinWidth,
                   minHeight: DSTokens.Sizing.buttonHeight)
            .background(style.backgroundColor)
            .cornerRadius(DSTokens.Borders.radiusMedium)
            .overlay(
                RoundedRectangle(cornerRadius: DSTokens.Borders.radiusMedium)
                    .stroke(style.borderColor ?? Color.clear,
                            lineWidth: style.borderWidth)
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .opacity(isPressed ? 0.8 : 1.0)
        }
        .onLongPressGesture(minimumDuration: 0,
                            pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

// MARK: - Preview
#if DEBUG
struct DSButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            DSButton(.primary, icon: "star.fill", label: "Primary") {}
            DSButton(.secondary, label: "Secondary") {}
            DSButton(.ghost, label: "Ghost") {}
            DSButton(.destructive, icon: "trash", label: "Delete") {}
        }
        .padding()
        .background(Color.gray.opacity(0.1))
    }
}
#endif
