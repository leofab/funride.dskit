import SwiftUI

/// Represents the type of notification
public enum DSNotificationType {
    case `default`
    case info
    case error
    case warning
    case success
    
    /// Background color for the notification type
    var backgroundColor: Color {
        switch self {
        case .default:
            return DSTokens.Colors.notificationDefault
        case .info:
            return DSTokens.Colors.notificationInfo
        case .error:
            return DSTokens.Colors.notificationError
        case .warning:
            return DSTokens.Colors.notificationWarning
        case .success:
            return DSTokens.Colors.notificationSuccess
        }
    }
    
    /// Border color for the notification type
    var borderColor: Color {
        switch self {
        case .default:
            return DSTokens.Colors.notificationBorderDefault
        case .info:
            return DSTokens.Colors.notificationBorderInfo
        case .error:
            return DSTokens.Colors.notificationBorderError
        case .warning:
            return DSTokens.Colors.notificationBorderWarning
        case .success:
            return DSTokens.Colors.notificationBorderSuccess
        }
    }
    
    /// Icon name for the notification type (SF Symbols)
    var iconName: String {
        switch self {
        case .default:
            return "info.circle"
        case .info:
            return "info.circle"
        case .error:
            return "exclamationmark.circle"
        case .warning:
            return "exclamationmark.triangle"
        case .success:
            return "checkmark.circle"
        }
    }
    
    /// Icon color for the notification type
    var iconColor: Color {
        switch self {
        case .default:
            return DSTokens.Colors.notificationTextSecondary
        case .info:
            return DSTokens.Colors.notificationBorderInfo
        case .error:
            return DSTokens.Colors.notificationBorderError
        case .warning:
            return DSTokens.Colors.notificationBorderWarning
        case .success:
            return DSTokens.Colors.notificationBorderSuccess
        }
    }
}

/// Represents the style of notification
public enum DSNotificationStyle {
    case inline
    case toast
}

/// Represents an action button in a notification
public struct DSNotificationAction {
    public let title: String
    public let style: DSButtonStyle
    public let handler: () -> Void
    
    public init(title: String, style: DSButtonStyle = .secondary, handler: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}