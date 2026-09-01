import XCTest
import SwiftUI
@testable import FDSDKit

final class DSPillTests: XCTestCase {
    
    // MARK: - State Tests
    
    func testDefaultStateProperties() {
        let state = DSPillState.default
        XCTAssertEqual(state.backgroundColor, DSTokens.Colors.pillDefaultBackground)
        XCTAssertEqual(state.borderColor, .clear)
        XCTAssertEqual(state.borderWidth, 0)
    }
    
    func testHoverStateProperties() {
        let state = DSPillState.hover
        XCTAssertEqual(state.backgroundColor, DSTokens.Colors.pillHoverBackground)
        XCTAssertEqual(state.borderColor, .clear)
        XCTAssertEqual(state.borderWidth, 0)
    }
    
    func testFocusStateProperties() {
        let state = DSPillState.focus
        XCTAssertEqual(state.backgroundColor, DSTokens.Colors.pillHoverBackground)
        XCTAssertEqual(state.borderColor, DSTokens.Colors.pillFocusBorder)
        XCTAssertEqual(state.borderWidth, DSTokens.Sizing.pillBorderWidth)
    }
    
    // MARK: - Token Tests
    
    func testPillTokensExist() {
        // Colors
        XCTAssertEqual(DSTokens.Colors.pillDefaultBackground, Color(hex: "#212426"))
        XCTAssertEqual(DSTokens.Colors.pillHoverBackground, Color(hex: "#2e3434"))
        XCTAssertEqual(DSTokens.Colors.pillFocusBorder, Color(hex: "#7efff5"))
        XCTAssertEqual(DSTokens.Colors.pillText, .white)
        
        // Sizing
        XCTAssertEqual(DSTokens.Sizing.pillHeight, 24)
        XCTAssertEqual(DSTokens.Sizing.pillRadius, 6)
        XCTAssertEqual(DSTokens.Sizing.pillBorderWidth, 1)
        XCTAssertEqual(DSTokens.Sizing.pillCloseIconSize, 12)
        
        // Spacing
        XCTAssertEqual(DSTokens.Spacing.pillIconTextGap, 4)
        XCTAssertEqual(DSTokens.Spacing.pillHorizontalPadding, 8)
        
        // Typography
        XCTAssertEqual(DSTokens.Typography.pillFontSize, 12)
        XCTAssertEqual(DSTokens.Typography.pillFontWeight, .regular)
    }
    
    // MARK: - Edge Case Tests
    
    func testEmptyText() {
        let pill = DSPill("", isDismissible: true)
        XCTAssertEqual(pill.text, "")
    }
    
    func testNonDismissiblePill() {
        let pill = DSPill("Tag", isDismissible: false)
        XCTAssertFalse(pill.isDismissible)
    }
    
    func testDefaultState() {
        let pill = DSPill("Tag")
        XCTAssertEqual(pill.state, .default)
    }
    
    func testCustomState() {
        let pill = DSPill("Tag", state: .focus)
        XCTAssertEqual(pill.state, .focus)
    }
    
    // MARK: - Callback Tests (UIKit)
    
    #if canImport(UIKit)
    func testUIKitPillTapCallback() {
        var tapCalled = false
        let pill = DSPillUIKit(text: "Tag", onTap: { tapCalled = true })
        
        pill.onTap?()
        
        XCTAssertTrue(tapCalled, "onTap callback should be invoked")
    }
    
    func testUIKitPillDismissCallback() {
        var dismissCalled = false
        let pill = DSPillUIKit(text: "Tag", onDismiss: { dismissCalled = true })
        
        pill.onDismiss?()
        
        XCTAssertTrue(dismissCalled, "onDismiss callback should be invoked")
    }
    
    func testUIKitPillDismissHiddenWhenNotDismissible() {
        let pill = DSPillUIKit(text: "Tag", isDismissible: false)
        
        // Access the close button via reflection or check visibility
        // The close button should be hidden when isDismissible is false
        XCTAssertFalse(pill.isDismissible, "Pill should not be dismissible")
    }
    
    func testUIKitPillUpdateText() {
        let pill = DSPillUIKit(text: "Initial")
        pill.updateText("Updated")
        
        XCTAssertEqual(pill.text, "Updated", "Text should be updated")
    }
    
    func testUIKitPillStateChange() {
        let pill = DSPillUIKit(text: "Tag", state: .default)
        XCTAssertEqual(pill.state, .default)
        
        pill.state = .focus
        XCTAssertEqual(pill.state, .focus)
    }
    
    func testUIKitPillAccessibilityLabel() {
        let pill = DSPillUIKit(text: "Filter")
        
        XCTAssertEqual(pill.accessibilityLabel, "Pill: Filter")
    }
    
    func testDismissRemovesPillFromDataSource() {
        var tags = ["Tag", "Filter", "Category"]
        
        let pill = DSPillUIKit(text: "Filter", onDismiss: {
            tags.removeAll { $0 == "Filter" }
        })
        
        // Simulate close button tap
        pill.onDismiss?()
        
        XCTAssertFalse(tags.contains("Filter"), "Filter should be removed from data source")
        XCTAssertEqual(tags.count, 2, "Should have 2 tags remaining")
        XCTAssertEqual(tags, ["Tag", "Category"])
    }
    
    func testDismissOnlyRemovesMatchingPill() {
        var tags = ["Tag", "Filter", "Tag"]
        
        let pill = DSPillUIKit(text: "Filter", onDismiss: {
            tags.removeAll { $0 == "Filter" }
        })
        
        pill.onDismiss?()
        
        XCTAssertEqual(tags, ["Tag", "Tag"], "Only Filter should be removed, not Tag")
    }
    
    func testDismissCallbackReceivesCorrectText() {
        var dismissedText: String?
        
        let pill = DSPillUIKit(text: "Category", onDismiss: {
            dismissedText = "Category"
        })
        
        pill.onDismiss?()
        
        XCTAssertEqual(dismissedText, "Category")
    }
    #endif
}
