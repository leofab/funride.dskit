import XCTest
import SwiftUI
@testable import FDSDKit

final class DSTabsTests: XCTestCase {
    
    // MARK: - Style Tests
    
    func testDefaultStyleProperties() {
        let style = DSTabsStyle.default
        XCTAssertEqual(style.backgroundColor, DSTokens.Colors.tabsDefaultBackground)
        XCTAssertEqual(style.textColor, DSTokens.Colors.tabsText)
    }
    
    func testHoverStyleProperties() {
        let style = DSTabsStyle.hover
        XCTAssertEqual(style.backgroundColor, DSTokens.Colors.tabsSelectedBackground)
        XCTAssertEqual(style.textColor, DSTokens.Colors.tabsText)
    }
    
    func testSelectedStyleProperties() {
        let style = DSTabsStyle.selected
        XCTAssertEqual(style.backgroundColor, DSTokens.Colors.tabsSelectedBackground)
        XCTAssertEqual(style.textColor, DSTokens.Colors.tabsText)
    }
    
    // MARK: - TabItem Tests
    
    func testTabItemInitialization() {
        let item = DSTabItem(label: "Home", icon: "house")
        XCTAssertEqual(item.label, "Home")
        XCTAssertEqual(item.icon, "house")
        XCTAssertNotNil(item.id)
    }
    
    func testTabItemEquality() {
        let id = UUID()
        let item1 = DSTabItem(id: id, label: "Tab")
        let item2 = DSTabItem(id: id, label: "Tab")
        XCTAssertEqual(item1, item2)
    }
    
    func testTabItemWithoutIcon() {
        let item = DSTabItem(label: "Settings")
        XCTAssertNil(item.icon)
    }
    
    // MARK: - Token Tests
    
    func testTabsTokensExist() {
        // Colors
        XCTAssertEqual(DSTokens.Colors.tabsDefaultBackground, .clear)
        XCTAssertEqual(DSTokens.Colors.tabsSelectedBackground, Color(hex: "#2e3434"))
        XCTAssertEqual(DSTokens.Colors.tabsHoverBackground, Color(hex: "#2e3434"))
        XCTAssertEqual(DSTokens.Colors.tabsText, .white)
        XCTAssertEqual(DSTokens.Colors.tabsTextMuted, Color(hex: "#8f9da3"))
        XCTAssertEqual(DSTokens.Colors.tabsContainerBackground, Color(hex: "#000000"))
        
        // Sizing
        XCTAssertEqual(DSTokens.Sizing.tabsHeight, 32)
        XCTAssertEqual(DSTokens.Sizing.tabsBorderRadius, 8)
        XCTAssertEqual(DSTokens.Sizing.tabsIconSize, 16)
        
        // Spacing
        XCTAssertEqual(DSTokens.Spacing.tabsItemPaddingHorizontal, 12)
        XCTAssertEqual(DSTokens.Spacing.tabsItemPaddingVertical, 8)
        XCTAssertEqual(DSTokens.Spacing.tabsIconTextGap, 4)
        XCTAssertEqual(DSTokens.Spacing.tabsItemGap, 16)
        
        // Typography
        XCTAssertEqual(DSTokens.Typography.tabsLabelSize, 12)
        XCTAssertEqual(DSTokens.Typography.tabsLabelWeight, .regular)
    }
    
    // MARK: - Variant Tests
    
    func testTabVariants() {
        let iconText = DSTabsVariant.iconText
        let text = DSTabsVariant.text
        let icon = DSTabsVariant.icon
        
        XCTAssertNotNil(iconText)
        XCTAssertNotNil(text)
        XCTAssertNotNil(icon)
    }
    
    // MARK: - Edge Case Tests
    
    func testEmptyItemsArray() {
        let tabs = DSTabs(items: [], selectedIndex: .constant(0))
        XCTAssertTrue(tabs.items.isEmpty)
    }
    
    func testSingleTab() {
        let items = [DSTabItem(label: "Only Tab")]
        let tabs = DSTabs(items: items, selectedIndex: .constant(0))
        XCTAssertEqual(tabs.items.count, 1)
    }
    
    func testSelectedIndexBinding() {
        @State var selectedIndex = 0
        let binding = Binding.constant(selectedIndex)
        let tabs = DSTabs(items: [DSTabItem(label: "Tab")], selectedIndex: binding)
        XCTAssertEqual(tabs.items.count, 1)
    }
    
    // MARK: - Callback Tests (UIKit)
    
    #if canImport(UIKit)
    func testUIKitTabsSelectionCallback() {
        var selectedIndex = 0
        var callbackInvoked = false
        
        let tabs = DSTabsUIKit(
            items: [DSTabItem(label: "Tab 1"), DSTabItem(label: "Tab 2")],
            selectedIndex: 0,
            onSelection: { index in
                selectedIndex = index
                callbackInvoked = true
            }
        )
        
        tabs.onSelection?(1)
        
        XCTAssertTrue(callbackInvoked)
        XCTAssertEqual(selectedIndex, 1)
    }
    
    func testUIKitTabsSetSelectedIndex() {
        let tabs = DSTabsUIKit(
            items: [DSTabItem(label: "Tab 1"), DSTabItem(label: "Tab 2")],
            selectedIndex: 0
        )
        
        tabs.setSelectedIndex(1)
        XCTAssertEqual(tabs.selectedIndex, 1)
    }
    
    func testUIKitTabsSetSelectedIndexOutOfBounds() {
        let tabs = DSTabsUIKit(
            items: [DSTabItem(label: "Tab 1")],
            selectedIndex: 0
        )
        
        tabs.setSelectedIndex(5)
        XCTAssertEqual(tabs.selectedIndex, 0, "Should not change to invalid index")
    }
    
    func testUIKitTabsAccessibilityLabel() {
        let tabs = DSTabsUIKit(
            items: [DSTabItem(label: "Home"), DSTabItem(label: "Settings")]
        )
        
        XCTAssertEqual(tabs.accessibilityLabel, "Tabs: Home, Settings")
    }
    
    func testUIKitTabsUpdateItems() {
        let tabs = DSTabsUIKit(
            items: [DSTabItem(label: "Tab 1")],
            selectedIndex: 0
        )
        
        tabs.items = [DSTabItem(label: "New Tab 1"), DSTabItem(label: "New Tab 2")]
        XCTAssertEqual(tabs.items.count, 2)
    }
    
    func testUIKitTabsVariantChange() {
        let tabs = DSTabsUIKit(
            items: [DSTabItem(label: "Tab")],
            variant: .text
        )
        
        tabs.variant = .icon
        XCTAssertEqual(tabs.variant, .icon)
    }
    #endif
}
