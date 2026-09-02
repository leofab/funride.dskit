import SwiftUI

/// A selectable option for DSSelect
public struct DSSelectOption: Identifiable, Hashable {
    public let id: String
    public let label: String
    public let icon: String?
    public let value: AnyHashable
    
    public init(id: String, label: String, icon: String? = nil, value: AnyHashable) {
        self.id = id
        self.label = label
        self.icon = icon
        self.value = value
    }
    
    public static func == (lhs: DSSelectOption, rhs: DSSelectOption) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

/// A reusable select component based on Penpot design system
/// Supports single selection from a list of options with dropdown
public struct DSSelect: View {
    @Binding private var selection: String?
    @State private var isDropdownVisible = false
    @State private var isHovered = false
    @State private var isFocused = false
    
    private let options: [DSSelectOption]
    private let placeholder: String
    private let label: String?
    private let style: DSSelectStyle
    private let isDisabled: Bool
    private let onSelect: ((DSSelectOption) -> Void)?
    
    /// Creates a select with selection binding
    /// - Parameters:
    ///   - selection: Binding to the selected option ID
    ///   - options: Array of available options
    ///   - placeholder: Placeholder text when no selection
    ///   - label: Optional label displayed above the select
    ///   - style: Current visual state
    ///   - isDisabled: Whether the select is disabled
    ///   - onSelect: Action when an option is selected
    public init(
        selection: Binding<String?>,
        options: [DSSelectOption],
        placeholder: String = "Select...",
        label: String? = nil,
        style: DSSelectStyle = .default,
        isDisabled: Bool = false,
        onSelect: ((DSSelectOption) -> Void)? = nil
    ) {
        self._selection = selection
        self.options = options
        self.placeholder = placeholder
        self.label = label
        self.style = style
        self.isDisabled = isDisabled
        self.onSelect = onSelect
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: DSTokens.Spacing.xs) {
            // Label
            if let label = label {
                Text(label)
                    .font(.system(size: DSTokens.Typography.selectLabelSize,
                                  weight: DSTokens.Typography.selectLabelWeight))
                    .foregroundColor(currentStyle.textColor)
            }
            
            // Select Button
            selectButton
        }
        .overlay(
            // Dropdown
            GeometryReader { geometry in
                if isDropdownVisible {
                    dropdownView
                        .position(
                            x: geometry.size.width / 2,
                            y: geometry.size.height + DSTokens.Spacing.selectDropdownPadding
                        )
                }
            }
        )
        .onHover { hovering in
            guard !isDisabled else { return }
            isHovered = hovering
        }
    }
    
    // MARK: - Private Views
    
    private var selectButton: some View {
        Button(action: {
            guard !isDisabled else { return }
            toggleDropdown()
        }) {
            HStack(spacing: DSTokens.Spacing.selectIconGap) {
                // Selected text or placeholder
                Text(selectedLabel)
                    .font(.system(size: DSTokens.Typography.selectFontSize,
                                  weight: DSTokens.Typography.selectFontWeight))
                    .foregroundColor(selectedLabel == placeholder ? currentStyle.placeholderColor : currentStyle.textColor)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                Spacer(minLength: 0)
                
                // Chevron
                Image(systemName: isDropdownVisible ? "chevron.up" : "chevron.down")
                    .font(.system(size: DSTokens.Sizing.selectIconSize, weight: .medium))
                    .foregroundColor(currentStyle.chevronColor)
            }
            .padding(.horizontal, DSTokens.Spacing.selectPadding)
            .frame(minWidth: DSTokens.Sizing.selectMinWidth,
                    maxWidth: DSTokens.Sizing.selectMaxWidth)
            .frame(height: DSTokens.Sizing.selectHeight)
            .background(currentStyle.backgroundColor)
            .cornerRadius(DSTokens.Sizing.selectRadius)
            .overlay(
                RoundedRectangle(cornerRadius: DSTokens.Sizing.selectRadius)
                    .stroke(currentStyle.borderColor ?? Color.clear,
                            lineWidth: currentStyle.borderWidth)
            )
            .opacity(currentStyle.opacity)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isDisabled)
    }
    
    private var dropdownView: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(options) { option in
                    optionRow(option)
                }
            }
            .padding(DSTokens.Spacing.selectDropdownPadding)
        }
        .background(DSTokens.Colors.selectDropdownBackground)
        .cornerRadius(DSTokens.Sizing.selectRadius)
        .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
        .frame(maxHeight: DSTokens.Sizing.selectDropdownMaxHeight)
    }
    
    private func optionRow(_ option: DSSelectOption) -> some View {
        Button(action: {
            selectOption(option)
        }) {
            HStack(spacing: DSTokens.Spacing.selectIconGap) {
                // Option icon
                if let iconName = option.icon {
                    Image(systemName: iconName)
                        .font(.system(size: DSTokens.Sizing.selectIconSize))
                        .foregroundColor(DSTokens.Colors.selectText)
                }
                
                // Option label
                Text(option.label)
                    .font(.system(size: DSTokens.Typography.selectFontSize,
                                  weight: DSTokens.Typography.selectFontWeight))
                    .foregroundColor(DSTokens.Colors.selectText)
                    .lineLimit(1)
                
                Spacer()
                
                // Checkmark for selected option
                if selection == option.id {
                    Image(systemName: "checkmark")
                        .font(.system(size: DSTokens.Sizing.selectIconSize, weight: .medium))
                        .foregroundColor(DSTokens.Colors.selectFocus)
                }
            }
            .padding(.horizontal, DSTokens.Spacing.selectOptionPadding)
            .frame(height: DSTokens.Sizing.selectOptionHeight)
            .background(optionBackground(for: option))
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Computed Properties
    
    private var currentStyle: DSSelectStyle {
        if isDisabled {
            return .disabled
        } else if isFocused {
            return .focus
        } else if isHovered {
            return .hover
        } else {
            return style
        }
    }
    
    private var selectedLabel: String {
        guard let selection = selection,
              let selectedOption = options.first(where: { $0.id == selection }) else {
            return placeholder
        }
        return selectedOption.label
    }
    
    // MARK: - Private Methods
    
    private func toggleDropdown() {
        isDropdownVisible.toggle()
        isFocused = isDropdownVisible
    }
    
    private func selectOption(_ option: DSSelectOption) {
        selection = option.id
        isDropdownVisible = false
        isFocused = false
        onSelect?(option)
    }
    
    private func optionBackground(for option: DSSelectOption) -> Color {
        if selection == option.id {
            return DSTokens.Colors.selectOptionSelected
        }
        return Color.clear
    }
}

// MARK: - Preview
#if DEBUG
struct DSSelect_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 24) {
            Text("Select Component")
                .font(.headline)
                .foregroundColor(.white)
            
            DSSelectPreview()
        }
        .padding()
        .background(Color.black)
        .previewLayout(.sizeThatFits)
    }
}

struct DSSelectPreview: View {
    @State private var selection1: String? = "option1"
    @State private var selection2: String? = nil
    @State private var selection3: String? = "option1"
    @State private var selection4: String? = "option1"
    @State private var selection5: String? = "option1"
    @State private var selection6: String? = "option1"
    @State private var selection7: String? = "option1"
    @State private var selection8: String? = nil
    
    var body: some View {
        VStack(spacing: 24) {
            DSSelect(
                selection: $selection1,
                options: [
                    DSSelectOption(id: "option1", label: "Option 1", value: "1"),
                    DSSelectOption(id: "option2", label: "Option 2", value: "2"),
                    DSSelectOption(id: "option3", label: "Option 3", value: "3"),
                    DSSelectOption(id: "option4", label: "Option 4", value: "4")
                ],
                placeholder: "Choose an option",
                label: "Label"
            )
            
            DSSelect(
                selection: $selection2,
                options: [
                    DSSelectOption(id: "option1", label: "Option 1", value: "1"),
                    DSSelectOption(id: "option2", label: "Option 2", value: "2"),
                    DSSelectOption(id: "option3", label: "Option 3", value: "3")
                ],
                placeholder: "Select..."
            )
            
            DSSelect(
                selection: $selection3,
                options: [
                    DSSelectOption(id: "option1", label: "Option A", value: "a"),
                    DSSelectOption(id: "option2", label: "Option B", value: "b"),
                    DSSelectOption(id: "option3", label: "Option C", value: "c")
                ],
                label: "Disabled",
                isDisabled: true
            )
            
            Text("States")
                .font(.headline)
                .foregroundColor(.white)
            
            VStack(spacing: 16) {
                DSSelect(
                    selection: $selection4,
                    options: [
                        DSSelectOption(id: "option1", label: "Default", value: "1"),
                        DSSelectOption(id: "option2", label: "Other", value: "2")
                    ],
                    style: .default
                )
                
                DSSelect(
                    selection: $selection5,
                    options: [
                        DSSelectOption(id: "option1", label: "Hover", value: "1"),
                        DSSelectOption(id: "option2", label: "Other", value: "2")
                    ],
                    style: .hover
                )
                
                DSSelect(
                    selection: $selection6,
                    options: [
                        DSSelectOption(id: "option1", label: "Focus", value: "1"),
                        DSSelectOption(id: "option2", label: "Other", value: "2")
                    ],
                    style: .focus
                )
                
                DSSelect(
                    selection: $selection7,
                    options: [
                        DSSelectOption(id: "option1", label: "Disabled", value: "1"),
                        DSSelectOption(id: "option2", label: "Other", value: "2")
                    ],
                    isDisabled: true
                )
            }
            
            Text("With Icons")
                .font(.headline)
                .foregroundColor(.white)
            
            DSSelect(
                selection: $selection8,
                options: [
                    DSSelectOption(id: "star", label: "Starred", icon: "star.fill", value: "star"),
                    DSSelectOption(id: "heart", label: "Favorite", icon: "heart.fill", value: "heart"),
                    DSSelectOption(id: "bell", label: "Notifications", icon: "bell.fill", value: "bell")
                ],
                placeholder: "Choose icon..."
            )
        }
    }
}
#endif
