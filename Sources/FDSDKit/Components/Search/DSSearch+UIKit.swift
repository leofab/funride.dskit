#if canImport(UIKit)
import SwiftUI
import UIKit

// MARK: - UIViewRepresentable Wrapper

public struct DSSearchUIView: UIViewRepresentable {
    @Binding var text: String
    let placeholder: String
    let style: DSSearchStyle
    let isDisabled: Bool
    let showsFilter: Bool
    var onSearch: ((String) -> Void)?
    var onClear: (() -> Void)?
    var onFilterTap: (() -> Void)?
    
    public init(
        text: Binding<String>,
        placeholder: String = "Search...",
        style: DSSearchStyle = .default,
        isDisabled: Bool = false,
        showsFilter: Bool = false,
        onSearch: ((String) -> Void)? = nil,
        onClear: (() -> Void)? = nil,
        onFilterTap: (() -> Void)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.style = style
        self.isDisabled = isDisabled
        self.showsFilter = showsFilter
        self.onSearch = onSearch
        self.onClear = onClear
        self.onFilterTap = onFilterTap
    }
    
    public func makeUIView(context: Context) -> DSSearchView {
        let view = DSSearchView()
        view.text = text
        view.placeholder = placeholder
        view.style = style
        view.isDisabled = isDisabled
        view.showsFilter = showsFilter
        view.onSearch = onSearch
        view.onClear = onClear
        view.onFilterTap = onFilterTap
        view.delegate = context.coordinator
        return view
    }
    
    public func updateUIView(_ uiView: DSSearchView, context: Context) {
        uiView.text = text
        uiView.placeholder = placeholder
        uiView.style = style
        uiView.isDisabled = isDisabled
        uiView.showsFilter = showsFilter
        uiView.updateAppearance()
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public class Coordinator: NSObject, DSSearchViewDelegate {
        var parent: DSSearchUIView
        
        init(_ parent: DSSearchUIView) {
            self.parent = parent
        }
        
        public func searchView(_ searchView: DSSearchView, didUpdateSearch text: String) {
            parent.text = text
            parent.onSearch?(text)
        }
        
        public func searchViewDidTapClear(_ searchView: DSSearchView) {
            parent.text = ""
            parent.onClear?()
        }
        
        public func searchViewDidTapFilter(_ searchView: DSSearchView) {
            parent.onFilterTap?()
        }
    }
}

// MARK: - Delegate Protocol

public protocol DSSearchViewDelegate: AnyObject {
    func searchView(_ searchView: DSSearchView, didUpdateSearch text: String)
    func searchViewDidTapClear(_ searchView: DSSearchView)
    func searchViewDidTapFilter(_ searchView: DSSearchView)
}

// MARK: - UIKit Search View

public class DSSearchView: UIView {
    public var text: String = "" {
        didSet { textField.text = text; updateClearButtonVisibility() }
    }
    
    public var placeholder: String = "Search..." {
        didSet { updatePlaceholder() }
    }
    
    public var style: DSSearchStyle = .default {
        didSet { updateAppearance() }
    }
    
    public var isDisabled: Bool = false {
        didSet { updateAppearance() }
    }
    
    public var showsFilter: Bool = false {
        didSet { updateLayout() }
    }
    
    public var onSearch: ((String) -> Void)?
    public var onClear: (() -> Void)?
    public var onFilterTap: (() -> Void)?
    
    public weak var delegate: DSSearchViewDelegate?
    
    // MARK: - UI Elements
    
    private let searchIcon = UIImageView()
    private let textField = UITextField()
    private let clearButton = UIButton(type: .system)
    private let filterButton = UIButton(type: .system)
    
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
        
        // Search Icon
        let searchConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .regular)
        searchIcon.image = UIImage(systemName: "magnifyingglass", withConfiguration: searchConfig)
        searchIcon.tintColor = UIColor(DSTokens.Colors.inputTextDisabled)
        searchIcon.contentMode = .scaleAspectFit
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        addSubview(searchIcon)
        
        // TextField
        let inputFont = UIFont.systemFont(ofSize: DSTokens.Typography.inputFontSize,
                                          weight: UIFont.Weight(DSTokens.Typography.inputFontWeight))
        textField.font = inputFont
        textField.textColor = UIColor(DSTokens.Colors.inputText)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        addSubview(textField)
        
        // Clear Button
        let clearConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .regular)
        clearButton.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: clearConfig), for: .normal)
        clearButton.tintColor = UIColor(DSTokens.Colors.inputTextDisabled)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        clearButton.isHidden = true
        addSubview(clearButton)
        
        // Filter Button
        let filterConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .regular)
        filterButton.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle", withConfiguration: filterConfig), for: .normal)
        filterButton.tintColor = UIColor(DSTokens.Colors.inputTextDisabled)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.addTarget(self, action: #selector(filterTapped), for: .touchUpInside)
        filterButton.isHidden = true
        addSubview(filterButton)
        
        NSLayoutConstraint.activate([
            searchIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DSTokens.Spacing.inputIconGap),
            searchIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchIcon.widthAnchor.constraint(equalToConstant: 16),
            searchIcon.heightAnchor.constraint(equalToConstant: 16),
            
            textField.leadingAnchor.constraint(equalTo: searchIcon.trailingAnchor, constant: DSTokens.Spacing.inputIconGap),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor),
            textField.trailingAnchor.constraint(equalTo: clearButton.leadingAnchor, constant: -DSTokens.Spacing.inputIconGap),
            textField.heightAnchor.constraint(equalToConstant: DSTokens.Sizing.inputHeight),
            
            clearButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            clearButton.widthAnchor.constraint(equalToConstant: 16),
            clearButton.heightAnchor.constraint(equalToConstant: 16),
            
            filterButton.leadingAnchor.constraint(equalTo: clearButton.trailingAnchor, constant: DSTokens.Spacing.inputIconGap),
            filterButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            filterButton.widthAnchor.constraint(equalToConstant: 16),
            filterButton.heightAnchor.constraint(equalToConstant: 16),
            filterButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DSTokens.Spacing.inputIconGap)
        ])
        
        textField.addTarget(self, action: #selector(textFieldDidBegin), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldDidEnd), for: .editingDidEnd)
        
        updatePlaceholder()
        updateAppearance()
    }
    
    // MARK: - Actions
    
    @objc private func clearTapped() {
        textField.text = ""
        text = ""
        updateClearButtonVisibility()
        onClear?()
        delegate?.searchViewDidTapClear(self)
    }
    
    @objc private func filterTapped() {
        onFilterTap?()
        delegate?.searchViewDidTapFilter(self)
    }
    
    @objc private func textFieldDidChange() {
        let value = textField.text ?? ""
        text = value
        updateClearButtonVisibility()
        onSearch?(value)
        delegate?.searchView(self, didUpdateSearch: value)
    }
    
    @objc private func textFieldDidBegin() {
        style = .focus
    }
    
    @objc private func textFieldDidEnd() {
        style = .default
    }
    
    // MARK: - Update
    
    public func updateAppearance() {
        let currentStyle = resolveStyle()
        
        backgroundColor = UIColor(currentStyle.backgroundColor)
        textField.textColor = UIColor(currentStyle.textColor)
        alpha = CGFloat(currentStyle.opacity)
        
        updatePlaceholder()
        
        // Border
        layer.borderWidth = currentStyle.borderWidth
        if let bc = currentStyle.borderColor {
            layer.borderColor = UIColor(bc).cgColor
        } else {
            layer.borderColor = UIColor.clear.cgColor
        }
        
        // Icon colors
        searchIcon.tintColor = UIColor(currentStyle.iconColor)
        clearButton.tintColor = UIColor(currentStyle.iconColor)
        filterButton.tintColor = UIColor(currentStyle.iconColor)
        
        textField.isUserInteractionEnabled = !isDisabled
    }
    
    private func updatePlaceholder() {
        let currentStyle = resolveStyle()
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: UIColor(currentStyle.placeholderColor),
                .font: UIFont.systemFont(ofSize: DSTokens.Typography.inputFontSize,
                                        weight: UIFont.Weight(DSTokens.Typography.inputFontWeight))
            ]
        )
    }
    
    private func updateLayout() {
        filterButton.isHidden = !showsFilter
        updateClearButtonVisibility()
    }
    
    private func updateClearButtonVisibility() {
        clearButton.isHidden = text.isEmpty
    }
    
    private func resolveStyle() -> DSSearchStyle {
        if isDisabled { return .disabled }
        return style
    }
}

// MARK: - UITextFieldDelegate

extension DSSearchView: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
#endif
