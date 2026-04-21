import SpriteKit

protocol PetRenderable: AnyObject {
    func apply(animation: AnimationState, runtime: PetRuntimeState)
}

protocol PetAnimationDriving: AnyObject {
    func apply(runtimeState: PetRuntimeState)
}

protocol PetExpressionDriving: AnyObject {
    func setEmotion(_ emotion: EmotionState)
}

final class PetRenderer: PetAnimationDriving, PetExpressionDriving {
    private(set) var scene: PetScene
    private var animationState = AnimationState()
    private let settings: SettingsStore

    init(settings: SettingsStore) {
        self.settings = settings
        self.scene = PetScene(size: PetConfig.baseSize)
    }

    func apply(runtimeState: PetRuntimeState) {
        animationState = AnimationController.shared.blend(runtime: runtimeState, previous: animationState)
        scene.layeredNode.apply(animation: animationState, runtime: runtimeState)
    }

    func setEmotion(_ emotion: EmotionState) {
        scene.layeredNode.setEmotion(emotion)
    }
}
