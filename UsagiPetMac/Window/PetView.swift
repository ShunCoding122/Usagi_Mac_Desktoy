import AppKit
import SpriteKit

final class PetView: NSView {
    let skView = SKView()
    private var dragStart: NSPoint?
    var onDrag: ((CGPoint) -> Void)?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        layer?.backgroundColor = NSColor.clear.cgColor
        skView.allowsTransparency = true
        skView.backgroundColor = .clear
        skView.ignoresSiblingOrder = true
        skView.frame = bounds
        skView.autoresizingMask = [.width, .height]
        addSubview(skView)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func mouseDown(with event: NSEvent) {
        dragStart = event.locationInWindow
    }

    override func mouseDragged(with event: NSEvent) {
        guard let start = dragStart else { return }
        let current = event.locationInWindow
        let dx = current.x - start.x
        let dy = current.y - start.y
        onDrag?(CGPoint(x: dx, y: dy))
    }

    override func mouseUp(with event: NSEvent) {
        dragStart = nil
    }
}
