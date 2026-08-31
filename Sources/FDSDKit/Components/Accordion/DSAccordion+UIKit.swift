#if canImport(UIKit)
import UIKit
import SwiftUI

/// A model representing a single accordion item for UIKit
public class DSAccordionItemUIKit {
    public let title: String
    public let icon: UIImage?
    public var isExpanded: Bool
    public let isDisabled: Bool
    public let content: UIView
    
    public init(
        title: String,
        icon: UIImage? = nil,
        isExpanded: Bool = false,
        isDisabled: Bool = false,
        content: UIView
    ) {
        self.title = title
        self.icon = icon
        self.isExpanded = isExpanded
        self.isDisabled = isDisabled
        self.content = content
    }
}

/// UIKit wrapper for DSAccordion
public class DSAccordionUIKit: UIView {
    private var items: [DSAccordionItemUIKit] = []
    private var headerButtons: [UIButton] = []
    private var contentViews: [UIView] = []
    private var chevronImageViews: [UIImageView] = []
    
    public var configuration = DSAccordionConfiguration()
    public var onItemToggled: ((Int, Bool) -> Void)?
    
    private let stackView = UIStackView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        stackView.axis = .vertical
        stackView.spacing = DSTokens.Spacing.accordionItemGap
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    /// Configures the accordion with items
    public func configure(with items: [DSAccordionItemUIKit]) {
        self.items = items
        setupItems()
    }
    
    private func setupItems() {
        // Clear existing views
        headerButtons.forEach { $0.removeFromSuperview() }
        contentViews.forEach { $0.removeFromSuperview() }
        chevronImageViews.forEach { $0.removeFromSuperview() }
        headerButtons.removeAll()
        contentViews.removeAll()
        chevronImageViews.removeAll()
        
        for (index, item) in items.enumerated() {
            // Create header button
            let headerButton = createHeaderButton(for: item, at: index)
            headerButtons.append(headerButton)
            stackView.addArrangedSubview(headerButton)
            
            // Create content view
            let contentView = item.content
            contentView.isHidden = !item.isExpanded
            contentView.translatesAutoresizingMaskIntoConstraints = false
            contentViews.append(contentView)
            stackView.addArrangedSubview(contentView)
            
            // Apply initial state
            if item.isExpanded {
                expandItem(at: index, animated: false)
            }
        }
    }
    
    private func createHeaderButton(for item: DSAccordionItemUIKit, at index: Int) -> UIButton {
        let button = UIButton(type: .custom)
        button.tag = index
        button.backgroundColor = UIColor(DSTokens.Colors.accordionBackground)
        button.layer.cornerRadius = DSTokens.Sizing.accordionItemRadius
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: DSTokens.Sizing.accordionHeaderHeight).isActive = true
        
        // Add tap handler
        button.addTarget(self, action: #selector(headerTapped(_:)), for: .touchUpInside)
        
        // Create content layout
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = DSTokens.Spacing.xs
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: button.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: DSTokens.Spacing.accordionHeaderPadding),
            stackView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -DSTokens.Spacing.accordionHeaderPadding),
            stackView.bottomAnchor.constraint(equalTo: button.bottomAnchor)
        ])
        
        // Icon
        if let icon = item.icon {
            let iconImageView = UIImageView(image: icon)
            iconImageView.tintColor = UIColor(DSTokens.Colors.accordionHeaderText)
            iconImageView.contentMode = .scaleAspectFit
            iconImageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                iconImageView.widthAnchor.constraint(equalToConstant: DSTokens.Sizing.accordionIconSize),
                iconImageView.heightAnchor.constraint(equalToConstant: DSTokens.Sizing.accordionIconSize)
            ])
            stackView.addArrangedSubview(iconImageView)
        }
        
        // Title
        let titleLabel = UILabel()
        titleLabel.text = item.title
        titleLabel.font = .systemFont(
            ofSize: DSTokens.Typography.accordionTitleSize,
            weight: UIFont.Weight(DSTokens.Typography.accordionTitleWeight)
        )
        titleLabel.textColor = UIColor(DSTokens.Colors.accordionHeaderText)
        stackView.addArrangedSubview(titleLabel)
        
        // Spacer
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stackView.addArrangedSubview(spacer)
        
        // Chevron
        let chevronImage = UIImage(systemName: "chevron.right")
        let chevronImageView = UIImageView(image: chevronImage)
        chevronImageView.tintColor = UIColor(DSTokens.Colors.accordionSubtext)
        chevronImageView.contentMode = .scaleAspectFit
        chevronImageView.tag = index
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chevronImageView.widthAnchor.constraint(equalToConstant: 12),
            chevronImageView.heightAnchor.constraint(equalToConstant: 12)
        ])
        chevronImageViews.append(chevronImageView)
        stackView.addArrangedSubview(chevronImageView)
        
        // Apply disabled state
        if item.isDisabled {
            button.alpha = 0.5
            button.isUserInteractionEnabled = false
        }
        
        return button
    }
    
    @objc private func headerTapped(_ sender: UIButton) {
        let index = sender.tag
        guard index < items.count, !items[index].isDisabled else { return }
        
        if items[index].isExpanded {
            collapseItem(at: index, animated: true)
        } else {
            // Handle single expand mode
            if !configuration.allowsMultipleExpansion {
                for i in items.indices where items[i].isExpanded {
                    collapseItem(at: i, animated: true)
                }
            }
            expandItem(at: index, animated: true)
        }
        
        onItemToggled?(index, items[index].isExpanded)
    }
    
    private func expandItem(at index: Int, animated: Bool) {
        guard index < items.count, index < contentViews.count else { return }
        
        items[index].isExpanded = true
        let contentView = contentViews[index]
        
        let action = {
            contentView.isHidden = false
            contentView.alpha = 1.0
            
            // Rotate chevron
            if index < self.chevronImageViews.count {
                self.chevronImageViews[index].transform = CGAffineTransform(rotationAngle: .pi / 2)
            }
        }
        
        if animated {
            UIView.animate(withDuration: configuration.animationDuration, animations: action)
        } else {
            action()
        }
    }
    
    private func collapseItem(at index: Int, animated: Bool) {
        guard index < items.count, index < contentViews.count else { return }
        
        items[index].isExpanded = false
        let contentView = contentViews[index]
        
        let action = {
            contentView.alpha = 0.0
            contentView.isHidden = true
            
            // Rotate chevron back
            if index < self.chevronImageViews.count {
                self.chevronImageViews[index].transform = .identity
            }
        }
        
        if animated {
            UIView.animate(withDuration: configuration.animationDuration, animations: action)
        } else {
            action()
        }
    }
    
    /// Expands all items
    public func expandAll() {
        guard configuration.allowsMultipleExpansion else { return }
        for index in items.indices where !items[index].isDisabled {
            expandItem(at: index, animated: true)
        }
    }
    
    /// Collapses all items
    public func collapseAll() {
        for index in items.indices where !items[index].isDisabled {
            collapseItem(at: index, animated: true)
        }
    }
}
#endif
