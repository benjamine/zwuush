import SwiftUI
import AVFoundation

struct ZwuushApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    private let audioManager = AudioManager()
    @StateObject private var soundPlayer = SoundPlayer()
    @State private var contentView: AnyView = AnyView(ConfettiAnimation())  // Default to ConfettiAnimation

    var body: some Scene {
        WindowGroup {
            contentView
                .frame(width: NSScreen.main?.frame.width, height: NSScreen.main?.frame.height)
                .background(Color.clear)
                .ignoresSafeArea()  
                .onAppear {
                    let arguments = CommandLine.arguments

                    let animationType = parseAnimationFlag(arguments)
                    // Set the content view based on the animation type
                    self.contentView = selectAnimation(type: animationType)

                    if let soundFilePath = parseSoundFlag(arguments) {
                        playSound(from: soundFilePath)
                    } else {
                        // No audio file specified; exit after the a fixed duration
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            NSApplication.shared.terminate(nil)
                        }
                    }
                }
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }

    private func parseAnimationFlag(_ arguments: [String]) -> String {
        for (index, arg) in arguments.enumerated() {
            if arg == "--animation", index + 1 < arguments.count {
                return arguments[index + 1]
            }
        }
        return "confetti"  // Default to confetti animation
    }

    private func selectAnimation(type: String) -> AnyView {
        switch type {
        case "confetti":
            return AnyView(ConfettiAnimation())
        case "petals":
            return AnyView(PetalsAnimation())
        //case "rain":
        //    return AnyView(RainAnimation())
        default:
            return AnyView(ConfettiAnimation())
        }
    }

    private func parseSoundFlag(_ arguments: [String]) -> String? {
        for (index, arg) in arguments.enumerated() {
            if arg == "--sound", index + 1 < arguments.count {
                return arguments[index + 1]
            }
        }
        return nil
    }

    private func playSound(from path: String) {
        let fileManager = FileManager.default
        let soundURL = URL(fileURLWithPath: path)
        
        if fileManager.fileExists(atPath: path) {
            soundPlayer.playSound(from: soundURL) {
                NSApplication.shared.terminate(nil)
            }
        } else {
            print("sound file not found at path: \(path)")
            NSApplication.shared.terminate(nil)
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let window = NSApplication.shared.windows.first {
            window.isOpaque = false
            window.backgroundColor = .clear
            window.styleMask.insert(.fullSizeContentView)
            window.titlebarAppearsTransparent = true
            window.level = .floating // Ensure the window is on top
        }
    }
}

class SoundPlayer: ObservableObject {
    private var audioPlayer: AVAudioPlayer?
    
    func playSound(from url: URL, completion: @escaping () -> Void) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
            // Wait until audio finishes
            DispatchQueue.main.asyncAfter(deadline: .now() + audioPlayer!.duration) {
                completion()
            }
        } catch {
            print("Error playing sound: \(error)")
            completion()
        }
    }
}