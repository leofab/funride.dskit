#if canImport(UIKit)
import SwiftUI
import UIKit

// MARK: - Delegate Protocol

public protocol DSLoginViewDelegate: AnyObject {
    func loginView(_ loginView: DSLoginUIKit, didAttemptLoginWithEmail email: String, password: String)
    func loginViewDidTapGoogleLogin(_ loginView: DSLoginUIKit)
    func loginViewDidTapForgotPassword(_ loginView: DSLoginUIKit)
    func loginViewDidTapSignUp(_ loginView: DSLoginUIKit)
}

// MARK: - UIKit Login View

public class DSLoginUIKit: UIView {
    public weak var delegate: DSLoginViewDelegate?

    public var email: String = "" {
        didSet { emailField.text = email }
    }

    public var password: String = "" {
        didSet { passwordField.text = password }
    }

    public var configuration = DSLoginConfiguration() {
        didSet { updateConfiguration() }
    }

    public var isLoading: Bool = false {
        didSet { updateLoadingState() }
    }

    public var errorMessage: String? {
        didSet { updateErrorState() }
    }

    // MARK: - UI Elements

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    private let cardView = UIView()

    private lazy var emailField: DSInputView = {
        let field = DSInputView()
        field.placeholder = "Email"
        field.delegate = nil
        field.translatesAutoresizingMaskIntoConstraints = false
        field.accessibilityIdentifier = "DSLoginEmailField"
        return field
    }()

    private lazy var passwordField: DSInputView = {
        let field = DSInputView()
        field.placeholder = "Password"
        field.isSecureTextEntry = true
        field.delegate = nil
        field.translatesAutoresizingMaskIntoConstraints = false
        field.accessibilityIdentifier = "DSLoginPasswordField"
        return field
    }()

    private lazy var loginButton: DSButtonUIKit = {
        let button = DSButtonUIKit(style: .primary, label: "Log In")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        button.accessibilityIdentifier = "DSLoginLoginButton"
        button.accessibilityHint = "Double tap to log in with email and password"
        return button
    }()

    private let loadingIndicator = UIActivityIndicatorView(style: .medium)

    private let errorContainer = UIView()
    private let errorIcon = UIImageView()
    private let errorLabel = UILabel()

    private let forgotPasswordButton = UIButton(type: .system)

    private let dividerView = UIView()
    private let dividerLeft = UIView()
    private let dividerOrLabel = UILabel()
    private let dividerRight = UIView()

    private lazy var googleButton: DSButtonUIKit = {
        let button = DSButtonUIKit(style: .secondary, label: "Continue with Google")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(googleLoginTapped), for: .touchUpInside)
        button.accessibilityIdentifier = "DSLoginGoogleButton"
        button.accessibilityHint = "Double tap to log in with Google"
        return button
    }()

    private let signUpView = UIView()
    private let signUpPrefixLabel = UILabel()
    private let signUpButton = UIButton(type: .system)

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
        backgroundColor = UIColor(DSTokens.Colors.loginBackground)
        accessibilityIdentifier = "DSLoginView"
        configureViews()
        buildHierarchy()
        activateConstraints()
        updateConfiguration()
    }

    // MARK: - Configure

    private func configureViews() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false

        contentView.translatesAutoresizingMaskIntoConstraints = false

        logoImageView.image = UIImage(systemName: "car.fill")
        logoImageView.tintColor = UIColor(DSTokens.Colors.loginLink)
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.isHidden = true
        logoImageView.isAccessibilityElement = false

        titleLabel.font = .systemFont(ofSize: DSTokens.Typography.loginTitleSize, weight: UIFont.Weight(DSTokens.Typography.loginTitleWeight))
        titleLabel.textColor = UIColor(DSTokens.Colors.loginTitle)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.accessibilityIdentifier = "DSLoginTitleLabel"

        subtitleLabel.font = .systemFont(ofSize: DSTokens.Typography.loginSubtitleSize, weight: UIFont.Weight(DSTokens.Typography.loginSubtitleWeight))
        subtitleLabel.textColor = UIColor(DSTokens.Colors.loginSubtitle)
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.accessibilityIdentifier = "DSLoginSubtitleLabel"

        cardView.backgroundColor = UIColor(DSTokens.Colors.loginCard)
        cardView.layer.cornerRadius = DSTokens.Sizing.loginCardRadius
        cardView.clipsToBounds = true
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.isAccessibilityElement = false

        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.tintColor = UIColor(DSTokens.Colors.loginLink)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.accessibilityLabel = "Loading"
        loadingIndicator.isAccessibilityElement = true

        errorContainer.backgroundColor = UIColor(DSTokens.Colors.notificationError)
        errorContainer.layer.cornerRadius = DSTokens.Borders.radiusMedium
        errorContainer.clipsToBounds = true
        errorContainer.isHidden = true
        errorContainer.translatesAutoresizingMaskIntoConstraints = false
        errorContainer.accessibilityIdentifier = "DSLoginErrorContainer"
        errorContainer.isAccessibilityElement = false

        errorIcon.image = UIImage(systemName: "exclamationmark.triangle.fill")
        errorIcon.tintColor = UIColor(DSTokens.Colors.error)
        errorIcon.contentMode = .scaleAspectFit
        errorIcon.translatesAutoresizingMaskIntoConstraints = false
        errorIcon.isAccessibilityElement = false

        errorLabel.font = .systemFont(ofSize: DSTokens.Typography.notificationLabelSize, weight: UIFont.Weight(DSTokens.Typography.notificationLabelWeight))
        errorLabel.textColor = UIColor(DSTokens.Colors.notificationText)
        errorLabel.numberOfLines = 0
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.accessibilityIdentifier = "DSLoginErrorLabel"

        forgotPasswordButton.setTitle("Forgot Password?", for: .normal)
        forgotPasswordButton.titleLabel?.font = .systemFont(ofSize: DSTokens.Typography.loginLinkSize, weight: UIFont.Weight(DSTokens.Typography.loginLinkWeight))
        forgotPasswordButton.setTitleColor(UIColor(DSTokens.Colors.loginLink), for: .normal)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton.accessibilityIdentifier = "DSLoginForgotPasswordButton"
        forgotPasswordButton.accessibilityHint = "Double tap to reset your password"

        dividerView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.isAccessibilityElement = false

        dividerLeft.backgroundColor = UIColor(DSTokens.Colors.loginDivider)
        dividerLeft.translatesAutoresizingMaskIntoConstraints = false
        dividerLeft.isAccessibilityElement = false

        dividerOrLabel.text = "or"
        dividerOrLabel.font = .systemFont(ofSize: DSTokens.Typography.loginDividerTextSize, weight: UIFont.Weight(DSTokens.Typography.loginDividerTextWeight))
        dividerOrLabel.textColor = UIColor(DSTokens.Colors.loginSubtitle)
        dividerOrLabel.translatesAutoresizingMaskIntoConstraints = false
        dividerOrLabel.isAccessibilityElement = false

        dividerRight.backgroundColor = UIColor(DSTokens.Colors.loginDivider)
        dividerRight.translatesAutoresizingMaskIntoConstraints = false
        dividerRight.isAccessibilityElement = false

        signUpView.translatesAutoresizingMaskIntoConstraints = false
        signUpView.isAccessibilityElement = false

        signUpPrefixLabel.text = "Don't have an account?"
        signUpPrefixLabel.font = .systemFont(ofSize: DSTokens.Typography.loginLinkSize, weight: UIFont.Weight(DSTokens.Typography.loginLinkWeight))
        signUpPrefixLabel.textColor = UIColor(DSTokens.Colors.loginSubtitle)
        signUpPrefixLabel.accessibilityIdentifier = "DSLoginSignUpPrefixLabel"

        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.titleLabel?.font = .systemFont(ofSize: DSTokens.Typography.loginLinkSize, weight: UIFont.Weight(DSTokens.Typography.loginLinkWeight))
        signUpButton.setTitleColor(UIColor(DSTokens.Colors.loginLink), for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        signUpButton.accessibilityIdentifier = "DSLoginSignUpButton"
        signUpButton.accessibilityHint = "Double tap to create a new account"
    }

    // MARK: - Build Hierarchy

    private func buildHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(logoImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(cardView)
        contentView.addSubview(signUpView)

        cardView.addSubview(emailField)
        cardView.addSubview(passwordField)
        cardView.addSubview(loginButton)
        cardView.addSubview(loadingIndicator)
        cardView.addSubview(errorContainer)
        cardView.addSubview(forgotPasswordButton)
        cardView.addSubview(dividerView)
        cardView.addSubview(googleButton)

        errorContainer.addSubview(errorIcon)
        errorContainer.addSubview(errorLabel)

        dividerView.addSubview(dividerLeft)
        dividerView.addSubview(dividerOrLabel)
        dividerView.addSubview(dividerRight)

        signUpView.addSubview(signUpPrefixLabel)
        signUpView.addSubview(signUpButton)
    }

    // MARK: - Activate Constraints

    private func activateConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DSTokens.Spacing.loginLogoGap),
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: DSTokens.Sizing.loginLogoSize),
            logoImageView.heightAnchor.constraint(equalToConstant: DSTokens.Sizing.loginLogoSize),

            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: DSTokens.Spacing.sm),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: DSTokens.Spacing.xs),
            subtitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            subtitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor),

            cardView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: DSTokens.Spacing.loginSectionGap),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DSTokens.Spacing.lg),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DSTokens.Spacing.lg),

            emailField.topAnchor.constraint(equalTo: cardView.topAnchor, constant: DSTokens.Spacing.loginCardPadding),
            emailField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: DSTokens.Spacing.loginCardPadding),
            emailField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -DSTokens.Spacing.loginCardPadding),
            emailField.heightAnchor.constraint(equalToConstant: DSTokens.Sizing.inputHeight),

            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: DSTokens.Spacing.loginFieldGap),
            passwordField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: DSTokens.Spacing.loginCardPadding),
            passwordField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -DSTokens.Spacing.loginCardPadding),
            passwordField.heightAnchor.constraint(equalToConstant: DSTokens.Sizing.inputHeight),

            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: DSTokens.Spacing.loginFieldGap),
            loginButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: DSTokens.Spacing.loginCardPadding),
            loginButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -DSTokens.Spacing.loginCardPadding),
            loginButton.heightAnchor.constraint(equalToConstant: DSTokens.Sizing.buttonHeight),

            loadingIndicator.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: DSTokens.Spacing.sm),
            loadingIndicator.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),

            errorContainer.topAnchor.constraint(equalTo: loadingIndicator.bottomAnchor, constant: DSTokens.Spacing.sm),
            errorContainer.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: DSTokens.Spacing.loginCardPadding),
            errorContainer.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -DSTokens.Spacing.loginCardPadding),

            errorIcon.leadingAnchor.constraint(equalTo: errorContainer.leadingAnchor, constant: DSTokens.Spacing.notificationPadding),
            errorIcon.centerYAnchor.constraint(equalTo: errorContainer.centerYAnchor),
            errorIcon.widthAnchor.constraint(equalToConstant: DSTokens.Sizing.notificationIconSize),
            errorIcon.heightAnchor.constraint(equalToConstant: DSTokens.Sizing.notificationIconSize),

            errorLabel.leadingAnchor.constraint(equalTo: errorIcon.trailingAnchor, constant: DSTokens.Spacing.notificationIconGap),
            errorLabel.trailingAnchor.constraint(equalTo: errorContainer.trailingAnchor, constant: -DSTokens.Spacing.notificationPadding),
            errorLabel.topAnchor.constraint(equalTo: errorContainer.topAnchor, constant: DSTokens.Spacing.notificationPadding),
            errorLabel.bottomAnchor.constraint(equalTo: errorContainer.bottomAnchor, constant: -DSTokens.Spacing.notificationPadding),

            forgotPasswordButton.topAnchor.constraint(equalTo: errorContainer.bottomAnchor, constant: DSTokens.Spacing.sm),
            forgotPasswordButton.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),

            dividerView.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: DSTokens.Spacing.loginFieldGap),
            dividerView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: DSTokens.Spacing.loginCardPadding),
            dividerView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -DSTokens.Spacing.loginCardPadding),
            dividerView.heightAnchor.constraint(equalToConstant: 20),

            dividerLeft.leadingAnchor.constraint(equalTo: dividerView.leadingAnchor),
            dividerLeft.centerYAnchor.constraint(equalTo: dividerView.centerYAnchor),
            dividerLeft.widthAnchor.constraint(equalToConstant: DSTokens.Sizing.loginDividerWidth),
            dividerLeft.heightAnchor.constraint(equalToConstant: DSTokens.Sizing.loginDividerHeight),

            dividerOrLabel.centerXAnchor.constraint(equalTo: dividerView.centerXAnchor),
            dividerOrLabel.centerYAnchor.constraint(equalTo: dividerView.centerYAnchor),

            dividerRight.trailingAnchor.constraint(equalTo: dividerView.trailingAnchor),
            dividerRight.centerYAnchor.constraint(equalTo: dividerView.centerYAnchor),
            dividerRight.widthAnchor.constraint(equalToConstant: DSTokens.Sizing.loginDividerWidth),
            dividerRight.heightAnchor.constraint(equalToConstant: DSTokens.Sizing.loginDividerHeight),

            googleButton.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: DSTokens.Spacing.loginFieldGap),
            googleButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: DSTokens.Spacing.loginCardPadding),
            googleButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -DSTokens.Spacing.loginCardPadding),
            googleButton.heightAnchor.constraint(equalToConstant: DSTokens.Sizing.buttonHeight),
            googleButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -DSTokens.Spacing.loginCardPadding),

            signUpView.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: DSTokens.Spacing.loginSectionGap),
            signUpView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            signUpView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -DSTokens.Spacing.loginLogoGap),

            signUpPrefixLabel.leadingAnchor.constraint(equalTo: signUpView.leadingAnchor),
            signUpPrefixLabel.centerYAnchor.constraint(equalTo: signUpView.centerYAnchor),

            signUpButton.leadingAnchor.constraint(equalTo: signUpPrefixLabel.trailingAnchor, constant: DSTokens.Spacing.xs),
            signUpButton.centerYAnchor.constraint(equalTo: signUpView.centerYAnchor),
            signUpButton.trailingAnchor.constraint(equalTo: signUpView.trailingAnchor),
        ])
    }

    // MARK: - Actions

    @objc private func loginTapped() {
        let email = emailField.text
        let password = passwordField.text
        delegate?.loginView(self, didAttemptLoginWithEmail: email, password: password)
    }

    @objc private func googleLoginTapped() {
        delegate?.loginViewDidTapGoogleLogin(self)
    }

    @objc private func forgotPasswordTapped() {
        delegate?.loginViewDidTapForgotPassword(self)
    }

    @objc private func signUpTapped() {
        delegate?.loginViewDidTapSignUp(self)
    }

    // MARK: - Updates

    private func updateConfiguration() {
        titleLabel.text = configuration.title
        titleLabel.accessibilityLabel = configuration.title
        subtitleLabel.text = configuration.subtitle
        subtitleLabel.accessibilityLabel = configuration.subtitle
        loginButton.setTitle(configuration.loginButtonLabel, for: .normal)
        loginButton.accessibilityLabel = configuration.loginButtonLabel
        googleButton.setTitle(configuration.googleButtonLabel, for: .normal)
        googleButton.accessibilityLabel = configuration.googleButtonLabel
        forgotPasswordButton.setTitle(configuration.forgotPasswordLabel, for: .normal)
        forgotPasswordButton.accessibilityLabel = configuration.forgotPasswordLabel
        signUpPrefixLabel.text = configuration.signUpPrefix
        signUpPrefixLabel.accessibilityLabel = configuration.signUpPrefix
        signUpButton.setTitle(configuration.signUpLabel, for: .normal)
        signUpButton.accessibilityLabel = configuration.signUpLabel
        emailField.placeholder = configuration.emailPlaceholder
        emailField.accessibilityLabel = configuration.emailPlaceholder
        passwordField.placeholder = configuration.passwordPlaceholder
        passwordField.accessibilityLabel = configuration.passwordPlaceholder

        if configuration.logoImage != nil {
            logoImageView.isHidden = false
        }
    }

    private func updateLoadingState() {
        loginButton.isEnabled = !isLoading
        googleButton.isEnabled = !isLoading

        if isLoading {
            loadingIndicator.startAnimating()
            loginButton.alpha = 0.6
            googleButton.alpha = 0.6
        } else {
            loadingIndicator.stopAnimating()
            loginButton.alpha = 1.0
            googleButton.alpha = 1.0
        }
    }

    private func updateErrorState() {
        if let message = errorMessage, !message.isEmpty {
            errorLabel.text = message
            errorLabel.accessibilityLabel = message
            errorContainer.isHidden = false
            errorContainer.accessibilityLabel = "Error: \(message)"
        } else {
            errorContainer.isHidden = true
        }
    }
}
#endif
