import SwiftUI

struct ContentView: View {
    @State private var showZwuush = true
    
    var body: some View {
        ZStack {
            if showZwuush {
                ZwuushView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            NSApp.terminate(nil) // Exit the app after 5 seconds
                        }
                    }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
    }
}