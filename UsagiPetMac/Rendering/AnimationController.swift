import Foundation
import CoreGraphics

final class AnimationController {
    static let shared = AnimationController()

    private var blinkAccumulator: TimeInterval = 0

    func nextBlinkPhase(dt: TimeInterval, idleTime: TimeInterval) -> CGFloat {
        let frequency = idleTime > PetConfig.idleToSleepySeconds ? 0.25 : 0.45
        blinkAccumulator += dt * frequency
        let phase = CGFloat((sin(blinkAccumulator * .pi * 2) + 1) * 0.5)
        return phase > 0.92 ? (phase - 0.92) * 12.5 : 0
    }

    func blend(runtime: PetRuntimeState, previous: AnimationState) -> AnimationState {
        var state = previous
        let t: CGFloat = 0.18

        let headTarget = CGPoint(x: runtime.cursorNormalizedX * 7, y: runtime.cursorNormalizedY * 5)
        let eyeTarget = CGPoint(x: runtime.cursorNormalizedX * 11, y: runtime.cursorNormalizedY * 8)
        let bodyTarget = CGPoint(x: runtime.cursorNormalizedX * 2.0, y: runtime.cursorNormalizedY * 1.2)

        state.headOffset.x = MathUtils.lerp(state.headOffset.x, headTarget.x, t: t)
        state.headOffset.y = MathUtils.lerp(state.headOffset.y, headTarget.y, t: t)
        state.eyeOffset.x = MathUtils.lerp(state.eyeOffset.x, eyeTarget.x, t: t)
        state.eyeOffset.y = MathUtils.lerp(state.eyeOffset.y, eyeTarget.y, t: t)
        state.bodyOffset.x = MathUtils.lerp(state.bodyOffset.x, bodyTarget.x, t: t * 0.7)
        state.bodyOffset.y = MathUtils.lerp(state.bodyOffset.y, bodyTarget.y, t: t * 0.7)

        let clickBonus = runtime.clickBurst * 0.13
        state.headRotation = MathUtils.lerp(state.headRotation, runtime.cursorNormalizedX * 0.06 + clickBonus, t: t)
        state.leftEarRotation = MathUtils.lerp(state.leftEarRotation, state.headRotation * 0.65, t: t * 0.8)
        state.rightEarRotation = MathUtils.lerp(state.rightEarRotation, -state.headRotation * 0.5, t: t * 0.8)

        state.typingPoseBlend = MathUtils.lerp(state.typingPoseBlend, runtime.typingIntensity, t: 0.22)
        state.blinkAmount = runtime.blinkPhase > 0 ? runtime.blinkPhase : (runtime.clickBurst > 0.6 ? 1 : 0)

        state.smileAmount = runtime.activityState == .typingFast ? 1.0 : (runtime.activityState == .clickReact ? 0.6 : 0)
        state.blushOpacity = runtime.emotionState == .sleepy ? 0 : max(0, runtime.typingIntensity - 0.55)

        return state
    }
}
