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
                    // let arguments = CommandLine.arguments

                    let args = parseArguments(CommandLine.arguments);
                    if (args.errorMessage != nil) {
                        print(args.errorMessage!)
                        exit(1)
                    }
                    
                    // Set the content view based on the animation type
                    self.contentView = selectAnimation(args: args)

                    if (args.animationType != .video) {
                        if (args.soundFile != nil) {
                            playSound(from: args.soundFile!)
                        } else {
                            // No audio or video; exit after a fixed time delay
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                NSApplication.shared.terminate(nil)
                            }
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

    private func selectAnimation(args: ArgumentsResult) -> AnyView {
        switch args.animationType {
        case .image:
            return AnyView(ImageAnimation(imagePath: args.mediaFile!))
        case .video:
            return AnyView(VideoAnimation(videoPath: args.mediaFile!))
        default:
            return AnyView(EmptyAnimation())
        }
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
