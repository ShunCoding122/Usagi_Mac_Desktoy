import Foundation
import CoreGraphics

final class ActivityEstimator {
    private(set) var lastInputAt = Date()
    private(set) var typingIntensity: CGFloat = 0
    private(set) var clickBurst: CGFloat = 0

    func registerTyping() {
        lastInputAt = Date()
        typingIntensity = min(1.0, typingIntensity + 0.22)
    }

    func registerClick() {
        lastInputAt = Date()
        clickBurst = min(1.0, clickBurst + 0.5)
    }

    func registerMovement() {
        lastInputAt = Date()
    }

    func tick(deltaTime: TimeInterval) {
        typingIntensity = max(0, typingIntensity - CGFloat(deltaTime) * 0.55)
        clickBurst = max(0, clickBurst - CGFloat(deltaTime) * 1.8)
    }

    var idleSeconds: TimeInterval {
        Date().timeIntervalSince(lastInputAt)
    }
}
