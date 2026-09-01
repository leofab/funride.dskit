#if canImport(UIKit)
import UIKit
import SwiftUI

/// A UIKit wrapper for the DSComboButton component
public class DSComboButtonUIKit: UIButton {
    private let style: DSComboButtonStyle
    private let label: String
    private let sublabel: String
    private let leadingIcon: String?
    private let trailingIcon: String?
    private var isEnabledState: Bool
    private let action: () -> Void
    
    private var hostingController: UIHostingController<DSComboButton>?
    
    /// Creates a UIKit combo button
    /// - Parameters:
    ///   - style: The button style (standard or collapsible)
    ///   - label: The primary label text
    ///   - sublabel: The secondary label text
    ///   - leadingIcon: Optional SF Symbol name for the leading icon
    ///   - trailingIcon: Optional SF Symbol name for the trailing icon
    ///   - isEnabled: Whether the button is enabled (default: true)
    ///   - action: The action to execute on tap
    public init(
        _ style: DSComboButtonStyle = .standard,
        label: String,
        sublabel: String,
        leadingIcon: String? = nil,
        trailingIcon: String? = nil,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.style = style
        self.label = label
        self.sublabel = sublabel
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.isEnabledState = isEnabled
        self.action = action
        
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor(DSTokens.Colors.comboButtonDefault)
        layer.cornerRadius = DSTokens.Sizing.comboButtonRadius
        clipsToBounds = true
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: DSTokens.Sizing.comboButtonWidth),
            heightAnchor.constraint(equalToConstant: DSTokens.Sizing.comboButtonHeight)
        ])
        
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        setupContent()
    }
    
    private func setupContent() {
        subviews.forEach { $0.removeFromSuperview() }
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = DSTokens.Spacing.comboButtonIconGap
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        if style == .collapsible {
            let leadingButton = createIconButton(systemName: "gearshape")
            stackView.addArrangedSubview(leadingButton)
        }
        
        if let iconName = leadingIcon {
            let iconView = createIconButton(systemName: iconName)
            stackView.addArrangedSubview(iconView)
        }
        
        let textStack = UIStackView()
        textStack.axis = .vertical
        textStack.spacing = 0
        textStack.alignment = .leading
        
        let labelView = UILabel()
        labelView.text = label
        labelView.font = .systemFont(ofSize: DSTokens.Typography.comboButtonLabelSize,
                                     weight: UIFont.Weight(DSTokens.Typography.comboButtonLabelWeight))
        labelView.textColor = UIColor(DSTokens.Colors.comboButtonText)
        
        let sublabelView = UILabel()
        sublabelView.text = sublabel
        sublabelView.font = .systemFont(ofSize: DSTokens.Typography.comboButtonLabelSize,
                                        weight: UIFont.Weight(DSTokens.Typography.comboButtonLabelWeight))
        sublabelView.textColor = UIColor(DSTokens.Colors.comboButtonSubtext)
        
        textStack.addArrangedSubview(labelView)
        textStack.addArrangedSubview(sublabelView)
        
        stackView.addArrangedSubview(textStack)
        
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stackView.addArrangedSubview(spacer)
        
        if let iconName = trailingIcon {
            let iconView = createIconButton(systemName: iconName)
            stackView.addArrangedSubview(iconView)
        }
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DSTokens.Spacing.sm),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DSTokens.Spacing.sm),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: DSTokens.Spacing.sm),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -DSTokens.Spacing.sm)
        ])
        
        updateAppearance()
    }
    
    private func createIconButton(systemName: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: systemName)
        imageView.tintColor = UIColor(DSTokens.Colors.comboButtonText)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: DSTokens.Sizing.comboButtonIconSize),
            imageView.heightAnchor.constraint(equalToConstant: DSTokens.Sizing.comboButtonIconSize)
        ])
        
        return imageView
    }
    
    @objc private func buttonTapped() {
        guard isEnabledState else { return }
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        action()
    }
    
    private func updateAppearance() {
        backgroundColor = UIColor(DSTokens.Colors.comboButtonDefault)
        alpha = isEnabledState ? 1.0 : 0.5
        isUserInteractionEnabled = isEnabledState
    }
    
    /// Sets the enabled state of the button
    /// - Parameter enabled: Whether the button should be enabled
    public func setEnabled(_ enabled: Bool) {
        isEnabledState = enabled
        updateAppearance()
    }
}

#endif
