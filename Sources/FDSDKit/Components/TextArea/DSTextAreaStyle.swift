import SwiftUI

/// TextArea style definitions matching Penpot design system
public enum DSTextAreaStyle {
    case empty
    case `default`
    case hover
    case active
    case focus
    case disabled
    case success
    case error
    
    /// Background color for the text area style
    var backgroundColor: Color {
        switch self {
        case .empty, .default:
            return DSTokens.Colors.textAreaDefault
        case .hover, .focus, .success, .error:
            return DSTokens.Colors.textAreaHover
        case .active:
            return DSTokens.Colors.textAreaActive
        case .disabled:
            return DSTokens.Colors.textAreaDisabled
        }
    }
    
    /// Border color for the text area style (nil for no border)
    var borderColor: Color? {
        switch self {
        case .active, .focus:
            return DSTokens.Colors.textAreaBorderFocus
        case .success:
            return DSTokens.Colors.textAreaBorderSuccess
        case .error:
            return DSTokens.Colors.textAreaBorderError
        case .disabled:
            return DSTokens.Colors.textAreaBorderDisabled
        default:
            return nil
        }
    }
    
    /// Border width for the text area style
    var borderWidth: CGFloat {
        switch self {
        case .active, .focus, .disabled, .success, .error:
            return DSTokens.Borders.widthThin
        default:
            return 0
        }
    }
    
    /// Text color for the text area style
    var textColor: Color {
        switch self {
        case .empty, .disabled:
            return DSTokens.Colors.textAreaTextPlaceholder
        default:
            return DSTokens.Colors.textAreaText
        }
    }
    
    /// Placeholder color for the text area style
    var placeholderColor: Color {
        return DSTokens.Colors.textAreaTextPlaceholder
    }
    
    /// Opacity for the text area style
    var opacity: Double {
        switch self {
        case .disabled:
            return 0.5
        default:
            return 1.0
        }
    }
}
