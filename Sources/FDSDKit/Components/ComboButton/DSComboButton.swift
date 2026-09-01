import SwiftUI

/// A combo button component displaying an icon, labels, and trailing action icon
public struct DSComboButton: View {
    private let style: DSComboButtonStyle
    private let label: String
    private let sublabel: String
    private let leadingIcon: String?
    private let trailingIcon: String?
    private let isEnabled: Bool
    private let action: () -> Void
    
    @State private var isPressed = false
    @State private var isFocused = false
    
    /// Creates a combo button
    /// - Parameters:
    ///   - style: The button style (standard or collapsible)
    ///   - label: The primary label text
    ///   - sublabel: The secondary label text
    ///   - leadingIcon: Optional SF Symbol name for the leading icon
    ///   - trailingIcon: Optional SF Symbol name for the trailing icon
    ///   - isEnabled: Whether the button is enabled (default: true)
    ///   - action: The action to execute on tap
    public init(
        _ style: DSComboButtonStyle = .standard,
        label: String,
        sublabel: String,
        leadingIcon: String? = nil,
        trailingIcon: String? = nil,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.style = style
        self.label = label
        self.sublabel = sublabel
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.isEnabled = isEnabled
        self.action = action
    }
    
    private var currentState: DSComboButtonState {
        if !isEnabled { return .disabled }
        if isFocused { return .focus }
        if isPressed { return .active }
        return .default
    }
    
    public var body: some View {
        Button(action: {
            guard isEnabled else { return }
            #if canImport(UIKit)
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            #endif
            action()
        }) {
            HStack(spacing: 0) {
                if style == .collapsible {
                    collapsibleLeadingButton
                }
                
                mainContent
            }
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isEnabled)
        .opacity(currentState.opacity)
        .background(currentState.backgroundColor)
        .cornerRadius(DSTokens.Sizing.comboButtonRadius)
        .overlay(
            RoundedRectangle(cornerRadius: DSTokens.Sizing.comboButtonRadius)
                .stroke(currentState.borderColor, lineWidth: currentState.borderWidth)
        )
        .frame(width: DSTokens.Sizing.comboButtonWidth, height: DSTokens.Sizing.comboButtonHeight)
        .onLongPressGesture(minimumDuration: 0,
                            pressing: { pressing in
            guard isEnabled else { return }
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label), \(sublabel)")
        .accessibilityHint(trailingIcon != nil ? "Double tap to activate" : "")
        .disabled(!isEnabled)
    }
    
    private var collapsibleLeadingButton: some View {
        Image(systemName: "gearshape")
            .resizable()
            .scaledToFit()
            .frame(width: DSTokens.Sizing.comboButtonIconSize,
                   height: DSTokens.Sizing.comboButtonIconSize)
            .foregroundColor(DSTokens.Colors.comboButtonText)
            .frame(width: DSTokens.Sizing.comboButtonHeight,
                   height: DSTokens.Sizing.comboButtonHeight)
    }
    
    private var mainContent: some View {
        HStack(spacing: DSTokens.Spacing.comboButtonIconGap) {
            if let iconName = leadingIcon {
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: DSTokens.Sizing.comboButtonIconSize,
                           height: DSTokens.Sizing.comboButtonIconSize)
                    .foregroundColor(DSTokens.Colors.comboButtonText)
            }
            
            textBlock
            
            Spacer()
            
            if let iconName = trailingIcon {
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: DSTokens.Sizing.comboButtonIconSize,
                           height: DSTokens.Sizing.comboButtonIconSize)
                    .foregroundColor(DSTokens.Colors.comboButtonText)
            }
        }
        .padding(.horizontal, DSTokens.Spacing.sm)
        .padding(.vertical, DSTokens.Spacing.sm)
    }
    
    private var textBlock: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(label)
                .font(.system(size: DSTokens.Typography.comboButtonLabelSize,
                              weight: DSTokens.Typography.comboButtonLabelWeight))
                .foregroundColor(DSTokens.Colors.comboButtonText)
            
            Text(sublabel)
                .font(.system(size: DSTokens.Typography.comboButtonLabelSize,
                              weight: DSTokens.Typography.comboButtonLabelWeight))
                .foregroundColor(DSTokens.Colors.comboButtonSubtext)
        }
    }
}

// MARK: - Preview
#if DEBUG
struct DSComboButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            DSComboButton(.standard,
                          label: "Label",
                          sublabel: "Label",
                          leadingIcon: "sparkle",
                          trailingIcon: "minus") {
                print("Standard tapped")
            }
            
            DSComboButton(.collapsible,
                          label: "Label",
                          sublabel: "Label",
                          leadingIcon: "sparkle",
                          trailingIcon: "minus") {
                print("Collapsible tapped")
            }
            
            DSComboButton(.standard,
                          label: "Label",
                          sublabel: "Label",
                          leadingIcon: "sparkle",
                          trailingIcon: "minus",
                          isEnabled: false) {
                print("Disabled tapped")
            }
        }
        .padding()
        .background(Color.black)
    }
}
#endif
