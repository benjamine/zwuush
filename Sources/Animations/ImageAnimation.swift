import SwiftUI
import AppKit

struct ImageAnimation: NSViewRepresentable {
    var imagePath: String

    func makeNSView(context: Context) -> NSView {
        let containerView = NSView()
        let imageView = NSImageView()

        // Allow auto-layout
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.imageScaling = .scaleProportionallyUpOrDown

        containerView.addSubview(imageView)

        imageView.canDrawSubviewsIntoLayer = true
        imageView.animates = true
        imageView.wantsLayer = true
        imageView.layer?.backgroundColor = NSColor.clear.cgColor

        // Load image from URL or local file
        loadImage(from: imagePath, into: imageView, in: containerView)
    
        return containerView

    }


    private func loadImage(from pathOrURL: String, into imageView: NSImageView, in containerView: NSView) {
        if let url = URL(string: pathOrURL), (url.scheme == "http" || url.scheme == "https") {
            // Handle remote URL
            downloadImage(from: url) { data in
                DispatchQueue.main.async {
                    if let imageData = data, let image = NSImage(data: imageData) {
                        imageView.image = image
                        setUpAutoLayout(imageView: imageView, imageSize: image.size, in: containerView)
                    }
                }
            }
        } else {
            // Handle local file path
            let fileURL = URL(fileURLWithPath: pathOrURL)
            if let imageData = try? Data(contentsOf: fileURL), let image = NSImage(data: imageData) {
                imageView.image = image
                setUpAutoLayout(imageView: imageView, imageSize: image.size, in: containerView)
            }
        }
    }

    private func downloadImage(from url: URL, completion: @escaping (Data?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            completion(data)
        }
        task.resume()
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        return
    }

    // Setup Auto-Layout to center and size the image proportionally
    private func setUpAutoLayout(imageView: NSImageView, imageSize: NSSize, in containerView: NSView) {
        // Get the screen size
        let screenSize = NSScreen.main?.frame.size ?? CGSize(width: 800, height: 600)

        // Calculate the available width and height (80% of the screen size for margin)
        let maxAllowedWidth = screenSize.width * 0.5
        let maxAllowedHeight = screenSize.height * 0.5

        // Calculate the scaling factor to fit the image within the available space
        let widthRatio = maxAllowedWidth / imageSize.width
        let heightRatio = maxAllowedHeight / imageSize.height
        let scalingFactor = min(widthRatio, heightRatio)

        // Scale the image size accordingly
        let scaledWidth = imageSize.width * scalingFactor
        let scaledHeight = imageSize.height * scalingFactor

        // Set constraints for the scaled size and center it in the superview
        NSLayoutConstraint.deactivate(imageView.constraints)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: scaledWidth),
            imageView.heightAnchor.constraint(equalToConstant: scaledHeight),
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])

        // Force layout update to ensure it appears correctly
        containerView.layoutSubtreeIfNeeded()
    }
}