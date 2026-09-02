import SwiftUI

/// Data model for a single tab item
public struct DSTabItem: Identifiable, Equatable {
    public let id: UUID
    public let label: String
    public let icon: String?
    
    /// Initialize a tab item with label and optional icon
    public init(id: UUID = UUID(), label: String, icon: String? = nil) {
        self.id = id
        self.label = label
        self.icon = icon
    }
}
