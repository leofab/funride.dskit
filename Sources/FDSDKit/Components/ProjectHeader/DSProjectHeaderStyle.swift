import SwiftUI

/// Configuration for a trailing action button in DSProjectHeader
public struct DSProjectHeaderAction: Identifiable {
    public let id = UUID()
    public let iconName: String
    public let action: () -> Void
    
    public init(iconName: String, action: @escaping () -> Void) {
        self.iconName = iconName
        self.action = action
    }
}
