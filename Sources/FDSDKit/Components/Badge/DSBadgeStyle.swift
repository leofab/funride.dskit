import SwiftUI

/// Badge type definitions matching Penpot design system
public enum DSBadgeType {
    case `default`   // Neutral label, dark background, subtle border
    case error       // Error label, dark red background, red border
    case layers      // Layer indicator, dark background, cyan border/text
    
    /// Background color for the badge type
    var backgroundColor: Color {
        switch self {
        case .default:
            return DSTokens.Colors.badgeDefaultBackground
        case .error:
            return DSTokens.Colors.badgeErrorBackground
        case .layers:
            return DSTokens.Colors.badgeLayersBackground
        }
    }
    
    /// Border color for the badge type
    var borderColor: Color {
        switch self {
        case .default:
            return DSTokens.Colors.badgeDefaultBorder
        case .error:
            return DSTokens.Colors.badgeErrorBorder
        case .layers:
            return DSTokens.Colors.badgeLayersBorder
        }
    }
    
    /// Text color for the badge type
    var textColor: Color {
        switch self {
        case .default:
            return DSTokens.Colors.badgeDefaultText
        case .error:
            return DSTokens.Colors.badgeErrorText
        case .layers:
            return DSTokens.Colors.badgeLayersText
        }
    }
    
    /// Font size for the badge type
    var fontSize: CGFloat {
        switch self {
        case .default, .error:
            return DSTokens.Typography.badgeDefaultFontSize
        case .layers:
            return DSTokens.Typography.badgeLayersFontSize
        }
    }
    
    /// Border radius for the badge type
    var cornerRadius: CGFloat {
        switch self {
        case .default, .error:
            return DSTokens.Sizing.badgeDefaultRadius
        case .layers:
            return DSTokens.Sizing.badgeLayersRadius
        }
    }
    
    /// Horizontal padding for the badge type
    var horizontalPadding: CGFloat {
        switch self {
        case .default, .error:
            return DSTokens.Sizing.badgeHorizontalPadding
        case .layers:
            return DSTokens.Sizing.badgeLayersHorizontalPadding
        }
    }
    
    /// Vertical padding for the badge type
    var verticalPadding: CGFloat {
        switch self {
        case .default, .error:
            return DSTokens.Sizing.badgeVerticalPadding
        case .layers:
            return DSTokens.Sizing.badgeLayersVerticalPadding
        }
    }
}
