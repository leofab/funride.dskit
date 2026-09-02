import SwiftUI

/// Visual state of the tabs component
public enum DSTabsStyle {
    case `default`
    case hover
    case selected
    
    /// Background color for the tab state
    var backgroundColor: Color {
        switch self {
        case .default:
            return DSTokens.Colors.tabsDefaultBackground
        case .hover, .selected:
            return DSTokens.Colors.tabsSelectedBackground
        }
    }
    
    /// Text color for the tab state
    var textColor: Color {
        switch self {
        case .default, .hover, .selected:
            return DSTokens.Colors.tabsText
        }
    }
}
