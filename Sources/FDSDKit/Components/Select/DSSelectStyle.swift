import SwiftUI

/// Select style definitions matching Penpot design system
public enum DSSelectStyle {
    case `default`
    case hover
    case focus
    case disabled
    
    /// Background color for the select style
    var backgroundColor: Color {
        switch self {
        case .default, .focus:
            return DSTokens.Colors.selectDefault
        case .hover:
            return DSTokens.Colors.selectHover
        case .disabled:
            return DSTokens.Colors.selectDisabled
        }
    }
    
    /// Border color for the select style (nil for no border)
    var borderColor: Color? {
        switch self {
        case .focus:
            return DSTokens.Colors.selectBorder
        default:
            return nil
        }
    }
    
    /// Border width for the select style
    var borderWidth: CGFloat {
        switch self {
        case .focus:
            return DSTokens.Borders.widthThin
        default:
            return 0
        }
    }
    
    /// Text color for the select style
    var textColor: Color {
        switch self {
        case .disabled:
            return DSTokens.Colors.selectTextDisabled
        default:
            return DSTokens.Colors.selectText
        }
    }
    
    /// Placeholder color for the select style
    var placeholderColor: Color {
        return DSTokens.Colors.selectTextDisabled
    }
    
    /// Chevron color for the select style
    var chevronColor: Color {
        switch self {
        case .disabled:
            return DSTokens.Colors.selectTextDisabled
        default:
            return DSTokens.Colors.selectText
        }
    }
    
    /// Opacity for the select style
    var opacity: Double {
        switch self {
        case .disabled:
            return 0.5
        default:
            return 1.0
        }
    }
}
