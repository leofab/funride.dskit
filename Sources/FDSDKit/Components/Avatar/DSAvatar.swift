import SwiftUI

/// A reusable avatar component based on Penpot design system
public struct DSAvatar: View {
    let size: DSAvatarSize
    let type: DSAvatarType
    let name: String
    let imageURL: URL?
    let state: DSAvatarState
    
    @State private var isImageLoaded = false
    
    /// Initialize an avatar with initials
    public init(_ size: DSAvatarSize = .medium,
                name: String,
                state: DSAvatarState = .default) {
        self.size = size
        self.type = .initials
        self.name = name
        self.imageURL = nil
        self.state = state
    }
    
    /// Initialize an avatar with an image URL
    public init(_ size: DSAvatarSize = .medium,
                imageURL: URL?,
                name: String,
                state: DSAvatarState = .default) {
        self.size = size
        self.type = .image
        self.name = name
        self.imageURL = imageURL
        self.state = state
    }
    
    public var body: some View {
        ZStack {
            if let imageURL = imageURL, type == .image {
                imageAvatar(url: imageURL)
            } else {
                initialsAvatar
            }
        }
        .frame(width: size.dimension, height: size.dimension)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(state.borderColor ?? Color.clear,
                        lineWidth: state.borderWidth)
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("Avatar for \(name)"))
    }
    
    @ViewBuilder
    private func imageAvatar(url: URL) -> some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .failure:
                initialsAvatar
            case .empty:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(0.5)
            @unknown default:
                initialsAvatar
            }
        }
    }
    
    private var initialsAvatar: some View {
        let initials = DSAvatarInitials.extract(from: name)
        let backgroundColor = state.backgroundColor ?? DSAvatarColor.color(for: name)
        
        return ZStack {
            Circle()
                .fill(backgroundColor)
            
            Text(initials)
                .font(.system(size: size.fontSize,
                              weight: DSTokens.Typography.avatarFontWeight))
                .foregroundColor(DSTokens.Colors.avatarText)
        }
    }
}

// MARK: - Preview
#if DEBUG
struct DSAvatar_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                DSAvatar(.small, name: "John Doe")
                DSAvatar(.medium, name: "John Doe")
                DSAvatar(.large, name: "John Doe")
            }
            
            HStack(spacing: 8) {
                DSAvatar(.small, name: "Jane Smith")
                DSAvatar(.medium, name: "Jane Smith")
                DSAvatar(.large, name: "Jane Smith")
            }
            
            HStack(spacing: 8) {
                DSAvatar(.small, name: "AB", state: .selected)
                DSAvatar(.medium, name: "CD", state: .hover)
                DSAvatar(.large, name: "EF", state: .focus)
            }
            
            HStack(spacing: 8) {
                DSAvatar(.small, imageURL: URL(string: "https://picsum.photos/100"), name: "User")
                DSAvatar(.medium, imageURL: URL(string: "https://picsum.photos/100"), name: "User")
                DSAvatar(.large, imageURL: URL(string: "https://picsum.photos/100"), name: "User")
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
    }
}
#endif
