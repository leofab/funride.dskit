import SwiftUI

/// A pagination component based on Penpot design system
/// Helps users navigate forwards and backwards through a series of pages
public struct DSPagination: View {
    @Binding private var currentPage: Int
    private let totalPages: Int
    private let style: DSPaginationStyle
    private let onPageChange: ((Int) -> Void)?
    
    /// Initialize pagination with binding, total pages, style, and callback
    public init(currentPage: Binding<Int>,
                totalPages: Int,
                style: DSPaginationStyle = .dark,
                onPageChange: ((Int) -> Void)? = nil) {
        self._currentPage = currentPage
        self.totalPages = max(0, totalPages)
        self.style = style
        self.onPageChange = onPageChange
    }
    
    public var body: some View {
        HStack(spacing: DSTokens.Spacing.paginationButtonSpacing) {
            previousButton
            pageNumberView
            nextButton
        }
    }
    
    // MARK: - Previous Button
    
    private var previousButton: some View {
        Button(action: goToPreviousPage) {
            Image(systemName: "chevron.left")
                .font(.system(size: DSTokens.Sizing.paginationIconSize))
                .foregroundColor(style.iconColor)
                .frame(width: DSTokens.Sizing.paginationButtonWidth,
                       height: DSTokens.Sizing.paginationButtonHeight)
                .background(style.backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: DSTokens.Sizing.paginationButtonRadius)
                        .stroke(style.borderColor, lineWidth: DSTokens.Borders.widthThin)
                )
                .clipShape(RoundedRectangle(cornerRadius: DSTokens.Sizing.paginationButtonRadius))
        }
        .disabled(!canGoPrevious)
        .opacity(canGoPrevious ? 1.0 : style.disabledOpacity)
        .accessibilityLabel("Previous page")
        .accessibilityHint(currentPage > 1 ? "Navigates to page \(currentPage - 1)" : "Already on first page")
    }
    
    // MARK: - Page Number View
    
    private var pageNumberView: some View {
        Text("\(currentPage) / \(totalPages)")
            .font(.system(size: DSTokens.Typography.paginationPageSize,
                          weight: DSTokens.Typography.paginationPageWeight))
            .foregroundColor(style.textColor)
            .frame(width: DSTokens.Sizing.paginationNumberingWidth,
                   height: DSTokens.Sizing.paginationNumberingHeight)
            .background(style.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: DSTokens.Sizing.paginationNumberingRadius))
            .accessibilityLabel("Page \(currentPage) of \(totalPages)")
    }
    
    // MARK: - Next Button
    
    private var nextButton: some View {
        Button(action: goToNextPage) {
            Image(systemName: "chevron.right")
                .font(.system(size: DSTokens.Sizing.paginationIconSize))
                .foregroundColor(style.iconColor)
                .frame(width: DSTokens.Sizing.paginationButtonWidth,
                       height: DSTokens.Sizing.paginationButtonHeight)
                .background(style.backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: DSTokens.Sizing.paginationButtonRadius)
                        .stroke(style.borderColor, lineWidth: DSTokens.Borders.widthThin)
                )
                .clipShape(RoundedRectangle(cornerRadius: DSTokens.Sizing.paginationButtonRadius))
        }
        .disabled(!canGoNext)
        .opacity(canGoNext ? 1.0 : style.disabledOpacity)
        .accessibilityLabel("Next page")
        .accessibilityHint(currentPage < totalPages ? "Navigates to page \(currentPage + 1)" : "Already on last page")
    }
    
    // MARK: - Navigation Logic
    
    private var canGoPrevious: Bool {
        currentPage > 1
    }
    
    private var canGoNext: Bool {
        currentPage < totalPages
    }
    
    private func goToPreviousPage() {
        guard canGoPrevious else { return }
        currentPage -= 1
        onPageChange?(currentPage)
    }
    
    private func goToNextPage() {
        guard canGoNext else { return }
        currentPage += 1
        onPageChange?(currentPage)
    }
}

// MARK: - Preview
#if DEBUG
struct DSPagination_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 24) {
            Text("Interactive (Page 2 of 5)")
                .font(.headline)
                .foregroundColor(.white)
            InteractivePaginationPreview(currentPage: 2, totalPages: 5)
            
            Text("First Page (Page 1 of 5)")
                .font(.headline)
                .foregroundColor(.white)
            InteractivePaginationPreview(currentPage: 1, totalPages: 5)
            
            Text("Last Page (Page 5 of 5)")
                .font(.headline)
                .foregroundColor(.white)
            InteractivePaginationPreview(currentPage: 5, totalPages: 5)
            
            Text("Single Page")
                .font(.headline)
                .foregroundColor(.white)
            InteractivePaginationPreview(currentPage: 1, totalPages: 1)
            
            Text("No Pages")
                .font(.headline)
                .foregroundColor(.white)
            InteractivePaginationPreview(currentPage: 0, totalPages: 0)
        }
        .padding()
        .background(Color.black)
        .previewLayout(.sizeThatFits)
    }
}

struct InteractivePaginationPreview: View {
    @State private var currentPage: Int
    let totalPages: Int
    
    init(currentPage: Int, totalPages: Int) {
        self._currentPage = State(initialValue: currentPage)
        self.totalPages = totalPages
    }
    
    var body: some View {
        DSPagination(currentPage: $currentPage, totalPages: totalPages)
    }
}
#endif
