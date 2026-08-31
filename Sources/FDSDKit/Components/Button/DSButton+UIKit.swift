#if canImport(UIKit)
import UIKit
import SwiftUI

/// UIKit wrapper for DSButton
public class DSButtonUIKit: UIButton {
    private let style: DSButtonStyle
    private let buttonLabel: String
    
    public init(style: DSButtonStyle = .primary,
                icon: UIImage? = nil,
                label: String) {
        self.style = style
        self.buttonLabel = label
        super.init(frame: .zero)
        setupButton(icon: icon)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton(icon: UIImage?) {
        // Configure title
        setTitle(buttonLabel, for: .normal)
        setTitleColor(UIColor(style.foregroundColor), for: .normal)
        titleLabel?.font = .systemFont(ofSize: DSTokens.Typography.buttonSize,
                                       weight: UIFont.Weight(DSTokens.Typography.buttonWeight))
        
        // Configure icon
        if let iconImage = icon {
            setImage(iconImage.withRenderingMode(.alwaysTemplate), for: .normal)
            tintColor = UIColor(style.foregroundColor)
        }
        
        // Configure appearance
        backgroundColor = UIColor(style.backgroundColor)
        layer.cornerRadius = DSTokens.Borders.radiusMedium
        clipsToBounds = true
        
        if let borderColor = style.borderColor {
            layer.borderColor = UIColor(borderColor).cgColor
            layer.borderWidth = style.borderWidth
        }
        
        // Set size constraints
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: DSTokens.Sizing.buttonHeight),
            widthAnchor.constraint(greaterThanOrEqualToConstant: DSTokens.Sizing.buttonMinWidth)
        ])
        
        // Add touch handling
        addTarget(self, action: #selector(buttonPressed), for: [.touchDown])
        addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside])
    }
    
    @objc private func buttonPressed() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.alpha = 0.8
        }
    }
    
    @objc private func buttonReleased() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
            self.alpha = 1.0
        }
    }
}

// MARK: - UIColor Extension
extension UIColor {
    convenience init(_ color: Color) {
        let scanner = Scanner(string: color.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        scanner.scanHexInt64(&hexNumber)
        
        let r, g, b: CGFloat
        switch color.description.count {
        case 7: // #RRGGBB
            r = CGFloat((hexNumber & 0xFF0000) >> 16) / 255
            g = CGFloat((hexNumber & 0x00FF00) >> 8) / 255
            b = CGFloat(hexNumber & 0x0000FF) / 255
            self.init(red: r, green: g, blue: b, alpha: 1.0)
        default:
            self.init(red: 0, green: 0, blue: 0, alpha: 1.0)
        }
    }
}

// MARK: - UIFont.Weight Extension
extension UIFont.Weight {
    init(_ weight: Font.Weight) {
        switch weight {
        case .ultraLight:
            self = .ultraLight
        case .thin:
            self = .thin
        case .light:
            self = .light
        case .regular:
            self = .regular
        case .medium:
            self = .medium
        case .semibold:
            self = .semibold
        case .bold:
            self = .bold
        case .heavy:
            self = .heavy
        case .black:
            self = .black
        default:
            self = .regular
        }
    }
}
#endif
