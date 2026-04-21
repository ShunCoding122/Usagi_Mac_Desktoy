import CoreGraphics

enum MathUtils {
    static func clamp<T: Comparable>(_ value: T, min lower: T, max upper: T) -> T {
        Swift.min(upper, Swift.max(lower, value))
    }

    static func lerp(_ a: CGFloat, _ b: CGFloat, t: CGFloat) -> CGFloat {
        a + (b - a) * t
    }
}
