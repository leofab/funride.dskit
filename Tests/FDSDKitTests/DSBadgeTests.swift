import XCTest
import SwiftUI
@testable import FDSDKit

final class DSBadgeTests: XCTestCase {
    
    // MARK: - Token Tests
    
    func testBadgeDefaultColors() {
        XCTAssertEqual(DSTokens.Colors.badgeDefaultBackground, Color(hex: "#18181a"))
        XCTAssertEqual(DSTokens.Colors.badgeDefaultBorder, Color(hex: "#2e3434"))
        XCTAssertEqual(DSTokens.Colors.badgeDefaultText, Color.white)
    }
    
    func testBadgeErrorColors() {
        XCTAssertEqual(DSTokens.Colors.badgeErrorBackground, Color(hex: "#441606"))
        XCTAssertEqual(DSTokens.Colors.badgeErrorBorder, Color(hex: "#fe4811"))
        XCTAssertEqual(DSTokens.Colors.badgeErrorText, Color.white)
    }
    
    func testBadgeLayersColors() {
        XCTAssertEqual(DSTokens.Colors.badgeLayersBackground, Color(hex: "#18181a"))
        XCTAssertEqual(DSTokens.Colors.badgeLayersBorder, Color(hex: "#7efff5"))
        XCTAssertEqual(DSTokens.Colors.badgeLayersText, Color(hex: "#7efff5"))
    }
    
    func testBadgeTypography() {
        XCTAssertEqual(DSTokens.Typography.badgeDefaultFontSize, 14)
        XCTAssertEqual(DSTokens.Typography.badgeLayersFontSize, 12)
        XCTAssertEqual(DSTokens.Typography.badgeFontWeight, .regular)
    }
    
    func testBadgeSizing() {
        XCTAssertEqual(DSTokens.Sizing.badgeDefaultHeight, 32)
        XCTAssertEqual(DSTokens.Sizing.badgeLayersHeight, 20)
        XCTAssertEqual(DSTokens.Sizing.badgeDefaultRadius, 8)
        XCTAssertEqual(DSTokens.Sizing.badgeLayersRadius, 6)
        XCTAssertEqual(DSTokens.Sizing.badgeHorizontalPadding, 8)
        XCTAssertEqual(DSTokens.Sizing.badgeVerticalPadding, 4)
        XCTAssertEqual(DSTokens.Sizing.badgeLayersHorizontalPadding, 6)
        XCTAssertEqual(DSTokens.Sizing.badgeLayersVerticalPadding, 2)
        XCTAssertEqual(DSTokens.Sizing.badgeBorderWidth, 1)
    }
    
    // MARK: - BadgeType Tests
    
    func testBadgeTypeDefaultProperties() {
        let type = DSBadgeType.default
        XCTAssertEqual(type.backgroundColor, DSTokens.Colors.badgeDefaultBackground)
        XCTAssertEqual(type.borderColor, DSTokens.Colors.badgeDefaultBorder)
        XCTAssertEqual(type.textColor, DSTokens.Colors.badgeDefaultText)
        XCTAssertEqual(type.fontSize, DSTokens.Typography.badgeDefaultFontSize)
        XCTAssertEqual(type.cornerRadius, DSTokens.Sizing.badgeDefaultRadius)
        XCTAssertEqual(type.horizontalPadding, DSTokens.Sizing.badgeHorizontalPadding)
        XCTAssertEqual(type.verticalPadding, DSTokens.Sizing.badgeVerticalPadding)
    }
    
    func testBadgeTypeErrorProperties() {
        let type = DSBadgeType.error
        XCTAssertEqual(type.backgroundColor, DSTokens.Colors.badgeErrorBackground)
        XCTAssertEqual(type.borderColor, DSTokens.Colors.badgeErrorBorder)
        XCTAssertEqual(type.textColor, DSTokens.Colors.badgeErrorText)
        XCTAssertEqual(type.fontSize, DSTokens.Typography.badgeDefaultFontSize)
        XCTAssertEqual(type.cornerRadius, DSTokens.Sizing.badgeDefaultRadius)
    }
    
    func testBadgeTypeLayersProperties() {
        let type = DSBadgeType.layers
        XCTAssertEqual(type.backgroundColor, DSTokens.Colors.badgeLayersBackground)
        XCTAssertEqual(type.borderColor, DSTokens.Colors.badgeLayersBorder)
        XCTAssertEqual(type.textColor, DSTokens.Colors.badgeLayersText)
        XCTAssertEqual(type.fontSize, DSTokens.Typography.badgeLayersFontSize)
        XCTAssertEqual(type.cornerRadius, DSTokens.Sizing.badgeLayersRadius)
        XCTAssertEqual(type.horizontalPadding, DSTokens.Sizing.badgeLayersHorizontalPadding)
        XCTAssertEqual(type.verticalPadding, DSTokens.Sizing.badgeLayersVerticalPadding)
    }
    
    func testBadgeTypeAccessibilityLabel() {
        XCTAssertEqual(DSBadgeType.default.accessibilityLabel, "Default")
        XCTAssertEqual(DSBadgeType.error.accessibilityLabel, "Error")
        XCTAssertEqual(DSBadgeType.layers.accessibilityLabel, "Layer")
    }
    
    // MARK: - UIKit Tests
    
    #if canImport(UIKit)
    func testDSBadgeUIKitInitialization() {
        let badge = DSBadgeUIKit(type: .default, text: "Label")
        XCTAssertEqual(badge.text, "Label")
        XCTAssertEqual(badge.layer.cornerRadius, DSTokens.Sizing.badgeDefaultRadius)
        XCTAssertEqual(badge.layer.borderWidth, DSTokens.Sizing.badgeBorderWidth)
        XCTAssertEqual(badge.numberOfLines, 1)
        XCTAssertEqual(badge.lineBreakMode, .byTruncatingTail)
    }
    
    func testDSBadgeUIKitUpdateText() {
        let badge = DSBadgeUIKit(type: .default, text: "Label")
        badge.updateText("Updated")
        XCTAssertEqual(badge.text, "Updated")
    }
    
    func testDSBadgeUIKitErrorType() {
        let badge = DSBadgeUIKit(type: .error, text: "Error")
        XCTAssertEqual(badge.text, "Error")
        XCTAssertEqual(badge.layer.cornerRadius, DSTokens.Sizing.badgeDefaultRadius)
        XCTAssertNotNil(badge.textColor)
    }
    
    func testDSBadgeUIKitLayersType() {
        let badge = DSBadgeUIKit(type: .layers, text: "View mode")
        XCTAssertEqual(badge.text, "View mode")
        XCTAssertEqual(badge.layer.cornerRadius, DSTokens.Sizing.badgeLayersRadius)
        XCTAssertNotNil(badge.textColor)
    }
    #endif
}
