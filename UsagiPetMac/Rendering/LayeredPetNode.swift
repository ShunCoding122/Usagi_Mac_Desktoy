import SpriteKit

final class LayeredPetNode: SKNode, PetRenderable {
    private var usingDebugShapes = false

    private let body = SKSpriteNode()
    private let desk = SKSpriteNode()
    private let head = SKSpriteNode()
    private let leftEar = SKSpriteNode()
    private let rightEar = SKSpriteNode()
    private let eyesOpen = SKSpriteNode()
    private let eyesClosed = SKSpriteNode()
    private let mouthNeutral = SKSpriteNode()
    private let mouthHappy = SKSpriteNode()
    private let blush = SKSpriteNode()
    private let leftArmIdle = SKSpriteNode()
    private let leftArmTyping = SKSpriteNode()
    private let rightArmIdle = SKSpriteNode()
    private let rightArmTyping = SKSpriteNode()

    override init() {
        super.init()
        setupNodes()
    }

    required init?(coder: NSCoder) {
        nil
    }

    func apply(animation: AnimationState, runtime: PetRuntimeState) {
        body.position = animation.bodyOffset
        head.position = CGPoint(x: animation.headOffset.x, y: 42 + animation.headOffset.y)
        head.zRotation = animation.headRotation

        eyesOpen.position = animation.eyeOffset
        eyesClosed.position = animation.eyeOffset
        eyesOpen.alpha = 1 - animation.blinkAmount
        eyesClosed.alpha = animation.blinkAmount

        leftEar.zRotation = animation.leftEarRotation
        rightEar.zRotation = animation.rightEarRotation

        leftArmTyping.alpha = animation.typingPoseBlend
        rightArmTyping.alpha = animation.typingPoseBlend
        leftArmIdle.alpha = 1 - animation.typingPoseBlend
        rightArmIdle.alpha = 1 - animation.typingPoseBlend

        mouthHappy.alpha = animation.smileAmount
        mouthNeutral.alpha = 1 - animation.smileAmount
        blush.alpha = animation.blushOpacity
    }

    func setEmotion(_ emotion: EmotionState) {
        if emotion == .sleepy {
            mouthHappy.alpha = 0
            mouthNeutral.alpha = 1
        }
    }

    private func setupNodes() {
        usingDebugShapes = !loadTexturesIfAvailable()

        desk.position = CGPoint(x: 0, y: -80)
        body.position = CGPoint(x: 0, y: -18)
        head.position = CGPoint(x: 0, y: 42)
        leftEar.position = CGPoint(x: -35, y: 56)
        rightEar.position = CGPoint(x: 35, y: 56)
        leftArmIdle.position = CGPoint(x: -35, y: -30)
        leftArmTyping.position = leftArmIdle.position
        rightArmIdle.position = CGPoint(x: 35, y: -30)
        rightArmTyping.position = rightArmIdle.position

        addChild(desk)
        addChild(body)
        addChild(leftArmIdle)
        addChild(leftArmTyping)
        addChild(rightArmIdle)
        addChild(rightArmTyping)
        addChild(leftEar)
        addChild(rightEar)
        addChild(head)
        head.addChild(eyesOpen)
        head.addChild(eyesClosed)
        head.addChild(mouthNeutral)
        head.addChild(mouthHappy)
        head.addChild(blush)

        if usingDebugShapes {
            configureDebugShapes()
        }
    }

    private func loadTexturesIfAvailable() -> Bool {
        func texture(_ name: String) -> SKTexture? {
            if NSImage(named: name) != nil {
                return SKTexture(imageNamed: name)
            }
            return nil
        }

        guard let bodyTx = texture("body_base"), let headTx = texture("head_base") else {
            return false
        }

        body.texture = bodyTx
        head.texture = headTx
        desk.texture = texture("desk")
        leftEar.texture = texture("left_ear")
        rightEar.texture = texture("right_ear")
        eyesOpen.texture = texture("eyes_open")
        eyesClosed.texture = texture("eyes_closed")
        mouthNeutral.texture = texture("mouth_neutral")
        mouthHappy.texture = texture("mouth_happy")
        blush.texture = texture("blush")
        leftArmIdle.texture = texture("arm_left_idle")
        leftArmTyping.texture = texture("arm_left_typing")
        rightArmIdle.texture = texture("arm_right_idle")
        rightArmTyping.texture = texture("arm_right_typing")
        return true
    }

    private func configureDebugShapes() {
        body.color = .systemPink; body.size = CGSize(width: 130, height: 96); body.colorBlendFactor = 1
        head.color = .white; head.size = CGSize(width: 110, height: 88); head.colorBlendFactor = 1
        desk.color = .brown; desk.size = CGSize(width: 220, height: 52); desk.colorBlendFactor = 1
        leftEar.color = .white; rightEar.color = .white
        leftEar.size = CGSize(width: 28, height: 70); rightEar.size = leftEar.size
        eyesOpen.color = .black; eyesOpen.size = CGSize(width: 30, height: 8); eyesOpen.colorBlendFactor = 1
        eyesClosed.color = .black; eyesClosed.size = CGSize(width: 30, height: 2); eyesClosed.colorBlendFactor = 1
        mouthNeutral.color = .black; mouthNeutral.size = CGSize(width: 16, height: 4); mouthNeutral.colorBlendFactor = 1
        mouthHappy.color = .systemRed; mouthHappy.size = CGSize(width: 18, height: 6); mouthHappy.colorBlendFactor = 1
        blush.color = .systemPink; blush.size = CGSize(width: 56, height: 14); blush.colorBlendFactor = 1
        leftArmIdle.color = .white; leftArmIdle.size = CGSize(width: 26, height: 40); leftArmIdle.colorBlendFactor = 1
        leftArmTyping.color = .systemOrange; leftArmTyping.size = leftArmIdle.size; leftArmTyping.colorBlendFactor = 1
        rightArmIdle.color = .white; rightArmIdle.size = leftArmIdle.size; rightArmIdle.colorBlendFactor = 1
        rightArmTyping.color = .systemOrange; rightArmTyping.size = rightArmIdle.size; rightArmTyping.colorBlendFactor = 1
    }
}
