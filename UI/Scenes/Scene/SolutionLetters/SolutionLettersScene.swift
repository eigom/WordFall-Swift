//
//  Copyright 2022 Eigo Madaloja
//

import SpriteKit
import RxCocoa

class SolutionLettersScene: Scene {
    private let imageProvider: ImageProvider
    private var letterNodes = [SolutionLetterNode]()
    private var activeLetterNodes = [SolutionLetterNode]()

    init(
        isSoundEnabled: BehaviorRelay<Bool>,
        letterCount: Int,
        imageProvider: ImageProvider
    ) {
        self.imageProvider = imageProvider
        super.init(isSoundEnabled: isSoundEnabled)
        setup(letterCount: letterCount)
    }

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        layout()
    }

    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        layout()
    }

    func setActiveLetters(
        _ letters: [Character?],
        timing: AnimationTiming
    ) {
        guard letters.count <= letterNodes.count else { return }

        let firstNodeIndex = (letterNodes.count - letters.count) / 2
        let activeRange = firstNodeIndex ..< (firstNodeIndex + letters.count)
        let nodeLetters: [Character?] = Array(
            repeating: nil,
            count: firstNodeIndex
        ) + letters + Array(
            repeating: nil,
            count: letterNodes.count - (firstNodeIndex + letters.count)
        )

        activeLetterNodes.removeAll()

        letterNodes
            .enumerated()
            .forEach { node in
                node.element.setup(
                    letter: nodeLetters[node.offset],
                    isVisible: activeRange.contains(node.offset),
                    timing: timing
                )

                if activeRange.contains(node.offset) {
                    activeLetterNodes.append(node.element)
                }
        }
    }

    func revealLetter(
        _ letter: Character,
        at index: Int,
        timing: AnimationTiming,
        soundEffect: SoundEffect
    ) {
        guard activeLetterNodes.indices ~= index else { return }

        activeLetterNodes[index].revealLetter(
            letter,
            timing: timing
        )

        run(action(for: soundEffect))
    }

    private func setup(letterCount: Int) {
        backgroundColor = .clear
        scaleMode = .resizeFill

        (0 ..< letterCount).forEach { _ in
            let letterNode = SolutionLetterNode()
            letterNodes.append(letterNode)
        }

        letterNodes.forEach { letterNode in
            addChild(letterNode)
        }
    }

    private func layout() {
        let letterNodeLayout = LinearLayout(
            areaSize: size,
            minimumItemSpacing: 10,
            layoutAxis: .horizontal
        )
        let letterNodeSize = letterNodeLayout.itemSize(
            itemCount: letterNodes.count
        )
        let letterNodeImage = imageProvider.solutionNodeImage(
            size: letterNodeSize,
            color: Assets.Colors.GamePlay.green.color
        )

        let nodePositionSpacing = letterNodeLayout.itemSpacing(
            itemCount: letterNodes.count
        )

        letterNodes
            .enumerated()
            .forEach { letterNode in
                let horizontalOffset = nodePositionSpacing * CGFloat(letterNode.offset + 1)
                let verticalOffset = size.height / 2.0

                letterNode.element.position = CGPoint(
                    x: horizontalOffset,
                    y: verticalOffset
                )

                letterNode.element.image = letterNodeImage
            }
    }
}
