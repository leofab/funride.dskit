import SwiftUI

/// A reusable pill/tag component based on Penpot design system
public struct DSPill: View {
    let text: String
    let isDismissible: Bool
    let state: DSPillState
    var onTap: (() -> Void)?
    var onDismiss: (() -> Void)?
    
    /// Initialize a pill with text and options
    public init(_ text: String,
                isDismissible: Bool = true,
                state: DSPillState = .default,
                onTap: (() -> Void)? = nil,
                onDismiss: (() -> Void)? = nil) {
        self.text = text
        self.isDismissible = isDismissible
        self.state = state
        self.onTap = onTap
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        HStack(spacing: DSTokens.Spacing.pillIconTextGap) {
            // Text Label
            Text(text)
                .font(.system(size: DSTokens.Typography.pillFontSize,
                              weight: DSTokens.Typography.pillFontWeight))
                .foregroundColor(DSTokens.Colors.pillText)
                .lineLimit(1)
                .truncationMode(.tail)
            
            // Close Icon (if dismissible)
            if isDismissible {
                Button(action: { onDismiss?() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: DSTokens.Sizing.pillCloseIconSize))
                        .foregroundColor(DSTokens.Colors.pillText)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Remove")
            }
        }
        .padding(.horizontal, DSTokens.Spacing.pillHorizontalPadding)
        .frame(height: DSTokens.Sizing.pillHeight)
        .background(state.backgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: DSTokens.Sizing.pillRadius)
                .stroke(state.borderColor, lineWidth: state.borderWidth)
        )
        .clipShape(RoundedRectangle(cornerRadius: DSTokens.Sizing.pillRadius))
        .onTapGesture { onTap?() }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("Pill: \(text)"))
    }
}

// MARK: - Preview
#if DEBUG
struct DSPillDemoView: View {
    @State private var tags = ["Tag", "Filter", "Category"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Dismissible Pills (tap x to remove)")
                .font(.headline)
            HStack(spacing: 8) {
                ForEach(tags, id: \.self) { tag in
                    DSPill(tag) {
                        print("Tapped: \(tag)")
                    } onDismiss: {
                        tags.removeAll { $0 == tag }
                    }
                }
            }
            
            if tags.isEmpty {
                Text("All pills dismissed!")
                    .foregroundColor(.green)
                    .font(.subheadline)
            }
            
            Divider()
            
            Text("Non-Dismissible Pills")
                .font(.headline)
            HStack(spacing: 8) {
                DSPill("Static", isDismissible: false)
                DSPill("Label", isDismissible: false)
            }
            
            Text("States")
                .font(.headline)
            HStack(spacing: 8) {
                DSPill("Default", state: .default)
                DSPill("Hover", state: .hover)
                DSPill("Focus", state: .focus)
            }
            
            Text("Long Text (Truncation)")
                .font(.headline)
            DSPill("This is a very long pill text that should be truncated")
                .frame(width: 200)
        }
        .padding()
        .background(Color.gray.opacity(0.3))
        .previewLayout(.sizeThatFits)
    }
}

struct DSPill_Previews: PreviewProvider {
    static var previews: some View {
        DSPillDemoView()
    }
}
#endif
