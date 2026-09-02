import SwiftUI

/// A reusable text area component based on Penpot design system
/// Supports multi-line text input with label, placeholder, and validation
public struct DSTextArea: View {
    @Binding private var text: String
    @State private var internalText: String = ""
    @State private var isHovered: Bool = false
    
    private let label: String
    private let placeholder: String
    private let style: DSTextAreaStyle
    private let isDisabled: Bool
    private let onCommit: ((String) -> Void)?
    private let validator: ((String) -> Bool)?
    
    /// Creates a text area with text binding
    /// - Parameters:
    ///   - text: Binding to the text area value
    ///   - label: Label text displayed above the text area
    ///   - placeholder: Placeholder text when empty
    ///   - style: Current visual state
    ///   - isDisabled: Whether the text area is disabled
    ///   - onCommit: Action when content is saved (focus lost)
    ///   - validator: Validation closure, returns true if valid
    public init(
        text: Binding<String>,
        label: String = "",
        placeholder: String = "",
        style: DSTextAreaStyle = .default,
        isDisabled: Bool = false,
        onCommit: ((String) -> Void)? = nil,
        validator: ((String) -> Bool)? = nil
    ) {
        self._text = text
        self.label = label
        self.placeholder = placeholder
        self.style = style
        self.isDisabled = isDisabled
        self.onCommit = onCommit
        self.validator = validator
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: DSTokens.Spacing.xs) {
            // Label
            if !label.isEmpty {
                Text(label)
                    .font(.system(size: DSTokens.Typography.textAreaLabelSize,
                                  weight: DSTokens.Typography.textAreaLabelWeight))
                    .foregroundColor(DSTokens.Colors.textAreaText)
            }
            
            // Text Editor
            textEditorContainer
            .frame(height: DSTokens.Sizing.textAreaHeight)
            .background(currentStyle.backgroundColor)
            .cornerRadius(DSTokens.Sizing.textAreaRadius)
            .overlay(
                RoundedRectangle(cornerRadius: DSTokens.Sizing.textAreaRadius)
                    .stroke(currentStyle.borderColor ?? Color.clear,
                            lineWidth: currentStyle.borderWidth)
            )
            .opacity(currentStyle.opacity)
            .disabled(isDisabled)
            .onHover { hovering in
                guard !isDisabled else { return }
                isHovered = hovering
            }
        }
        .onAppear {
            internalText = text
        }
        .onChange(of: text) { newValue in
            internalText = newValue
        }
    }
    
    // MARK: - Private Views
    
    @ViewBuilder
    private var textEditorContainer: some View {
        #if canImport(UIKit)
        TextAreaContainer(
            text: $internalText,
            placeholder: placeholder,
            isDisabled: isDisabled,
            backgroundColor: UIColor(hex: "#212426"),
            textColor: isDisabled ? UIColor(hex: "#8f9da3") : UIColor(hex: "#ffffff"),
            placeholderColor: UIColor(hex: "#8f9da3"),
            onCommit: { _ in commitChanges() }
        )
        #else
        TextAreaContainer(
            text: $internalText,
            placeholder: placeholder,
            isDisabled: isDisabled,
            textColor: isDisabled ? DSTokens.Colors.textAreaTextPlaceholder : DSTokens.Colors.textAreaText,
            placeholderColor: DSTokens.Colors.textAreaTextPlaceholder,
            onCommit: { _ in commitChanges() }
        )
        #endif
    }
    
    // MARK: - Computed Properties
    
    private var currentStyle: DSTextAreaStyle {
        if isDisabled {
            return .disabled
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

// MARK: - TextArea Container (UIKit Wrapper)

#if canImport(UIKit)
struct TextAreaContainer: UIViewRepresentable {
    @Binding var text: String
    let placeholder: String
    let isDisabled: Bool
    let backgroundColor: UIColor
    let textColor: UIColor
    let placeholderColor: UIColor
    var onCommit: ((String) -> Void)?
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: DSTokens.Typography.textAreaFontSize,
                                          weight: UIFont.Weight(DSTokens.Typography.textAreaFontWeight))
        textView.textColor = textColor
        textView.backgroundColor = .clear
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        textView.textContainerInset = UIEdgeInsets(
            top: DSTokens.Spacing.textAreaPadding,
            left: DSTokens.Spacing.textAreaPadding - 4,
            bottom: DSTokens.Spacing.textAreaPadding,
            right: DSTokens.Spacing.textAreaPadding - 4
        )
        textView.delegate = context.coordinator
        textView.isEditable = !isDisabled
        textView.text = text
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.textColor = textColor
        uiView.isEditable = !isDisabled
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextAreaContainer
        
        init(_ parent: TextAreaContainer) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            parent.onCommit?(textView.text)
        }
    }
}
#else
struct TextAreaContainer: View {
    @Binding var text: String
    let placeholder: String
    let isDisabled: Bool
    let textColor: Color
    let placeholderColor: Color
    var onCommit: ((String) -> Void)?
    
    var body: some View {
        Group {
            if #available(macOS 13.0, *) {
                TextEditor(text: $text)
                    .font(.system(size: DSTokens.Typography.textAreaFontSize,
                                  weight: DSTokens.Typography.textAreaFontWeight))
                    .foregroundColor(textColor)
                    .scrollContentBackground(.hidden)
                    .padding(DSTokens.Spacing.textAreaPadding)
                    .overlay(
                        GeometryReader { geometry in
                            if text.isEmpty {
                                Text(placeholder)
                                    .font(.system(size: DSTokens.Typography.textAreaFontSize,
                                                  weight: DSTokens.Typography.textAreaFontWeight))
                                    .foregroundColor(placeholderColor)
                                    .padding(.horizontal, DSTokens.Spacing.textAreaPadding + 4)
                                    .padding(.vertical, DSTokens.Spacing.textAreaPadding + 8)
                                    .allowsHitTesting(false)
                            }
                        }
                    )
                    .onChange(of: text) { newValue in
                        onCommit?(newValue)
                    }
            } else {
                TextEditor(text: $text)
                    .font(.system(size: DSTokens.Typography.textAreaFontSize,
                                  weight: DSTokens.Typography.textAreaFontWeight))
                    .foregroundColor(textColor)
                    .padding(DSTokens.Spacing.textAreaPadding)
                    .overlay(
                        GeometryReader { geometry in
                            if text.isEmpty {
                                Text(placeholder)
                                    .font(.system(size: DSTokens.Typography.textAreaFontSize,
                                                  weight: DSTokens.Typography.textAreaFontWeight))
                                    .foregroundColor(placeholderColor)
                                    .padding(.horizontal, DSTokens.Spacing.textAreaPadding + 4)
                                    .padding(.vertical, DSTokens.Spacing.textAreaPadding + 8)
                                    .allowsHitTesting(false)
                            }
                        }
                    )
                    .onChange(of: text) { newValue in
                        onCommit?(newValue)
                    }
            }
        }
    }
}
#endif

// MARK: - Preview
#if DEBUG
struct DSTextArea_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Basic Text Area")
                    .font(.headline)
                    .foregroundColor(.white)
                
                DSTextArea(text: .constant(""), placeholder: "Enter description...")
                
                DSTextArea(text: .constant("This is a sample text area component."),
                           label: "Description")
                
                Divider()
                    .foregroundColor(.gray)
                
                Text("States")
                    .font(.headline)
                    .foregroundColor(.white)
                
                DSTextArea(text: .constant(""), placeholder: "Empty state", style: .empty)
                DSTextArea(text: .constant("Default state"), style: .default)
                DSTextArea(text: .constant("Hover state"), style: .hover)
                DSTextArea(text: .constant("Active state"), style: .active)
                DSTextArea(text: .constant("Focus state"), style: .focus)
                DSTextArea(text: .constant("Disabled"), isDisabled: true)
                DSTextArea(text: .constant("Success"), style: .success)
                DSTextArea(text: .constant("Error"), style: .error)
            }
        }
        .padding()
        .background(Color.black)
        .previewLayout(.sizeThatFits)
    }
}
#endif
