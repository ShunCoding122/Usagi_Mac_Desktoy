import Foundation

enum PetInputEvent {
    case cursor(CGPoint)
    case clickDown
    case clickUp
    case typingDown
    case typingUp
}

final class InputEventRouter {
    var onInputEvent: ((PetInputEvent) -> Void)?
    private let monitor: GlobalInputMonitor

    init(inputMonitor: GlobalInputMonitor) {
        self.monitor = inputMonitor
        self.monitor.onEvent = { [weak self] in self?.route($0) }
    }

    private func route(_ event: GlobalInputEvent) {
        switch event {
        case .mouseMoved(let point): onInputEvent?(.cursor(point))
        case .leftMouseDown: onInputEvent?(.clickDown)
        case .leftMouseUp: onInputEvent?(.clickUp)
        case .keyDown: onInputEvent?(.typingDown)
        case .keyUp: onInputEvent?(.typingUp)
        }
    }
}
