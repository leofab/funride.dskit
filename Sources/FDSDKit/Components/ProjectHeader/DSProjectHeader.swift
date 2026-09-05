import SwiftUI

/// A workspace project header component based on Penpot design system.
/// Displays a project logo, subtitle, title, and optional trailing action buttons.
public struct DSProjectHeader: View {
    private let title: String
    private let subtitle: String
    private let logoImage: Image?
    private let trailingActions: [DSProjectHeaderAction]
    
    @State private var hoveredActionId: UUID?
    
    public init(
        title: String,
        subtitle: String,
        logoImage: Image? = nil,
        trailingActions: [DSProjectHeaderAction] = []
    ) {
        self.title = title
        self.subtitle = subtitle
        self.logoImage = logoImage
        self.trailingActions = trailingActions
    }
    
    public var body: some View {
        HStack(alignment: .top, spacing: DSTokens.Spacing.projectHeaderGap) {
            logoView
            
            textColumn
            
            Spacer(minLength: 0)
            
            trailingButtons
        }
        .padding(.horizontal, DSTokens.Spacing.projectHeaderPaddingH)
        .padding(.vertical, DSTokens.Spacing.projectHeaderPaddingV)
        .frame(minHeight: DSTokens.Sizing.projectHeaderHeight)
        .background(DSTokens.Colors.projectHeaderBackground)
    }
    
    // MARK: - Logo
    
    @ViewBuilder
    private var logoView: some View {
        if let image = logoImage {
            image
                .resizable()
                .scaledToFit()
                .frame(
                    width: DSTokens.Sizing.projectHeaderLogoSize,
                    height: DSTokens.Sizing.projectHeaderLogoSize
                )
        } else {
            Image(systemName: "folder.fill")
                .resizable()
                .scaledToFit()
                .frame(
                    width: DSTokens.Sizing.projectHeaderLogoSize,
                    height: DSTokens.Sizing.projectHeaderLogoSize
                )
                .foregroundColor(DSTokens.Colors.projectHeaderIconButton)
        }
    }
    
    // MARK: - Text Column
    
    private var textColumn: some View {
        VStack(alignment: .leading, spacing: DSTokens.Spacing.projectHeaderColumnGap) {
            Text(subtitle)
                .font(.system(
                    size: DSTokens.Typography.projectHeaderSubtitleSize,
                    weight: DSTokens.Typography.projectHeaderSubtitleWeight
                ))
                .foregroundColor(DSTokens.Colors.projectHeaderSubtitle)
                .lineSpacing(DSTokens.Typography.projectHeaderSubtitleSize * (1.2 - 1))
                .lineLimit(1)
            
            Text(title)
                .font(.system(
                    size: DSTokens.Typography.projectHeaderTitleSize,
                    weight: DSTokens.Typography.projectHeaderTitleWeight
                ))
                .foregroundColor(DSTokens.Colors.projectHeaderTitle)
                .lineSpacing(DSTokens.Typography.projectHeaderTitleSize * (1.3 - 1))
                .lineLimit(1)
        }
    }
    
    // MARK: - Trailing Buttons
    
    private var trailingButtons: some View {
        HStack(spacing: DSTokens.Spacing.projectHeaderGap) {
            ForEach(trailingActions) { action in
                actionButton(for: action)
            }
        }
    }
    
    private func actionButton(for action: DSProjectHeaderAction) -> some View {
        Button(action: {
            #if canImport(UIKit)
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            #endif
            action.action()
        }) {
            Image(systemName: action.iconName)
                .resizable()
                .scaledToFit()
                .frame(
                    width: DSTokens.Sizing.projectHeaderIconSize,
                    height: DSTokens.Sizing.projectHeaderIconSize
                )
                .foregroundColor(DSTokens.Colors.projectHeaderIconButton)
                .frame(
                    width: DSTokens.Sizing.projectHeaderButtonSize,
                    height: DSTokens.Sizing.projectHeaderButtonSize
                )
                .background(
                    hoveredActionId == action.id
                        ? DSTokens.Colors.projectHeaderButtonHover
                        : DSTokens.Colors.projectHeaderButtonBackground
                )
                .cornerRadius(DSTokens.Borders.radiusMedium)
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                hoveredActionId = hovering ? action.id : nil
            }
        }
    }
}

// MARK: - Preview
#if DEBUG
struct DSProjectHeader_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            DSProjectHeader(
                title: "App",
                subtitle: "Design system",
                trailingActions: [
                    DSProjectHeaderAction(iconName: "square.stack.3d.up") {},
                    DSProjectHeaderAction(iconName: "ellipsis") {}
                ]
            )
        }
        .previewLayout(.sizeThatFits)
    }
}
#endif
