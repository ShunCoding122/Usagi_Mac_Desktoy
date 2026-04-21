import AppKit

final class PetWindowController: NSWindowController {
    private let petView: PetView
    private let settings: SettingsStore
    private let debugField = NSTextField(labelWithString: "")

    init(renderer: PetRenderer, settings: SettingsStore) {
        self.settings = settings
        let baseSize = NSSize(width: PetConfig.baseSize.width * settings.petScale, height: PetConfig.baseSize.height * settings.petScale)
        let initialOrigin = ScreenUtils.clampedOrigin(for: CGRect(origin: .zero, size: baseSize), targetOrigin: settings.rememberedPosition)
        let window = PetWindow(contentRect: NSRect(origin: initialOrigin, size: baseSize))
        petView = PetView(frame: NSRect(origin: .zero, size: baseSize))
        super.init(window: window)

        window.contentView = petView
        renderer.scene.size = baseSize
        petView.skView.presentScene(renderer.scene)
        petView.onDrag = { [weak self] delta in self?.dragWindow(by: delta) }

        setupDebugField()
        applyWindowMode()
    }

    required init?(coder: NSCoder) {
        nil
    }

    func toggleVisibility() {
        guard let window else { return }
        window.isVisible ? window.orderOut(nil) : window.orderFrontRegardless()
    }

    func recenterPet() {
        guard let window, let screen = NSScreen.main else { return }
        let origin = CGPoint(x: screen.visibleFrame.midX - window.frame.width / 2, y: screen.visibleFrame.minY + 80)
        window.setFrameOrigin(origin)
        settings.rememberedPosition = origin
    }

    func applySettings(_ change: SettingsChange) {
        guard case .all = change else { return }
        applyWindowMode()
        updateScale()
        debugField.isHidden = !settings.debugOverlayEnabled
    }

    func updateDebugOverlay(_ runtime: PetRuntimeState) {
        guard settings.debugOverlayEnabled else { return }
        debugField.stringValue = "x:\(String(format: "%.2f", runtime.cursorNormalizedX)) y:\(String(format: "%.2f", runtime.cursorNormalizedY)) t:\(String(format: "%.2f", runtime.typingIntensity)) c:\(String(format: "%.2f", runtime.clickBurst)) s:\(runtime.activityState.rawValue)"
    }

    private func setupDebugField() {
        guard let content = window?.contentView else { return }
        debugField.font = NSFont.monospacedSystemFont(ofSize: 10, weight: .regular)
        debugField.textColor = .white
        debugField.backgroundColor = NSColor.black.withAlphaComponent(0.4)
        debugField.drawsBackground = true
        debugField.frame = NSRect(x: 8, y: 8, width: 300, height: 16)
        debugField.isHidden = !settings.debugOverlayEnabled
        content.addSubview(debugField)
    }

    private func dragWindow(by delta: CGPoint) {
        guard let window else { return }
        var origin = window.frame.origin
        origin.x += delta.x
        origin.y += delta.y
        origin = ScreenUtils.clampedOrigin(for: window.frame, targetOrigin: origin)
        window.setFrameOrigin(origin)
        settings.rememberedPosition = origin
    }

    private func applyWindowMode() {
        guard let window else { return }
        window.level = settings.alwaysOnTop ? .floating : .normal
        window.ignoresMouseEvents = settings.clickThroughMode
    }

    private func updateScale() {
        guard let window else { return }
        let newSize = NSSize(width: PetConfig.baseSize.width * settings.petScale, height: PetConfig.baseSize.height * settings.petScale)
        var frame = window.frame
        frame.size = newSize
        frame.origin = ScreenUtils.clampedOrigin(for: frame, targetOrigin: frame.origin)
        window.setFrame(frame, display: true)
    }
}
