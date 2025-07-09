import AppKit
import SwiftUI
import ComposableArchitecture

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusBarController: StatusBarController?
    private let store = Store(initialState: AppFeature.State()) {
        AppFeature()
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Initialize status bar controller
        statusBarController = StatusBarController(store: store)
        
        // Hide dock icon (menu bar app)
        NSApp.setActivationPolicy(.accessory)
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        // Clean up if needed
    }
}