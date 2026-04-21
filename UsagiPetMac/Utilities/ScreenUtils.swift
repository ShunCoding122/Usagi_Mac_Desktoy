import AppKit

struct ScreenUtils {
    static func safeFrameForPoint(_ point: CGPoint) -> CGRect {
        NSScreen.screens.first(where: { $0.frame.contains(point) })?.visibleFrame ?? (NSScreen.main?.visibleFrame ?? .zero)
    }

    static func clampedOrigin(for frame: CGRect, targetOrigin: CGPoint) -> CGPoint {
        let screen = safeFrameForPoint(targetOrigin)
        let x = min(max(targetOrigin.x, screen.minX), screen.maxX - frame.width)
        let y = min(max(targetOrigin.y, screen.minY), screen.maxY - frame.height)
        return CGPoint(x: x, y: y)
    }
}
