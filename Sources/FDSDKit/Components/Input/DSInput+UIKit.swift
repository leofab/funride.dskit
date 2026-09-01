#if canImport(UIKit)
import SwiftUI
import UIKit

// MARK: - UIViewRepresentable Wrapper

public struct DSInputUIView: UIViewRepresentable {
    @Binding var text: String
    let placeholder: String
    let style: DSInputStyle
    let isDisabled: Bool
    let showsSwatch: Bool
    let swatchColor: UIColor
    var onSwatchTap: (() -> Void)?
    var onCommit: ((String) -> Void)?
    var validator: ((String) -> Bool)?
    
    public init(
        text: Binding<String>,
        placeholder: String = "",
        style: DSInputStyle = .default,
        isDisabled: Bool = false,
        showsSwatch: Bool = false,
        swatchColor: UIColor = .white,
        onSwatchTap: (() -> Void)? = nil,
        onCommit: ((String) -> Void)? = nil,
        validator: ((String) -> Bool)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.style = style
        self.isDisabled = isDisabled
        self.showsSwatch = showsSwatch
        self.swatchColor = swatchColor
        self.onSwatchTap = onSwatchTap
        self.onCommit = onCommit
        self.validator = validator
    }
    
    public func makeUIView(context: Context) -> DSInputView {
        let view = DSInputView()
        view.text = text
        view.placeholder = placeholder
        view.style = style
        view.isDisabled = isDisabled
        view.showsSwatch = showsSwatch
        view.swatchColor = swatchColor
        view.onSwatchTap = onSwatchTap
        view.onCommit = onCommit
        view.validator = validator
        view.delegate = context.coordinator
        return view
    }
    
    public func updateUIView(_ uiView: DSInputView, context: Context) {
        uiView.text = text
        uiView.placeholder = placeholder
        uiView.style = style
        uiView.isDisabled = isDisabled
        uiView.showsSwatch = showsSwatch
        uiView.swatchColor = swatchColor
        uiView.updateAppearance()
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public class Coordinator: NSObject, DSInputViewDelegate {
        var parent: DSInputUIView
        
        init(_ parent: DSInputUIView) {
            self.parent = parent
        }
        
        public func inputView(_ inputView: DSInputView, didCommitText value: String) {
            parent.text = value
            parent.onCommit?(value)
        }
        
        public func inputViewDidTapSwatch(_ inputView: DSInputView) {
            parent.onSwatchTap?()
        }
    }
}

// MARK: - Delegate Protocol

public protocol DSInputViewDelegate: AnyObject {
    func inputView(_ inputView: DSInputView, didCommitText value: String)
    func inputViewDidTapSwatch(_ inputView: DSInputView)
}

// MARK: - UIKit Input View

public class DSInputView: UIView {
    public var text: String = "" {
        didSet { textField.text = text }
    }
    
    public var placeholder: String = "" {
        didSet { textField.placeholder = placeholder }
    }
    
    public var style: DSInputStyle = .default {
        didSet { updateAppearance() }
    }
    
    public var isDisabled: Bool = false {
        didSet { updateAppearance() }
    }
    
    public var showsSwatch: Bool = false {
        didSet { updateLayout() }
    }
    
    public var swatchColor: UIColor = .white {
        didSet { swatchView.backgroundColor = swatchColor }
    }
    
    public var onSwatchTap: (() -> Void)?
    public var onCommit: ((String) -> Void)?
    public var validator: ((String) -> Bool)?
    
    public weak var delegate: DSInputViewDelegate?
    
    private var previousValidText: String = ""
    
    // MARK: - UI Elements
    
    private let swatchView = UIView()
    private let textField = UITextField()
    
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
        backgroundColor = UIColor(DSTokens.Colors.inputDefault)
        layer.cornerRadius = DSTokens.Sizing.inputRadius
        clipsToBounds = true
        
        // Swatch
        swatchView.layer.cornerRadius = 4
        swatchView.translatesAutoresizingMaskIntoConstraints = false
        swatchView.isHidden = true
        addSubview(swatchView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(swatchTapped))
        swatchView.addGestureRecognizer(tapGesture)
        
        // TextField
        let inputFont = UIFont.systemFont(ofSize: DSTokens.Typography.inputFontSize,
                                          weight: UIFont.Weight(DSTokens.Typography.inputFontWeight))
        textField.font = inputFont
        textField.textColor = UIColor(DSTokens.Colors.inputText)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        addSubview(textField)
        
        NSLayoutConstraint.activate([
            swatchView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DSTokens.Spacing.inputIconGap),
            swatchView.centerYAnchor.constraint(equalTo: centerYAnchor),
            swatchView.widthAnchor.constraint(equalToConstant: DSTokens.Sizing.inputSwatchSize),
            swatchView.heightAnchor.constraint(equalToConstant: DSTokens.Sizing.inputSwatchSize),
            
            textField.leadingAnchor.constraint(equalTo: swatchView.trailingAnchor, constant: DSTokens.Spacing.inputIconGap),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DSTokens.Spacing.inputIconGap),
            textField.heightAnchor.constraint(equalToConstant: DSTokens.Sizing.inputHeight)
        ])
        
        textField.addTarget(self, action: #selector(textFieldDidBegin), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldDidEnd), for: .editingDidEnd)
        
        previousValidText = text
        updateAppearance()
    }
    
    // MARK: - Actions
    
    @objc private func swatchTapped() {
        onSwatchTap?()
        delegate?.inputViewDidTapSwatch(self)
    }
    
    @objc private func textFieldDidBegin() {
        // Select all text on focus
        textField.selectAll(nil)
        previousValidText = textField.text ?? ""
    }
    
    @objc private func textFieldDidEnd() {
        commitChanges()
    }
    
    // MARK: - Update
    
    public func updateAppearance() {
        let currentStyle = resolveStyle()
        
        backgroundColor = UIColor(currentStyle.backgroundColor)
        textField.textColor = UIColor(currentStyle.textColor)
        alpha = CGFloat(currentStyle.opacity)
        
        // Placeholder
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: UIColor(currentStyle.placeholderColor),
                .font: UIFont.systemFont(ofSize: DSTokens.Typography.inputFontSize,
                                        weight: UIFont.Weight(DSTokens.Typography.inputFontWeight))
            ]
        )
        
        // Border
        layer.borderWidth = currentStyle.borderWidth
        if let bc = currentStyle.borderColor {
            layer.borderColor = UIColor(bc).cgColor
        } else {
            layer.borderColor = UIColor.clear.cgColor
        }
        
        // Swatch
        swatchView.backgroundColor = swatchColor
        
        textField.isUserInteractionEnabled = !isDisabled
    }
    
    private func updateLayout() {
        swatchView.isHidden = !showsSwatch
    }
    
    private func resolveStyle() -> DSInputStyle {
        if isDisabled { return .disabled }
        return style
    }
    
    private func commitChanges() {
        let value = textField.text ?? ""
        
        if let validator = validator, !validator(value) {
            // Invalid: revert
            textField.text = previousValidText
            text = previousValidText
            return
        }
        
        text = value
        previousValidText = value
        delegate?.inputView(self, didCommitText: value)
        onCommit?(value)
    }
}

// MARK: - UITextFieldDelegate

extension DSInputView: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
#endif
