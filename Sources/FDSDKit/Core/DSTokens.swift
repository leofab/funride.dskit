import SwiftUI

/// Design tokens sourced from Penpot design system
public enum DSTokens {
    
    // MARK: - Colors
    public enum Colors {
        public static let primary = Color(hex: "#007BFF")
        public static let secondary = Color(hex: "#6C757D")
        public static let background = Color.white
        public static let text = Color.black
        public static let success = Color(hex: "#28A745")
        public static let warning = Color(hex: "#FFC107")
        public static let error = Color(hex: "#DC3545")
        public static let accent = Color(hex: "#FF6B6B")
        
        // Button-specific colors from Penpot
        public static let buttonPrimaryDefault = Color(hex: "#7EFFF5")
        public static let buttonText = Color.black
        
        // Accordion-specific colors from Penpot
        public static let accordionBackground = Color(hex: "#212426")
        public static let accordionHover = Color(hex: "#2e3434")
        public static let accordionBorder = Color(hex: "#18181a")
        public static let accordionHeaderText = Color.white
        public static let accordionSubtext = Color(hex: "#8f9da3")
        
        // Combo button-specific colors from Penpot
        public static let comboButtonDefault = Color(hex: "#212426")
        public static let comboButtonHover = Color(hex: "#2e3434")
        public static let comboButtonFocus = Color(hex: "#7efff5")
        public static let comboButtonDisabled = Color(hex: "#18181a")
        public static let comboButtonText = Color.white
        public static let comboButtonSubtext = Color(hex: "#8f9da3")
        public static let comboButtonBorder = Color(hex: "#2e3434")
        
        // Notification-specific colors from Penpot
        public static let notificationDefault = Color(hex: "#18181a")
        public static let notificationInfo = Color(hex: "#082c49")
        public static let notificationError = Color(hex: "#500124")
        public static let notificationWarning = Color(hex: "#500124") // To be confirmed
        public static let notificationSuccess = Color(hex: "#1a3d2e") // To be confirmed
        public static let notificationBorderDefault = Color(hex: "#2e3434")
        public static let notificationBorderInfo = Color(hex: "#0e9be9")
        public static let notificationBorderError = Color(hex: "#c80857")
        public static let notificationBorderWarning = Color(hex: "#c80857") // To be confirmed
        public static let notificationBorderSuccess = Color(hex: "#48c393") // To be confirmed
        public static let notificationText = Color.white
        public static let notificationTextSecondary = Color(hex: "#8f9da3")
        
        // Avatar-specific colors from Penpot
        public static let avatarPink = Color(hex: "#f49ef7")
        public static let avatarBlue = Color(hex: "#38c0fa")
        public static let avatarGreen = Color(hex: "#48c393")
        public static let avatarYellow = Color(hex: "#d4a03c")
        public static let avatarPurple = Color(hex: "#9b6dff")
        public static let avatarOrange = Color(hex: "#e0785c")
        public static let avatarHover = Color(hex: "#18181a")
        public static let avatarBorderSelected = Color(hex: "#38c0fa")
        public static let avatarText = Color.black
        
        // Badge-specific colors from Penpot
        public static let badgeDefaultBackground = Color(hex: "#18181a")
        public static let badgeDefaultBorder = Color(hex: "#2e3434")
        public static let badgeDefaultText = Color.white
        public static let badgeErrorBackground = Color(hex: "#441606")
        public static let badgeErrorBorder = Color(hex: "#fe4811")
        public static let badgeErrorText = Color.white
        public static let badgeLayersBackground = Color(hex: "#18181a")
        public static let badgeLayersBorder = Color(hex: "#7efff5")
        public static let badgeLayersText = Color(hex: "#7efff5")
        
        // Input-specific colors from Penpot
        public static let inputDefault = Color(hex: "#212426")
        public static let inputHover = Color(hex: "#2e3434")
        public static let inputActive = Color(hex: "#18181a")
        public static let inputBorder = Color(hex: "#7efff5")
        public static let inputText = Color.white
        public static let inputTextDisabled = Color(hex: "#8f9da3")
        
        // Pagination-specific colors from Penpot
        public static let paginationBackground = Color(hex: "#18181a")
        public static let paginationBorder = Color(hex: "#2e3434")
        public static let paginationText = Color(hex: "#8f9da3")
        public static let paginationIcon = Color(hex: "#8f9da3")
    }
    
    // MARK: - Spacing
    public enum Spacing {
        public static let xs: CGFloat = 4
        public static let sm: CGFloat = 8
        public static let md: CGFloat = 16
        public static let lg: CGFloat = 24
        public static let xl: CGFloat = 32
        
        // Button-specific spacing
        public static let buttonIconTextGap: CGFloat = 4
        
        // Accordion-specific spacing
        public static let accordionItemGap: CGFloat = 2
        public static let accordionHeaderPadding: CGFloat = 16
        public static let accordionContentPadding: CGFloat = 16
        
        // Combo button-specific spacing
        public static let comboButtonPadding: CGFloat = 12
        public static let comboButtonIconGap: CGFloat = 8
        public static let comboButtonOptionHeight: CGFloat = 40
        
        // Notification-specific spacing
        public static let notificationPadding: CGFloat = 12
        public static let notificationIconGap: CGFloat = 8
        public static let notificationActionGap: CGFloat = 8
        
        // Input-specific spacing
        public static let inputIconGap: CGFloat = 4
        
        // Pagination-specific spacing
        public static let paginationButtonSpacing: CGFloat = 8
    }
    
    // MARK: - Typography
    public enum Typography {
        public static let fontFamily = "Work Sans"
        public static let bodySize: CGFloat = 14
        public static let headingSize: CGFloat = 18
        public static let buttonSize: CGFloat = 12
        public static let buttonWeight: Font.Weight = .medium
        
        // Accordion-specific typography
        public static let accordionTitleSize: CGFloat = 12
        public static let accordionTitleWeight: Font.Weight = .regular
        
        // Combo button-specific typography
        public static let comboButtonLabelSize: CGFloat = 12
        public static let comboButtonLabelWeight: Font.Weight = .regular
        
        // Notification-specific typography
        public static let notificationLabelSize: CGFloat = 12
        public static let notificationLabelWeight: Font.Weight = .regular
        public static let notificationActionSize: CGFloat = 12
        public static let notificationActionWeight: Font.Weight = .medium
        
        // Avatar-specific typography
        public static let avatarSmallFontSize: CGFloat = 10
        public static let avatarMediumFontSize: CGFloat = 12
        public static let avatarLargeFontSize: CGFloat = 14
        public static let avatarFontWeight: Font.Weight = .medium
        
        // Badge-specific typography
        public static let badgeDefaultFontSize: CGFloat = 14
        public static let badgeLayersFontSize: CGFloat = 12
        public static let badgeFontWeight: Font.Weight = .regular
        
        // Input-specific typography
        public static let inputFontSize: CGFloat = 12
        public static let inputFontWeight: Font.Weight = .regular
        
        // Pagination-specific typography
        public static let paginationPageSize: CGFloat = 14
        public static let paginationPageWeight: Font.Weight = .regular
    }
    
    // MARK: - Sizing
    public enum Sizing {
        // Button-specific sizing
        public static let buttonHeight: CGFloat = 32
        public static let buttonMinWidth: CGFloat = 86
        public static let iconSize: CGFloat = 16
        
        // Accordion-specific sizing
        public static let accordionHeaderHeight: CGFloat = 50
        public static let accordionIconSize: CGFloat = 16
        public static let accordionItemRadius: CGFloat = 8
        public static let accordionContainerRadius: CGFloat = 24
        
        // Combo button-specific sizing
        public static let comboButtonHeight: CGFloat = 48
        public static let comboButtonWidth: CGFloat = 248
        public static let comboButtonRadius: CGFloat = 8
        public static let comboButtonIconSize: CGFloat = 16
        public static let comboButtonDropdownMaxHeight: CGFloat = 200
        
        // Notification-specific sizing
        public static let notificationInlineHeight: CGFloat = 50
        public static let notificationInlineWidth: CGFloat = 627
        public static let notificationInlineRadius: CGFloat = 8
        public static let notificationToastHeight: CGFloat = 32
        public static let notificationToastWidth: CGFloat = 228
        public static let notificationToastRadius: CGFloat = 8
        public static let notificationIconSize: CGFloat = 16
        
        // Avatar-specific sizing
        public static let avatarSmall: CGFloat = 24
        public static let avatarMedium: CGFloat = 32
        public static let avatarLarge: CGFloat = 40
        public static let avatarBorderWidth: CGFloat = 2
        
        // Badge-specific sizing
        public static let badgeDefaultHeight: CGFloat = 32
        public static let badgeLayersHeight: CGFloat = 20
        public static let badgeDefaultRadius: CGFloat = 8
        public static let badgeLayersRadius: CGFloat = 6
        public static let badgeHorizontalPadding: CGFloat = 8
        public static let badgeVerticalPadding: CGFloat = 4
        public static let badgeLayersHorizontalPadding: CGFloat = 6
        public static let badgeLayersVerticalPadding: CGFloat = 2
        public static let badgeBorderWidth: CGFloat = 1
        
        // Input-specific sizing
        public static let inputHeight: CGFloat = 32
        public static let inputWidthWithoutOpacity: CGFloat = 179
        public static let inputWidthWithOpacity: CGFloat = 248
        public static let inputSwatchSize: CGFloat = 16
        public static let inputRadius: CGFloat = 8
        public static let inputPadding: CGFloat = 8
        public static let inputIconGap: CGFloat = 4
        
        // Pagination-specific sizing
        public static let paginationNumberingWidth: CGFloat = 62
        public static let paginationNumberingHeight: CGFloat = 31
        public static let paginationNumberingRadius: CGFloat = 6
        public static let paginationButtonWidth: CGFloat = 32
        public static let paginationButtonHeight: CGFloat = 64
        public static let paginationButtonRadius: CGFloat = 8
        public static let paginationIconSize: CGFloat = 16
    }
    
    // MARK: - Borders
    public enum Borders {
        public static let radiusSmall: CGFloat = 4
        public static let radiusMedium: CGFloat = 8
        public static let radiusLarge: CGFloat = 12
        public static let widthThin: CGFloat = 1
        public static let widthMedium: CGFloat = 2
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
