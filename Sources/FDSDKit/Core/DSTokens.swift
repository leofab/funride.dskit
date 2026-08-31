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
    }
    
    // MARK: - Sizing
    public enum Sizing {
        // Button-specific sizing
        public static let buttonHeight: CGFloat = 32
        public static let buttonMinWidth: CGFloat = 86
        public static let iconSize: CGFloat = 16
        public static let inputHeight: CGFloat = 40
        
        // Accordion-specific sizing
        public static let accordionHeaderHeight: CGFloat = 50
        public static let accordionIconSize: CGFloat = 16
        public static let accordionItemRadius: CGFloat = 8
        public static let accordionContainerRadius: CGFloat = 24
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
