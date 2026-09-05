import SwiftUI

/// A full-screen login view for carpool apps, composing DSInput, DSButton, and DSNotification.
/// Wrap in a NavigationStack to enable navigation links.
public struct DSLogin: View {
    @Binding private var email: String
    @Binding private var password: String

    private let configuration: DSLoginConfiguration
    private let style: DSLoginStyle
    private let onLogin: (String, String) -> Void
    private let onGoogleLogin: () -> Void
    private let onForgotPassword: () -> Void
    private let onSignUp: () -> Void

    @State private var isEmailFocused = false
    @State private var isPasswordFocused = false

    public init(
        email: Binding<String>,
        password: Binding<String>,
        configuration: DSLoginConfiguration = DSLoginConfiguration(),
        style: DSLoginStyle = DSLoginStyle(),
        onLogin: @escaping (String, String) -> Void = { _, _ in },
        onGoogleLogin: @escaping () -> Void = {},
        onForgotPassword: @escaping () -> Void = {},
        onSignUp: @escaping () -> Void = {}
    ) {
        self._email = email
        self._password = password
        self.configuration = configuration
        self.style = style
        self.onLogin = onLogin
        self.onGoogleLogin = onGoogleLogin
        self.onForgotPassword = onForgotPassword
        self.onSignUp = onSignUp
    }

    public var body: some View {
        ZStack {
            style.backgroundColor
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: DSTokens.Spacing.loginSectionGap) {
                    Spacer(minLength: DSTokens.Spacing.loginLogoGap)

                    headerSection

                    cardSection

                    footerSection

                    Spacer(minLength: DSTokens.Spacing.loginLogoGap)
                }
                .padding(.horizontal, DSTokens.Spacing.xl)
            }
        }
        #if os(iOS)
        .navigationBarHidden(true)
        #endif
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: DSTokens.Spacing.sm) {
            if let logo = configuration.logoImage {
                logo
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: DSTokens.Sizing.loginLogoSize,
                        height: DSTokens.Sizing.loginLogoSize
                    )
            } else {
                Image(systemName: "car.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: DSTokens.Sizing.loginLogoSize,
                        height: DSTokens.Sizing.loginLogoSize
                    )
                    .foregroundColor(DSTokens.Colors.loginLink)
            }

            Text(configuration.title)
                .font(.system(
                    size: DSTokens.Typography.loginTitleSize,
                    weight: DSTokens.Typography.loginTitleWeight,
                    design: .rounded
                ))
                .foregroundColor(style.titleColor)

            Text(configuration.subtitle)
                .font(.system(
                    size: DSTokens.Typography.loginSubtitleSize,
                    weight: DSTokens.Typography.loginSubtitleWeight
                ))
                .foregroundColor(style.subtitleColor)
        }
    }

    // MARK: - Card

    private var cardSection: some View {
        VStack(spacing: DSTokens.Spacing.loginFieldGap) {
            DSInput(
                text: $email,
                placeholder: configuration.emailPlaceholder,
                style: isEmailFocused ? .focus : .default
            )
            #if os(iOS)
            .textContentType(.emailAddress)
            .keyboardType(.emailAddress)
            .textInputAutocapitalization(.never)
            #endif

            DSInput(
                text: $password,
                placeholder: configuration.passwordPlaceholder,
                style: isPasswordFocused ? .focus : .default
            )

            loginButton

            if configuration.isLoading {
                ProgressView()
                    .tint(DSTokens.Colors.loginLink)
            }

            if let errorMessage = configuration.errorMessage {
                DSNotification(
                    type: .error,
                    style: .inline,
                    title: errorMessage,
                    isPresented: .constant(true),
                    autoDismiss: false
                )
            }

            forgotPasswordLink

            dividerWithText

            googleLoginButton
        }
        .padding(DSTokens.Spacing.loginCardPadding)
        .background(style.cardBackground)
        .cornerRadius(DSTokens.Sizing.loginCardRadius)
    }

    // MARK: - Login Button

    private var loginButton: some View {
        DSButton(
            .primary,
            icon: configuration.isLoading ? nil : "arrow.right",
            label: configuration.loginButtonLabel
        ) {
            onLogin(email, password)
        }
        .disabled(configuration.isLoading)
        .frame(maxWidth: .infinity)
    }

    // MARK: - Forgot Password

    private var forgotPasswordLink: some View {
        Button(action: onForgotPassword) {
            Text(configuration.forgotPasswordLabel)
                .font(.system(
                    size: DSTokens.Typography.loginLinkSize,
                    weight: DSTokens.Typography.loginLinkWeight
                ))
                .foregroundColor(style.linkColor)
        }
    }

    // MARK: - Divider

    private var dividerWithText: some View {
        HStack(spacing: DSTokens.Spacing.sm) {
            Rectangle()
                .fill(style.dividerColor)
                .frame(height: DSTokens.Sizing.loginDividerHeight)

            Text("or")
                .font(.system(
                    size: DSTokens.Typography.loginDividerTextSize,
                    weight: DSTokens.Typography.loginDividerTextWeight
                ))
                .foregroundColor(style.subtitleColor)

            Rectangle()
                .fill(style.dividerColor)
                .frame(height: DSTokens.Sizing.loginDividerHeight)
        }
    }

    // MARK: - Google Login

    private var googleLoginButton: some View {
        DSButton(
            .secondary,
            icon: "g.circle",
            label: configuration.googleButtonLabel
        ) {
            onGoogleLogin()
        }
        .disabled(configuration.isLoading)
        .frame(maxWidth: .infinity)
    }

    // MARK: - Footer

    private var footerSection: some View {
        HStack(spacing: DSTokens.Spacing.xs) {
            Text(configuration.signUpPrefix)
                .font(.system(
                    size: DSTokens.Typography.loginLinkSize,
                    weight: DSTokens.Typography.loginLinkWeight
                ))
                .foregroundColor(style.subtitleColor)

            Button(action: onSignUp) {
                Text(configuration.signUpLabel)
                    .font(.system(
                        size: DSTokens.Typography.loginLinkSize,
                        weight: DSTokens.Typography.loginLinkWeight
                    ))
                    .foregroundColor(style.linkColor)
            }
        }
    }
}

// MARK: - Preview
#if DEBUG
struct DSLogin_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DSLogin(
                email: .constant(""),
                password: .constant(""),
                configuration: DSLoginConfiguration(
                    title: "FunRide",
                    subtitle: "Carpool with confidence"
                ),
                onLogin: { _, _ in },
                onGoogleLogin: {},
                onForgotPassword: {},
                onSignUp: {}
            )
        }
    }
}
#endif
