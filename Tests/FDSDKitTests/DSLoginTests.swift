import XCTest
import SwiftUI
@testable import FDSDKit

final class DSLoginTests: XCTestCase {

    // MARK: - Token Tests

    func testLoginColors() {
        XCTAssertEqual(DSTokens.Colors.loginBackground, Color(hex: "#18181a"))
        XCTAssertEqual(DSTokens.Colors.loginCard, Color(hex: "#212426"))
        XCTAssertEqual(DSTokens.Colors.loginTitle, Color.white)
        XCTAssertEqual(DSTokens.Colors.loginSubtitle, Color(hex: "#8f9da3"))
        XCTAssertEqual(DSTokens.Colors.loginLink, Color(hex: "#7efff5"))
        XCTAssertEqual(DSTokens.Colors.loginDivider, Color(hex: "#2e3434"))
        XCTAssertEqual(DSTokens.Colors.loginGoogleBackground, Color(hex: "#212426"))
        XCTAssertEqual(DSTokens.Colors.loginGoogleBorder, Color(hex: "#2e3434"))
    }

    func testLoginSpacing() {
        XCTAssertEqual(DSTokens.Spacing.loginCardPadding, 24)
        XCTAssertEqual(DSTokens.Spacing.loginFieldGap, 16)
        XCTAssertEqual(DSTokens.Spacing.loginSectionGap, 24)
        XCTAssertEqual(DSTokens.Spacing.loginLogoGap, 32)
        XCTAssertEqual(DSTokens.Spacing.loginLinkGap, 16)
    }

    func testLoginTypography() {
        XCTAssertEqual(DSTokens.Typography.loginTitleSize, 24)
        XCTAssertEqual(DSTokens.Typography.loginTitleWeight, .bold)
        XCTAssertEqual(DSTokens.Typography.loginSubtitleSize, 14)
        XCTAssertEqual(DSTokens.Typography.loginSubtitleWeight, .regular)
        XCTAssertEqual(DSTokens.Typography.loginLinkSize, 12)
        XCTAssertEqual(DSTokens.Typography.loginLinkWeight, .medium)
        XCTAssertEqual(DSTokens.Typography.loginDividerTextSize, 12)
        XCTAssertEqual(DSTokens.Typography.loginDividerTextWeight, .regular)
    }

    func testLoginSizing() {
        XCTAssertEqual(DSTokens.Sizing.loginCardRadius, 12)
        XCTAssertEqual(DSTokens.Sizing.loginLogoSize, 64)
        XCTAssertEqual(DSTokens.Sizing.loginGoogleIconSize, 20)
        XCTAssertEqual(DSTokens.Sizing.loginDividerHeight, 1)
        XCTAssertEqual(DSTokens.Sizing.loginDividerWidth, 40)
    }

    // MARK: - DSLoginConfiguration Tests

    func testConfigurationDefaultInitialization() {
        let config = DSLoginConfiguration()

        XCTAssertEqual(config.title, "FunRide")
        XCTAssertEqual(config.subtitle, "Carpool with confidence")
        XCTAssertNil(config.logoImage)
        XCTAssertEqual(config.emailPlaceholder, "Email")
        XCTAssertEqual(config.passwordPlaceholder, "Password")
        XCTAssertEqual(config.loginButtonLabel, "Log In")
        XCTAssertEqual(config.googleButtonLabel, "Continue with Google")
        XCTAssertEqual(config.forgotPasswordLabel, "Forgot Password?")
        XCTAssertEqual(config.signUpPrefix, "Don't have an account?")
        XCTAssertEqual(config.signUpLabel, "Sign Up")
        XCTAssertFalse(config.isLoading)
        XCTAssertNil(config.errorMessage)
    }

    func testConfigurationCustomInitialization() {
        let config = DSLoginConfiguration(
            title: "MyApp",
            subtitle: "Welcome back",
            emailPlaceholder: "Your email",
            passwordPlaceholder: "Your password",
            loginButtonLabel: "Sign In",
            googleButtonLabel: "Sign in with Google",
            forgotPasswordLabel: "Reset password",
            signUpPrefix: "New here?",
            signUpLabel: "Register",
            isLoading: true,
            errorMessage: "Invalid credentials"
        )

        XCTAssertEqual(config.title, "MyApp")
        XCTAssertEqual(config.subtitle, "Welcome back")
        XCTAssertEqual(config.emailPlaceholder, "Your email")
        XCTAssertEqual(config.passwordPlaceholder, "Your password")
        XCTAssertEqual(config.loginButtonLabel, "Sign In")
        XCTAssertEqual(config.googleButtonLabel, "Sign in with Google")
        XCTAssertEqual(config.forgotPasswordLabel, "Reset password")
        XCTAssertEqual(config.signUpPrefix, "New here?")
        XCTAssertEqual(config.signUpLabel, "Register")
        XCTAssertTrue(config.isLoading)
        XCTAssertEqual(config.errorMessage, "Invalid credentials")
    }

    func testConfigurationPropertyMutability() {
        var config = DSLoginConfiguration()
        config.title = "Changed"
        config.isLoading = true
        config.errorMessage = "Error"

        XCTAssertEqual(config.title, "Changed")
        XCTAssertTrue(config.isLoading)
        XCTAssertEqual(config.errorMessage, "Error")
    }

    func testConfigurationWithLogoImage() {
        let image = Image(systemName: "car.fill")
        let config = DSLoginConfiguration(logoImage: image)

        XCTAssertNotNil(config.logoImage)
    }

    func testConfigurationErrorIsNilByDefault() {
        let config = DSLoginConfiguration()
        XCTAssertNil(config.errorMessage)
    }

    // MARK: - DSLoginStyle Tests

    func testStyleDefaultInitialization() {
        let style = DSLoginStyle()

        XCTAssertEqual(style.backgroundColor, DSTokens.Colors.loginBackground)
        XCTAssertEqual(style.cardBackground, DSTokens.Colors.loginCard)
        XCTAssertEqual(style.titleColor, DSTokens.Colors.loginTitle)
        XCTAssertEqual(style.subtitleColor, DSTokens.Colors.loginSubtitle)
        XCTAssertEqual(style.linkColor, DSTokens.Colors.loginLink)
        XCTAssertEqual(style.dividerColor, DSTokens.Colors.loginDivider)
    }

    func testStyleCustomInitialization() {
        let style = DSLoginStyle(
            backgroundColor: .black,
            cardBackground: .gray,
            titleColor: .white,
            subtitleColor: .blue,
            linkColor: .green,
            dividerColor: .red
        )

        XCTAssertEqual(style.backgroundColor, .black)
        XCTAssertEqual(style.cardBackground, .gray)
        XCTAssertEqual(style.titleColor, .white)
        XCTAssertEqual(style.subtitleColor, .blue)
        XCTAssertEqual(style.linkColor, .green)
        XCTAssertEqual(style.dividerColor, .red)
    }

    // MARK: - DSLogin SwiftUI View Tests

    func testLoginViewInitialization() {
        let email = Binding.constant("")
        let password = Binding.constant("")

        let login = DSLogin(
            email: email,
            password: password,
            configuration: DSLoginConfiguration(),
            style: DSLoginStyle()
        )

        XCTAssertNotNil(login)
    }

    func testLoginViewWithCallbacks() {
        let email = Binding.constant("")
        let password = Binding.constant("")
        var loginCalled = false
        var googleCalled = false
        var forgotCalled = false
        var signUpCalled = false

        let login = DSLogin(
            email: email,
            password: password,
            onLogin: { _, _ in loginCalled = true },
            onGoogleLogin: { googleCalled = true },
            onForgotPassword: { forgotCalled = true },
            onSignUp: { signUpCalled = true }
        )

        XCTAssertNotNil(login)
        XCTAssertFalse(loginCalled)
        XCTAssertFalse(googleCalled)
        XCTAssertFalse(forgotCalled)
        XCTAssertFalse(signUpCalled)
    }

    func testLoginViewWithLoadingState() {
        let email = Binding.constant("")
        let password = Binding.constant("")
        let config = DSLoginConfiguration(isLoading: true)

        let login = DSLogin(
            email: email,
            password: password,
            configuration: config
        )

        XCTAssertNotNil(login)
    }

    func testLoginViewWithErrorMessage() {
        let email = Binding.constant("")
        let password = Binding.constant("")
        let config = DSLoginConfiguration(errorMessage: "Auth failed")

        let login = DSLogin(
            email: email,
            password: password,
            configuration: config
        )

        XCTAssertNotNil(login)
    }

    func testLoginViewEmailPasswordBinding() {
        var email = "test@email.com"
        var password = "secret123"

        let emailBinding = Binding(
            get: { email },
            set: { email = $0 }
        )
        let passwordBinding = Binding(
            get: { password },
            set: { password = $0 }
        )

        let login = DSLogin(
            email: emailBinding,
            password: passwordBinding
        )

        XCTAssertNotNil(login)
        XCTAssertEqual(email, "test@email.com")
        XCTAssertEqual(password, "secret123")
    }

    // MARK: - UIKit Tests

    #if canImport(UIKit)
    func testUIKitLoginInitialization() {
        let loginView = DSLoginUIKit()

        XCTAssertNotNil(loginView)
        XCTAssertEqual(loginView.email, "")
        XCTAssertEqual(loginView.password, "")
        XCTAssertFalse(loginView.isLoading)
        XCTAssertNil(loginView.errorMessage)
    }

    func testUIKitLoginConfiguration() {
        let loginView = DSLoginUIKit()
        let config = DSLoginConfiguration(
            title: "MyApp",
            subtitle: "Test",
            isLoading: true,
            errorMessage: "Error occurred"
        )

        loginView.configuration = config

        XCTAssertEqual(loginView.configuration.title, "MyApp")
        XCTAssertEqual(loginView.configuration.subtitle, "Test")
        XCTAssertTrue(loginView.configuration.isLoading)
        XCTAssertEqual(loginView.configuration.errorMessage, "Error occurred")
    }

    func testUIKitLoginEmailPassword() {
        let loginView = DSLoginUIKit()
        loginView.email = "user@test.com"
        loginView.password = "pass123"

        XCTAssertEqual(loginView.email, "user@test.com")
        XCTAssertEqual(loginView.password, "pass123")
    }

    func testUIKitLoginLoadingState() {
        let loginView = DSLoginUIKit()

        loginView.isLoading = true
        XCTAssertTrue(loginView.isLoading)

        loginView.isLoading = false
        XCTAssertFalse(loginView.isLoading)
    }

    func testUIKitLoginErrorMessage() {
        let loginView = DSLoginUIKit()

        loginView.errorMessage = "Invalid credentials"
        XCTAssertEqual(loginView.errorMessage, "Invalid credentials")

        loginView.errorMessage = nil
        XCTAssertNil(loginView.errorMessage)
    }

    func testUIKitLoginDelegateAssignment() {
        let loginView = DSLoginUIKit()
        let delegate = MockLoginDelegate()

        loginView.delegate = delegate

        XCTAssertNotNil(loginView.delegate)
    }
    #endif
}

// MARK: - Mock Delegate

#if canImport(UIKit)
private class MockLoginDelegate: DSLoginViewDelegate {
    var loginEmail: String?
    var loginPassword: String?
    var googleLoginCalled = false
    var forgotPasswordCalled = false
    var signUpCalled = false

    func loginView(_ loginView: DSLoginUIKit, didAttemptLoginWithEmail email: String, password: String) {
        loginEmail = email
        loginPassword = password
    }

    func loginViewDidTapGoogleLogin(_ loginView: DSLoginUIKit) {
        googleLoginCalled = true
    }

    func loginViewDidTapForgotPassword(_ loginView: DSLoginUIKit) {
        forgotPasswordCalled = true
    }

    func loginViewDidTapSignUp(_ loginView: DSLoginUIKit) {
        signUpCalled = true
    }
}
#endif
