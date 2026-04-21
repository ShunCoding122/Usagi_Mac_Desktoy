import Foundation
import AppKit

final class PetStateMachine {
    var onRuntimeStateChanged: ((PetRuntimeState) -> Void)?

    private let estimator = ActivityEstimator()
    private let settings: SettingsStore
    private let cursorFollow = CursorFollowController()
    private var runtime = PetRuntimeState()
    private var timer: Timer?
    private var lastTick = Date()

    init(settings: SettingsStore) {
        self.settings = settings
        startTicker()
    }

    deinit {
        timer?.invalidate()
    }

    func handle(input: PetInputEvent) {
        switch input {
        case .cursor(let point):
            estimator.registerMovement()
            let normalized = cursorFollow.normalizedCursor(fromScreen: point)
            runtime.cursorNormalizedX = normalized.x * settings.followCursorIntensity
            runtime.cursorNormalizedY = normalized.y * settings.followCursorIntensity
        case .clickDown:
            estimator.registerClick()
        case .clickUp:
            break
        case .typingDown:
            estimator.registerTyping()
        case .typingUp:
            break
        }
    }

    func applySettingsChange(_ change: SettingsChange) {
        guard case .all = change else { return }
        onRuntimeStateChanged?(runtime)
    }

    private func startTicker() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }

    private func tick() {
        let now = Date()
        let dt = now.timeIntervalSince(lastTick)
        lastTick = now

        estimator.tick(deltaTime: dt)

        runtime.typingIntensity = estimator.typingIntensity * settings.typingReactionIntensity
        runtime.clickBurst = estimator.clickBurst
        runtime.idleTime = estimator.idleSeconds
        runtime.blinkPhase = AnimationController.shared.nextBlinkPhase(dt: dt, idleTime: runtime.idleTime)

        runtime.emotionState = runtime.idleTime > PetConfig.idleToSleepySeconds ? .sleepy : .neutral
        runtime.activityState = deriveActivityState()

        onRuntimeStateChanged?(runtime)
    }

    private func deriveActivityState() -> PetActivityState {
        if runtime.clickBurst > 0.2 { return .clickReact }
        if runtime.typingIntensity > PetConfig.typingFastThreshold { return .typingFast }
        if runtime.typingIntensity > PetConfig.typingSoftThreshold { return .typingSoft }
        if runtime.idleTime > PetConfig.idleToSleepySeconds { return .sleepy }
        if abs(runtime.cursorNormalizedX) > 0.08 || abs(runtime.cursorNormalizedY) > 0.08 { return .mouseFollow }
        return .idle
    }
}
