import SwiftUI

/// A reusable search input component based on Penpot design system
/// Supports live search with optional filter controls
public struct DSSearch: View {
    @Binding private var text: String
    @State private var internalText: String = ""
    @State private var isFocused: Bool = false
    @State private var isHovered: Bool = false
    
    private let placeholder: String
    private let style: DSSearchStyle
    private let isDisabled: Bool
    private let showsFilter: Bool
    private let onSearch: ((String) -> Void)?
    private let onClear: (() -> Void)?
    private let onFilterTap: (() -> Void)?
    
    /// Creates a search input with text binding
    /// - Parameters:
    ///   - text: Binding to the search term value
    ///   - placeholder: Placeholder text when empty (default: "Search...")
    ///   - style: Current visual state
    ///   - isDisabled: Whether the search is disabled
    ///   - showsFilter: Whether to show filter controls
    ///   - onSearch: Live search callback triggered on text change
    ///   - onClear: Action when clear button is tapped
    ///   - onFilterTap: Action when filter button is tapped
    public init(
        text: Binding<String>,
        placeholder: String = "Search...",
        style: DSSearchStyle = .default,
        isDisabled: Bool = false,
        showsFilter: Bool = false,
        onSearch: ((String) -> Void)? = nil,
        onClear: (() -> Void)? = nil,
        onFilterTap: (() -> Void)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.style = style
        self.isDisabled = isDisabled
        self.showsFilter = showsFilter
        self.onSearch = onSearch
        self.onClear = onClear
        self.onFilterTap = onFilterTap
    }
    
    public var body: some View {
        HStack(spacing: DSTokens.Spacing.inputIconGap) {
            // Search Icon
            searchIcon
            
            // Text Field
            textField
            
            // Clear Button (X)
            if !internalText.isEmpty {
                clearButton
            }
            
            // Filter Button
            if showsFilter {
                filterButton
            }
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
        .onChange(of: internalText) { newValue in
            onSearch?(newValue)
        }
    }
    
    // MARK: - Private Views
    
    private var searchIcon: some View {
        Image(systemName: "magnifyingglass")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 16, height: 16)
            .foregroundColor(currentStyle.iconColor)
            .padding(.leading, DSTokens.Spacing.inputIconGap)
    }
    
    private var textField: some View {
        TextField(placeholder, text: $internalText, onEditingChanged: { editing in
            if editing {
                isFocused = true
            } else {
                isFocused = false
            }
        }, onCommit: {
            isFocused = false
        })
        .font(.system(size: DSTokens.Typography.inputFontSize,
                      weight: DSTokens.Typography.inputFontWeight))
        .foregroundColor(currentStyle.textColor)
        .disableAutocorrection(true)
        #if os(iOS)
        .textInputAutocapitalization(.never)
        #endif
        .padding(.horizontal, DSTokens.Spacing.sm)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var clearButton: some View {
        Button(action: {
            internalText = ""
            text = ""
            onClear?()
        }) {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 16, height: 16)
                .foregroundColor(currentStyle.iconColor)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.trailing, DSTokens.Spacing.inputIconGap)
    }
    
    private var filterButton: some View {
        Button(action: {
            onFilterTap?()
        }) {
            Image(systemName: "line.3.horizontal.decrease.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 16, height: 16)
                .foregroundColor(currentStyle.iconColor)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.trailing, DSTokens.Spacing.inputIconGap)
    }
    
    // MARK: - Computed Properties
    
    private var currentStyle: DSSearchStyle {
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
}

// MARK: - Preview
#if DEBUG
struct DSSearch_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            Text("Simple Search")
                .font(.headline)
                .foregroundColor(.white)
            
            DSSearch(text: .constant(""))
            DSSearch(text: .constant("Search term"))
            DSSearch(text: .constant("Disabled"), isDisabled: true)
            
            Divider()
                .foregroundColor(.gray)
            
            Text("With Filter")
                .font(.headline)
                .foregroundColor(.white)
            
            DSSearch(text: .constant(""), showsFilter: true)
            DSSearch(text: .constant("Filter search"), showsFilter: true)
            
            Divider()
                .foregroundColor(.gray)
            
            Text("States")
                .font(.headline)
                .foregroundColor(.white)
            
            DSSearch(text: .constant("Default"), style: .default)
            DSSearch(text: .constant("Hover"), style: .hover)
            DSSearch(text: .constant("Active"), style: .active)
            DSSearch(text: .constant("Focus"), style: .focus)
            DSSearch(text: .constant("Disabled"), isDisabled: true)
        }
        .padding()
        .background(Color.black)
        .previewLayout(.sizeThatFits)
    }
}
#endif
