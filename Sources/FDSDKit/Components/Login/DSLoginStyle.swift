import SwiftUI

/// Style configuration for the login view
public struct DSLoginStyle {
    public let backgroundColor: Color
    public let cardBackground: Color
    public let titleColor: Color
    public let subtitleColor: Color
    public let linkColor: Color
    public let dividerColor: Color

    public init(
        backgroundColor: Color = DSTokens.Colors.loginBackground,
        cardBackground: Color = DSTokens.Colors.loginCard,
        titleColor: Color = DSTokens.Colors.loginTitle,
        subtitleColor: Color = DSTokens.Colors.loginSubtitle,
        linkColor: Color = DSTokens.Colors.loginLink,
        dividerColor: Color = DSTokens.Colors.loginDivider
    ) {
        self.backgroundColor = backgroundColor
        self.cardBackground = cardBackground
        self.titleColor = titleColor
        self.subtitleColor = subtitleColor
        self.linkColor = linkColor
        self.dividerColor = dividerColor
    }
}
