# FDSDKit

A SwiftUI and UIKit design system component library based on the Penpot design system.

## Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/username/funride.dskit.git", from: "1.0.0")
]
```

Or in Xcode: File → Add Package Dependencies → Enter repository URL

## Components

### DSButton

A reusable button component with multiple styles.

#### SwiftUI

```swift
import FDSDKit

// Primary button with icon
DSButton(.primary, icon: "star.fill", label: "Primary") {
    print("Tapped!")
}

// Secondary button
DSButton(.secondary, label: "Secondary") {
    print("Tapped!")
}

// Ghost button
DSButton(.ghost, label: "Ghost") {
    print("Tapped!")
}

// Destructive button with icon
DSButton(.destructive, icon: "trash", label: "Delete") {
    print("Tapped!")
}
```

#### UIKit

```swift
import FDSDKit

// Create button
let button = DSButtonUIKit(style: .primary, icon: UIImage(systemName: "star"), label: "Primary")
button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

// Add to view
view.addSubview(button)
```

### Button Styles

| Style | Description |
|-------|-------------|
| `.primary` | Filled background with cyan color (#7EFFF5) |
| `.secondary` | Outlined with primary color border |
| `.ghost` | Transparent with primary color text |
| `.destructive` | Red background for destructive actions |

### DSAccordion

A vertical stack of collapsible items for displaying expandable content.

#### SwiftUI

```swift
import FDSDKit

// Basic accordion
DSAccordion(items: $items) {
    // Items are managed via binding
}

// Accordion with custom configuration
DSAccordion(
    items: $items,
    configuration: DSAccordionConfiguration(
        allowsMultipleExpansion: false,
        requiresAtLeastOneExpanded: true,
        animationDuration: 0.3
    )
)

// Creating items with selection callback
let items = [
    DSAccordionItem(title: "Section 1", icon: "star.fill") {
        Text("Content for section 1")
    },
    DSAccordionItem(title: "Section 2", isExpanded: true) {
        Text("Content for section 2")
    },
    DSAccordionItem(title: "Disabled Section", isDisabled: true) {
        Text("This content is hidden")
    }
]

// Items with selection callback (collapses accordion on selection and shows selected option)
let itemsWithSelection = [
    DSAccordionItem(
        title: "Payment Methods",
        icon: "creditcard.fill",
        selectedOption: "Credit Card ending in 1234", // Shows as subtitle
        onSelection: { option in
            print("Selected: \(option)")
        }
    ) {
        VStack(alignment: .leading, spacing: 12) {
            Text("Credit Card ending in 1234")
                .accordionSelectable("Credit Card ending in 1234")
            
            Text("PayPal Account")
                .accordionSelectable("PayPal Account")
            
            Text("Apple Pay")
                .accordionSelectable("Apple Pay")
        }
    }
]
```

#### UIKit

```swift
import FDSDKit

// Create accordion
let accordion = DSAccordionUIKit(frame: .zero)
accordion.configuration = DSAccordionConfiguration(
    allowsMultipleExpansion: false
)

// Create items
let label1 = UILabel()
label1.text = "Content for section 1"

let item1 = DSAccordionItemUIKit(
    title: "Section 1",
    icon: UIImage(systemName: "star.fill"),
    content: label1
)

// Configure accordion
accordion.configure(with: [item1])

// Add to view
view.addSubview(accordion)

// Handle item toggling
accordion.onItemToggled = { index, isExpanded in
    print("Item \(index) is now \(isExpanded ? "expanded" : "collapsed")")
}
```

#### Accordion Configuration

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `allowsMultipleExpansion` | `Bool` | `true` | Allow multiple items to be expanded |
| `requiresAtLeastOneExpanded` | `Bool` | `false` | Require at least one item to stay expanded |
| `animationDuration` | `Double` | `0.2` | Duration of expand/collapse animation |

#### Accordion Item Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `title` | `String` | - | The title text displayed in the header |
| `icon` | `String?` | `nil` | Optional SF Symbol name displayed before the title |
| `isExpanded` | `Bool` | `false` | Whether the item starts expanded |
| `isDisabled` | `Bool` | `false` | Whether the item is interactive |
| `selectedOption` | `String?` | `nil` | The currently selected option text (displayed as subtitle) |
| `onSelection` | `((String) -> Void)?` | `nil` | Callback when content is selected (triggers accordion collapse) |

#### Accordion Content Selection

Use the `.accordionSelectable()` modifier to make content items selectable:

```swift
VStack(alignment: .leading, spacing: 12) {
    Text("Option 1")
        .accordionSelectable("Option 1")
    
    Text("Option 2")
        .accordionSelectable("Option 2")
}
```

When a selectable item is tapped:
1. The `onSelection` callback is triggered with the selected option text
2. The accordion automatically collapses
3. The `selectedOption` property is updated
4. The selected option is displayed as a subtitle in the header

### DSComboButton

A dropdown button that displays a list of selectable options.

#### SwiftUI

```swift
import FDSDKit

// Basic combo button
@State private var selectedOption: DSComboButtonOption?

DSComboButton(
    label: "Select Option",
    options: [
        DSComboButtonOption(label: "Option 1", icon: "star.fill"),
        DSComboButtonOption(label: "Option 2", icon: "heart.fill"),
        DSComboButtonOption(label: "Option 3 (Disabled)", isDisabled: true),
        DSComboButtonOption(label: "Option 4", icon: "bolt.fill")
    ],
    selectedOption: $selectedOption
) { option in
    print("Selected: \(option.label)")
}

// Combo button with custom configuration
DSComboButton(
    label: "Select Option",
    options: options,
    selectedOption: $selectedOption,
    configuration: DSComboButtonConfiguration(
        isDisabled: false,
        dropdownMaxHeight: 300,
        showOptionIcons: true,
        animationDuration: 0.3
    )
)
```

#### UIKit

```swift
import FDSDKit

// Create combo button
let comboButton = DSComboButtonUIKit(frame: .zero)
comboButton.configuration = DSComboButtonConfiguration(
    dropdownMaxHeight: 250
)

// Create options
let option1 = DSComboButtonOptionUIKit(
    label: "Option 1",
    icon: UIImage(systemName: "star.fill")
)

let option2 = DSComboButtonOptionUIKit(
    label: "Option 2",
    icon: UIImage(systemName: "heart.fill")
)

// Configure combo button
comboButton.configure(label: "Select Option", options: [option1, option2])

// Add to view
view.addSubview(comboButton)

// Handle selection
comboButton.onSelectionChanged = { option in
    print("Selected: \(option.label)")
}
```

#### Combo Button Configuration

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `isDisabled` | `Bool` | `false` | Disable the combo button |
| `dropdownMaxHeight` | `CGFloat` | `200` | Maximum height of dropdown menu |
| `showOptionIcons` | `Bool` | `true` | Show icons in options |
| `animationDuration` | `Double` | `0.2` | Duration of dropdown animation |

### DSNotification

A notification component that displays informational messages with optional actions.

#### SwiftUI

```swift
import FDSDKit

@State private var showNotification = true

// Inline notification (persistent)
DSNotification(
    type: .default,
    style: .inline,
    title: "There are updates in shared libraries.",
    actions: [
        DSNotificationAction(title: "dismiss", style: .secondary) {
            print("Dismiss tapped")
        },
        DSNotificationAction(title: "update", style: .primary) {
            print("Update tapped")
        }
    ],
    isPresented: $showNotification
)

// Toast notification (auto-dismiss after 7 seconds)
DSNotification(
    type: .info,
    style: .toast,
    title: "Label",
    isPresented: $showNotification
)

// Error toast (requires user interaction to dismiss)
DSNotification(
    type: .error,
    style: .toast,
    title: "Error occurred",
    message: "Please try again",
    actions: [
        DSNotificationAction(title: "retry", style: .primary) {
            print("Retry tapped")
        }
    ],
    isPresented: $showNotification
)
```

#### UIKit

```swift
import FDSDKit

// Create notification
let notification = DSNotificationUIKit(
    type: .default,
    style: .inline,
    title: "There are updates in shared libraries.",
    message: "More info available",
    actions: [
        DSNotificationAction(title: "dismiss", style: .secondary) {
            print("Dismiss tapped")
        }
    ]
)

// Show notification
view.addSubview(notification)
notification.show()

// Hide notification
notification.hide()
```

#### Notification Types

| Type | Description |
|------|-------------|
| `.default` | Default notification with standard styling |
| `.info` | Informational notification with blue accent |
| `.error` | Error notification with red accent (requires user interaction) |
| `.warning` | Warning notification with yellow accent |
| `.success` | Success notification with green accent |

#### Notification Styles

| Style | Description |
|-------|-------------|
| `.inline` | Persistent notification that requires user interaction to dismiss |
| `.toast` | Ephemeral notification that auto-dismisses after 7 seconds (except error) |

### DSAvatar

A visual representation of a user or project, displaying initials or an image.

#### SwiftUI

```swift
import FDSDKit

// Initials avatar with different sizes
DSAvatar(.small, name: "John Doe")
DSAvatar(.medium, name: "Jane Smith")
DSAvatar(.large, name: "Bob Wilson")

// Avatar with image
DSAvatar(.medium, imageURL: URL(string: "https://example.com/photo.jpg"), name: "User")

// Avatar with state
DSAvatar(.large, name: "Selected User", state: .selected)
DSAvatar(.medium, name: "Hovered User", state: .hover)
```

#### UIKit

```swift
import FDSDKit

// Create avatar
let avatar = DSAvatarUIKit(size: .medium, name: "John Doe")
view.addSubview(avatar)

// Create avatar with image
let imageAvatar = DSAvatarUIKit(
    size: .large,
    imageURL: URL(string: "https://example.com/photo.jpg"),
    name: "User"
)
view.addSubview(imageAvatar)

// Update state
avatar.updateState(.selected)

// Update image
avatar.updateImage(URL(string: "https://example.com/new-photo.jpg"))
```

#### Avatar Sizes

| Size | Dimensions | Use Case |
|------|------------|----------|
| `.small` | 24pt | Active users list, project dropdowns |
| `.medium` | 32pt | Comment popups |
| `.large` | 40pt | User account menu |

#### Avatar States

| State | Description |
|-------|-------------|
| `.default` | Standard display with background color |
| `.hover` | Dark background (#18181a) |
| `.selected` | Cyan border ring (#38c0fa) |
| `.focus` | Cyan border ring (#38c0fa) |

#### Color Palette

Initials avatars use a deterministic color based on the user's name:

| Color | Hex |
|-------|-----|
| Pink | #f49ef7 |
| Blue | #38c0fa |
| Green | #48c393 |
| Yellow | #d4a03c |
| Purple | #9b6dff |
| Orange | #e0785c |

### Design Tokens

All design tokens are available in `DSTokens`:

```swift
// Colors
DSTokens.Colors.primary
DSTokens.Colors.buttonPrimaryDefault
DSTokens.Colors.accordionBackground  // #212426
DSTokens.Colors.accordionHover       // #2e3434
DSTokens.Colors.comboButtonDefault   // #212426
DSTokens.Colors.comboButtonHover     // //2e3434
DSTokens.Colors.comboButtonFocus     // #7efff5
DSTokens.Colors.notificationDefault  // #18181a
DSTokens.Colors.notificationInfo     // #082c49
DSTokens.Colors.notificationError    // #500124
DSTokens.Colors.notificationBorderDefault  // #2e3434
DSTokens.Colors.notificationBorderInfo     // #0e9be9
DSTokens.Colors.notificationBorderError    // #c80857
DSTokens.Colors.avatarPink           // #f49ef7
DSTokens.Colors.avatarBlue           // #38c0fa
DSTokens.Colors.avatarGreen          // #48c393
DSTokens.Colors.avatarYellow         // #d4a03c
DSTokens.Colors.avatarPurple         // #9b6dff
DSTokens.Colors.avatarOrange         // #e0785c
DSTokens.Colors.avatarHover          // #18181a
DSTokens.Colors.avatarBorderSelected // #38c0fa

// Spacing
DSTokens.Spacing.xs  // 4pt
DSTokens.Spacing.sm  // 8pt
DSTokens.Spacing.accordionItemGap     // 2pt
DSTokens.Spacing.accordionHeaderPadding  // 16pt
DSTokens.Spacing.comboButtonPadding   // 12pt
DSTokens.Spacing.comboButtonIconGap   // 8pt
DSTokens.Spacing.notificationPadding  // 12pt
DSTokens.Spacing.notificationIconGap  // 8pt
DSTokens.Spacing.notificationActionGap  // 8pt

// Typography
DSTokens.Typography.buttonSize  // 12pt
DSTokens.Typography.buttonWeight  // Medium
DSTokens.Typography.accordionTitleSize  // 12pt
DSTokens.Typography.comboButtonLabelSize  // 12pt
DSTokens.Typography.notificationLabelSize  // 12pt
DSTokens.Typography.notificationLabelWeight  // Regular
DSTokens.Typography.avatarSmallFontSize   // 10pt
DSTokens.Typography.avatarMediumFontSize  // 12pt
DSTokens.Typography.avatarLargeFontSize   // 14pt
DSTokens.Typography.avatarFontWeight      // Medium

// Sizing
DSTokens.Sizing.buttonHeight  // 32pt
DSTokens.Sizing.iconSize  // 16pt
DSTokens.Sizing.accordionHeaderHeight  // 50pt
DSTokens.Sizing.accordionItemRadius    // 8pt
DSTokens.Sizing.comboButtonHeight      // 48pt
DSTokens.Sizing.comboButtonWidth       // 248pt
DSTokens.Sizing.comboButtonRadius      // 8pt
DSTokens.Sizing.notificationInlineHeight  // 50pt
DSTokens.Sizing.notificationInlineWidth   // 627pt
DSTokens.Sizing.notificationToastHeight   // 32pt
DSTokens.Sizing.notificationToastWidth    // 228pt
DSTokens.Sizing.notificationIconSize      // 16pt
DSTokens.Sizing.avatarSmall       // 24pt
DSTokens.Sizing.avatarMedium      // 32pt
DSTokens.Sizing.avatarLarge       // 40pt
DSTokens.Sizing.avatarBorderWidth // 2pt

// Borders
DSTokens.Borders.radiusMedium  // 8pt
DSTokens.Borders.widthThin     // 1pt
```

## Requirements

- iOS 15.0+
- macOS 12.0+
- Swift 5.9+

## License

MIT License
