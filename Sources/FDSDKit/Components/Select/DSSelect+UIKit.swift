#if canImport(UIKit)
import SwiftUI
import UIKit

// MARK: - UIViewRepresentable Wrapper

public struct DSSelectUIView: UIViewRepresentable {
    @Binding var selection: String?
    let options: [DSSelectOption]
    let placeholder: String
    let label: String?
    let style: DSSelectStyle
    let isDisabled: Bool
    var onSelect: ((DSSelectOption) -> Void)?
    
    public init(
        selection: Binding<String?>,
        options: [DSSelectOption],
        placeholder: String = "Select...",
        label: String? = nil,
        style: DSSelectStyle = .default,
        isDisabled: Bool = false,
        onSelect: ((DSSelectOption) -> Void)? = nil
    ) {
        self._selection = selection
        self.options = options
        self.placeholder = placeholder
        self.label = label
        self.style = style
        self.isDisabled = isDisabled
        self.onSelect = onSelect
    }
    
    public func makeUIView(context: Context) -> DSSelectView {
        let view = DSSelectView()
        view.selection = selection
        view.options = options
        view.placeholder = placeholder
        view.labelText = label
        view.style = style
        view.isDisabled = isDisabled
        view.onSelect = onSelect
        view.delegate = context.coordinator
        return view
    }
    
    public func updateUIView(_ uiView: DSSelectView, context: Context) {
        uiView.selection = selection
        uiView.options = options
        uiView.placeholder = placeholder
        uiView.labelText = label
        uiView.style = style
        uiView.isDisabled = isDisabled
        uiView.updateAppearance()
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public class Coordinator: NSObject, DSSelectViewDelegate {
        var parent: DSSelectUIView
        
        init(_ parent: DSSelectUIView) {
            self.parent = parent
        }
        
        public func selectView(_ selectView: DSSelectView, didSelectOption option: DSSelectOption) {
            parent.selection = option.id
            parent.onSelect?(option)
        }
    }
}

// MARK: - Delegate Protocol

public protocol DSSelectViewDelegate: AnyObject {
    func selectView(_ selectView: DSSelectView, didSelectOption option: DSSelectOption)
}

// MARK: - UIKit Select View

public class DSSelectView: UIView {
    public var selection: String? = nil {
        didSet { updateSelectedLabel() }
    }
    
    public var options: [DSSelectOption] = [] {
        didSet { updateSelectedLabel() }
    }
    
    public var placeholder: String = "Select..." {
        didSet { updateSelectedLabel() }
    }
    
    public var labelText: String? = nil {
        didSet { updateLayout() }
    }
    
    public var style: DSSelectStyle = .default {
        didSet { updateAppearance() }
    }
    
    public var isDisabled: Bool = false {
        didSet { updateAppearance() }
    }
    
    public var onSelect: ((DSSelectOption) -> Void)?
    
    public weak var delegate: DSSelectViewDelegate?
    
    private var isDropdownVisible = false
    private var dropdownView: DSSelectDropdownView?
    
    // MARK: - UI Elements
    
    private let containerView = UIView()
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: DSTokens.Typography.selectLabelSize,
                                       weight: UIFont.Weight(DSTokens.Typography.selectLabelWeight))
        label.textColor = UIColor(DSTokens.Colors.selectText)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let selectButton = UIButton(type: .system)
    private let selectedLabel = UILabel()
    private let chevronImageView = UIImageView()
    
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
        // Container
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        // Label
        containerView.addSubview(label)
        
        // Select Button
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        selectButton.addTarget(self, action: #selector(selectTapped), for: .touchUpInside)
        containerView.addSubview(selectButton)
        
        // Selected Label
        selectedLabel.translatesAutoresizingMaskIntoConstraints = false
        selectedLabel.font = UIFont.systemFont(ofSize: DSTokens.Typography.selectFontSize,
                                               weight: UIFont.Weight(DSTokens.Typography.selectFontWeight))
        selectedLabel.textColor = UIColor(DSTokens.Colors.selectText)
        selectedLabel.lineBreakMode = .byTruncatingTail
        selectButton.addSubview(selectedLabel)
        
        // Chevron
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.image = UIImage(systemName: "chevron.down")
        chevronImageView.tintColor = UIColor(DSTokens.Colors.selectText)
        chevronImageView.contentMode = .scaleAspectFit
        selectButton.addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            label.topAnchor.constraint(equalTo: containerView.topAnchor),
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            selectButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: DSTokens.Spacing.xs),
            selectButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            selectButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            selectButton.heightAnchor.constraint(equalToConstant: DSTokens.Sizing.selectHeight),
            selectButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            selectedLabel.leadingAnchor.constraint(equalTo: selectButton.leadingAnchor, constant: DSTokens.Spacing.selectPadding),
            selectedLabel.centerYAnchor.constraint(equalTo: selectButton.centerYAnchor),
            selectedLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -DSTokens.Spacing.xs),
            
            chevronImageView.trailingAnchor.constraint(equalTo: selectButton.trailingAnchor, constant: -DSTokens.Spacing.selectPadding),
            chevronImageView.centerYAnchor.constraint(equalTo: selectButton.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: DSTokens.Sizing.selectIconSize),
            chevronImageView.heightAnchor.constraint(equalToConstant: DSTokens.Sizing.selectIconSize)
        ])
        
        // Button styling
        selectButton.layer.cornerRadius = DSTokens.Sizing.selectRadius
        selectButton.clipsToBounds = true
        
        updateAppearance()
        updateSelectedLabel()
        updateLayout()
    }
    
    // MARK: - Actions
    
    @objc private func selectTapped() {
        guard !isDisabled else { return }
        
        if isDropdownVisible {
            hideDropdown()
        } else {
            showDropdown()
        }
    }
    
    // MARK: - Dropdown
    
    private func showDropdown() {
        let dropdown = DSSelectDropdownView(options: options, selection: selection)
        dropdown.onSelect = { [weak self] option in
            self?.selectOption(option)
        }
        dropdown.onDismiss = { [weak self] in
            self?.hideDropdown()
        }
        
        dropdown.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dropdown)
        
        NSLayoutConstraint.activate([
            dropdown.topAnchor.constraint(equalTo: selectButton.bottomAnchor, constant: DSTokens.Spacing.selectDropdownPadding),
            dropdown.leadingAnchor.constraint(equalTo: leadingAnchor),
            dropdown.trailingAnchor.constraint(equalTo: trailingAnchor),
            dropdown.heightAnchor.constraint(lessThanOrEqualToConstant: DSTokens.Sizing.selectDropdownMaxHeight)
        ])
        
        dropdownView = dropdown
        isDropdownVisible = true
        
        // Animate
        dropdown.alpha = 0
        UIView.animate(withDuration: 0.2) {
            dropdown.alpha = 1
        }
    }
    
    private func hideDropdown() {
        guard let dropdown = dropdownView else { return }
        
        UIView.animate(withDuration: 0.2, animations: {
            dropdown.alpha = 0
        }) { [weak self] _ in
            dropdown.removeFromSuperview()
            self?.dropdownView = nil
            self?.isDropdownVisible = false
        }
    }
    
    private func selectOption(_ option: DSSelectOption) {
        selection = option.id
        hideDropdown()
        delegate?.selectView(self, didSelectOption: option)
        onSelect?(option)
    }
    
    // MARK: - Update
    
    public func updateAppearance() {
        let currentStyle = resolveStyle()
        
        selectButton.backgroundColor = UIColor(currentStyle.backgroundColor)
        selectedLabel.textColor = currentStyle.textColor == DSTokens.Colors.selectText ?
            UIColor(DSTokens.Colors.selectText) : UIColor(currentStyle.placeholderColor)
        
        alpha = CGFloat(currentStyle.opacity)
        
        // Border
        selectButton.layer.borderWidth = currentStyle.borderWidth
        if let bc = currentStyle.borderColor {
            selectButton.layer.borderColor = UIColor(bc).cgColor
        } else {
            selectButton.layer.borderColor = UIColor.clear.cgColor
        }
        
        // Chevron
        chevronImageView.tintColor = UIColor(currentStyle.chevronColor)
        
        selectButton.isUserInteractionEnabled = !isDisabled
    }
    
    private func updateSelectedLabel() {
        if let selection = selection,
           let selectedOption = options.first(where: { $0.id == selection }) {
            selectedLabel.text = selectedOption.label
            selectedLabel.textColor = UIColor(DSTokens.Colors.selectText)
        } else {
            selectedLabel.text = placeholder
            selectedLabel.textColor = UIColor(style.placeholderColor)
        }
    }
    
    private func updateLayout() {
        label.text = labelText
        label.isHidden = labelText == nil
        
        if labelText != nil {
            selectButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: DSTokens.Spacing.xs).isActive = true
        } else {
            selectButton.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        }
    }
    
    private func resolveStyle() -> DSSelectStyle {
        if isDisabled { return .disabled }
        return style
    }
    
    // Touch handling for dropdown dismissal
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if isDropdownVisible {
            let touch = touches.first
            let location = touch?.location(in: self) ?? .zero
            
            if !selectButton.frame.contains(location) {
                hideDropdown()
            }
        }
    }
}

// MARK: - Dropdown View

private class DSSelectDropdownView: UIView {
    var onSelect: ((DSSelectOption) -> Void)?
    var onDismiss: (() -> Void)?
    
    private let options: [DSSelectOption]
    private let selection: String?
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    init(options: [DSSelectOption], selection: String?) {
        self.options = options
        self.selection = selection
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = UIColor(DSTokens.Colors.selectDropdownBackground)
        layer.cornerRadius = DSTokens.Sizing.selectRadius
        clipsToBounds = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DSSelectOptionCell.self, forCellReuseIdentifier: DSSelectOptionCell.reuseIdentifier)
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: DSTokens.Spacing.selectDropdownPadding),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DSTokens.Spacing.selectDropdownPadding),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DSTokens.Spacing.selectDropdownPadding),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -DSTokens.Spacing.selectDropdownPadding)
        ])
    }
}

extension DSSelectDropdownView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DSSelectOptionCell.reuseIdentifier, for: indexPath) as! DSSelectOptionCell
        let option = options[indexPath.row]
        cell.configure(with: option, isSelected: selection == option.id)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        DSTokens.Sizing.selectOptionHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let option = options[indexPath.row]
        onSelect?(option)
    }
}

// MARK: - Option Cell

private class DSSelectOptionCell: UITableViewCell {
    static let reuseIdentifier = "DSSelectOptionCell"
    
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let checkmarkImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
        
        // Icon
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = UIColor(DSTokens.Colors.selectText)
        contentView.addSubview(iconImageView)
        
        // Title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: DSTokens.Typography.selectFontSize,
                                           weight: UIFont.Weight(DSTokens.Typography.selectFontWeight))
        titleLabel.textColor = UIColor(DSTokens.Colors.selectText)
        titleLabel.lineBreakMode = .byTruncatingTail
        contentView.addSubview(titleLabel)
        
        // Checkmark
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        checkmarkImageView.image = UIImage(systemName: "checkmark")
        checkmarkImageView.tintColor = UIColor(DSTokens.Colors.selectFocus)
        checkmarkImageView.contentMode = .scaleAspectFit
        contentView.addSubview(checkmarkImageView)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DSTokens.Spacing.selectOptionPadding),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: DSTokens.Sizing.selectIconSize),
            iconImageView.heightAnchor.constraint(equalToConstant: DSTokens.Sizing.selectIconSize),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: DSTokens.Spacing.selectIconGap),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: checkmarkImageView.leadingAnchor, constant: -DSTokens.Spacing.xs),
            
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DSTokens.Spacing.selectOptionPadding),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: DSTokens.Sizing.selectIconSize),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: DSTokens.Sizing.selectIconSize),
            
            contentView.heightAnchor.constraint(equalToConstant: DSTokens.Sizing.selectOptionHeight)
        ])
    }
    
    func configure(with option: DSSelectOption, isSelected: Bool) {
        titleLabel.text = option.label
        
        if let iconName = option.icon {
            iconImageView.image = UIImage(systemName: iconName)
            iconImageView.isHidden = false
        } else {
            iconImageView.isHidden = true
        }
        
        checkmarkImageView.isHidden = !isSelected
        
        backgroundColor = isSelected ? UIColor(DSTokens.Colors.selectOptionSelected) : .clear
    }
}
#endif
