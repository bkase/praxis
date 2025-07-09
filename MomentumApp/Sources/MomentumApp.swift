import SwiftUI
import ComposableArchitecture

@main
struct MomentumApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate
    
    var body: some Scene {
        // Hidden window is necessary for menu bar apps to properly display
        // Settings windows and other UI elements. Without this, the app
        // cannot present new windows when running as .accessory
        WindowGroup("HiddenWindow") {
            HiddenWindowView()
        }
        .windowResizability(.contentSize)
        .defaultSize(width: 1, height: 1)
        .windowStyle(.hiddenTitleBar)
    }
}

struct HiddenWindowView: View {
    var body: some View {
        EmptyView()
            .frame(width: 0, height: 0)
            .background(Color.clear)
            .onAppear {
                if let window = NSApplication.shared.windows.first {
                    window.close()
                }
            }
    }
}