import XCTest
import SwiftUI
@testable import FDSDKit

final class DSComboButtonTests: XCTestCase {
    
    // MARK: - Button Style Tests
    
    func testButtonStyleInitialization() {
        let standardStyle = DSComboButtonStyle.standard
        let collapsibleStyle = DSComboButtonStyle.collapsible
        
        XCTAssertNotNil(standardStyle)
        XCTAssertNotNil(collapsibleStyle)
    }
    
    // MARK: - Button State Tests
    
    func testButtonStateInitialization() {
        let defaultState = DSComboButtonState.default
        let hoverState = DSComboButtonState.hover
        let activeState = DSComboButtonState.active
        let focusState = DSComboButtonState.focus
        let disabledState = DSComboButtonState.disabled
        
        XCTAssertNotNil(defaultState)
        XCTAssertNotNil(hoverState)
        XCTAssertNotNil(activeState)
        XCTAssertNotNil(focusState)
        XCTAssertNotNil(disabledState)
    }
    
    func testButtonStateBackgroundColors() {
        XCTAssertEqual(DSComboButtonState.default.backgroundColor, DSTokens.Colors.comboButtonDefault)
        XCTAssertEqual(DSComboButtonState.hover.backgroundColor, DSTokens.Colors.comboButtonHover)
        XCTAssertEqual(DSComboButtonState.active.backgroundColor, DSTokens.Colors.comboButtonDefault)
        XCTAssertEqual(DSComboButtonState.focus.backgroundColor, DSTokens.Colors.comboButtonDefault)
        XCTAssertEqual(DSComboButtonState.disabled.backgroundColor, DSTokens.Colors.comboButtonDisabled)
    }
    
    func testButtonStateBorderColors() {
        XCTAssertEqual(DSComboButtonState.default.borderColor, Color.clear)
        XCTAssertEqual(DSComboButtonState.hover.borderColor, Color.clear)
        XCTAssertEqual(DSComboButtonState.active.borderColor, DSTokens.Colors.comboButtonFocus)
        XCTAssertEqual(DSComboButtonState.focus.borderColor, DSTokens.Colors.comboButtonFocus)
        XCTAssertEqual(DSComboButtonState.disabled.borderColor, Color.clear)
    }
    
    func testButtonStateOpacity() {
        XCTAssertEqual(DSComboButtonState.default.opacity, 1.0)
        XCTAssertEqual(DSComboButtonState.hover.opacity, 1.0)
        XCTAssertEqual(DSComboButtonState.active.opacity, 1.0)
        XCTAssertEqual(DSComboButtonState.focus.opacity, 1.0)
        XCTAssertEqual(DSComboButtonState.disabled.opacity, 0.5)
    }
    
    // MARK: - Design Token Tests
    
    func testComboButtonTokensExist() {
        XCTAssertNotNil(DSTokens.Colors.comboButtonDefault)
        XCTAssertNotNil(DSTokens.Colors.comboButtonHover)
        XCTAssertNotNil(DSTokens.Colors.comboButtonFocus)
        XCTAssertNotNil(DSTokens.Colors.comboButtonDisabled)
        XCTAssertNotNil(DSTokens.Colors.comboButtonText)
        XCTAssertNotNil(DSTokens.Colors.comboButtonSubtext)
        XCTAssertNotNil(DSTokens.Colors.comboButtonBorder)
        
        XCTAssertGreaterThan(DSTokens.Spacing.comboButtonPadding, 0)
        XCTAssertGreaterThan(DSTokens.Spacing.comboButtonIconGap, 0)
        XCTAssertGreaterThan(DSTokens.Spacing.comboButtonOptionHeight, 0)
        
        XCTAssertGreaterThan(DSTokens.Typography.comboButtonLabelSize, 0)
        XCTAssertNotNil(DSTokens.Typography.comboButtonLabelWeight)
        
        XCTAssertGreaterThan(DSTokens.Sizing.comboButtonHeight, 0)
        XCTAssertGreaterThan(DSTokens.Sizing.comboButtonWidth, 0)
        XCTAssertGreaterThan(DSTokens.Sizing.comboButtonRadius, 0)
        XCTAssertGreaterThan(DSTokens.Sizing.comboButtonIconSize, 0)
        XCTAssertGreaterThan(DSTokens.Sizing.comboButtonDropdownMaxHeight, 0)
    }
    
    // MARK: - UIKit Wrapper Tests
    
    #if canImport(UIKit)
    func testUIKitComboButtonInitialization() {
        let button = DSComboButtonUIKit(
            .standard,
            label: "Test Label",
            sublabel: "Test Sublabel",
            leadingIcon: "sparkle",
            trailingIcon: "minus"
        ) {
            // Action handler
        }
        
        XCTAssertNotNil(button)
    }
    
    func testUIKitComboButtonCollapsibleInitialization() {
        let button = DSComboButtonUIKit(
            .collapsible,
            label: "Test Label",
            sublabel: "Test Sublabel",
            leadingIcon: "sparkle",
            trailingIcon: "minus"
        ) {
            // Action handler
        }
        
        XCTAssertNotNil(button)
    }
    
    func testUIKitComboButtonEnableDisable() {
        let button = DSComboButtonUIKit(
            .standard,
            label: "Test Label",
            sublabel: "Test Sublabel"
        ) {
            // Action handler
        }
        
        // Initially enabled
        XCTAssertTrue(button.isUserInteractionEnabled)
        XCTAssertEqual(button.alpha, 1.0)
        
        // Disable
        button.setEnabled(false)
        XCTAssertFalse(button.isUserInteractionEnabled)
        XCTAssertEqual(button.alpha, 0.5)
        
        // Re-enable
        button.setEnabled(true)
        XCTAssertTrue(button.isUserInteractionEnabled)
        XCTAssertEqual(button.alpha, 1.0)
    }
    #endif
}
