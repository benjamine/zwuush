import SwiftUI
import AppKit

struct EmptyAnimation: NSViewRepresentable {

    func makeNSView(context: Context) -> NSImageView {
        let imageView = NSImageView()

        // Allow animation
        imageView.canDrawSubviewsIntoLayer = true

        // Set the image scaling and placement
        imageView.imageScaling = .scaleProportionallyUpOrDown

        return imageView
    }

    func updateNSView(_ nsView: NSImageView, context: Context) {
        // No update required in this example
    }
}