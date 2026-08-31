import SwiftUI

/// Button style definitions matching Penpot design system
public enum DSButtonStyle {
    case primary
    case secondary
    case ghost
    case destructive
    
    /// Background color for the button style
    var backgroundColor: Color {
        switch self {
        case .primary:
            return DSTokens.Colors.buttonPrimaryDefault
        case .secondary:
            return Color.clear
        case .ghost:
            return Color.clear
        case .destructive:
            return DSTokens.Colors.error
        }
    }
    
    /// Foreground (text/icon) color for the button style
    var foregroundColor: Color {
        switch self {
        case .primary:
            return DSTokens.Colors.buttonText
        case .secondary:
            return DSTokens.Colors.primary
        case .ghost:
            return DSTokens.Colors.primary
        case .destructive:
            return Color.white
        }
    }
    
    /// Border color for outlined styles
    var borderColor: Color? {
        switch self {
        case .secondary:
            return DSTokens.Colors.primary
        default:
            return nil
        }
    }
    
    /// Border width for the button style
    var borderWidth: CGFloat {
        switch self {
        case .secondary:
            return DSTokens.Borders.widthThin
        default:
            return 0
        }
    }
}
