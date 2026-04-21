import CoreGraphics

enum EmotionState: String {
    case neutral
    case happy
    case surprised
    case sleepy
}

enum PetActivityState: String {
    case idle
    case typingSoft
    case typingFast
    case mouseFollow
    case clickReact
    case sleepy
}

struct PetRuntimeState {
    var cursorNormalizedX: CGFloat = 0
    var cursorNormalizedY: CGFloat = 0
    var typingIntensity: CGFloat = 0
    var clickBurst: CGFloat = 0
    var idleTime: TimeInterval = 0
    var emotionState: EmotionState = .neutral
    var blinkPhase: CGFloat = 0
    var activityState: PetActivityState = .idle
}
