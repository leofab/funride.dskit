#if canImport(UIKit)
import SwiftUI
import UIKit

// MARK: - UIViewRepresentable Wrapper

public struct DSTextAreaUIView: UIViewRepresentable {
    @Binding var text: String
    let label: String
    let placeholder: String
    let style: DSTextAreaStyle
    let isDisabled: Bool
    var onCommit: ((String) -> Void)?
    var validator: ((String) -> Bool)?
    
    public init(
        text: Binding<String>,
        label: String = "",
        placeholder: String = "",
        style: DSTextAreaStyle = .default,
        isDisabled: Bool = false,
        onCommit: ((String) -> Void)? = nil,
        validator: ((String) -> Bool)? = nil
    ) {
        self._text = text
        self.label = label
        self.placeholder = placeholder
        self.style = style
        self.isDisabled = isDisabled
        self.onCommit = onCommit
        self.validator = validator
    }
    
    public func makeUIView(context: Context) -> DSTextAreaView {
        let view = DSTextAreaView()
        view.text = text
        view.label = label
        view.placeholder = placeholder
        view.style = style
        view.isDisabled = isDisabled
        view.onCommit = onCommit
        view.validator = validator
        view.delegate = context.coordinator
        return view
    }
    
    public func updateUIView(_ uiView: DSTextAreaView, context: Context) {
        uiView.text = text
        uiView.label = label
        uiView.placeholder = placeholder
        uiView.style = style
        uiView.isDisabled = isDisabled
        uiView.updateAppearance()
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public class Coordinator: NSObject, DSTextAreaViewDelegate {
        var parent: DSTextAreaUIView
        
        init(_ parent: DSTextAreaUIView) {
            self.parent = parent
        }
        
        public func textView(_ textView: DSTextAreaView, didCommitText value: String) {
            parent.text = value
            parent.onCommit?(value)
        }
    }
}

// MARK: - Delegate Protocol

public protocol DSTextAreaViewDelegate: AnyObject {
    func textView(_ textView: DSTextAreaView, didCommitText value: String)
}

// MARK: - UIKit TextAreaView

public class DSTextAreaView: UIView {
    public var text: String = "" {
        didSet { textView.text = text }
    }
    
    public var label: String = "" {
        didSet { updateLabel() }
    }
    
    public var placeholder: String = "" {
        didSet { updatePlaceholder() }
    }
    
    public var style: DSTextAreaStyle = .default {
        didSet { updateAppearance() }
    }
    
    public var isDisabled: Bool = false {
        didSet { updateAppearance() }
    }
    
    public var onCommit: ((String) -> Void)?
    public var validator: ((String) -> Bool)?
    
    public weak var delegate: DSTextAreaViewDelegate?
    
    private var previousValidText: String = ""
    
    // MARK: - UI Elements
    
    private let labelView = UILabel()
    private let textView = UITextView()
    private let placeholderLabel = UILabel()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        // Label
        labelView.font = UIFont.systemFont(ofSize: DSTokens.Typography.textAreaLabelSize,
                                           weight: UIFont.Weight(DSTokens.Typography.textAreaLabelWeight))
        labelView.textColor = UIColor(DSTokens.Colors.textAreaText)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelView)
        
        // TextView container
        let containerView = UIView()
        containerView.backgroundColor = UIColor(DSTokens.Colors.textAreaDefault)
        containerView.layer.cornerRadius = DSTokens.Sizing.textAreaRadius
        containerView.clipsToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        // TextView
        textView.font = UIFont.systemFont(ofSize: DSTokens.Typography.textAreaFontSize,
                                          weight: UIFont.Weight(DSTokens.Typography.textAreaFontWeight))
        textView.textColor = UIColor(DSTokens.Colors.textAreaText)
        textView.backgroundColor = .clear
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        textView.textContainerInset = UIEdgeInsets(
            top: DSTokens.Spacing.textAreaPadding,
            left: DSTokens.Spacing.textAreaPadding - 4,
            bottom: DSTokens.Spacing.textAreaPadding,
            right: DSTokens.Spacing.textAreaPadding - 4
        )
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        containerView.addSubview(textView)
        
        // Placeholder
        placeholderLabel.font = UIFont.systemFont(ofSize: DSTokens.Typography.textAreaFontSize,
                                                  weight: UIFont.Weight(DSTokens.Typography.textAreaFontWeight))
        placeholderLabel.textColor = UIColor(DSTokens.Colors.textAreaTextPlaceholder)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            labelView.topAnchor.constraint(equalTo: topAnchor),
            labelView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            containerView.topAnchor.constraint(equalTo: labelView.bottomAnchor, constant: DSTokens.Spacing.xs),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: DSTokens.Sizing.textAreaHeight),
            
            textView.topAnchor.constraint(equalTo: containerView.topAnchor),
            textView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: DSTokens.Spacing.textAreaPadding + 4),
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: DSTokens.Spacing.textAreaPadding)
        ])
        
        previousValidText = text
        updateAppearance()
    }
    
    // MARK: - Update
    
    public func updateLabel() {
        labelView.text = label
        labelView.isHidden = label.isEmpty
    }
    
    public func updatePlaceholder() {
        placeholderLabel.text = placeholder
        updatePlaceholderVisibility()
    }
    
    private func updatePlaceholderVisibility() {
        placeholderLabel.isHidden = !textView.text.isEmpty || isFirstResponder
    }
    
    public func updateAppearance() {
        let currentStyle = resolveStyle()
        
        backgroundColor = UIColor(currentStyle.backgroundColor)
        textView.textColor = UIColor(currentStyle.textColor)
        alpha = CGFloat(currentStyle.opacity)
        
        // Border
        layer.borderWidth = currentStyle.borderWidth
        if let bc = currentStyle.borderColor {
            layer.borderColor = UIColor(bc).cgColor
        } else {
            layer.borderColor = UIColor.clear.cgColor
        }
        
        textView.isEditable = !isDisabled
        updatePlaceholderVisibility()
    }
    
    private func resolveStyle() -> DSTextAreaStyle {
        if isDisabled { return .disabled }
        return style
    }
    
    private func commitChanges() {
        let value = textView.text ?? ""
        
        if let validator = validator, !validator(value) {
            // Invalid: revert
            textView.text = previousValidText
            text = previousValidText
            return
        }
        
        text = value
        previousValidText = value
        delegate?.textView(self, didCommitText: value)
        onCommit?(value)
    }
}

// MARK: - UITextViewDelegate

extension DSTextAreaView: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        updatePlaceholderVisibility()
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        previousValidText = textView.text ?? ""
        updatePlaceholderVisibility()
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        commitChanges()
        updatePlaceholderVisibility()
    }
}
#endif
