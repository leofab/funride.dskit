import SwiftUI

/// Input style definitions matching Penpot design system
public enum DSInputStyle {
    case `default`
    case hover
    case active
    case focus
    case disabled
    case placeholder
    
    /// Background color for the input style
    var backgroundColor: Color {
        switch self {
        case .default, .focus, .placeholder:
            return DSTokens.Colors.inputDefault
        case .hover:
            return DSTokens.Colors.inputHover
        case .active, .disabled:
            return DSTokens.Colors.inputActive
        }
    }
    
    /// Border color for the input style (nil for no border)
    var borderColor: Color? {
        switch self {
        case .active, .focus:
            return DSTokens.Colors.inputBorder
        default:
            return nil
        }
    }
    
    /// Border width for the input style
    var borderWidth: CGFloat {
        switch self {
        case .active, .focus:
            return DSTokens.Borders.widthThin
        default:
            return 0
        }
    }
    
    /// Text color for the input style
    var textColor: Color {
        switch self {
        case .disabled:
            return DSTokens.Colors.inputTextDisabled
        case .placeholder:
            return DSTokens.Colors.inputTextPlaceholder
        default:
            return DSTokens.Colors.inputText
        }
    }
    
    /// Placeholder color for the input style
    var placeholderColor: Color {
        return DSTokens.Colors.inputTextPlaceholder
    }
    
    /// Opacity for the input style
    var opacity: Double {
        switch self {
        case .disabled:
            return 0.5
        default:
            return 1.0
        }
    }
}
