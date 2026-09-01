import SwiftUI

/// Pagination style definitions matching Penpot design system
public enum DSPaginationStyle: CaseIterable {
    case dark
    
    /// Background color for the pagination style
    var backgroundColor: Color {
        switch self {
        case .dark:
            return DSTokens.Colors.paginationBackground
        }
    }
    
    /// Border color for the pagination style
    var borderColor: Color {
        switch self {
        case .dark:
            return DSTokens.Colors.paginationBorder
        }
    }
    
    /// Text color for page numbers
    var textColor: Color {
        switch self {
        case .dark:
            return DSTokens.Colors.paginationText
        }
    }
    
    /// Icon color for navigation arrows
    var iconColor: Color {
        switch self {
        case .dark:
            return DSTokens.Colors.paginationIcon
        }
    }
    
    /// Background color for disabled state
    var disabledBackgroundColor: Color {
        switch self {
        case .dark:
            return DSTokens.Colors.paginationBackground
        }
    }
    
    /// Opacity for disabled state
    var disabledOpacity: Double {
        switch self {
        case .dark:
            return 0.5
        }
    }
}
