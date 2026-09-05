#if canImport(UIKit)
import UIKit
import SwiftUI

/// UIKit wrapper for DSProjectHeader
public class DSProjectHeaderUIKit: UIView {
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let logoImageView = UIImageView()
    private var actionButtons: [UIButton] = []
    private var actions: [DSProjectHeaderAction] = []
    
    public init(
        title: String,
        subtitle: String,
        logoImage: UIImage? = nil,
        actionIcons: [(iconName: String, action: () -> Void)] = []
    ) {
        super.init(frame: .zero)
        setupView(
            title: title,
            subtitle: subtitle,
            logoImage: logoImage,
            actionIcons: actionIcons
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(
        title: String,
        subtitle: String,
        logoImage: UIImage?,
        actionIcons: [(iconName: String, action: () -> Void)]
    ) {
        backgroundColor = UIColor(DSTokens.Colors.projectHeaderBackground)
        
        // Logo
        logoImageView.image = logoImage
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.tintColor = UIColor(DSTokens.Colors.projectHeaderIconButton)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(logoImageView)
        
        // Subtitle
        subtitleLabel.text = subtitle
        subtitleLabel.font = .systemFont(
            ofSize: DSTokens.Typography.projectHeaderSubtitleSize,
            weight: UIFont.Weight(DSTokens.Typography.projectHeaderSubtitleWeight)
        )
        subtitleLabel.textColor = UIColor(DSTokens.Colors.projectHeaderSubtitle)
        subtitleLabel.numberOfLines = 1
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subtitleLabel)
        
        // Title
        titleLabel.text = title
        titleLabel.font = .systemFont(
            ofSize: DSTokens.Typography.projectHeaderTitleSize,
            weight: UIFont.Weight(DSTokens.Typography.projectHeaderTitleWeight)
        )
        titleLabel.textColor = UIColor(DSTokens.Colors.projectHeaderTitle)
        titleLabel.numberOfLines = 1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        // Action buttons
        var previousButton: UIButton?
        for actionIcon in actionIcons {
            let button = UIButton(type: .system)
            let config = UIImage.SymbolConfiguration(
                pointSize: DSTokens.Sizing.projectHeaderIconSize,
                weight: .regular
            )
            button.setImage(
                UIImage(systemName: actionIcon.iconName, withConfiguration: config),
                for: .normal
            )
            button.tintColor = UIColor(DSTokens.Colors.projectHeaderIconButton)
            button.backgroundColor = .clear
            button.layer.cornerRadius = DSTokens.Borders.radiusMedium
            button.clipsToBounds = true
            button.translatesAutoresizingMaskIntoConstraints = false
            
            let action = DSProjectHeaderAction(
                iconName: actionIcon.iconName,
                action: actionIcon.action
            )
            actions.append(action)
            actionButtons.append(button)
            
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            addSubview(button)
            
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: DSTokens.Sizing.projectHeaderButtonSize),
                button.heightAnchor.constraint(equalToConstant: DSTokens.Sizing.projectHeaderButtonSize)
            ])
            
            if let prev = previousButton {
                button.leadingAnchor.constraint(equalTo: prev.trailingAnchor,
                                                constant: DSTokens.Spacing.projectHeaderGap).isActive = true
            }
            
            previousButton = button
        }
        
        // Layout constraints
        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: DSTokens.Sizing.projectHeaderHeight),
            
            // Logo: top-aligned with padding
            logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                    constant: DSTokens.Spacing.projectHeaderPaddingH),
            logoImageView.topAnchor.constraint(equalTo: topAnchor,
                                               constant: DSTokens.Spacing.projectHeaderPaddingV),
            logoImageView.widthAnchor.constraint(equalToConstant: DSTokens.Sizing.projectHeaderLogoSize),
            logoImageView.heightAnchor.constraint(equalToConstant: DSTokens.Sizing.projectHeaderLogoSize),
            
            // Text column: top-aligned, fills remaining horizontal space
            subtitleLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor,
                                                    constant: DSTokens.Spacing.projectHeaderGap),
            subtitleLabel.topAnchor.constraint(equalTo: topAnchor,
                                               constant: DSTokens.Spacing.projectHeaderPaddingV),
            
            titleLabel.leadingAnchor.constraint(equalTo: subtitleLabel.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor,
                                            constant: DSTokens.Spacing.projectHeaderColumnGap),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor,
                                              constant: -DSTokens.Spacing.projectHeaderPaddingV),
        ])
        
        // Text column trailing constraint to first button (fill behavior)
        if let firstButton = actionButtons.first {
            firstButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                  constant: -DSTokens.Spacing.projectHeaderPaddingH).isActive = true
            firstButton.topAnchor.constraint(equalTo: topAnchor,
                                             constant: DSTokens.Spacing.projectHeaderPaddingV).isActive = true
            
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: firstButton.leadingAnchor,
                                                    constant: -DSTokens.Spacing.projectHeaderGap).isActive = true
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: firstButton.leadingAnchor,
                                                 constant: -DSTokens.Spacing.projectHeaderGap).isActive = true
        } else {
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor,
                                                    constant: -DSTokens.Spacing.projectHeaderPaddingH).isActive = true
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor,
                                                 constant: -DSTokens.Spacing.projectHeaderPaddingH).isActive = true
        }
        
        if actionButtons.count > 1 {
            for i in 1..<actionButtons.count {
                actionButtons[i].trailingAnchor.constraint(equalTo: actionButtons[i - 1].leadingAnchor,
                                                           constant: -DSTokens.Spacing.projectHeaderGap).isActive = true
                actionButtons[i].topAnchor.constraint(equalTo: topAnchor,
                                                      constant: DSTokens.Spacing.projectHeaderPaddingV).isActive = true
            }
        }
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let index = actionButtons.firstIndex(of: sender) else { return }
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        actions[index].action()
    }
    
    public func updateTitle(_ title: String) {
        titleLabel.text = title
    }
    
    public func updateSubtitle(_ subtitle: String) {
        subtitleLabel.text = subtitle
    }
    
    public func updateLogoImage(_ image: UIImage?) {
        logoImageView.image = image
    }
}
#endif
