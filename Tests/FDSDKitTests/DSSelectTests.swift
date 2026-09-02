import XCTest
import SwiftUI
@testable import FDSDKit

final class DSSelectTests: XCTestCase {

    // MARK: - Token Tests

    func testSelectColors() {
        XCTAssertEqual(DSTokens.Colors.selectDefault, Color(hex: "#212426"))
        XCTAssertEqual(DSTokens.Colors.selectHover, Color(hex: "#2e3434"))
        XCTAssertEqual(DSTokens.Colors.selectFocus, Color(hex: "#7efff5"))
        XCTAssertEqual(DSTokens.Colors.selectDisabled, Color(hex: "#18181a"))
        XCTAssertEqual(DSTokens.Colors.selectText, Color.white)
        XCTAssertEqual(DSTokens.Colors.selectTextDisabled, Color(hex: "#8f9da3"))
        XCTAssertEqual(DSTokens.Colors.selectBorder, Color(hex: "#7efff5"))
        XCTAssertEqual(DSTokens.Colors.selectDropdownBackground, Color(hex: "#212426"))
        XCTAssertEqual(DSTokens.Colors.selectOptionHover, Color(hex: "#2e3434"))
        XCTAssertEqual(DSTokens.Colors.selectOptionSelected, Color(hex: "#2e3434"))
    }

    func testSelectTypography() {
        XCTAssertEqual(DSTokens.Typography.selectFontSize, 12)
        XCTAssertEqual(DSTokens.Typography.selectFontWeight, .regular)
        XCTAssertEqual(DSTokens.Typography.selectLabelSize, 12)
        XCTAssertEqual(DSTokens.Typography.selectLabelWeight, .medium)
    }

    func testSelectSizing() {
        XCTAssertEqual(DSTokens.Sizing.selectHeight, 32)
        XCTAssertEqual(DSTokens.Sizing.selectMinWidth, 120)
        XCTAssertEqual(DSTokens.Sizing.selectMaxWidth, 248)
        XCTAssertEqual(DSTokens.Sizing.selectRadius, 8)
        XCTAssertEqual(DSTokens.Sizing.selectIconSize, 16)
        XCTAssertEqual(DSTokens.Sizing.selectDropdownMaxHeight, 200)
        XCTAssertEqual(DSTokens.Sizing.selectOptionHeight, 32)
    }

    func testSelectSpacing() {
        XCTAssertEqual(DSTokens.Spacing.selectPadding, 8)
        XCTAssertEqual(DSTokens.Spacing.selectIconGap, 4)
        XCTAssertEqual(DSTokens.Spacing.selectOptionPadding, 8)
        XCTAssertEqual(DSTokens.Spacing.selectOptionGap, 4)
        XCTAssertEqual(DSTokens.Spacing.selectDropdownPadding, 4)
    }

    // MARK: - DSSelectStyle Tests

    func testStyleInitialization() {
        XCTAssertNotNil(DSSelectStyle.default)
        XCTAssertNotNil(DSSelectStyle.hover)
        XCTAssertNotNil(DSSelectStyle.focus)
        XCTAssertNotNil(DSSelectStyle.disabled)
    }

    func testStyleBackgroundColors() {
        XCTAssertEqual(DSSelectStyle.default.backgroundColor, DSTokens.Colors.selectDefault)
        XCTAssertEqual(DSSelectStyle.hover.backgroundColor, DSTokens.Colors.selectHover)
        XCTAssertEqual(DSSelectStyle.focus.backgroundColor, DSTokens.Colors.selectDefault)
        XCTAssertEqual(DSSelectStyle.disabled.backgroundColor, DSTokens.Colors.selectDisabled)
    }

    func testStyleBorderColors() {
        XCTAssertNil(DSSelectStyle.default.borderColor)
        XCTAssertNil(DSSelectStyle.hover.borderColor)
        XCTAssertEqual(DSSelectStyle.focus.borderColor, DSTokens.Colors.selectBorder)
        XCTAssertNil(DSSelectStyle.disabled.borderColor)
    }

    func testStyleBorderWidths() {
        XCTAssertEqual(DSSelectStyle.default.borderWidth, 0)
        XCTAssertEqual(DSSelectStyle.hover.borderWidth, 0)
        XCTAssertEqual(DSSelectStyle.focus.borderWidth, DSTokens.Borders.widthThin)
        XCTAssertEqual(DSSelectStyle.disabled.borderWidth, 0)
    }

    func testStyleTextColors() {
        XCTAssertEqual(DSSelectStyle.default.textColor, DSTokens.Colors.selectText)
        XCTAssertEqual(DSSelectStyle.hover.textColor, DSTokens.Colors.selectText)
        XCTAssertEqual(DSSelectStyle.focus.textColor, DSTokens.Colors.selectText)
        XCTAssertEqual(DSSelectStyle.disabled.textColor, DSTokens.Colors.selectTextDisabled)
    }

    func testStylePlaceholderColors() {
        XCTAssertEqual(DSSelectStyle.default.placeholderColor, DSTokens.Colors.selectTextDisabled)
        XCTAssertEqual(DSSelectStyle.hover.placeholderColor, DSTokens.Colors.selectTextDisabled)
        XCTAssertEqual(DSSelectStyle.focus.placeholderColor, DSTokens.Colors.selectTextDisabled)
        XCTAssertEqual(DSSelectStyle.disabled.placeholderColor, DSTokens.Colors.selectTextDisabled)
    }

    func testStyleChevronColors() {
        XCTAssertEqual(DSSelectStyle.default.chevronColor, DSTokens.Colors.selectText)
        XCTAssertEqual(DSSelectStyle.hover.chevronColor, DSTokens.Colors.selectText)
        XCTAssertEqual(DSSelectStyle.focus.chevronColor, DSTokens.Colors.selectText)
        XCTAssertEqual(DSSelectStyle.disabled.chevronColor, DSTokens.Colors.selectTextDisabled)
    }

    func testStyleOpacity() {
        XCTAssertEqual(DSSelectStyle.default.opacity, 1.0)
        XCTAssertEqual(DSSelectStyle.hover.opacity, 1.0)
        XCTAssertEqual(DSSelectStyle.focus.opacity, 1.0)
        XCTAssertEqual(DSSelectStyle.disabled.opacity, 0.5)
    }

    // MARK: - DSSelectOption Tests

    func testOptionInitialization() {
        let option = DSSelectOption(id: "1", label: "One", value: "one")
        XCTAssertEqual(option.id, "1")
        XCTAssertEqual(option.label, "One")
        XCTAssertEqual(option.icon, nil)
        XCTAssertEqual(option.value as? String, "one")
    }

    func testOptionWithIcon() {
        let option = DSSelectOption(id: "star", label: "Star", icon: "star.fill", value: 1)
        XCTAssertEqual(option.icon, "star.fill")
    }

    func testOptionEqualityById() {
        let a = DSSelectOption(id: "1", label: "One", value: "one")
        let b = DSSelectOption(id: "1", label: "Two", value: "two")
        XCTAssertEqual(a, b, "Options with the same id should be equal")
    }

    func testOptionInequalityByDifferentId() {
        let a = DSSelectOption(id: "1", label: "One", value: "one")
        let b = DSSelectOption(id: "2", label: "One", value: "one")
        XCTAssertNotEqual(a, b, "Options with different ids should not be equal")
    }

    func testOptionHashable() {
        let a = DSSelectOption(id: "1", label: "One", value: "one")
        let b = DSSelectOption(id: "1", label: "Two", value: "two")
        XCTAssertEqual(a.hashValue, b.hashValue, "Options with the same id should hash equally")
    }

    func testOptionIdentifiable() {
        let option = DSSelectOption(id: "abc", label: "ABC", value: "abc")
        var set = Set<DSSelectOption>()
        set.insert(option)
        XCTAssertEqual(set.count, 1, "Set should contain one option")
    }

    // MARK: - DSSelectOption Value Types

    func testOptionStringValue() {
        let option = DSSelectOption(id: "1", label: "One", value: "hello")
        XCTAssertEqual(option.value as? String, "hello")
    }

    func testOptionIntValue() {
        let option = DSSelectOption(id: "1", label: "One", value: 42)
        XCTAssertEqual(option.value as? Int, 42)
    }

    func testOptionBoolValue() {
        let option = DSSelectOption(id: "flag", label: "Flag", value: true)
        XCTAssertEqual(option.value as? Bool, true)
    }

    // MARK: - Edge Case Tests

    func testEmptyOptionsArray() {
        let options: [DSSelectOption] = []
        XCTAssertTrue(options.isEmpty)
    }

    func testSingleOptionArray() {
        let options = [DSSelectOption(id: "only", label: "Only", value: "only")]
        XCTAssertEqual(options.count, 1)
    }

    func testOptionWithEmptyLabel() {
        let option = DSSelectOption(id: "1", label: "", value: "one")
        XCTAssertEqual(option.label, "")
    }

    func testOptionWithEmptyId() {
        let option = DSSelectOption(id: "", label: "Empty", value: "empty")
        XCTAssertEqual(option.id, "")
    }

    func testOptionWithWhitespaceLabel() {
        let option = DSSelectOption(id: "1", label: "  ", value: "space")
        XCTAssertEqual(option.label, "  ")
    }

    func testOptionWithSpecialCharacters() {
        let option = DSSelectOption(id: "1", label: "Option @#$%", value: "special")
        XCTAssertEqual(option.label, "Option @#$%")
    }

    func testMultipleOptionsUniqueIds() {
        let options = [
            DSSelectOption(id: "a", label: "A", value: "a"),
            DSSelectOption(id: "b", label: "B", value: "b"),
            DSSelectOption(id: "c", label: "C", value: "c")
        ]
        let ids = options.map { $0.id }
        XCTAssertEqual(Set(ids).count, 3, "All ids should be unique")
    }

    // MARK: - UIKit Tests

    #if canImport(UIKit)
    func testUIViewInitialization() {
        let view = DSSelectView()
        XCTAssertNotNil(view)
    }

    func testUIViewDefaultProperties() {
        let view = DSSelectView()
        XCTAssertNil(view.selection)
        XCTAssertNil(view.labelText)
        XCTAssertTrue(view.placeholder.isEmpty == false)
        XCTAssertFalse(view.isDisabled)
    }

    func testUIViewOptions() {
        let view = DSSelectView()
        let options = [
            DSSelectOption(id: "1", label: "One", value: "one"),
            DSSelectOption(id: "2", label: "Two", value: "two")
        ]
        view.options = options
        XCTAssertEqual(view.options.count, 2)
    }

    func testUIViewSelection() {
        let view = DSSelectView()
        view.options = [
            DSSelectOption(id: "1", label: "One", value: "one"),
            DSSelectOption(id: "2", label: "Two", value: "two")
        ]
        view.selection = "1"
        XCTAssertEqual(view.selection, "1")
    }

    func testUIViewPlaceholder() {
        let view = DSSelectView()
        view.placeholder = "Choose..."
        XCTAssertEqual(view.placeholder, "Choose...")
    }

    func testUIViewLabel() {
        let view = DSSelectView()
        view.labelText = "Country"
        XCTAssertEqual(view.labelText, "Country")
    }

    func testUIViewStyle() {
        let view = DSSelectView()
        view.style = .hover
        XCTAssertEqual(view.style, .hover)
    }

    func testUIViewDisabledState() {
        let view = DSSelectView()
        view.isDisabled = true
        view.updateAppearance()
        XCTAssertEqual(view.alpha, 0.5)
    }

    func testUIViewEnabledState() {
        let view = DSSelectView()
        view.isDisabled = false
        view.updateAppearance()
        XCTAssertEqual(view.alpha, 1.0)
    }

    func testUIViewOnSelectCallback() {
        let view = DSSelectView()
        var selectedOption: DSSelectOption?
        view.onSelect = { option in
            selectedOption = option
        }

        let option = DSSelectOption(id: "1", label: "One", value: "one")
        view.onSelect?(option)

        XCTAssertEqual(selectedOption?.id, "1")
        XCTAssertEqual(selectedOption?.label, "One")
    }

    func testUIViewUpdateAppearanceAlpha() {
        let view = DSSelectView()
        view.isDisabled = false
        view.updateAppearance()
        XCTAssertEqual(view.alpha, 1.0)
    }

    func testUIViewStyleChangeUpdatesAlpha() {
        let view = DSSelectView()
        view.style = .default
        view.updateAppearance()
        XCTAssertEqual(view.alpha, 1.0)

        view.style = .disabled
        view.updateAppearance()
        XCTAssertEqual(view.alpha, 0.5)
    }

    func testUIViewSelectionChangeUpdatesLabel() {
        let view = DSSelectView()
        view.options = [
            DSSelectOption(id: "1", label: "Apple", value: "apple"),
            DSSelectOption(id: "2", label: "Banana", value: "banana")
        ]
        view.selection = "2"
        XCTAssertEqual(view.selection, "2")
    }

    func testUIViewEmptySelection() {
        let view = DSSelectView()
        view.options = [
            DSSelectOption(id: "1", label: "One", value: "one")
        ]
        view.selection = nil
        XCTAssertNil(view.selection)
    }

    func testUIViewLabelHiddenWhenNil() {
        let view = DSSelectView()
        view.labelText = nil
        view.updateAppearance()
        XCTAssertNil(view.labelText)
    }

    func testUIViewLabelVisibleWhenSet() {
        let view = DSSelectView()
        view.labelText = "Pick one"
        XCTAssertEqual(view.labelText, "Pick one")
    }

    // MARK: - UIKit Delegate Tests

    func testDelegatePropertyIsSettable() {
        let view = DSSelectView()
        let delegate = MockSelectDelegate()
        view.delegate = delegate
        XCTAssertTrue(view.delegate === delegate)
    }

    func testDelegateConformsToProtocol() {
        let delegate = MockSelectDelegate()
        XCTAssertTrue(delegate is DSSelectViewDelegate)
    }

    // MARK: - UIKit Coordinator Tests

    func testCoordinatorInvokesOnSelect() {
        var receivedOption: DSSelectOption?
        let view = DSSelectUIView(
            selection: .constant(nil),
            options: [DSSelectOption(id: "1", label: "One", value: "one")],
            onSelect: { receivedOption = $0 }
        )
        let coordinator = view.makeCoordinator()

        let option = DSSelectOption(id: "1", label: "One", value: "one")
        let mockView = DSSelectView()
        coordinator.selectView(mockView, didSelectOption: option)

        XCTAssertEqual(receivedOption?.id, "1")
    }

    // MARK: - UIKit Multiple Selections

    func testMultipleSelections() {
        let view = DSSelectView()
        view.options = [
            DSSelectOption(id: "a", label: "A", value: "a"),
            DSSelectOption(id: "b", label: "B", value: "b"),
            DSSelectOption(id: "c", label: "C", value: "c")
        ]
        view.selection = "a"
        XCTAssertEqual(view.selection, "a")

        view.selection = "c"
        XCTAssertEqual(view.selection, "c")
    }

    func testSelectionResetsToNil() {
        let view = DSSelectView()
        view.options = [DSSelectOption(id: "1", label: "One", value: "one")]
        view.selection = "1"
        XCTAssertEqual(view.selection, "1")

        view.selection = nil
        XCTAssertNil(view.selection)
    }
    #endif
}

// MARK: - Mock Helpers

#if canImport(UIKit)
private class MockSelectDelegate: DSSelectViewDelegate {
    func selectView(_ selectView: DSSelectView, didSelectOption option: DSSelectOption) {}
}
#endif
