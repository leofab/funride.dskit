import XCTest
import SwiftUI
@testable import FDSDKit

final class DSAccordionTests: XCTestCase {
    
    // MARK: - Token Tests
    
    func testAccordionColors() {
        XCTAssertEqual(DSTokens.Colors.accordionBackground, Color(hex: "#212426"))
        XCTAssertEqual(DSTokens.Colors.accordionHover, Color(hex: "#2e3434"))
        XCTAssertEqual(DSTokens.Colors.accordionBorder, Color(hex: "#18181a"))
    }
    
    func testAccordionSpacing() {
        XCTAssertEqual(DSTokens.Spacing.accordionItemGap, 2)
        XCTAssertEqual(DSTokens.Spacing.accordionHeaderPadding, 16)
        XCTAssertEqual(DSTokens.Spacing.accordionContentPadding, 16)
    }
    
    func testAccordionSizing() {
        XCTAssertEqual(DSTokens.Sizing.accordionHeaderHeight, 50)
        XCTAssertEqual(DSTokens.Sizing.accordionIconSize, 16)
        XCTAssertEqual(DSTokens.Sizing.accordionItemRadius, 8)
        XCTAssertEqual(DSTokens.Sizing.accordionContainerRadius, 24)
    }
    
    func testAccordionTypography() {
        XCTAssertEqual(DSTokens.Typography.accordionTitleSize, 12)
        XCTAssertEqual(DSTokens.Typography.accordionTitleWeight, .regular)
    }
    
    // MARK: - Configuration Tests
    
    func testDefaultConfiguration() {
        let config = DSAccordionConfiguration()
        XCTAssertTrue(config.allowsMultipleExpansion)
        XCTAssertFalse(config.requiresAtLeastOneExpanded)
        XCTAssertEqual(config.animationDuration, 0.2)
    }
    
    func testCustomConfiguration() {
        let config = DSAccordionConfiguration(
            allowsMultipleExpansion: false,
            requiresAtLeastOneExpanded: true,
            animationDuration: 0.3
        )
        XCTAssertFalse(config.allowsMultipleExpansion)
        XCTAssertTrue(config.requiresAtLeastOneExpanded)
        XCTAssertEqual(config.animationDuration, 0.3)
    }
    
    // MARK: - Item Tests
    
    func testAccordionItemCreation() {
        let item = DSAccordionItem(title: "Test Section") {
            Text("Content")
        }
        
        XCTAssertEqual(item.title, "Test Section")
        XCTAssertNil(item.icon)
        XCTAssertFalse(item.isExpanded)
        XCTAssertFalse(item.isDisabled)
    }
    
    func testAccordionItemWithIcon() {
        let item = DSAccordionItem(
            title: "Section with Icon",
            icon: "star.fill"
        ) {
            Text("Content")
        }
        
        XCTAssertEqual(item.title, "Section with Icon")
        XCTAssertEqual(item.icon, "star.fill")
    }
    
    func testAccordionItemExpanded() {
        let item = DSAccordionItem(
            title: "Expanded Section",
            isExpanded: true
        ) {
            Text("Content")
        }
        
        XCTAssertTrue(item.isExpanded)
    }
    
    func testAccordionItemDisabled() {
        let item = DSAccordionItem(
            title: "Disabled Section",
            isDisabled: true
        ) {
            Text("Content")
        }
        
        XCTAssertTrue(item.isDisabled)
    }
    
    func testAccordionItemUniqueId() {
        let item1 = DSAccordionItem(title: "Section 1") { Text("1") }
        let item2 = DSAccordionItem(title: "Section 2") { Text("2") }
        
        XCTAssertNotEqual(item1.id, item2.id)
    }
    
    #if canImport(UIKit)
    // MARK: - UIKit Tests
    
    func testUIKitAccordionItemCreation() {
        let label = UILabel()
        label.text = "Test Content"
        
        let item = DSAccordionItemUIKit(
            title: "UIKit Section",
            content: label
        )
        
        XCTAssertEqual(item.title, "UIKit Section")
        XCTAssertNil(item.icon)
        XCTAssertFalse(item.isExpanded)
        XCTAssertFalse(item.isDisabled)
    }
    
    func testUIKitAccordionInitialization() {
        let accordion = DSAccordionUIKit(frame: .zero)
        XCTAssertNotNil(accordion)
    }
    #endif
}
