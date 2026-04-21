import Foundation
import CoreGraphics

struct PetConfig {
    static let baseSize = CGSize(width: 320, height: 280)
    static let minScale: CGFloat = 0.6
    static let maxScale: CGFloat = 2.0
    static let defaultScale: CGFloat = 1.0

    static let idleToSleepySeconds: TimeInterval = 25
    static let followDamping: CGFloat = 0.16

    static let typingSoftThreshold: CGFloat = 0.25
    static let typingFastThreshold: CGFloat = 0.65
}
