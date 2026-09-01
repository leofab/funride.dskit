#if canImport(UIKit)
import UIKit
import SwiftUI

/// UIKit wrapper for DSAvatar
public class DSAvatarUIKit: UIView {
    private let size: DSAvatarSize
    private let avatarName: String
    private var state: DSAvatarState
    private var imageURL: URL?
    
    private let initialsLabel = UILabel()
    private let imageView = UIImageView()
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    private let borderLayer = CAShapeLayer()
    
    public init(size: DSAvatarSize = .medium,
                imageURL: URL? = nil,
                name: String,
                state: DSAvatarState = .default) {
        self.size = size
        self.imageURL = imageURL
        self.avatarName = name
        self.state = state
        super.init(frame: CGRect(x: 0, y: 0,
                                 width: size.dimension,
                                 height: size.dimension))
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        // Configure base view
        backgroundColor = UIColor(DSAvatarColor.color(for: avatarName))
        layer.cornerRadius = size.dimension / 2
        clipsToBounds = true
        
        // Configure initials label
        let initials = DSAvatarInitials.extract(from: avatarName)
        initialsLabel.text = initials
        initialsLabel.textColor = UIColor(DSTokens.Colors.avatarText)
        initialsLabel.font = .systemFont(ofSize: size.fontSize,
                                         weight: UIFont.Weight(DSTokens.Typography.avatarFontWeight))
        initialsLabel.textAlignment = .center
        initialsLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(initialsLabel)
        
        // Configure image view
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        // Configure loading indicator
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loadingIndicator)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            initialsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            initialsLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        // Setup border layer
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor(DSTokens.Colors.avatarBorderSelected).cgColor
        borderLayer.lineWidth = DSTokens.Sizing.avatarBorderWidth
        layer.addSublayer(borderLayer)
        
        updateBorder()
        
        // Load image if URL provided
        if let url = imageURL {
            loadImage(from: url)
        }
    }
    
    public func updateState(_ newState: DSAvatarState) {
        state = newState
        updateAppearance()
    }
    
    public func updateImage(_ url: URL?) {
        imageURL = url
        if let url = url {
            loadImage(from: url)
        } else {
            imageView.image = nil
            imageView.isHidden = true
            initialsLabel.isHidden = false
            backgroundColor = UIColor(DSAvatarColor.color(for: avatarName))
        }
    }
    
    private func updateAppearance() {
        // Update background color
        if let bgColor = state.backgroundColor {
            backgroundColor = UIColor(bgColor)
        } else if imageURL == nil || imageView.image == nil {
            backgroundColor = UIColor(DSAvatarColor.color(for: avatarName))
        }
        
        updateBorder()
    }
    
    private func updateBorder() {
        if state == .selected || state == .focus {
            borderLayer.path = UIBezierPath(ovalIn: bounds).cgPath
            borderLayer.isHidden = false
        } else {
            borderLayer.isHidden = true
        }
    }
    
    private func loadImage(from url: URL) {
        loadingIndicator.startTimer()
        imageView.isHidden = true
        initialsLabel.isHidden = false
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.loadingIndicator.stopTimer()
                
                if let data = data, let image = UIImage(data: data) {
                    self.imageView.image = image
                    self.imageView.isHidden = false
                    self.initialsLabel.isHidden = true
                    self.backgroundColor = .clear
                }
            }
        }.resume()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = size.dimension / 2
        borderLayer.path = UIBezierPath(ovalIn: bounds).cgPath
    }
}

// MARK: - UIActivityIndicatorView Extension
extension UIActivityIndicatorView {
    func startTimer() {
        startAnimating()
    }
    
    func stopTimer() {
        stopAnimating()
    }
}
#endif
