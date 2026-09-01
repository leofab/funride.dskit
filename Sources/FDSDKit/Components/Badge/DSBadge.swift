import SwiftUI

/// A reusable badge component based on Penpot design system
public struct DSBadge: View {
    let type: DSBadgeType
    let text: String
    
    /// Initialize a badge with type and text
    public init(_ type: DSBadgeType = .default,
                text: String) {
        self.type = type
        self.text = text
    }
    
    public var body: some View {
        Text(text)
            .font(.system(size: type.fontSize,
                          weight: DSTokens.Typography.badgeFontWeight))
            .foregroundColor(type.textColor)
            .lineLimit(1)
            .truncationMode(.tail)
            .padding(.horizontal, type.horizontalPadding)
            .padding(.vertical, type.verticalPadding)
            .background(type.backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: type.cornerRadius)
                    .stroke(type.borderColor,
                            lineWidth: DSTokens.Sizing.badgeBorderWidth)
            )
            .clipShape(RoundedRectangle(cornerRadius: type.cornerRadius))
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(Text("\(type.accessibilityLabel) badge: \(text)"))
    }
}

// MARK: - Accessibility Helpers
extension DSBadgeType {
    var accessibilityLabel: String {
        switch self {
        case .default:
            return "Default"
        case .error:
            return "Error"
        case .layers:
            return "Layer"
        }
    }
}

// MARK: - Preview
#if DEBUG
struct DSBadge_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Default Badges")
                .font(.headline)
            HStack(spacing: 8) {
                DSBadge(.default, text: "Label")
                DSBadge(.default, text: "Active")
                DSBadge(.default, text: "Published")
            }
            
            Text("Error Badges")
                .font(.headline)
            HStack(spacing: 8) {
                DSBadge(.error, text: "Pending")
                DSBadge(.error, text: "Failed")
                DSBadge(.error, text: "Error")
            }
            
            Text("Layer Badges")
                .font(.headline)
            HStack(spacing: 8) {
                DSBadge(.layers, text: "View mode")
                DSBadge(.layers, text: "Focus mode")
                DSBadge(.layers, text: "Edit mode")
            }
            
            Text("Truncation")
                .font(.headline)
            DSBadge(.default, text: "This is a very long badge text that should be truncated")
                .frame(width: 150)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .previewLayout(.sizeThatFits)
    }
}
#endif
