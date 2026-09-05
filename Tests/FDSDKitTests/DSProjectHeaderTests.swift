import XCTest
import SwiftUI
@testable import FDSDKit

final class DSProjectHeaderTests: XCTestCase {
    
    func testProjectHeaderTokenColors() {
        XCTAssertEqual(DSTokens.Colors.projectHeaderBackground, Color(hex: "#18181a"))
        XCTAssertEqual(DSTokens.Colors.projectHeaderSubtitle, Color(hex: "#8f9da3"))
        XCTAssertEqual(DSTokens.Colors.projectHeaderTitle, Color.white)
    }
    
    func testProjectHeaderTokenSizing() {
        XCTAssertEqual(DSTokens.Sizing.projectHeaderHeight, 52)
        XCTAssertEqual(DSTokens.Sizing.projectHeaderLogoSize, 36)
        XCTAssertEqual(DSTokens.Sizing.projectHeaderButtonSize, 32)
        XCTAssertEqual(DSTokens.Sizing.projectHeaderButtonRadius, 8)
        XCTAssertEqual(DSTokens.Sizing.projectHeaderIconSize, 16)
    }
    
    func testProjectHeaderTokenSpacing() {
        XCTAssertEqual(DSTokens.Spacing.projectHeaderPaddingH, 12)
        XCTAssertEqual(DSTokens.Spacing.projectHeaderPaddingV, 8)
        XCTAssertEqual(DSTokens.Spacing.projectHeaderGap, 4)
        XCTAssertEqual(DSTokens.Spacing.projectHeaderColumnGap, 4)
    }
    
    func testProjectHeaderTokenTypography() {
        XCTAssertEqual(DSTokens.Typography.projectHeaderSubtitleSize, 12)
        XCTAssertEqual(DSTokens.Typography.projectHeaderTitleSize, 14)
    }
    
    func testProjectHeaderActionCreation() {
        let action = DSProjectHeaderAction(iconName: "ellipsis") {}
        XCTAssertNotNil(action.id)
        XCTAssertEqual(action.iconName, "ellipsis")
    }
    
    func testProjectHeaderDefaultInit() {
        let header = DSProjectHeader(
            title: "App",
            subtitle: "Design system"
        )
        XCTAssertNotNil(header)
    }
    
    func testProjectHeaderWithActions() {
        let actions = [
            DSProjectHeaderAction(iconName: "square.stack.3d.up") {},
            DSProjectHeaderAction(iconName: "ellipsis") {}
        ]
        let header = DSProjectHeader(
            title: "App",
            subtitle: "Design system",
            trailingActions: actions
        )
        XCTAssertNotNil(header)
        XCTAssertEqual(actions.count, 2)
    }
    
    #if canImport(UIKit)
    func testUIKitProjectHeaderInitialization() {
        let header = DSProjectHeaderUIKit(
            title: "App",
            subtitle: "Design system"
        )
        XCTAssertNotNil(header)
    }
    
    func testUIKitProjectHeaderUpdateTitle() {
        let header = DSProjectHeaderUIKit(
            title: "App",
            subtitle: "Design system"
        )
        header.updateTitle("Updated")
        XCTAssertNotNil(header)
    }
    
    func testUIKitProjectHeaderUpdateSubtitle() {
        let header = DSProjectHeaderUIKit(
            title: "App",
            subtitle: "Design system"
        )
        header.updateSubtitle("Updated")
        XCTAssertNotNil(header)
    }
    #endif
}
