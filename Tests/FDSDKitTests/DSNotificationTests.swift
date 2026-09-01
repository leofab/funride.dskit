import XCTest
@testable import FDSDKit

final class DSNotificationTests: XCTestCase {
    
    // MARK: - Notification Type Tests
    
    func testNotificationTypeInitialization() {
        // Test all notification types can be initialized
        let defaultType = DSNotificationType.default
        let infoType = DSNotificationType.info
        let errorType = DSNotificationType.error
        let warningType = DSNotificationType.warning
        let successType = DSNotificationType.success
        
        XCTAssertNotNil(defaultType)
        XCTAssertNotNil(infoType)
        XCTAssertNotNil(errorType)
        XCTAssertNotNil(warningType)
        XCTAssertNotNil(successType)
    }
    
    func testNotificationTypeBackgroundColors() {
        // Test that each type has the correct background color
        XCTAssertEqual(DSNotificationType.default.backgroundColor, DSTokens.Colors.notificationDefault)
        XCTAssertEqual(DSNotificationType.info.backgroundColor, DSTokens.Colors.notificationInfo)
        XCTAssertEqual(DSNotificationType.error.backgroundColor, DSTokens.Colors.notificationError)
        XCTAssertEqual(DSNotificationType.warning.backgroundColor, DSTokens.Colors.notificationWarning)
        XCTAssertEqual(DSNotificationType.success.backgroundColor, DSTokens.Colors.notificationSuccess)
    }
    
    func testNotificationTypeBorderColors() {
        // Test that each type has the correct border color
        XCTAssertEqual(DSNotificationType.default.borderColor, DSTokens.Colors.notificationBorderDefault)
        XCTAssertEqual(DSNotificationType.info.borderColor, DSTokens.Colors.notificationBorderInfo)
        XCTAssertEqual(DSNotificationType.error.borderColor, DSTokens.Colors.notificationBorderError)
        XCTAssertEqual(DSNotificationType.warning.borderColor, DSTokens.Colors.notificationBorderWarning)
        XCTAssertEqual(DSNotificationType.success.borderColor, DSTokens.Colors.notificationBorderSuccess)
    }
    
    func testNotificationTypeIconNames() {
        // Test that each type has the correct icon name
        XCTAssertEqual(DSNotificationType.default.iconName, "info.circle")
        XCTAssertEqual(DSNotificationType.info.iconName, "info.circle")
        XCTAssertEqual(DSNotificationType.error.iconName, "exclamationmark.circle")
        XCTAssertEqual(DSNotificationType.warning.iconName, "exclamationmark.triangle")
        XCTAssertEqual(DSNotificationType.success.iconName, "checkmark.circle")
    }
    
    // MARK: - Notification Style Tests
    
    func testNotificationStyleInitialization() {
        // Test both notification styles can be initialized
        let inlineStyle = DSNotificationStyle.inline
        let toastStyle = DSNotificationStyle.toast
        
        XCTAssertNotNil(inlineStyle)
        XCTAssertNotNil(toastStyle)
    }
    
    // MARK: - Notification Action Tests
    
    func testNotificationActionInitialization() {
        // Test notification action initialization
        let action = DSNotificationAction(title: "Test Action", style: .primary) {
            // Action handler
        }
        
        XCTAssertEqual(action.title, "Test Action")
        XCTAssertEqual(action.style, .primary)
    }
    
    func testNotificationActionDefaultStyle() {
        // Test notification action default style
        let action = DSNotificationAction(title: "Test Action") {
            // Action handler
        }
        
        XCTAssertEqual(action.title, "Test Action")
        XCTAssertEqual(action.style, .secondary)
    }
    
    // MARK: - Design Token Tests
    
    func testNotificationTokensExist() {
        // Test that all notification tokens exist
        XCTAssertNotNil(DSTokens.Colors.notificationDefault)
        XCTAssertNotNil(DSTokens.Colors.notificationInfo)
        XCTAssertNotNil(DSTokens.Colors.notificationError)
        XCTAssertNotNil(DSTokens.Colors.notificationWarning)
        XCTAssertNotNil(DSTokens.Colors.notificationSuccess)
        
        XCTAssertNotNil(DSTokens.Colors.notificationBorderDefault)
        XCTAssertNotNil(DSTokens.Colors.notificationBorderInfo)
        XCTAssertNotNil(DSTokens.Colors.notificationBorderError)
        XCTAssertNotNil(DSTokens.Colors.notificationBorderWarning)
        XCTAssertNotNil(DSTokens.Colors.notificationBorderSuccess)
        
        XCTAssertNotNil(DSTokens.Colors.notificationText)
        XCTAssertNotNil(DSTokens.Colors.notificationTextSecondary)
        
        XCTAssertGreaterThan(DSTokens.Spacing.notificationPadding, 0)
        XCTAssertGreaterThan(DSTokens.Spacing.notificationIconGap, 0)
        XCTAssertGreaterThan(DSTokens.Spacing.notificationActionGap, 0)
        
        XCTAssertGreaterThan(DSTokens.Sizing.notificationInlineHeight, 0)
        XCTAssertGreaterThan(DSTokens.Sizing.notificationInlineWidth, 0)
        XCTAssertGreaterThan(DSTokens.Sizing.notificationInlineRadius, 0)
        XCTAssertGreaterThan(DSTokens.Sizing.notificationToastHeight, 0)
        XCTAssertGreaterThan(DSTokens.Sizing.notificationToastWidth, 0)
        XCTAssertGreaterThan(DSTokens.Sizing.notificationToastRadius, 0)
        XCTAssertGreaterThan(DSTokens.Sizing.notificationIconSize, 0)
        
        XCTAssertGreaterThan(DSTokens.Typography.notificationLabelSize, 0)
        XCTAssertNotNil(DSTokens.Typography.notificationLabelWeight)
        XCTAssertGreaterThan(DSTokens.Typography.notificationActionSize, 0)
        XCTAssertNotNil(DSTokens.Typography.notificationActionWeight)
    }
    
    // MARK: - UIKit Wrapper Tests
    
    #if canImport(UIKit)
    func testUIKitNotificationInitialization() {
        // Test UIKit notification initialization
        let notification = DSNotificationUIKit(
            type: .default,
            style: .inline,
            title: "Test Notification",
            message: "Test message"
        )
        
        XCTAssertNotNil(notification)
        XCTAssertEqual(notification.isHidden, true)
    }
    
    func testUIKitNotificationShowHide() {
        // Test UIKit notification show/hide functionality
        let notification = DSNotificationUIKit(
            type: .default,
            style: .inline,
            title: "Test Notification"
        )
        
        // Initially hidden
        XCTAssertTrue(notification.isHidden)
        
        // Show notification
        notification.show()
        XCTAssertFalse(notification.isHidden)
        
        // Hide notification and wait for animation
        let expectation = XCTestExpectation(description: "Hide animation")
        notification.hide()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            XCTAssertTrue(notification.isHidden)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    #endif
}