import SwiftUI

/// Button style definitions for DSComboButton
public enum DSComboButtonStyle {
    case standard
    case collapsible
}

/// Interaction states for DSComboButton
public enum DSComboButtonState {
    case `default`
    case hover
    case active
    case focus
    case disabled
    
    /// Background color for the button state
    var backgroundColor: Color {
        switch self {
        case .default, .active, .focus:
            return DSTokens.Colors.comboButtonDefault
        case .hover:
            return DSTokens.Colors.comboButtonHover
        case .disabled:
            return DSTokens.Colors.comboButtonDisabled
        }
    }
    
    /// Border color for the button state
    var borderColor: Color {
        switch self {
        case .active, .focus:
            return DSTokens.Colors.comboButtonFocus
        case .default, .hover, .disabled:
            return Color.clear
        }
    }
    
    /// Border width for the button state
    var borderWidth: CGFloat {
        switch self {
        case .active, .focus:
            return DSTokens.Borders.widthThin
        case .default, .hover, .disabled:
            return 0
        }
    }
    
    /// Opacity for the button state
    var opacity: Double {
        switch self {
        case .disabled:
            return 0.5
        case .default, .hover, .active, .focus:
            return 1.0
        }
    }
}
