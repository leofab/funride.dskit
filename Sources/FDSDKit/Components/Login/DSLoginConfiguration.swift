import SwiftUI

/// Configuration model for the login view
public struct DSLoginConfiguration {
    public var title: String
    public var subtitle: String
    public var logoImage: Image?
    public var emailPlaceholder: String
    public var passwordPlaceholder: String
    public var loginButtonLabel: String
    public var googleButtonLabel: String
    public var forgotPasswordLabel: String
    public var signUpPrefix: String
    public var signUpLabel: String
    public var isLoading: Bool
    public var errorMessage: String?

    public init(
        title: String = "FunRide",
        subtitle: String = "Carpool with confidence",
        logoImage: Image? = nil,
        emailPlaceholder: String = "Email",
        passwordPlaceholder: String = "Password",
        loginButtonLabel: String = "Log In",
        googleButtonLabel: String = "Continue with Google",
        forgotPasswordLabel: String = "Forgot Password?",
        signUpPrefix: String = "Don't have an account?",
        signUpLabel: String = "Sign Up",
        isLoading: Bool = false,
        errorMessage: String? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.logoImage = logoImage
        self.emailPlaceholder = emailPlaceholder
        self.passwordPlaceholder = passwordPlaceholder
        self.loginButtonLabel = loginButtonLabel
        self.googleButtonLabel = googleButtonLabel
        self.forgotPasswordLabel = forgotPasswordLabel
        self.signUpPrefix = signUpPrefix
        self.signUpLabel = signUpLabel
        self.isLoading = isLoading
        self.errorMessage = errorMessage
    }
}
