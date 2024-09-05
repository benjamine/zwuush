import SwiftUI
import AVFoundation

struct ZwuushApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var audioManager = AudioManager()
    @State private var contentView: AnyView = AnyView(EmptyAnimation())  // Default to ConfettiAnimation

    var body: some Scene {
        WindowGroup {
            contentView
                .frame(width: NSScreen.main?.frame.width, height: NSScreen.main?.frame.height)
                .edgesIgnoringSafeArea(.all)
                .background(Color.clear)
                // .ignoresSafeArea()  
                .onAppear {
                    let arguments = CommandLine.arguments
                    
                    let imagePath = parseImageFlag(arguments)

                    let animationType = imagePath != nil ? "image" : "empty"
                    // Set the content view based on the animation type
                    self.contentView = selectAnimation(type: animationType, imagePath: imagePath)

                    if let soundFilePath = parseSoundFlag(arguments) {
                        playSound(from: soundFilePath)
                    } else {
                        // No audio file specified; exit after the a fixed duration
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            NSApplication.shared.terminate(nil)
                        }
                    }
                }
                .onTapGesture {
                    print("exiting after click")
                    NSApplication.shared.terminate(nil)
                }
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }

    private func selectAnimation(type: String, imagePath: String?) -> AnyView {
        switch type {
        case "image":
            return AnyView(ImageAnimation(imagePath: imagePath!))
        default:
            return AnyView(EmptyAnimation())
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

        private func parseImageFlag(_ arguments: [String]) -> String? {
        for (index, arg) in arguments.enumerated() {
            if arg == "--image", index + 1 < arguments.count {
                return arguments[index + 1]
            }
        }
        return nil
    }

    private func playSound(from pathOrURL: String) {
        audioManager.play(from: pathOrURL) {
            // Terminate the app once sound has finished playing
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
