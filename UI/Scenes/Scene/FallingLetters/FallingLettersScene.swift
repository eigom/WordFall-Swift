//
//  Copyright 2022 Eigo Madaloja
//

import SpriteKit
import RxSwift
import RxCocoa

struct LetterFall {
    public let letter: Character
    public let fallAmount: CGFloat
    public let startAccelerationTiming: AnimationTiming
    public let fallTiming: AnimationTiming
    public let fadeOutTiming: AnimationTiming

    fileprivate func makeFall(
        totalDistance: CGFloat,
        nodeSize: CGSize
    ) -> FallingLetterNode.Fall {
        return .init(
            letter: letter,
            startFrom: totalDistance + nodeSize.height / 2.0,
            accelerateTo: (totalDistance - nodeSize.height / 2.0) * fallAmount,
            accelerationTiming: startAccelerationTiming,
            fallTo: nodeSize.height / 2.0 - 5,
            fallTiming: fallTiming,
            fadeOutTiming: fadeOutTiming
        )
    }
}

struct LetterRetraction {
    public let timing: AnimationTiming

    fileprivate func makeRetraction(
        totalDistance: CGFloat,
        nodeSize: CGSize
    ) -> FallingLetterNode.Retraction {
        return .init(
            moveTo: totalDistance + nodeSize.height / 2.0,
            timing: timing
        )
    }
}

class FallingLettersScene: Scene {
    public var letterNodeColor: UIColor = .clear
    public var letterTap: Observable<Int> {
        letterTapSubject.asObservable()
    }
    public var letterFinishedFalling: Observable<Int> {
        letterFinishedFallingSubject.asObservable()
    }

    private let imageProvider: ImageProvider
    private var letterNodes = [FallingLetterNode]()
    private let letterTapSubject = PublishSubject<Int>()
    private let letterFinishedFallingSubject = PublishSubject<Int>()
    private let letterCount: Int

    private var letterNodeLayout: LinearLayout {
        LinearLayout(
            areaSize: size,
            minimumItemSpacing: 25,
            layoutAxis: .horizontal
        )
    }

    private var letterNodeSize: CGSize {
        letterNodeLayout.itemSize(
            itemCount: letterCount
        )
    }

    init(
        isSoundEnabled: BehaviorRelay<Bool>,
        letterCount: Int,
        imageProvider: ImageProvider
    ) {
        self.letterCount = letterCount
        self.imageProvider = imageProvider
        super.init(isSoundEnabled: isSoundEnabled)
        setup()
    }

    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        layout()
    }

    func startFall(
        with letterFalls: [LetterFall],
        soundEffect: SoundEffect
    ) {
        let letterFalls = letterFalls.map {
            $0.makeFall(
                totalDistance: size.height,
                nodeSize: letterNodeSize
            )
        }

        letterNodes.removeAll()
        letterFalls
            .enumerated()
            .forEach { letterFall in
                let letterNode = FallingLetterNode(fall: letterFall.element)
                letterNode.onTouched = { [weak self] in
                    self?.letterTapSubject.onNext(letterFall.offset)
                }
                letterNode.onReachedEnd = { [weak self] in
                    self?.letterFinishedFallingSubject.onNext(letterFall.offset)
                }
                letterNodes.append(letterNode)
                addChild(letterNode)
            }

        layout()

        letterNodes.forEach { letterNode in
            letterNode.startFall()
        }

        run(action(for: soundEffect))
    }

    func retractAll(with retraction: LetterRetraction) {
        let retraction = retraction.makeRetraction(
            totalDistance: size.height + letterNodeSize.height / 2.0,
            nodeSize: letterNodeSize
        )
        letterNodes.forEach { letterNode in
            letterNode.retract(retraction)
        }
        letterNodes.removeAll()
    }

    func removeLetter(
        at index: Int,
        timing: AnimationTiming
    ) {
        guard letterNodes.indices ~= index else { return }

        letterNodes[index].fadeOut(timing: timing)
    }

    private func setup() {
        backgroundColor = .clear
        scaleMode = .resizeFill
    }

    private func layout() {
        let image = imageProvider.fallingNodeImage(
            size: letterNodeSize,
            color: letterNodeColor
        )

        let nodePositionSpacing = letterNodeLayout.itemSpacing(
            itemCount: letterNodes.count
        )

        letterNodes
            .enumerated()
            .forEach { letterNode in
                let horizontalOffset = nodePositionSpacing * CGFloat(letterNode.offset + 1)
                let verticalOffset = size.height + letterNodeSize.height / 2.0

                letterNode.element.position = CGPoint(
                    x: horizontalOffset,
                    y: verticalOffset
                )

                letterNode.element.image = image
            }
    }
}
