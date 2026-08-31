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
}

/// Individual accordion item view
struct DSAccordionItemView: View {
    @Binding var item: DSAccordionItem
    let isExpanded: Bool
    let onToggle: () -> Void
    
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
                    
                    // Title
                    Text(item.title)
                        .font(.system(
                            size: DSTokens.Typography.accordionTitleSize,
                            weight: DSTokens.Typography.accordionTitleWeight
                        ))
                        .foregroundColor(DSTokens.Colors.accordionHeaderText)
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
                .frame(height: DSTokens.Sizing.accordionHeaderHeight)
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
                    item.content
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

// MARK: - Preview
#if DEBUG
struct DSAccordion_Previews: PreviewProvider {
    static var previews: some View {
        DSAccordion(items: .constant([
            DSAccordionItem(title: "Section 1", icon: "star.fill") {
                Text("Content for section 1")
                    .foregroundColor(DSTokens.Colors.accordionHeaderText)
            },
            DSAccordionItem(title: "Section 2", isExpanded: true) {
                Text("Content for section 2")
                    .foregroundColor(DSTokens.Colors.accordionHeaderText)
            },
            DSAccordionItem(title: "Section 3 (Disabled)", isDisabled: true) {
                Text("This should not be visible")
            }
        ]))
        .padding()
        .background(Color.black)
    }
}
#endif
