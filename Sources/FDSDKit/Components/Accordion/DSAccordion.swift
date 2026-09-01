import SwiftUI

/// A vertical stack of collapsible items for displaying expandable content
public struct DSAccordion: View {
    @Binding public var items: [DSAccordionItem]
    public let configuration: DSAccordionConfiguration
    
    @State private var expandedIndices: Set<Int> = []
    
    /// Creates an accordion with items and configuration
    /// - Parameters:
    ///   - items: Binding to array of accordion items
    ///   - configuration: Accordion behavior configuration
    public init(
        items: Binding<[DSAccordionItem]>,
        configuration: DSAccordionConfiguration = DSAccordionConfiguration()
    ) {
        self._items = items
        self.configuration = configuration
    }
    
    public var body: some View {
        VStack(spacing: DSTokens.Spacing.accordionItemGap) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                DSAccordionItemView(
                    item: $items[index],
                    isExpanded: expandedIndices.contains(index),
                    onToggle: {
                        toggleItem(at: index)
                    },
                    onSelection: { option in
                        selectOption(at: index, option: option)
                    }
                )
            }
        }
        .onAppear {
            initializeExpandedState()
        }
    }
    
    private func initializeExpandedState() {
        for (index, item) in items.enumerated() {
            if item.isExpanded {
                expandedIndices.insert(index)
            }
        }
    }
    
    private func toggleItem(at index: Int) {
        guard !items[index].isDisabled else { return }
        
        withAnimation(.easeInOut(duration: configuration.animationDuration)) {
            if expandedIndices.contains(index) {
                // Check if we can collapse this item
                if configuration.requiresAtLeastOneExpanded && expandedIndices.count == 1 {
                    return
                }
                expandedIndices.remove(index)
                items[index].isExpanded = false
            } else {
                // Check if we can expand this item
                if !configuration.allowsMultipleExpansion {
                    expandedIndices.removeAll()
                    for i in items.indices {
                        items[i].isExpanded = false
                    }
                }
                expandedIndices.insert(index)
                items[index].isExpanded = true
            }
        }
    }
    
    private func selectOption(at index: Int, option: String) {
        // First update the selected option (this will trigger view refresh)
        items[index].selectedOption = option
        items[index].onSelection?(option)
        
        // Then collapse after a brief delay to allow subtitle to render
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeInOut(duration: self.configuration.animationDuration)) {
                self.expandedIndices.remove(index)
                self.items[index].isExpanded = false
            }
        }
    }
}

/// Individual accordion item view
struct DSAccordionItemView: View {
    @Binding var item: DSAccordionItem
    let isExpanded: Bool
    let onToggle: () -> Void
    let onSelection: (String) -> Void
    
    @State private var isHovered = false
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Button(action: onToggle) {
                HStack(spacing: DSTokens.Spacing.xs) {
                    // Icon
                    if let iconName = item.icon {
                        Image(systemName: iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(
                                width: DSTokens.Sizing.accordionIconSize,
                                height: DSTokens.Sizing.accordionIconSize
                            )
                            .foregroundColor(DSTokens.Colors.accordionHeaderText)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        // Title
                        Text(item.title)
                            .font(.system(
                                size: DSTokens.Typography.accordionTitleSize,
                                weight: DSTokens.Typography.accordionTitleWeight
                            ))
                            .foregroundColor(DSTokens.Colors.accordionHeaderText)
                        
                        // Selected option subtitle
                        if let selectedOption = item.selectedOption {
                            Text(selectedOption)
                                .font(.system(
                                    size: DSTokens.Typography.accordionTitleSize - 1,
                                    weight: .regular
                                ))
                                .foregroundColor(DSTokens.Colors.accordionSubtext)
                                .lineLimit(1)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    // Chevron
                    Image(systemName: "chevron.right")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12, height: 12)
                        .foregroundColor(DSTokens.Colors.accordionSubtext)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .animation(.easeInOut(duration: 0.2), value: isExpanded)
                }
                .padding(.horizontal, DSTokens.Spacing.accordionHeaderPadding)
                .frame(minHeight: DSTokens.Sizing.accordionHeaderHeight)
                .background(headerBackgroundColor)
                .cornerRadius(DSTokens.Sizing.accordionItemRadius)
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(item.isDisabled)
            .opacity(item.isDisabled ? 0.5 : 1.0)
            .onHover { hovering in
                isHovered = hovering
            }
            
            // Content
            if isExpanded {
                VStack(spacing: 0) {
                    DSAccordionContentView(
                        content: item.content,
                        onSelection: { option in
                            onSelection(option)
                        }
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(DSTokens.Spacing.accordionContentPadding)
                }
                .background(DSTokens.Colors.accordionBackground)
                .cornerRadius(DSTokens.Sizing.accordionItemRadius)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
    
    private var headerBackgroundColor: Color {
        if item.isDisabled {
            return DSTokens.Colors.accordionBackground
        } else if isPressed {
            return DSTokens.Colors.accordionHover
        } else if isHovered {
            return DSTokens.Colors.accordionHover
        } else {
            return DSTokens.Colors.accordionBackground
        }
    }
}

/// Wrapper view for accordion content that provides selection handling
struct DSAccordionContentView: View {
    let content: AnyView
    let onSelection: (String) -> Void
    
    var body: some View {
        content
            .environment(\.accordionSelectionHandler, onSelection)
    }
}

/// Environment key for accordion selection handler
private struct AccordionSelectionHandlerKey: EnvironmentKey {
    static let defaultValue: (String) -> Void = { _ in }
}

extension EnvironmentValues {
    var accordionSelectionHandler: (String) -> Void {
        get { self[AccordionSelectionHandlerKey.self] }
        set { self[AccordionSelectionHandlerKey.self] = newValue }
    }
}

/// View modifier for creating selectable items in accordion content
struct AccordionSelectableItemModifier: ViewModifier {
    let option: String
    @Environment(\.accordionSelectionHandler) var selectionHandler
    
    func body(content: Content) -> some View {
        Button(action: {
            selectionHandler(option)
        }) {
            content
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

extension View {
    /// Makes this view selectable within an accordion
    func accordionSelectable(_ option: String) -> some View {
        modifier(AccordionSelectableItemModifier(option: option))
    }
}

// MARK: - Preview
#if DEBUG
struct DSAccordion_Previews: PreviewProvider {
    static var previews: some View {
        DSAccordionPreview()
    }
}

struct DSAccordionPreview: View {
    @State private var items: [DSAccordionItem] = [
        DSAccordionItem(title: "Account Settings", icon: "person.fill") {
            VStack(alignment: .leading, spacing: 12) {
                Text("Edit Profile")
                    .accordionSelectable("Edit Profile")
                    .foregroundColor(DSTokens.Colors.accordionHeaderText)
                
                Text("Change Password")
                    .accordionSelectable("Change Password")
                    .foregroundColor(DSTokens.Colors.accordionHeaderText)
                
                Text("Notification Preferences")
                    .accordionSelectable("Notification Preferences")
                    .foregroundColor(DSTokens.Colors.accordionHeaderText)
            }
        },
        DSAccordionItem(title: "Payment Methods", icon: "creditcard.fill", isExpanded: true) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Credit Card ending in 1234")
                    .accordionSelectable("Credit Card ending in 1234")
                    .foregroundColor(DSTokens.Colors.accordionHeaderText)
                
                Text("PayPal Account")
                    .accordionSelectable("PayPal Account")
                    .foregroundColor(DSTokens.Colors.accordionHeaderText)
                
                Text("Apple Pay")
                    .accordionSelectable("Apple Pay")
                    .foregroundColor(DSTokens.Colors.accordionHeaderText)
                
                Text("Add New Payment Method")
                    .accordionSelectable("Add New Payment Method")
                    .foregroundColor(DSTokens.Colors.accordionHeaderText)
            }
        },
        DSAccordionItem(title: "Shipping Address", icon: "map.fill") {
            VStack(alignment: .leading, spacing: 12) {
                Text("Home - 123 Main St, City, State 12345")
                    .accordionSelectable("Home - 123 Main St, City, State 12345")
                    .foregroundColor(DSTokens.Colors.accordionHeaderText)
                
                Text("Work - 456 Office Blvd, Suite 100")
                    .accordionSelectable("Work - 456 Office Blvd, Suite 100")
                    .foregroundColor(DSTokens.Colors.accordionHeaderText)
                
                Text("Add New Address")
                    .accordionSelectable("Add New Address")
                    .foregroundColor(DSTokens.Colors.accordionHeaderText)
            }
        },
        DSAccordionItem(title: "Order History", icon: "clock.fill") {
            VStack(alignment: .leading, spacing: 12) {
                Text("Order #12345 - $99.99")
                    .accordionSelectable("Order #12345 - $99.99")
                    .foregroundColor(DSTokens.Colors.accordionHeaderText)
                
                Text("Order #12346 - $149.99")
                    .accordionSelectable("Order #12346 - $149.99")
                    .foregroundColor(DSTokens.Colors.accordionHeaderText)
                
                Text("Order #12347 - $79.99")
                    .accordionSelectable("Order #12347 - $79.99")
                    .foregroundColor(DSTokens.Colors.accordionHeaderText)
            }
        },
        DSAccordionItem(title: "Help & Support", icon: "questionmark.circle.fill", isDisabled: true) {
            Text("This section is currently unavailable")
                .foregroundColor(DSTokens.Colors.accordionHeaderText)
        }
    ]
    
    var body: some View {
        DSAccordion(items: $items)
            .padding()
            .background(Color.black)
    }
}
#endif
