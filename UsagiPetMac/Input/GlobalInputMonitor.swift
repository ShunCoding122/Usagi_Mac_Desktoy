import AppKit

enum GlobalInputEvent {
    case mouseMoved(CGPoint)
    case leftMouseDown
    case leftMouseUp
    case keyDown
    case keyUp
}

final class GlobalInputMonitor {
    var onEvent: ((GlobalInputEvent) -> Void)?

    private let permissionManager: PermissionManager
    private var globalMonitors: [Any] = []
    private var localMonitors: [Any] = []

    init(permissionManager: PermissionManager) {
        self.permissionManager = permissionManager
    }

    func start() {
        stop()

        globalMonitors.append(NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved) { [weak self] event in
            self?.onEvent?(.mouseMoved(event.locationInWindow))
        } as Any)

        globalMonitors.append(NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDown) { [weak self] _ in
            self?.onEvent?(.leftMouseDown)
        } as Any)

        globalMonitors.append(NSEvent.addGlobalMonitorForEvents(matching: .leftMouseUp) { [weak self] _ in
            self?.onEvent?(.leftMouseUp)
        } as Any)

        if permissionManager.hasAccessibilityAccess {
            globalMonitors.append(NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] _ in
                self?.onEvent?(.keyDown)
            } as Any)
            globalMonitors.append(NSEvent.addGlobalMonitorForEvents(matching: .keyUp) { [weak self] _ in
                self?.onEvent?(.keyUp)
            } as Any)
        } else {
            localMonitors.append(NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
                self?.onEvent?(.keyDown)
                return event
            } as Any)
            localMonitors.append(NSEvent.addLocalMonitorForEvents(matching: .keyUp) { [weak self] event in
                self?.onEvent?(.keyUp)
                return event
            } as Any)
        }
    }

    func stop() {
        (globalMonitors + localMonitors).forEach { NSEvent.removeMonitor($0) }
        globalMonitors.removeAll()
        localMonitors.removeAll()
    }
}
