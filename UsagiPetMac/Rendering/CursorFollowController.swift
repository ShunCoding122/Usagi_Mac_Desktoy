import AppKit

final class CursorFollowController {
    func normalizedCursor(fromScreen screenPoint: CGPoint) -> CGPoint {
        guard let screen = NSScreen.screens.first(where: { $0.frame.contains(screenPoint) }) ?? NSScreen.main else {
            return .zero
        }
        let nx = ((screenPoint.x - screen.frame.midX) / (screen.frame.width * 0.5)).clamped(to: -1...1)
        let ny = ((screenPoint.y - screen.frame.midY) / (screen.frame.height * 0.5)).clamped(to: -1...1)
        return CGPoint(x: nx, y: ny)
    }
}

private extension CGFloat {
    func clamped(to range: ClosedRange<CGFloat>) -> CGFloat {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
