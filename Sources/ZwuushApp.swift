import SwiftUI

struct ZwuushApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(width: NSScreen.main?.frame.width, height: NSScreen.main?.frame.height)
                .background(Color.clear)
                .ignoresSafeArea()  
        }
        .windowStyle(HiddenTitleBarWindowStyle())
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