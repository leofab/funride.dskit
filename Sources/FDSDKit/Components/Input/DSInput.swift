import SwiftUI

/// A reusable input component based on Penpot design system
/// Supports text/number input with optional color swatch
public struct DSInput: View {
    @Binding private var text: String
    @State private var internalText: String = ""
    @State private var isFocused: Bool = false
    @State private var isHovered: Bool = false
    
    private let placeholder: String
    private let style: DSInputStyle
    private let isDisabled: Bool
    private let showsSwatch: Bool
    private let swatchColor: Color
    private let onSwatchTap: (() -> Void)?
    private let onCommit: ((String) -> Void)?
    private let validator: ((String) -> Bool)?
    
    /// Creates an input with text binding
    /// - Parameters:
    ///   - text: Binding to the input text value
    ///   - placeholder: Placeholder text when empty
    ///   - style: Current visual state
    ///   - isDisabled: Whether the input is disabled
    ///   - showsSwatch: Whether to show the color swatch
    ///   - swatchColor: Color to display in the swatch
    ///   - onSwatchTap: Action when swatch is tapped
    ///   - onCommit: Action when content is saved (Enter or focus lost)
    ///   - validator: Validation closure, returns true if valid
    public init(
        text: Binding<String>,
        placeholder: String = "",
        style: DSInputStyle = .default,
        isDisabled: Bool = false,
        showsSwatch: Bool = false,
        swatchColor: Color = .white,
        onSwatchTap: (() -> Void)? = nil,
        onCommit: ((String) -> Void)? = nil,
        validator: ((String) -> Bool)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.style = style
        self.isDisabled = isDisabled
        self.showsSwatch = showsSwatch
        self.swatchColor = swatchColor
        self.onSwatchTap = onSwatchTap
        self.onCommit = onCommit
        self.validator = validator
    }
    
    public var body: some View {
        HStack(spacing: DSTokens.Spacing.inputIconGap) {
            // Color Swatch (optional)
            if showsSwatch {
                swatchButton
            }
            
            // Text Field
            textField
        }
        .frame(height: DSTokens.Sizing.inputHeight)
        .background(currentStyle.backgroundColor)
        .cornerRadius(DSTokens.Sizing.inputRadius)
        .overlay(
            RoundedRectangle(cornerRadius: DSTokens.Sizing.inputRadius)
                .stroke(currentStyle.borderColor ?? Color.clear,
                        lineWidth: currentStyle.borderWidth)
        )
        .opacity(currentStyle.opacity)
        .disabled(isDisabled)
        .onHover { hovering in
            guard !isDisabled else { return }
            isHovered = hovering
        }
        .onAppear {
            internalText = text
        }
        .onChange(of: text) { newValue in
            internalText = newValue
        }
    }
    
    // MARK: - Private Views
    
    private var swatchButton: some View {
        Button(action: {
            onSwatchTap?()
        }) {
            RoundedRectangle(cornerRadius: 4)
                .fill(swatchColor)
                .frame(width: DSTokens.Sizing.inputSwatchSize,
                       height: DSTokens.Sizing.inputSwatchSize)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.leading, DSTokens.Spacing.inputIconGap)
    }
    
    private var textField: some View {
        ZStack(alignment: .leading) {
            if internalText.isEmpty {
                Text(placeholder)
                    .font(.system(size: DSTokens.Typography.inputFontSize,
                                  weight: DSTokens.Typography.inputFontWeight))
                    .foregroundColor(currentStyle.placeholderColor)
            }
            TextField("", text: $internalText, onEditingChanged: { editing in
                if editing {
                    isFocused = true
                } else {
                    commitChanges()
                    isFocused = false
                }
            }, onCommit: {
                commitChanges()
                isFocused = false
            })
            .font(.system(size: DSTokens.Typography.inputFontSize,
                          weight: DSTokens.Typography.inputFontWeight))
            .foregroundColor(currentStyle.textColor)
            .disableAutocorrection(true)
            #if os(iOS)
            .textInputAutocapitalization(.never)
            #endif
        }
        .padding(.horizontal, DSTokens.Spacing.sm)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Computed Properties
    
    private var currentStyle: DSInputStyle {
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
    
    // MARK: - Private Methods
    
    private func commitChanges() {
        let value = internalText
        
        // Validate if validator is provided
        if let validator = validator, !validator(value) {
            // Invalid: revert to previous valid value
            internalText = text
            return
        }
        
        // Save the new value
        text = value
        onCommit?(value)
    }
}

// MARK: - Preview
#if DEBUG
struct DSInput_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            Text("Basic Input")
                .font(.headline)
                .foregroundColor(.white)
            
            DSInput(text: .constant(""), placeholder: "Enter text...")
            DSInput(text: .constant("FF6FE0"))
            DSInput(text: .constant("Disabled"), isDisabled: true)
            
            Divider()
                .foregroundColor(.gray)
            
            Text("With Swatch")
                .font(.headline)
                .foregroundColor(.white)
            
            DSInput(text: .constant("FF6FE0"),
                    showsSwatch: true,
                    swatchColor: Color(.sRGB, red: 1, green: 0.4, blue: 0.87))
            
            DSInput(text: .constant("FF6FE0"),
                    isDisabled: true,
                    showsSwatch: true,
                    swatchColor: Color(.sRGB, red: 1, green: 0.4, blue: 0.87))
            
            Divider()
                .foregroundColor(.gray)
            
            Text("With Validation")
                .font(.headline)
                .foregroundColor(.white)
            
            DSInput(text: .constant("123"),
                    placeholder: "Numbers only",
                    validator: { $0.allSatisfy(\.isNumber) })
            
            Text("States")
                .font(.headline)
                .foregroundColor(.white)
            
            DSInput(text: .constant("Default"), style: .default)
            DSInput(text: .constant("Hover"), style: .hover)
            DSInput(text: .constant("Active"), style: .active)
            DSInput(text: .constant("Focus"), style: .focus)
            DSInput(text: .constant("Disabled"), isDisabled: true)
        }
        .padding()
        .background(Color.black)
        .previewLayout(.sizeThatFits)
    }
}
#endif
