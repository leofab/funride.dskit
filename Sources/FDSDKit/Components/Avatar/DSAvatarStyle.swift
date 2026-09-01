import SwiftUI

/// Avatar size definitions matching Penpot design system
public enum DSAvatarSize {
    case small    // 24pt - workspace active users, dashboard dropdowns
    case medium   // 32pt - comment popups
    case large    // 40pt - user account menu
    
    /// Dimension in points for the avatar
    var dimension: CGFloat {
        switch self {
        case .small:
            return DSTokens.Sizing.avatarSmall
        case .medium:
            return DSTokens.Sizing.avatarMedium
        case .large:
            return DSTokens.Sizing.avatarLarge
        }
    }
    
    /// Font size for initials text
    var fontSize: CGFloat {
        switch self {
        case .small:
            return DSTokens.Typography.avatarSmallFontSize
        case .medium:
            return DSTokens.Typography.avatarMediumFontSize
        case .large:
            return DSTokens.Typography.avatarLargeFontSize
        }
    }
}

/// Avatar state definitions matching Penpot design system
public enum DSAvatarState {
    case `default`
    case hover
    case selected
    case focus
    
    /// Background color for the avatar state
    var backgroundColor: Color? {
        switch self {
        case .hover:
            return DSTokens.Colors.avatarHover
        case .default, .selected, .focus:
            return nil
        }
    }
    
    /// Border color for the avatar state
    var borderColor: Color? {
        switch self {
        case .selected, .focus:
            return DSTokens.Colors.avatarBorderSelected
        case .default, .hover:
            return nil
        }
    }
    
    /// Border width for the avatar state
    var borderWidth: CGFloat {
        switch self {
        case .selected, .focus:
            return DSTokens.Sizing.avatarBorderWidth
        case .default, .hover:
            return 0
        }
    }
}

/// Avatar type definitions
public enum DSAvatarType {
    case initials
    case image
}

/// Avatar color palette for initials background
public enum DSAvatarColor {
    static let palette: [Color] = [
        DSTokens.Colors.avatarPink,
        DSTokens.Colors.avatarBlue,
        DSTokens.Colors.avatarGreen,
        DSTokens.Colors.avatarYellow,
        DSTokens.Colors.avatarPurple,
        DSTokens.Colors.avatarOrange
    ]
    
    /// Get a deterministic color based on a name string
    static func color(for name: String) -> Color {
        let hash = abs(name.hashValue)
        let index = hash % palette.count
        return palette[index]
    }
}

/// Helper for extracting initials from a name
public struct DSAvatarInitials {
    /// Extract initials from a full name (max 2 characters)
    public static func extract(from name: String) -> String {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return "?" }
        
        let components = trimmed.components(separatedBy: .whitespaces)
            .filter { !$0.isEmpty }
        
        switch components.count {
        case 0:
            return "?"
        case 1:
            return String(components[0].prefix(1)).uppercased()
        default:
            let first = String(components[0].prefix(1))
            let last = String(components[components.count - 1].prefix(1))
            return (first + last).uppercased()
        }
    }
}
