#if canImport(UIKit)
import UIKit
import SwiftUI

/// UIKit wrapper for DSPill
public class DSPillUIKit: UIView {
    // MARK: - Properties
    public var text: String {
        didSet { textLabel.text = text }
    }
    
    public var isDismissible: Bool {
        didSet { closeButton.isHidden = !isDismissible }
    }
    
    public var state: DSPillState {
        didSet { applyState() }
    }
    
    public var onTap: (() -> Void)?
    public var onDismiss: (() -> Void)?
    
    // MARK: - UI Elements
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: DSTokens.Typography.pillFontSize,
                                 weight: UIFont.Weight(DSTokens.Typography.pillFontWeight))
        label.textColor = UIColor(DSTokens.Colors.pillText)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: DSTokens.Sizing.pillCloseIconSize,
                                                  weight: .regular)
        button.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
        button.tintColor = UIColor(DSTokens.Colors.pillText)
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [textLabel, closeButton])
        stack.axis = .horizontal
        stack.spacing = DSTokens.Spacing.pillIconTextGap
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Initialization
    public init(text: String,
                isDismissible: Bool = true,
                state: DSPillState = .default,
                onTap: (() -> Void)? = nil,
                onDismiss: (() -> Void)? = nil) {
        self.text = text
        self.isDismissible = isDismissible
        self.state = state
        self.onTap = onTap
        self.onDismiss = onDismiss
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    private func configure() {
        textLabel.text = text
        closeButton.isHidden = !isDismissible
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DSTokens.Spacing.pillHorizontalPadding),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DSTokens.Spacing.pillHorizontalPadding),
            heightAnchor.constraint(equalToConstant: DSTokens.Sizing.pillHeight)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pillTapped))
        addGestureRecognizer(tapGesture)
        
        applyState()
    }
    
    private func applyState() {
        backgroundColor = UIColor(state.backgroundColor)
        layer.cornerRadius = DSTokens.Sizing.pillRadius
        layer.masksToBounds = true
        
        layer.borderWidth = state.borderWidth
        layer.borderColor = state.borderColor.cgColor
    }
    
    // MARK: - Actions
    @objc private func pillTapped() {
        onTap?()
    }
    
    @objc private func closeTapped() {
        onDismiss?()
    }
    
    // MARK: - Public Methods
    public func updateText(_ text: String) {
        self.text = text
    }
    
    public override var accessibilityLabel: String? {
        get { "Pill: \(text)" }
        set { super.accessibilityLabel = newValue }
    }
}
#endif
