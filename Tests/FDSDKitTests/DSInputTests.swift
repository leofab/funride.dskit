import XCTest
import SwiftUI
@testable import FDSDKit

final class DSInputTests: XCTestCase {
    
    // MARK: - Token Tests
    
    func testInputColors() {
        XCTAssertEqual(DSTokens.Colors.inputDefault, Color(hex: "#212426"))
        XCTAssertEqual(DSTokens.Colors.inputHover, Color(hex: "#2e3434"))
        XCTAssertEqual(DSTokens.Colors.inputActive, Color(hex: "#18181a"))
        XCTAssertEqual(DSTokens.Colors.inputBorder, Color(hex: "#7efff5"))
        XCTAssertEqual(DSTokens.Colors.inputText, Color.white)
        XCTAssertEqual(DSTokens.Colors.inputTextDisabled, Color(hex: "#8f9da3"))
    }
    
    func testInputTypography() {
        XCTAssertEqual(DSTokens.Typography.inputFontSize, 12)
        XCTAssertEqual(DSTokens.Typography.inputFontWeight, .regular)
    }
    
    func testInputSizing() {
        XCTAssertEqual(DSTokens.Sizing.inputHeight, 32)
        XCTAssertEqual(DSTokens.Sizing.inputWidthWithoutOpacity, 179)
        XCTAssertEqual(DSTokens.Sizing.inputWidthWithOpacity, 248)
        XCTAssertEqual(DSTokens.Sizing.inputSwatchSize, 16)
        XCTAssertEqual(DSTokens.Sizing.inputRadius, 8)
        XCTAssertEqual(DSTokens.Sizing.inputPadding, 8)
    }
    
    func testInputSpacing() {
        XCTAssertEqual(DSTokens.Spacing.inputIconGap, 4)
    }
    
    // MARK: - DSInputStyle Tests
    
    func testInputStyleInitialization() {
        let defaultStyle = DSInputStyle.default
        let hoverStyle = DSInputStyle.hover
        let activeStyle = DSInputStyle.active
        let focusStyle = DSInputStyle.focus
        let disabledStyle = DSInputStyle.disabled
        
        XCTAssertNotNil(defaultStyle)
        XCTAssertNotNil(hoverStyle)
        XCTAssertNotNil(activeStyle)
        XCTAssertNotNil(focusStyle)
        XCTAssertNotNil(disabledStyle)
    }
    
    func testInputStyleBackgroundColors() {
        XCTAssertEqual(DSInputStyle.default.backgroundColor, DSTokens.Colors.inputDefault)
        XCTAssertEqual(DSInputStyle.hover.backgroundColor, DSTokens.Colors.inputHover)
        XCTAssertEqual(DSInputStyle.active.backgroundColor, DSTokens.Colors.inputActive)
        XCTAssertEqual(DSInputStyle.focus.backgroundColor, DSTokens.Colors.inputDefault)
        XCTAssertEqual(DSInputStyle.disabled.backgroundColor, DSTokens.Colors.inputActive)
    }
    
    func testInputStyleBorderColors() {
        XCTAssertNil(DSInputStyle.default.borderColor)
        XCTAssertNil(DSInputStyle.hover.borderColor)
        XCTAssertEqual(DSInputStyle.active.borderColor, DSTokens.Colors.inputBorder)
        XCTAssertEqual(DSInputStyle.focus.borderColor, DSTokens.Colors.inputBorder)
        XCTAssertNil(DSInputStyle.disabled.borderColor)
    }
    
    func testInputStyleBorderWidths() {
        XCTAssertEqual(DSInputStyle.default.borderWidth, 0)
        XCTAssertEqual(DSInputStyle.hover.borderWidth, 0)
        XCTAssertEqual(DSInputStyle.active.borderWidth, DSTokens.Borders.widthThin)
        XCTAssertEqual(DSInputStyle.focus.borderWidth, DSTokens.Borders.widthThin)
        XCTAssertEqual(DSInputStyle.disabled.borderWidth, 0)
    }
    
    func testInputStyleTextColors() {
        XCTAssertEqual(DSInputStyle.default.textColor, DSTokens.Colors.inputText)
        XCTAssertEqual(DSInputStyle.hover.textColor, DSTokens.Colors.inputText)
        XCTAssertEqual(DSInputStyle.active.textColor, DSTokens.Colors.inputText)
        XCTAssertEqual(DSInputStyle.focus.textColor, DSTokens.Colors.inputText)
        XCTAssertEqual(DSInputStyle.disabled.textColor, DSTokens.Colors.inputTextDisabled)
    }
    
    func testInputStylePlaceholderColors() {
        XCTAssertEqual(DSInputStyle.default.placeholderColor, DSTokens.Colors.inputTextDisabled)
        XCTAssertEqual(DSInputStyle.hover.placeholderColor, DSTokens.Colors.inputTextDisabled)
        XCTAssertEqual(DSInputStyle.active.placeholderColor, DSTokens.Colors.inputTextDisabled)
        XCTAssertEqual(DSInputStyle.focus.placeholderColor, DSTokens.Colors.inputTextDisabled)
        XCTAssertEqual(DSInputStyle.disabled.placeholderColor, DSTokens.Colors.inputTextDisabled)
    }
    
    func testInputStyleOpacity() {
        XCTAssertEqual(DSInputStyle.default.opacity, 1.0)
        XCTAssertEqual(DSInputStyle.hover.opacity, 1.0)
        XCTAssertEqual(DSInputStyle.active.opacity, 1.0)
        XCTAssertEqual(DSInputStyle.focus.opacity, 1.0)
        XCTAssertEqual(DSInputStyle.disabled.opacity, 0.5)
    }
    
    // MARK: - UIKit Tests
    
    #if canImport(UIKit)
    func testDSInputViewInitialization() {
        let input = DSInputView()
        input.text = "Test"
        input.placeholder = "Enter text"
        
        XCTAssertEqual(input.text, "Test")
        XCTAssertEqual(input.placeholder, "Enter text")
        XCTAssertFalse(input.isDisabled)
        XCTAssertFalse(input.showsSwatch)
    }
    
    func testDSInputViewDisabledState() {
        let input = DSInputView()
        input.isDisabled = true
        input.updateAppearance()
        
        XCTAssertEqual(input.alpha, 0.5)
    }
    
    func testDSInputViewStyle() {
        let input = DSInputView()
        
        input.style = .default
        input.updateAppearance()
        XCTAssertNotNil(input.backgroundColor)
        
        input.style = .hover
        input.updateAppearance()
        XCTAssertNotNil(input.backgroundColor)
        
        input.style = .active
        input.updateAppearance()
        XCTAssertNotNil(input.backgroundColor)
        
        input.style = .focus
        input.updateAppearance()
        XCTAssertNotNil(input.backgroundColor)
    }
    
    func testDSInputViewPlaceholder() {
        let input = DSInputView()
        input.placeholder = "Enter value"
        input.updateAppearance()
        
        XCTAssertNotNil(input)
    }
    
    func testDSInputViewOnCommit() {
        let input = DSInputView()
        var committedValue = ""
        input.onCommit = { value in
            committedValue = value
        }
        
        input.onCommit?("hello")
        XCTAssertEqual(committedValue, "hello")
    }
    
    func testDSInputViewValidator() {
        let input = DSInputView()
        input.validator = { $0.allSatisfy(\.isNumber) }
        
        XCTAssertEqual(input.validator?("123"), true)
        XCTAssertEqual(input.validator?("abc"), false)
        XCTAssertEqual(input.validator?(""), true)
    }
    #endif
}
