import SwiftUI

/// A model representing a single accordion item
public struct DSAccordionItem: Identifiable {
    public let id: UUID
    public var title: String
    public var icon: String?
    public var isExpanded: Bool
    public var isDisabled: Bool
    public var selectedOption: String?
    public var content: AnyView
    public var onSelection: ((String) -> Void)?
    
    /// Creates an accordion item
    /// - Parameters:
    ///   - title: The title text displayed in the header
    ///   - icon: Optional SF Symbol name displayed before the title
    ///   - isExpanded: Whether the item starts expanded (default: false)
    ///   - isDisabled: Whether the item is interactive (default: false)
    ///   - selectedOption: The currently selected option text (displayed as subtitle)
    ///   - content: The view to display when expanded
    ///   - onSelection: Optional callback when content is selected (triggers accordion collapse)
    public init<Content: View>(
        title: String,
        icon: String? = nil,
        isExpanded: Bool = false,
        isDisabled: Bool = false,
        selectedOption: String? = nil,
        onSelection: ((String) -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.id = UUID()
        self.title = title
        self.icon = icon
        self.isExpanded = isExpanded
        self.isDisabled = isDisabled
        self.selectedOption = selectedOption
        self.onSelection = onSelection
        self.content = AnyView(content())
    }
}

/// Configuration for accordion behavior
public struct DSAccordionConfiguration {
    /// Whether multiple items can be expanded simultaneously
    public var allowsMultipleExpansion: Bool
    
    /// Whether at least one item must remain expanded
    public var requiresAtLeastOneExpanded: Bool
    
    /// Animation duration for expand/collapse
    public var animationDuration: Double
    
    public init(
        allowsMultipleExpansion: Bool = true,
        requiresAtLeastOneExpanded: Bool = false,
        animationDuration: Double = 0.2
    ) {
        self.allowsMultipleExpansion = allowsMultipleExpansion
        self.requiresAtLeastOneExpanded = requiresAtLeastOneExpanded
        self.animationDuration = animationDuration
    }
}
