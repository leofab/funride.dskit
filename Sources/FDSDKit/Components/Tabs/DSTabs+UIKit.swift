#if canImport(UIKit)
import UIKit
import SwiftUI

/// UIKit wrapper for DSTabs
public class DSTabsUIKit: UIView {
    // MARK: - Properties
    public var items: [DSTabItem] {
        didSet { reloadTabs() }
    }
    
    public var selectedIndex: Int {
        didSet { updateSelectedTab() }
    }
    
    public var variant: DSTabsVariant {
        didSet { reloadTabs() }
    }
    
    public var onSelection: ((Int) -> Void)?
    
    // MARK: - UI Elements
    private var tabButtons: [UIButton] = []
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = DSTokens.Spacing.tabsItemGap
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Initialization
    public init(items: [DSTabItem],
                selectedIndex: Int = 0,
                variant: DSTabsVariant = .iconText,
                onSelection: ((Int) -> Void)? = nil) {
        self.items = items
        self.selectedIndex = selectedIndex
        self.variant = variant
        self.onSelection = onSelection
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    private func configure() {
        backgroundColor = UIColor(DSTokens.Colors.tabsContainerBackground)
        layer.cornerRadius = DSTokens.Sizing.tabsBorderRadius
        layer.masksToBounds = true
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        reloadTabs()
    }
    
    private func reloadTabs() {
        tabButtons.forEach { $0.removeFromSuperview() }
        tabButtons.removeAll()
        
        for (index, item) in items.enumerated() {
            let button = createTabButton(item: item, index: index)
            tabButtons.append(button)
            stackView.addArrangedSubview(button)
        }
        
        updateSelectedTab()
    }
    
    private func createTabButton(item: DSTabItem, index: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.tag = index
        button.addTarget(self, action: #selector(tabTapped(_:)), for: .touchUpInside)
        
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(
            top: DSTokens.Spacing.tabsItemPaddingVertical,
            leading: DSTokens.Spacing.tabsItemPaddingHorizontal,
            bottom: DSTokens.Spacing.tabsItemPaddingVertical,
            trailing: DSTokens.Spacing.tabsItemPaddingHorizontal
        )
        
        var title = AttributedString(item.label)
        title.font = .systemFont(ofSize: DSTokens.Typography.tabsLabelSize,
                                 weight: UIFont.Weight(DSTokens.Typography.tabsLabelWeight))
        config.attributedTitle = title
        
        if let iconName = item.icon, variant != .text {
            config.image = UIImage(systemName: iconName)
            config.imagePadding = DSTokens.Spacing.tabsIconTextGap
            config.imagePlacement = .leading
        }
        
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: DSTokens.Sizing.tabsHeight)
        ])
        
        return button
    }
    
    private func updateSelectedTab() {
        for (index, button) in tabButtons.enumerated() {
            let isSelected = index == selectedIndex
            let style: DSTabsStyle = isSelected ? .selected : .default
            
            button.backgroundColor = UIColor(style.backgroundColor)
            button.layer.cornerRadius = DSTokens.Sizing.tabsBorderRadius
            button.layer.masksToBounds = true
            
            if var config = button.configuration {
                config.baseForegroundColor = UIColor(style.textColor)
                button.configuration = config
            }
        }
    }
    
    // MARK: - Actions
    @objc private func tabTapped(_ sender: UIButton) {
        selectedIndex = sender.tag
        onSelection?(selectedIndex)
    }
    
    // MARK: - Public Methods
    public func setSelectedIndex(_ index: Int) {
        guard index >= 0 && index < items.count else { return }
        selectedIndex = index
    }
    
    public override var accessibilityLabel: String? {
        get { "Tabs: \(items.map(\.label).joined(separator: ", "))" }
        set { super.accessibilityLabel = newValue }
    }
}
#endif
