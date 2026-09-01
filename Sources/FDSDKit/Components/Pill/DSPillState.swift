import SwiftUI

/// Visual state of the pill component
public enum DSPillState {
    case `default`   // Normal state, background #212426
    case hover       // Hover state, background #2e3434
    case focus       // Focus state, background #2e3434, border #7efff5
    
    /// Background color for the pill state
    var backgroundColor: Color {
        switch self {
        case .default:
            return DSTokens.Colors.pillDefaultBackground
        case .hover, .focus:
            return DSTokens.Colors.pillHoverBackground
        }
    }
    
    /// Border color for the pill state
    var borderColor: Color {
        switch self {
        case .default, .hover:
            return .clear
        case .focus:
            return DSTokens.Colors.pillFocusBorder
        }
    }
    
    /// Border width for the pill state
    var borderWidth: CGFloat {
        switch self {
        case .default, .hover:
            return 0
        case .focus:
            return DSTokens.Sizing.pillBorderWidth
        }
    }
}
