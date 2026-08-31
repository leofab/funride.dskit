import XCTest
@testable import FDSDKit

final class DSButtonTests: XCTestCase {
    
    func testButtonStyleHasCorrectColors() {
        XCTAssertEqual(DSButtonStyle.primary.backgroundColor, DSTokens.Colors.buttonPrimaryDefault)
        XCTAssertEqual(DSButtonStyle.destructive.backgroundColor, DSTokens.Colors.error)
    }
    
    func testButtonDimensions() {
        XCTAssertEqual(DSTokens.Sizing.buttonHeight, 32)
        XCTAssertEqual(DSTokens.Sizing.buttonMinWidth, 86)
        XCTAssertEqual(DSTokens.Sizing.iconSize, 16)
    }
    
    func testButtonSpacing() {
        XCTAssertEqual(DSTokens.Spacing.buttonIconTextGap, 4)
    }
    
    func testBorderRadius() {
        XCTAssertEqual(DSTokens.Borders.radiusMedium, 8)
    }
    
    #if canImport(UIKit)
    func testUIKitButtonInitialization() {
        let button = DSButtonUIKit(style: .primary, label: "Test")
        XCTAssertEqual(button.currentTitle, "Test")
    }
    #endif
}
