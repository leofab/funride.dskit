import XCTest
import SwiftUI
@testable import FDSDKit

final class DSAvatarTests: XCTestCase {
    
    // MARK: - Token Tests
    
    func testAvatarColorTokens() {
        XCTAssertEqual(DSTokens.Colors.avatarPink, Color(hex: "#f49ef7"))
        XCTAssertEqual(DSTokens.Colors.avatarBlue, Color(hex: "#38c0fa"))
        XCTAssertEqual(DSTokens.Colors.avatarGreen, Color(hex: "#48c393"))
        XCTAssertEqual(DSTokens.Colors.avatarYellow, Color(hex: "#d4a03c"))
        XCTAssertEqual(DSTokens.Colors.avatarPurple, Color(hex: "#9b6dff"))
        XCTAssertEqual(DSTokens.Colors.avatarOrange, Color(hex: "#e0785c"))
    }
    
    func testAvatarSizingTokens() {
        XCTAssertEqual(DSTokens.Sizing.avatarSmall, 24)
        XCTAssertEqual(DSTokens.Sizing.avatarMedium, 32)
        XCTAssertEqual(DSTokens.Sizing.avatarLarge, 40)
        XCTAssertEqual(DSTokens.Sizing.avatarBorderWidth, 2)
    }
    
    func testAvatarTypographyTokens() {
        XCTAssertEqual(DSTokens.Typography.avatarSmallFontSize, 10)
        XCTAssertEqual(DSTokens.Typography.avatarMediumFontSize, 12)
        XCTAssertEqual(DSTokens.Typography.avatarLargeFontSize, 14)
    }
    
    // MARK: - Size Enum Tests
    
    func testAvatarSizeDimensions() {
        XCTAssertEqual(DSAvatarSize.small.dimension, 24)
        XCTAssertEqual(DSAvatarSize.medium.dimension, 32)
        XCTAssertEqual(DSAvatarSize.large.dimension, 40)
    }
    
    func testAvatarSizeFontSizes() {
        XCTAssertEqual(DSAvatarSize.small.fontSize, 10)
        XCTAssertEqual(DSAvatarSize.medium.fontSize, 12)
        XCTAssertEqual(DSAvatarSize.large.fontSize, 14)
    }
    
    // MARK: - State Enum Tests
    
    func testAvatarStateBackgroundColor() {
        XCTAssertNil(DSAvatarState.default.backgroundColor)
        XCTAssertEqual(DSAvatarState.hover.backgroundColor, DSTokens.Colors.avatarHover)
        XCTAssertNil(DSAvatarState.selected.backgroundColor)
        XCTAssertNil(DSAvatarState.focus.backgroundColor)
    }
    
    func testAvatarStateBorderColor() {
        XCTAssertNil(DSAvatarState.default.borderColor)
        XCTAssertNil(DSAvatarState.hover.borderColor)
        XCTAssertEqual(DSAvatarState.selected.borderColor, DSTokens.Colors.avatarBorderSelected)
        XCTAssertEqual(DSAvatarState.focus.borderColor, DSTokens.Colors.avatarBorderSelected)
    }
    
    func testAvatarStateBorderWidth() {
        XCTAssertEqual(DSAvatarState.default.borderWidth, 0)
        XCTAssertEqual(DSAvatarState.hover.borderWidth, 0)
        XCTAssertEqual(DSAvatarState.selected.borderWidth, 2)
        XCTAssertEqual(DSAvatarState.focus.borderWidth, 2)
    }
    
    // MARK: - Initials Tests
    
    func testInitialsExtractionSingleName() {
        XCTAssertEqual(DSAvatarInitials.extract(from: "John"), "J")
    }
    
    func testInitialsExtractionFullName() {
        XCTAssertEqual(DSAvatarInitials.extract(from: "John Doe"), "JD")
    }
    
    func testInitialsExtractionMultipleNames() {
        XCTAssertEqual(DSAvatarInitials.extract(from: "John Michael Doe"), "JD")
    }
    
    func testInitialsExtractionEmptyString() {
        XCTAssertEqual(DSAvatarInitials.extract(from: ""), "?")
    }
    
    func testInitialsExtractionWhitespace() {
        XCTAssertEqual(DSAvatarInitials.extract(from: "   "), "?")
    }
    
    func testInitialsExtractionLeadingTrailingSpaces() {
        XCTAssertEqual(DSAvatarInitials.extract(from: "  John Doe  "), "JD")
    }
    
    func testInitialsExtractionSingleCharNames() {
        XCTAssertEqual(DSAvatarInitials.extract(from: "J D"), "JD")
    }
    
    // MARK: - Color Selection Tests
    
    func testColorSelectionDeterministic() {
        let color1 = DSAvatarColor.color(for: "John Doe")
        let color2 = DSAvatarColor.color(for: "John Doe")
        XCTAssertEqual(color1, color2)
    }
    
    func testColorSelectionDifferentNames() {
        let color1 = DSAvatarColor.color(for: "Alice")
        let color2 = DSAvatarColor.color(for: "Bob")
        // Colors may or may not be different, but both should be valid
        XCTAssertNotNil(color1)
        XCTAssertNotNil(color2)
    }
    
    // MARK: - UIKit Tests
    
    #if canImport(UIKit)
    func testUIKitAvatarInitialization() {
        let avatar = DSAvatarUIKit(size: .medium, name: "John Doe")
        XCTAssertEqual(avatar.frame.width, 32)
        XCTAssertEqual(avatar.frame.height, 32)
    }
    
    func testUIKitAvatarStateUpdate() {
        let avatar = DSAvatarUIKit(size: .medium, name: "John Doe")
        avatar.updateState(.selected)
        // No assertion needed - just verify it doesn't crash
    }
    
    func testUIKitAvatarImageUpdate() {
        let avatar = DSAvatarUIKit(size: .medium, name: "John Doe")
        avatar.updateImage(nil)
        // No assertion needed - just verify it doesn't crash
    }
    #endif
}
