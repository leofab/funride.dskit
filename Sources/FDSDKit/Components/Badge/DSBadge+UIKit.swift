#if canImport(UIKit)
import UIKit
import SwiftUI

/// UIKit wrapper for DSBadge
public class DSBadgeUIKit: UILabel {
    private let type: DSBadgeType
    
    public init(type: DSBadgeType = .default,
                text: String) {
        self.type = type
        super.init(frame: .zero)
        configure(text: text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(text: String) {
        self.text = text
        self.numberOfLines = 1
        self.lineBreakMode = .byTruncatingTail
        self.textAlignment = .center
        
        // Apply text color
        textColor = UIColor(type.textColor)
        
        // Apply font
        font = .systemFont(ofSize: type.fontSize,
                           weight: UIFont.Weight(DSTokens.Typography.badgeFontWeight))
        
        // Apply background color
        backgroundColor = UIColor(type.backgroundColor)
        
        // Apply border
        layer.cornerRadius = type.cornerRadius
        layer.borderWidth = DSTokens.Sizing.badgeBorderWidth
        layer.borderColor = UIColor(type.borderColor).cgColor
        layer.masksToBounds = true
        
        // Apply padding via intrinsic content size
        let horizontalPadding = type.horizontalPadding
        let verticalPadding = type.verticalPadding
        let insets = UIEdgeInsets(top: verticalPadding,
                                  left: horizontalPadding,
                                  bottom: verticalPadding,
                                  right: horizontalPadding)
        invalidateIntrinsicContentSize()
        
        // Store insets for layout
        self.layoutInsets = insets
    }
    
    private var layoutInsets: UIEdgeInsets = .zero
    
    public override var intrinsicContentSize: CGSize {
        let textSize = super.intrinsicContentSize
        return CGSize(
            width: textSize.width + layoutInsets.left + layoutInsets.right,
            height: textSize.height + layoutInsets.top + layoutInsets.bottom
        )
    }
    
    public func updateText(_ text: String) {
        self.text = text
        invalidateIntrinsicContentSize()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = type.cornerRadius
    }
    
    /// Accessibility label for the badge
    public override var accessibilityLabel: String? {
        get {
            return "\(type.accessibilityLabel) badge: \(text ?? "")"
        }
        set {
            super.accessibilityLabel = newValue
        }
    }
}
#endif
