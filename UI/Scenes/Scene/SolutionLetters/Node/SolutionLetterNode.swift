//
//  Copyright 2022 Eigo Madaloja
//

import SpriteKit

class SolutionLetterNode: Node {
    var image: UIImage? {
        didSet {
            guard let image = image else {
                imageNode.texture = nil
                return
            }

            imageNode.texture = SKTexture(image: image)
            imageNode.size = image.size

            labelNode.attributedText = labelNode.attributedText?.string.first.map {
                letterText(letter: $0)
            }
        }
    }

    private let imageNode = SKSpriteNode()
    private let labelNode = SKLabelNode()

    override init() {
        super.init()
        setup()
        layout()
    }

    func setup(
        letter: Character?,
        isVisible: Bool,
        timing: AnimationTiming
    ) {
        let actionDuration = timing.secondsPerAction(actionCount: 2)
        let visibility = isVisible
            ? SKAction.fadeIn(withDuration: actionDuration)
            : SKAction.fadeOut(withDuration: actionDuration)

        let labelAction = SKAction.run { [weak self] in
            if let letter = letter {
                let setText = SKAction.run { [weak self] in
                    self?.labelNode.attributedText = self?.letterText(letter: letter)
                }
                self?.labelNode.run(setText)
            } else {
                let clearText = SKAction.run { [weak self] in
                    self?.labelNode.attributedText = nil
                }
                self?.labelNode.run(
                    SKAction.sequence([
                        SKAction.fadeOut(withDuration: actionDuration),
                        clearText
                    ])
                )
            }
        }

        run(
            SKAction.sequence([
                timing.delayAction,
                SKAction.group([visibility, labelAction])
            ])
        )
    }

    func revealLetter(
        _ letter: Character,
        timing: AnimationTiming
    ) {
        let actionDuration = timing.secondsPerAction(actionCount: 2)
        let scaleOut = SKAction.scaleX(
            to: 0.0,
            duration: actionDuration
        )
        scaleOut.timingMode = .easeIn

        let scaleIn = SKAction.scaleX(
            to: 1.0,
            duration: actionDuration
        )
        scaleIn.timingMode = .easeOut

        let showLabel = SKAction.run { [weak self] in
            let setText = SKAction.run { [weak self] in
                self?.labelNode.attributedText = self?.letterText(letter: letter)
            }
            self?.labelNode.run(
                SKAction.sequence([
                    setText,
                    SKAction.fadeIn(withDuration: actionDuration)
                ])
            )
        }

        run(
            SKAction.sequence([
                timing.delayAction,
                scaleOut,
                SKAction.group([scaleIn, showLabel])
            ])
        )
    }

    private func letterText(letter: Character) -> NSAttributedString {
        return NSAttributedString(
            string: String(letter),
            attributes: Attributes.SolutionLetterNode.title(
                fontSize: imageNode.size.height * 0.9
            )
        )
    }

    private func setup() {
        labelNode.verticalAlignmentMode = .center
    }

    private func layout() {
        addChild(imageNode)
        imageNode.addChild(labelNode)
    }
}
