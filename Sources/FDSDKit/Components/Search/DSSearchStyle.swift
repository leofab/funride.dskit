import SwiftUI

/// Search input style definitions matching Penpot design system
public enum DSSearchStyle {
    case `default`
    case hover
    case active
    case focus
    case disabled
    
    /// Background color for the search style
    var backgroundColor: Color {
        switch self {
        case .default, .focus:
            return DSTokens.Colors.inputDefault
        case .hover:
            return DSTokens.Colors.inputHover
        case .active, .disabled:
            return DSTokens.Colors.inputActive
        }
    }
    
    /// Border color for the search style (nil for no border)
    var borderColor: Color? {
        switch self {
        case .active, .focus:
            return DSTokens.Colors.inputBorder
        default:
            return nil
        }
    }
    
    /// Border width for the search style
    var borderWidth: CGFloat {
        switch self {
        case .active, .focus:
            return DSTokens.Borders.widthThin
        default:
            return 0
        }
    }
    
    /// Text color for the search style
    var textColor: Color {
        switch self {
        case .disabled:
            return DSTokens.Colors.inputTextDisabled
        default:
            return DSTokens.Colors.inputText
        }
    }
    
    /// Placeholder color for the search style
    var placeholderColor: Color {
        return DSTokens.Colors.inputTextDisabled
    }
    
    /// Icon color for the search style
    var iconColor: Color {
        switch self {
        case .active, .focus:
            return DSTokens.Colors.inputText
        case .disabled:
            return Color(white: 0.35)
        default:
            return DSTokens.Colors.inputTextDisabled
        }
    }
    
    /// Opacity for the search style
    var opacity: Double {
        switch self {
        case .disabled:
            return 0.5
        default:
            return 1.0
        }
    }
}
