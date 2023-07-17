//
//  Copyright 2022 Eigo Madaloja
//

import SpriteKit

class FallingLetterNode: Node {
    struct Fall {
        public let letter: Character
        public let startFrom: CGFloat
        public let accelerateTo: CGFloat
        public let accelerationTiming: AnimationTiming
        public let fallTo: CGFloat
        public let fallTiming: AnimationTiming
        public let fadeOutTiming: AnimationTiming
    }

    struct Retraction {
        public let moveTo: CGFloat
        public let timing: AnimationTiming
    }

    var image: UIImage? {
        didSet {
            guard let image = image else {
                imageNode.texture = nil
                return
            }

            imageNode.texture = SKTexture(image: image)
            imageNode.size = image.size

            labelNode.attributedText = letterText
        }
    }

    var onTouched: (() -> Void)?
    var onReachedEnd: (() -> Void)?

    private let fall: Fall
    private let imageNode = SKSpriteNode()
    private let labelNode = SKLabelNode()
    private let fallActionKey = "fallAction"

    private var letterText: NSAttributedString {
        return NSAttributedString(
            string: String(fall.letter),
            attributes: Attributes.FallingLetterNode.title(
                fontSize: imageNode.size.height * 0.7
            )
        )
    }

    init(fall: Fall) {
        self.fall = fall
        super.init()
        setup()
        layout()
    }

    func startFall() {
        let acceleratedFall = SKAction.moveTo(
            y: fall.accelerateTo,
            duration: fall.accelerationTiming.durationSeconds
        )
        acceleratedFall.timingMode = .easeOut

        let normalFall = SKAction.moveTo(
            y: fall.fallTo,
            duration: fall.fallTiming.durationSeconds
        )
        normalFall.timingMode = .linear

        let endReached = SKAction.run { [weak self] in
            self?.onReachedEnd?()
        }

        let fadeOut = SKAction.fadeOut(
            withDuration: fall.fadeOutTiming.durationSeconds
        )

        let removeFromParent = SKAction.removeFromParent()

        run(
            SKAction.sequence([
                fall.accelerationTiming.delayAction,
                acceleratedFall,
                fall.fallTiming.delayAction,
                normalFall,
                endReached,
                fall.fadeOutTiming.delayAction,
                fadeOut,
                removeFromParent
            ]), withKey: fallActionKey
        )
    }

    func retract(_ retraction: Retraction) {
        let stopFall = SKAction.run { [weak self] in
            self?.stopFall()
        }

        let retract = SKAction.moveTo(
            y: retraction.moveTo,
            duration: retraction.timing.durationSeconds
        )
        retract.timingMode = .easeIn

        let removeFromParent = SKAction.removeFromParent()

        run(
            SKAction.sequence([
                retraction.timing.delayAction,
                stopFall,
                retract,
                removeFromParent
            ])
        )
    }

    func fadeOut(timing: AnimationTiming) {
        let fadeOut = SKAction.fadeOut(
            withDuration: timing.durationSeconds
        )

        let stopFall = SKAction.run { [weak self] in
            self?.stopFall()
        }

        let removeFromParent = SKAction.removeFromParent()

        run(
            SKAction.sequence([
                timing.delayAction,
                fadeOut,
                stopFall,
                removeFromParent
            ])
        )
    }

    private func setup() {
        isUserInteractionEnabled = true

        labelNode.verticalAlignmentMode = .center
        labelNode.position = labelNode.position.applying(
            .init(translationX: 0.0, y: 3.0)
        )
    }

    private func layout() {
        addChild(imageNode)
        imageNode.addChild(labelNode)
    }

    override func touchesEnded(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        onTouched?()
    }

    private func stopFall() {
        removeAction(forKey: fallActionKey)
    }
}
