import SwiftUI

/// A tabbed interface component for navigating between multiple panels
public struct DSTabs: View {
    let items: [DSTabItem]
    @Binding var selectedIndex: Int
    let variant: DSTabsVariant
    var onSelection: ((Int) -> Void)?
    
    @State private var hoveredIndex: Int?
    
    /// Initialize tabs with items, selected index, variant, and optional callback
    public init(items: [DSTabItem],
                selectedIndex: Binding<Int>,
                variant: DSTabsVariant = .iconText,
                onSelection: ((Int) -> Void)? = nil) {
        self.items = items
        self._selectedIndex = selectedIndex
        self.variant = variant
        self.onSelection = onSelection
    }
    
    public var body: some View {
        HStack(spacing: DSTokens.Spacing.tabsItemGap) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                tabButton(item: item, index: index)
            }
        }
        .background(DSTokens.Colors.tabsContainerBackground)
        .clipShape(RoundedRectangle(cornerRadius: DSTokens.Sizing.tabsBorderRadius))
    }
    
    // MARK: - Private
    
    private func tabButton(item: DSTabItem, index: Int) -> some View {
        Button(action: {
            selectedIndex = index
            onSelection?(index)
        }) {
            HStack(spacing: DSTokens.Spacing.tabsIconTextGap) {
                if let iconName = item.icon, variant != .text {
                    Image(systemName: iconName)
                        .font(.system(size: DSTokens.Sizing.tabsIconSize))
                        .foregroundColor(currentStyle(for: index).textColor)
                }
                
                if variant != .icon {
                    Text(item.label)
                        .font(.system(size: DSTokens.Typography.tabsLabelSize,
                                      weight: DSTokens.Typography.tabsLabelWeight))
                        .foregroundColor(currentStyle(for: index).textColor)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
            }
            .padding(.horizontal, DSTokens.Spacing.tabsItemPaddingHorizontal)
            .padding(.vertical, DSTokens.Spacing.tabsItemPaddingVertical)
            .frame(minHeight: DSTokens.Sizing.tabsHeight)
            .background(currentStyle(for: index).backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: DSTokens.Sizing.tabsBorderRadius))
        }
        .buttonStyle(.plain)
        .onHover { isHovered in
            hoveredIndex = isHovered ? index : nil
        }
        .accessibilityLabel(Text(item.label))
        .accessibilityAddTraits(index == selectedIndex ? .isSelected : [])
    }
    
    private func currentStyle(for index: Int) -> DSTabsStyle {
        if index == selectedIndex {
            return .selected
        } else if index == hoveredIndex {
            return .hover
        } else {
            return .default
        }
    }
}

// MARK: - Preview
#if DEBUG
struct DSTabsDemoView: View {
    @State private var selectedIndex = 0
    
    let items = [
        DSTabItem(label: "Tab 1", icon: "house"),
        DSTabItem(label: "Tab 2", icon: "star"),
        DSTabItem(label: "Tab 3", icon: "gear")
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Icon + Text Variant")
                .font(.headline)
            DSTabs(items: items, selectedIndex: $selectedIndex, variant: .iconText) { index in
                print("Selected tab: \(index)")
            }
            
            Text("Text Only Variant")
                .font(.headline)
            DSTabs(items: items, selectedIndex: $selectedIndex, variant: .text)
            
            Text("Icon Only Variant")
                .font(.headline)
            DSTabs(items: items, selectedIndex: $selectedIndex, variant: .icon)
        }
        .padding()
        .background(Color.gray.opacity(0.3))
        .previewLayout(.sizeThatFits)
    }
}

struct DSTabs_Previews: PreviewProvider {
    static var previews: some View {
        DSTabsDemoView()
    }
}
#endif
