import SwiftUI
import AppKit
import AVFoundation

struct VideoAnimation: NSViewRepresentable {
    var videoPath: String

    func makeNSView(context: Context) -> NSView {
        let containerView = NSView()

        // Set up the player and player layer
        let player = AVPlayer()
        let playerView = NSView() // Create a view for the player layer

        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill

        // Add player layer to the player view
        playerView.wantsLayer = true
        playerView.layer?.addSublayer(playerLayer)
        playerView.alphaValue = 1.0 // Start with full opacity

        // Add player view to the containerView
        playerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(playerView)

        // Load the video from the provided path
        loadVideo(from: videoPath, into: player, playerLayer: playerLayer, in: containerView, playerView: playerView, context: context)
    
        return containerView
    }

    private func loadVideo(from pathOrURL: String, into player: AVPlayer, playerLayer: AVPlayerLayer, in containerView: NSView, playerView: NSView, context: Context) {
        let playerItem: AVPlayerItem
        
        if let url = URL(string: pathOrURL), (url.scheme == "http" || url.scheme == "https") {
            // Handle remote URL
            playerItem = AVPlayerItem(url: url)
        } else {
            // Handle local file path
            let fileURL = URL(fileURLWithPath: pathOrURL)
            playerItem = AVPlayerItem(url: fileURL)
        }

        // Replace the current item and start playing
        player.replaceCurrentItem(with: playerItem)
        player.play()

        // Set up observer for video status
        playerItem.addObserver(context.coordinator, forKeyPath: "status", options: [.new], context: nil)

        // Handle fade-out effect
        handleFadeOutEffect(for: player, playerView: playerView, fadeOutDuration: 2)

        // Set up auto-layout for centering the video
        setUpAutoLayout(playerView: playerView, playerLayer: playerLayer, in: containerView)
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        // No need to update view for now
        return
    }

    // Set up Auto-Layout to center and size the video at 50% of the screen size
    private func setUpAutoLayout(playerView: NSView, playerLayer: AVPlayerLayer, in containerView: NSView) {
        // Get the main screen size
        guard let screenSize = NSScreen.main?.frame.size else {
            return
        }

        // Calculate the desired size (50% of the screen)
        let videoWidth = screenSize.width * 0.5
        let videoHeight = screenSize.height * 0.5

        // Set up auto-layout constraints for centering the player view
        NSLayoutConstraint.activate([
            // Width and height constraints for 50% of screen size
            playerView.widthAnchor.constraint(equalToConstant: videoWidth),
            playerView.heightAnchor.constraint(equalToConstant: videoHeight),
            // Centering the player view in the container view
            playerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            playerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])

        // Set the frame of the player layer to match the size of the player view
        playerLayer.frame = CGRect(x: 0, y: 0, width: videoWidth, height: videoHeight)

        // Ensure layout updates immediately
        containerView.layoutSubtreeIfNeeded()
    }

    private func handleFadeOutEffect(for player: AVPlayer, playerView: NSView, fadeOutDuration: Double) {
        let playerItem = player.currentItem
        guard let playerItem = playerItem else { return }

        // Add periodic time observer to handle fade-out effect
        player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(600)), queue: .main) { [weak player, weak playerView] time in
            guard let _ = player, let playerView = playerView else { return }
            
            // Get video duration from playerItem
            let videoDuration = CMTimeGetSeconds(playerItem.duration)
            let fadeOutStart = videoDuration - fadeOutDuration
            
            let currentTime = CMTimeGetSeconds(time)
            if currentTime >= fadeOutStart {
                let progress = (currentTime - fadeOutStart) / fadeOutDuration
                playerView.animator().alphaValue = 1.0 - CGFloat(progress)
            }
        }

        // Set up notification for when the video finishes playing
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { _ in
            // Exit the application once the video has finished playing
            player.pause()
            player.replaceCurrentItem(with: nil)
            playerView.animator().alphaValue = 0.0
            
            // add a short delay before exiting (prevents audio glitches)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                NSApp.terminate(nil)
            }
        }
    }
}

class Coordinator: NSObject {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // Handle video status updates here, if necessary
    }
}

extension VideoAnimation {
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
}