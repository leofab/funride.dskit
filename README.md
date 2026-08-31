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

// Creating items
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

### Design Tokens

All design tokens are available in `DSTokens`:

```swift
// Colors
DSTokens.Colors.primary
DSTokens.Colors.buttonPrimaryDefault
DSTokens.Colors.accordionBackground  // #212426
DSTokens.Colors.accordionHover       // #2e3434

// Spacing
DSTokens.Spacing.xs  // 4pt
DSTokens.Spacing.sm  // 8pt
DSTokens.Spacing.accordionItemGap     // 2pt
DSTokens.Spacing.accordionHeaderPadding  // 16pt

// Typography
DSTokens.Typography.buttonSize  // 12pt
DSTokens.Typography.buttonWeight  // Medium
DSTokens.Typography.accordionTitleSize  // 12pt

// Sizing
DSTokens.Sizing.buttonHeight  // 32pt
DSTokens.Sizing.iconSize  // 16pt
DSTokens.Sizing.accordionHeaderHeight  // 50pt
DSTokens.Sizing.accordionItemRadius    // 8pt

// Borders
DSTokens.Borders.radiusMedium  // 8pt
```

## Requirements

- iOS 15.0+
- macOS 12.0+
- Swift 5.9+

## License

MIT License
