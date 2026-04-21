import CoreGraphics

struct AnimationState {
    var headOffset = CGPoint.zero
    var headRotation: CGFloat = 0
    var eyeOffset = CGPoint.zero
    var bodyOffset = CGPoint.zero
    var leftEarRotation: CGFloat = 0
    var rightEarRotation: CGFloat = 0
    var typingPoseBlend: CGFloat = 0
    var blinkAmount: CGFloat = 0
    var smileAmount: CGFloat = 0
    var blushOpacity: CGFloat = 0
}
