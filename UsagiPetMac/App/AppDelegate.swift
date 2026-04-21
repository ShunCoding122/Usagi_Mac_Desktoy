import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    private let settings = SettingsStore.shared
    private lazy var permissions = PermissionManager()
    private lazy var inputMonitor = GlobalInputMonitor(permissionManager: permissions)
    private lazy var eventRouter = InputEventRouter(inputMonitor: inputMonitor)
    private lazy var stateMachine = PetStateMachine(settings: settings)
    private lazy var renderer = PetRenderer(settings: settings)
    private lazy var windowController = PetWindowController(renderer: renderer, settings: settings)
    private lazy var menuBar = MenuBarController(settings: settings)

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        bindPipelines()
        windowController.showWindow(nil)
        menuBar.configure(
            onTogglePetVisibility: { [weak self] in self?.windowController.toggleVisibility() },
            onRecenter: { [weak self] in self?.windowController.recenterPet() },
            onOpenSettings: { [weak self] in self?.presentSettings() },
            onQuit: { NSApp.terminate(nil) }
        )

        permissions.ensureAccessibilityPermissionIfNeeded(prompt: false)
        inputMonitor.start()
    }

    func applicationWillTerminate(_ notification: Notification) {
        inputMonitor.stop()
    }

    private func bindPipelines() {
        eventRouter.onInputEvent = { [weak self] event in
            self?.stateMachine.handle(input: event)
        }

        stateMachine.onRuntimeStateChanged = { [weak self] runtime in
            self?.renderer.apply(runtimeState: runtime)
            self?.windowController.updateDebugOverlay(runtime)
        }

        settings.onSettingsChanged = { [weak self] change in
            self?.windowController.applySettings(change)
            self?.stateMachine.applySettingsChange(change)
            self?.menuBar.apply(settings: self?.settings)
        }
    }

    private func presentSettings() {
        let host = NSHostingController(rootView: SettingsView(store: settings, permissionManager: permissions))
        let window = NSWindow(contentViewController: host)
        window.styleMask = [.titled, .closable, .miniaturizable]
        window.title = "UsagiPetMac Settings"
        window.setContentSize(NSSize(width: 420, height: 420))
        window.center()
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}
