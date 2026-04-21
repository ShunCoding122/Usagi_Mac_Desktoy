import SpriteKit

final class PetScene: SKScene {
    let layeredNode = LayeredPetNode()

    override init(size: CGSize) {
        super.init(size: size)
        scaleMode = .resizeFill
        backgroundColor = .clear
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(layeredNode)
    }

    required init?(coder aDecoder: NSCoder) {
        nil
    }
}
