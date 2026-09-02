import XCTest
import SwiftUI
@testable import FDSDKit

final class DSTextAreaTests: XCTestCase {
    
    // MARK: - Token Tests
    
    func testTextAreaColors() {
        XCTAssertEqual(DSTokens.Colors.textAreaDefault, Color(hex: "#212426"))
        XCTAssertEqual(DSTokens.Colors.textAreaHover, Color(hex: "#2e3434"))
        XCTAssertEqual(DSTokens.Colors.textAreaActive, Color(hex: "#000000"))
        XCTAssertEqual(DSTokens.Colors.textAreaDisabled, Color(hex: "#18181a"))
        XCTAssertEqual(DSTokens.Colors.textAreaText, Color(hex: "#ffffff"))
        XCTAssertEqual(DSTokens.Colors.textAreaTextPlaceholder, Color(hex: "#8f9da3"))
        XCTAssertEqual(DSTokens.Colors.textAreaBorderFocus, Color(hex: "#7efff5"))
        XCTAssertEqual(DSTokens.Colors.textAreaBorderSuccess, Color(hex: "#00d1b8"))
        XCTAssertEqual(DSTokens.Colors.textAreaBorderError, Color(hex: "#ff3277"))
        XCTAssertEqual(DSTokens.Colors.textAreaBorderDisabled, Color(hex: "#2e3434"))
    }
    
    func testTextAreaTypography() {
        XCTAssertEqual(DSTokens.Typography.textAreaFontSize, 12)
        XCTAssertEqual(DSTokens.Typography.textAreaFontWeight, .regular)
        XCTAssertEqual(DSTokens.Typography.textAreaLabelSize, 12)
        XCTAssertEqual(DSTokens.Typography.textAreaLabelWeight, .medium)
    }
    
    func testTextAreaSizing() {
        XCTAssertEqual(DSTokens.Sizing.textAreaHeight, 96)
        XCTAssertEqual(DSTokens.Sizing.textAreaWidth, 228)
        XCTAssertEqual(DSTokens.Sizing.textAreaRadius, 8)
    }
    
    func testTextAreaSpacing() {
        XCTAssertEqual(DSTokens.Spacing.textAreaPadding, 8)
    }
    
    // MARK: - DSTextAreaStyle Tests
    
    func testTextAreaStyleInitialization() {
        let emptyStyle = DSTextAreaStyle.empty
        let defaultStyle = DSTextAreaStyle.default
        let hoverStyle = DSTextAreaStyle.hover
        let activeStyle = DSTextAreaStyle.active
        let focusStyle = DSTextAreaStyle.focus
        let disabledStyle = DSTextAreaStyle.disabled
        let successStyle = DSTextAreaStyle.success
        let errorStyle = DSTextAreaStyle.error
        
        XCTAssertNotNil(emptyStyle)
        XCTAssertNotNil(defaultStyle)
        XCTAssertNotNil(hoverStyle)
        XCTAssertNotNil(activeStyle)
        XCTAssertNotNil(focusStyle)
        XCTAssertNotNil(disabledStyle)
        XCTAssertNotNil(successStyle)
        XCTAssertNotNil(errorStyle)
    }
    
    func testTextAreaStyleBackgroundColors() {
        XCTAssertEqual(DSTextAreaStyle.empty.backgroundColor, DSTokens.Colors.textAreaDefault)
        XCTAssertEqual(DSTextAreaStyle.default.backgroundColor, DSTokens.Colors.textAreaDefault)
        XCTAssertEqual(DSTextAreaStyle.hover.backgroundColor, DSTokens.Colors.textAreaHover)
        XCTAssertEqual(DSTextAreaStyle.active.backgroundColor, DSTokens.Colors.textAreaActive)
        XCTAssertEqual(DSTextAreaStyle.focus.backgroundColor, DSTokens.Colors.textAreaHover)
        XCTAssertEqual(DSTextAreaStyle.disabled.backgroundColor, DSTokens.Colors.textAreaDisabled)
        XCTAssertEqual(DSTextAreaStyle.success.backgroundColor, DSTokens.Colors.textAreaHover)
        XCTAssertEqual(DSTextAreaStyle.error.backgroundColor, DSTokens.Colors.textAreaHover)
    }
    
    func testTextAreaStyleBorderColors() {
        XCTAssertNil(DSTextAreaStyle.empty.borderColor)
        XCTAssertNil(DSTextAreaStyle.default.borderColor)
        XCTAssertNil(DSTextAreaStyle.hover.borderColor)
        XCTAssertEqual(DSTextAreaStyle.active.borderColor, DSTokens.Colors.textAreaBorderFocus)
        XCTAssertEqual(DSTextAreaStyle.focus.borderColor, DSTokens.Colors.textAreaBorderFocus)
        XCTAssertEqual(DSTextAreaStyle.disabled.borderColor, DSTokens.Colors.textAreaBorderDisabled)
        XCTAssertEqual(DSTextAreaStyle.success.borderColor, DSTokens.Colors.textAreaBorderSuccess)
        XCTAssertEqual(DSTextAreaStyle.error.borderColor, DSTokens.Colors.textAreaBorderError)
    }
    
    func testTextAreaStyleBorderWidths() {
        XCTAssertEqual(DSTextAreaStyle.empty.borderWidth, 0)
        XCTAssertEqual(DSTextAreaStyle.default.borderWidth, 0)
        XCTAssertEqual(DSTextAreaStyle.hover.borderWidth, 0)
        XCTAssertEqual(DSTextAreaStyle.active.borderWidth, DSTokens.Borders.widthThin)
        XCTAssertEqual(DSTextAreaStyle.focus.borderWidth, DSTokens.Borders.widthThin)
        XCTAssertEqual(DSTextAreaStyle.disabled.borderWidth, DSTokens.Borders.widthThin)
        XCTAssertEqual(DSTextAreaStyle.success.borderWidth, DSTokens.Borders.widthThin)
        XCTAssertEqual(DSTextAreaStyle.error.borderWidth, DSTokens.Borders.widthThin)
    }
    
    func testTextAreaStyleTextColors() {
        XCTAssertEqual(DSTextAreaStyle.empty.textColor, DSTokens.Colors.textAreaTextPlaceholder)
        XCTAssertEqual(DSTextAreaStyle.default.textColor, DSTokens.Colors.textAreaText)
        XCTAssertEqual(DSTextAreaStyle.hover.textColor, DSTokens.Colors.textAreaText)
        XCTAssertEqual(DSTextAreaStyle.active.textColor, DSTokens.Colors.textAreaText)
        XCTAssertEqual(DSTextAreaStyle.focus.textColor, DSTokens.Colors.textAreaText)
        XCTAssertEqual(DSTextAreaStyle.disabled.textColor, DSTokens.Colors.textAreaTextPlaceholder)
        XCTAssertEqual(DSTextAreaStyle.success.textColor, DSTokens.Colors.textAreaText)
        XCTAssertEqual(DSTextAreaStyle.error.textColor, DSTokens.Colors.textAreaText)
    }
    
    func testTextAreaStylePlaceholderColors() {
        XCTAssertEqual(DSTextAreaStyle.empty.placeholderColor, DSTokens.Colors.textAreaTextPlaceholder)
        XCTAssertEqual(DSTextAreaStyle.default.placeholderColor, DSTokens.Colors.textAreaTextPlaceholder)
        XCTAssertEqual(DSTextAreaStyle.hover.placeholderColor, DSTokens.Colors.textAreaTextPlaceholder)
        XCTAssertEqual(DSTextAreaStyle.active.placeholderColor, DSTokens.Colors.textAreaTextPlaceholder)
        XCTAssertEqual(DSTextAreaStyle.focus.placeholderColor, DSTokens.Colors.textAreaTextPlaceholder)
        XCTAssertEqual(DSTextAreaStyle.disabled.placeholderColor, DSTokens.Colors.textAreaTextPlaceholder)
        XCTAssertEqual(DSTextAreaStyle.success.placeholderColor, DSTokens.Colors.textAreaTextPlaceholder)
        XCTAssertEqual(DSTextAreaStyle.error.placeholderColor, DSTokens.Colors.textAreaTextPlaceholder)
    }
    
    func testTextAreaStyleOpacity() {
        XCTAssertEqual(DSTextAreaStyle.empty.opacity, 1.0)
        XCTAssertEqual(DSTextAreaStyle.default.opacity, 1.0)
        XCTAssertEqual(DSTextAreaStyle.hover.opacity, 1.0)
        XCTAssertEqual(DSTextAreaStyle.active.opacity, 1.0)
        XCTAssertEqual(DSTextAreaStyle.focus.opacity, 1.0)
        XCTAssertEqual(DSTextAreaStyle.disabled.opacity, 0.5)
        XCTAssertEqual(DSTextAreaStyle.success.opacity, 1.0)
        XCTAssertEqual(DSTextAreaStyle.error.opacity, 1.0)
    }
    
    // MARK: - UIKit Tests
    
    #if canImport(UIKit)
    func testDSTextAreaViewInitialization() {
        let textView = DSTextAreaView()
        textView.text = "Test content"
        textView.label = "Description"
        textView.placeholder = "Enter text"
        
        XCTAssertEqual(textView.text, "Test content")
        XCTAssertEqual(textView.label, "Description")
        XCTAssertEqual(textView.placeholder, "Enter text")
        XCTAssertFalse(textView.isDisabled)
    }
    
    func testDSTextAreaViewDisabledState() {
        let textView = DSTextAreaView()
        textView.isDisabled = true
        textView.updateAppearance()
        
        XCTAssertEqual(textView.alpha, 0.5)
    }
    
    func testDSTextAreaViewStyle() {
        let textView = DSTextAreaView()
        
        textView.style = .default
        textView.updateAppearance()
        XCTAssertNotNil(textView.backgroundColor)
        
        textView.style = .hover
        textView.updateAppearance()
        XCTAssertNotNil(textView.backgroundColor)
        
        textView.style = .active
        textView.updateAppearance()
        XCTAssertNotNil(textView.backgroundColor)
        
        textView.style = .focus
        textView.updateAppearance()
        XCTAssertNotNil(textView.backgroundColor)
        
        textView.style = .disabled
        textView.updateAppearance()
        XCTAssertNotNil(textView.backgroundColor)
        
        textView.style = .success
        textView.updateAppearance()
        XCTAssertNotNil(textView.backgroundColor)
        
        textView.style = .error
        textView.updateAppearance()
        XCTAssertNotNil(textView.backgroundColor)
    }
    
    func testDSTextAreaViewPlaceholder() {
        let textView = DSTextAreaView()
        textView.placeholder = "Enter description"
        textView.updateAppearance()
        
        XCTAssertNotNil(textView)
    }
    
    func testDSTextAreaViewOnCommit() {
        let textView = DSTextAreaView()
        var committedValue = ""
        textView.onCommit = { value in
            committedValue = value
        }
        
        textView.onCommit?("hello world")
        XCTAssertEqual(committedValue, "hello world")
    }
    
    func testDSTextAreaViewValidator() {
        let textView = DSTextAreaView()
        textView.validator = { $0.count <= 100 }
        
        XCTAssertEqual(textView.validator?("short"), true)
        XCTAssertEqual(textView.validator?(String(repeating: "a", count: 100)), true)
        XCTAssertEqual(textView.validator?(String(repeating: "a", count: 101)), false)
        XCTAssertEqual(textView.validator?(""), true)
    }
    #endif
}
