#if canImport(UIKit)
import UIKit
import SwiftUI

/// A UIKit wrapper for the DSNotification component
public class DSNotificationUIKit: UIView {
    private var isPresented: Bool = false {
        didSet {
            if isPresented {
                show()
            } else {
                hide()
            }
        }
    }
    
    private let type: DSNotificationType
    private let style: DSNotificationStyle
    private let title: String
    private let message: String?
    private let actions: [DSNotificationAction]
    private let autoDismiss: Bool
    private let autoDismissDelay: TimeInterval
    
    private var autoDismissTimer: Timer?
    private var hostingController: UIHostingController<DSNotification>?
    
    /// Creates a UIKit notification view
    /// - Parameters:
    ///   - type: The type of notification (default, info, error, warning, success)
    ///   - style: The style of notification (inline or toast)
    ///   - title: The title text of the notification
    ///   - message: Optional message text of the notification
    ///   - actions: Array of action buttons to display
    ///   - autoDismiss: Whether the notification should auto-dismiss (only for non-error toasts)
    ///   - autoDismissDelay: Time in seconds before auto-dismiss (default: 7.0)
    public init(
        type: DSNotificationType = .default,
        style: DSNotificationStyle = .inline,
        title: String,
        message: String? = nil,
        actions: [DSNotificationAction] = [],
        autoDismiss: Bool = true,
        autoDismissDelay: TimeInterval = 7.0
    ) {
        self.type = type
        self.style = style
        self.title = title
        self.message = message
        self.actions = actions
        self.autoDismiss = autoDismiss
        self.autoDismissDelay = autoDismissDelay
        
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor(type.backgroundColor)
        layer.cornerRadius = style == .toast ? 8 : 8
        layer.borderWidth = 1
        layer.borderColor = UIColor(type.borderColor).cgColor
        clipsToBounds = true
        
        // Add shadow for better visibility
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.3
        
        isHidden = true
    }
    
    /// Shows the notification with animation
    public func show() {
        guard !isPresented else { return }
        isPresented = true
        
        isHidden = false
        alpha = 0
        transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
            self.alpha = 1
            self.transform = .identity
        } completion: { [weak self] _ in
            self?.startAutoDismissTimer()
        }
    }
    
    /// Hides the notification with animation
    public func hide() {
        guard isPresented else { return }
        isPresented = false
        
        autoDismissTimer?.invalidate()
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
            self.alpha = 0
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        } completion: { [weak self] _ in
            self?.isHidden = true
            self?.transform = .identity
        }
    }
    
    private func startAutoDismissTimer() {
        // Only auto-dismiss for non-error toasts
        guard autoDismiss, style == .toast, type != .error else { return }
        
        autoDismissTimer = Timer.scheduledTimer(withTimeInterval: autoDismissDelay, repeats: false) { [weak self] _ in
            self?.hide()
        }
    }
    
    deinit {
        autoDismissTimer?.invalidate()
    }
}

#endif