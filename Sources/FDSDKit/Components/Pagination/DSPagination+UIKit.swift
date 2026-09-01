#if canImport(UIKit)
import UIKit
import SwiftUI

/// UIKit wrapper for DSPagination
public class DSPaginationUIView: UIView {
    
    // MARK: - Public Properties
    
    public var currentPage: Int {
        didSet {
            updateUI()
            onPageChange?(currentPage)
        }
    }
    
    public var totalPages: Int {
        didSet {
            updateUI()
        }
    }
    
    public var style: DSPaginationStyle {
        didSet {
            updateUI()
        }
    }
    
    public var onPageChange: ((Int) -> Void)?
    
    // MARK: - UI Elements
    
    private lazy var previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var pageNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    
    public init(frame: CGRect,
                currentPage: Int = 1,
                totalPages: Int = 1,
                style: DSPaginationStyle = .dark) {
        self.currentPage = max(1, currentPage)
        self.totalPages = max(0, totalPages)
        self.style = style
        super.init(frame: frame)
        setupUI()
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        self.currentPage = 1
        self.totalPages = 1
        self.style = .dark
        super.init(coder: coder)
        setupUI()
        updateUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        addSubview(previousButton)
        addSubview(pageNumberLabel)
        addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            // Previous Button
            previousButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            previousButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            previousButton.widthAnchor.constraint(equalToConstant: DSTokens.Sizing.paginationButtonWidth),
            previousButton.heightAnchor.constraint(equalToConstant: DSTokens.Sizing.paginationButtonHeight),
            
            // Page Number Label
            pageNumberLabel.leadingAnchor.constraint(equalTo: previousButton.trailingAnchor, constant: DSTokens.Spacing.paginationButtonSpacing),
            pageNumberLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            pageNumberLabel.widthAnchor.constraint(equalToConstant: DSTokens.Sizing.paginationNumberingWidth),
            pageNumberLabel.heightAnchor.constraint(equalToConstant: DSTokens.Sizing.paginationNumberingHeight),
            
            // Next Button
            nextButton.leadingAnchor.constraint(equalTo: pageNumberLabel.trailingAnchor, constant: DSTokens.Spacing.paginationButtonSpacing),
            nextButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: DSTokens.Sizing.paginationButtonWidth),
            nextButton.heightAnchor.constraint(equalToConstant: DSTokens.Sizing.paginationButtonHeight),
            
            // Overall height
            heightAnchor.constraint(equalToConstant: DSTokens.Sizing.paginationButtonHeight)
        ])
    }
    
    // MARK: - Update
    
    private func updateUI() {
        let canGoPrevious = currentPage > 1
        let canGoNext = currentPage < totalPages
        
        // Update page number label
        pageNumberLabel.text = "\(currentPage) / \(totalPages)"
        pageNumberLabel.font = .systemFont(ofSize: DSTokens.Typography.paginationPageSize,
                                           weight: UIFont.Weight(DSTokens.Typography.paginationPageWeight))
        pageNumberLabel.textColor = UIColor(style.textColor)
        pageNumberLabel.backgroundColor = UIColor(style.backgroundColor)
        pageNumberLabel.layer.cornerRadius = DSTokens.Sizing.paginationNumberingRadius
        pageNumberLabel.layer.masksToBounds = true
        
        // Update previous button
        previousButton.tintColor = UIColor(style.iconColor)
        previousButton.backgroundColor = UIColor(style.backgroundColor)
        previousButton.layer.cornerRadius = DSTokens.Sizing.paginationButtonRadius
        previousButton.layer.borderWidth = DSTokens.Borders.widthThin
        previousButton.layer.borderColor = UIColor(style.borderColor).cgColor
        previousButton.layer.masksToBounds = true
        previousButton.isEnabled = canGoPrevious
        previousButton.alpha = canGoPrevious ? 1.0 : style.disabledOpacity
        
        // Update next button
        nextButton.tintColor = UIColor(style.iconColor)
        nextButton.backgroundColor = UIColor(style.backgroundColor)
        nextButton.layer.cornerRadius = DSTokens.Sizing.paginationButtonRadius
        nextButton.layer.borderWidth = DSTokens.Borders.widthThin
        nextButton.layer.borderColor = UIColor(style.borderColor).cgColor
        nextButton.layer.masksToBounds = true
        nextButton.isEnabled = canGoNext
        nextButton.alpha = canGoNext ? 1.0 : style.disabledOpacity
        
        // Update accessibility
        accessibilityLabel = "Page \(currentPage) of \(totalPages)"
        previousButton.accessibilityLabel = "Previous page"
        previousButton.accessibilityHint = canGoPrevious ? "Navigates to page \(currentPage - 1)" : "Already on first page"
        nextButton.accessibilityLabel = "Next page"
        nextButton.accessibilityHint = canGoNext ? "Navigates to page \(currentPage + 1)" : "Already on last page"
    }
    
    // MARK: - Actions
    
    @objc private func previousButtonTapped() {
        guard currentPage > 1 else { return }
        currentPage -= 1
    }
    
    @objc private func nextButtonTapped() {
        guard currentPage < totalPages else { return }
        currentPage += 1
    }
    
    // MARK: - Public Methods
    
    public func setPage(_ page: Int) {
        currentPage = max(1, min(page, totalPages))
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        previousButton.layer.cornerRadius = DSTokens.Sizing.paginationButtonRadius
        pageNumberLabel.layer.cornerRadius = DSTokens.Sizing.paginationNumberingRadius
        nextButton.layer.cornerRadius = DSTokens.Sizing.paginationButtonRadius
    }
}
#endif
