import SwiftUI

/// A notification component that displays informational messages with optional actions
public struct DSNotification: View {
    @Binding private var isPresented: Bool
    @State private var opacity: Double = 0
    @State private var autoDismissTimer: Timer?
    
    private let type: DSNotificationType
    private let style: DSNotificationStyle
    private let title: String
    private let message: String?
    private let actions: [DSNotificationAction]
    private let autoDismiss: Bool
    private let autoDismissDelay: TimeInterval
    
    /// Creates a notification
    /// - Parameters:
    ///   - type: The type of notification (default, info, error, warning, success)
    ///   - style: The style of notification (inline or toast)
    ///   - title: The title text of the notification
    ///   - message: Optional message text of the notification
    ///   - actions: Array of action buttons to display
    ///   - isPresented: Binding to control the presentation state
    ///   - autoDismiss: Whether the notification should auto-dismiss (only for non-error toasts)
    ///   - autoDismissDelay: Time in seconds before auto-dismiss (default: 7.0)
    public init(
        type: DSNotificationType = .default,
        style: DSNotificationStyle = .inline,
        title: String,
        message: String? = nil,
        actions: [DSNotificationAction] = [],
        isPresented: Binding<Bool>,
        autoDismiss: Bool = true,
        autoDismissDelay: TimeInterval = 7.0
    ) {
        self.type = type
        self.style = style
        self.title = title
        self.message = message
        self.actions = actions
        self._isPresented = isPresented
        self.autoDismiss = autoDismiss
        self.autoDismissDelay = autoDismissDelay
    }
    
    public var body: some View {
        if isPresented {
            notificationContent
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 0.2)) {
                        opacity = 1
                    }
                    startAutoDismissTimer()
                }
                .onDisappear {
                    autoDismissTimer?.invalidate()
                }
        }
    }
    
    private var notificationContent: some View {
        HStack(spacing: DSTokens.Spacing.notificationIconGap) {
            // Icon
            Image(systemName: type.iconName)
                .foregroundColor(type.iconColor)
                .frame(width: DSTokens.Sizing.notificationIconSize, height: DSTokens.Sizing.notificationIconSize)
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: DSTokens.Typography.notificationLabelSize, weight: DSTokens.Typography.notificationLabelWeight))
                    .foregroundColor(DSTokens.Colors.notificationText)
                
                if let message = message {
                    Text(message)
                        .font(.system(size: DSTokens.Typography.notificationLabelSize, weight: DSTokens.Typography.notificationLabelWeight))
                        .foregroundColor(DSTokens.Colors.notificationTextSecondary)
                }
            }
            
            Spacer()
            
            // Actions
            if !actions.isEmpty {
                HStack(spacing: DSTokens.Spacing.notificationActionGap) {
                    ForEach(Array(actions.enumerated()), id: \.offset) { index, action in
                        DSButton(
                            action.style,
                            icon: nil,
                            label: action.title
                        ) {
                            action.handler()
                            dismiss()
                        }
                    }
                }
            }
            
            // Close button for toast
            if style == .toast {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(DSTokens.Colors.notificationTextSecondary)
                        .frame(width: 16, height: 16)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(DSTokens.Spacing.notificationPadding)
        .background(type.backgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: style == .toast ? DSTokens.Sizing.notificationToastRadius : DSTokens.Sizing.notificationInlineRadius)
                .stroke(type.borderColor, lineWidth: DSTokens.Borders.widthThin)
        )
        .clipShape(RoundedRectangle(cornerRadius: style == .toast ? DSTokens.Sizing.notificationToastRadius : DSTokens.Sizing.notificationInlineRadius))
        .frame(maxWidth: style == .toast ? DSTokens.Sizing.notificationToastWidth : .infinity)
        .frame(height: style == .toast ? DSTokens.Sizing.notificationToastHeight : DSTokens.Sizing.notificationInlineHeight)
    }
    
    private func startAutoDismissTimer() {
        // Only auto-dismiss for non-error toasts
        guard autoDismiss, style == .toast, type != .error else { return }
        
        autoDismissTimer = Timer.scheduledTimer(withTimeInterval: autoDismissDelay, repeats: false) { _ in
            dismiss()
        }
    }
    
    private func dismiss() {
        withAnimation(.easeOut(duration: 0.2)) {
            opacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isPresented = false
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var showInline = true
        @State private var showToast = true
        
        var body: some View {
            VStack(spacing: 20) {
                DSNotification(
                    type: .default,
                    style: .inline,
                    title: "There are updates in shared libraries.",
                    message: nil,
                    actions: [
                        DSNotificationAction(title: "dismiss", style: .secondary) {
                            print("Dismiss tapped")
                        },
                        DSNotificationAction(title: "update", style: .primary) {
                            print("Update tapped")
                        }
                    ],
                    isPresented: $showInline
                )
                
                DSNotification(
                    type: .info,
                    style: .toast,
                    title: "Label",
                    isPresented: $showToast
                )
            }
            .padding()
            .background(Color.black)
        }
    }
    
    return PreviewWrapper()
}