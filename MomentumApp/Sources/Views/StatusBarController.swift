import AppKit
import SwiftUI
import ComposableArchitecture

@MainActor
final class StatusBarController: NSObject {
    private var statusItem: NSStatusItem?
    private let store: StoreOf<AppFeature>
    private var popover: NSPopover?
    
    init(store: StoreOf<AppFeature>) {
        self.store = store
        super.init()
        setupStatusItem()
    }
    
    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "timer", accessibilityDescription: "Momentum")
            button.action = #selector(togglePopover)
            button.target = self
            
            // Accessibility
            button.setAccessibilityTitle("Momentum")
            button.setAccessibilityRole(.button)
            button.setAccessibilityHelp("Focus session tracking")
        }
    }
    
    @objc private func togglePopover() {
        if let popover = popover, popover.isShown {
            popover.performClose(nil)
            self.popover = nil
        } else {
            showPopover()
        }
    }
    
    private func showPopover() {
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 320, height: 400)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(
            rootView: ContentView(store: store)
        )
        
        if let button = statusItem?.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
        
        self.popover = popover
    }
}