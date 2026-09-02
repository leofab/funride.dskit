import XCTest
import SwiftUI
@testable import FDSDKit

final class DSSearchTests: XCTestCase {
    
    // MARK: - Token Tests
    
    func testSearchColors() {
        XCTAssertEqual(DSTokens.Colors.inputDefault, Color(hex: "#212426"))
        XCTAssertEqual(DSTokens.Colors.inputHover, Color(hex: "#2e3434"))
        XCTAssertEqual(DSTokens.Colors.inputActive, Color(hex: "#18181a"))
        XCTAssertEqual(DSTokens.Colors.inputBorder, Color(hex: "#7efff5"))
        XCTAssertEqual(DSTokens.Colors.inputText, Color.white)
        XCTAssertEqual(DSTokens.Colors.inputTextDisabled, Color(hex: "#8f9da3"))
    }
    
    func testSearchTypography() {
        XCTAssertEqual(DSTokens.Typography.inputFontSize, 12)
        XCTAssertEqual(DSTokens.Typography.inputFontWeight, .regular)
    }
    
    func testSearchSizing() {
        XCTAssertEqual(DSTokens.Sizing.inputHeight, 32)
        XCTAssertEqual(DSTokens.Sizing.inputRadius, 8)
    }
    
    func testSearchSpacing() {
        XCTAssertEqual(DSTokens.Spacing.inputIconGap, 4)
    }
    
    // MARK: - DSSearchStyle Tests
    
    func testSearchStyleInitialization() {
        let defaultStyle = DSSearchStyle.default
        let hoverStyle = DSSearchStyle.hover
        let activeStyle = DSSearchStyle.active
        let focusStyle = DSSearchStyle.focus
        let disabledStyle = DSSearchStyle.disabled
        
        XCTAssertNotNil(defaultStyle)
        XCTAssertNotNil(hoverStyle)
        XCTAssertNotNil(activeStyle)
        XCTAssertNotNil(focusStyle)
        XCTAssertNotNil(disabledStyle)
    }
    
    func testSearchStyleBackgroundColors() {
        XCTAssertEqual(DSSearchStyle.default.backgroundColor, DSTokens.Colors.inputDefault)
        XCTAssertEqual(DSSearchStyle.hover.backgroundColor, DSTokens.Colors.inputHover)
        XCTAssertEqual(DSSearchStyle.active.backgroundColor, DSTokens.Colors.inputActive)
        XCTAssertEqual(DSSearchStyle.focus.backgroundColor, DSTokens.Colors.inputDefault)
        XCTAssertEqual(DSSearchStyle.disabled.backgroundColor, DSTokens.Colors.inputActive)
    }
    
    func testSearchStyleBorderColors() {
        XCTAssertNil(DSSearchStyle.default.borderColor)
        XCTAssertNil(DSSearchStyle.hover.borderColor)
        XCTAssertEqual(DSSearchStyle.active.borderColor, DSTokens.Colors.inputBorder)
        XCTAssertEqual(DSSearchStyle.focus.borderColor, DSTokens.Colors.inputBorder)
        XCTAssertNil(DSSearchStyle.disabled.borderColor)
    }
    
    func testSearchStyleBorderWidths() {
        XCTAssertEqual(DSSearchStyle.default.borderWidth, 0)
        XCTAssertEqual(DSSearchStyle.hover.borderWidth, 0)
        XCTAssertEqual(DSSearchStyle.active.borderWidth, DSTokens.Borders.widthThin)
        XCTAssertEqual(DSSearchStyle.focus.borderWidth, DSTokens.Borders.widthThin)
        XCTAssertEqual(DSSearchStyle.disabled.borderWidth, 0)
    }
    
    func testSearchStyleTextColors() {
        XCTAssertEqual(DSSearchStyle.default.textColor, DSTokens.Colors.inputText)
        XCTAssertEqual(DSSearchStyle.hover.textColor, DSTokens.Colors.inputText)
        XCTAssertEqual(DSSearchStyle.active.textColor, DSTokens.Colors.inputText)
        XCTAssertEqual(DSSearchStyle.focus.textColor, DSTokens.Colors.inputText)
        XCTAssertEqual(DSSearchStyle.disabled.textColor, DSTokens.Colors.inputTextDisabled)
    }
    
    func testSearchStylePlaceholderColors() {
        XCTAssertEqual(DSSearchStyle.default.placeholderColor, DSTokens.Colors.inputTextDisabled)
        XCTAssertEqual(DSSearchStyle.hover.placeholderColor, DSTokens.Colors.inputTextDisabled)
        XCTAssertEqual(DSSearchStyle.active.placeholderColor, DSTokens.Colors.inputTextDisabled)
        XCTAssertEqual(DSSearchStyle.focus.placeholderColor, DSTokens.Colors.inputTextDisabled)
        XCTAssertEqual(DSSearchStyle.disabled.placeholderColor, DSTokens.Colors.inputTextDisabled)
    }
    
    func testSearchStyleIconColors() {
        XCTAssertEqual(DSSearchStyle.default.iconColor, DSTokens.Colors.inputTextDisabled)
        XCTAssertEqual(DSSearchStyle.hover.iconColor, DSTokens.Colors.inputTextDisabled)
        XCTAssertEqual(DSSearchStyle.active.iconColor, DSTokens.Colors.inputText)
        XCTAssertEqual(DSSearchStyle.focus.iconColor, DSTokens.Colors.inputText)
        XCTAssertEqual(DSSearchStyle.disabled.iconColor, Color(white: 0.35))
    }
    
    func testSearchStyleOpacity() {
        XCTAssertEqual(DSSearchStyle.default.opacity, 1.0)
        XCTAssertEqual(DSSearchStyle.hover.opacity, 1.0)
        XCTAssertEqual(DSSearchStyle.active.opacity, 1.0)
        XCTAssertEqual(DSSearchStyle.focus.opacity, 1.0)
        XCTAssertEqual(DSSearchStyle.disabled.opacity, 0.5)
    }
    
    // MARK: - UIKit Tests
    
    #if canImport(UIKit)
    func testDSSearchViewInitialization() {
        let search = DSSearchView()
        search.text = "Test"
        search.placeholder = "Search..."
        
        XCTAssertEqual(search.text, "Test")
        XCTAssertEqual(search.placeholder, "Search...")
        XCTAssertFalse(search.isDisabled)
        XCTAssertFalse(search.showsFilter)
    }
    
    func testDSSearchViewDisabledState() {
        let search = DSSearchView()
        search.isDisabled = true
        search.updateAppearance()
        
        XCTAssertEqual(search.alpha, 0.5)
    }
    
    func testDSSearchViewStyle() {
        let search = DSSearchView()
        
        search.style = .default
        search.updateAppearance()
        XCTAssertNotNil(search.backgroundColor)
        
        search.style = .hover
        search.updateAppearance()
        XCTAssertNotNil(search.backgroundColor)
        
        search.style = .active
        search.updateAppearance()
        XCTAssertNotNil(search.backgroundColor)
        
        search.style = .focus
        search.updateAppearance()
        XCTAssertNotNil(search.backgroundColor)
    }
    
    func testDSSearchViewPlaceholder() {
        let search = DSSearchView()
        search.placeholder = "Search items..."
        search.updateAppearance()
        
        XCTAssertNotNil(search)
    }
    
    func testDSSearchViewOnSearch() {
        let search = DSSearchView()
        var searchedTerm = ""
        search.onSearch = { term in
            searchedTerm = term
        }
        
        search.onSearch?("test query")
        XCTAssertEqual(searchedTerm, "test query")
    }
    
    func testDSSearchViewOnClear() {
        let search = DSSearchView()
        var cleared = false
        search.onClear = {
            cleared = true
        }
        
        search.onClear?()
        XCTAssertTrue(cleared)
    }
    
    func testDSSearchViewOnFilterTap() {
        let search = DSSearchView()
        var filterTapped = false
        search.onFilterTap = {
            filterTapped = true
        }
        
        search.onFilterTap?()
        XCTAssertTrue(filterTapped)
    }
    
    func testDSSearchViewFilterVisibility() {
        let search = DSSearchView()
        search.showsFilter = true
        search.updateAppearance()
        
        XCTAssertNotNil(search)
    }
    #endif
}
