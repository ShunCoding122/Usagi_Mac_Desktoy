import AppKit

final class MenuBarController {
    private let settings: SettingsStore
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    private var onTogglePetVisibility: (() -> Void)?
    private var onRecenter: (() -> Void)?
    private var onOpenSettings: (() -> Void)?
    private var onQuit: (() -> Void)?

    init(settings: SettingsStore) {
        self.settings = settings
    }

    func configure(onTogglePetVisibility: @escaping () -> Void, onRecenter: @escaping () -> Void, onOpenSettings: @escaping () -> Void, onQuit: @escaping () -> Void) {
        self.onTogglePetVisibility = onTogglePetVisibility
        self.onRecenter = onRecenter
        self.onOpenSettings = onOpenSettings
        self.onQuit = onQuit

        statusItem.button?.title = "🐰"
        statusItem.menu = buildMenu()
    }

    func apply(settings: SettingsStore?) {
        statusItem.menu = buildMenu()
    }

    private func buildMenu() -> NSMenu {
        let menu = NSMenu()
        menu.addItem(item("Show / Hide Pet", #selector(togglePet)))
        menu.addItem(item(settings.launchAtLogin ? "Disable Launch at Login" : "Enable Launch at Login", #selector(toggleLaunchAtLogin)))
        menu.addItem(item(settings.clickThroughMode ? "Disable Click-Through" : "Enable Click-Through", #selector(toggleClickThrough)))
        menu.addItem(item("Open Settings", #selector(openSettings)))
        menu.addItem(item("Re-center Pet", #selector(recenter)))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(item("Quit", #selector(quit)))
        return menu
    }

    private func item(_ title: String, _ action: Selector) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: action, keyEquivalent: "")
        item.target = self
        return item
    }

    @objc private func togglePet() { onTogglePetVisibility?() }
    @objc private func recenter() { onRecenter?() }
    @objc private func openSettings() { onOpenSettings?() }
    @objc private func quit() { onQuit?() }

    @objc private func toggleLaunchAtLogin() {
        settings.launchAtLogin.toggle()
        settings.saveAndBroadcast()
    }

    @objc private func toggleClickThrough() {
        settings.clickThroughMode.toggle()
        settings.saveAndBroadcast()
    }
}
