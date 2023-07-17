//
//  Copyright 2022 Eigo Madaloja
//

import SpriteKit
import RxSwift
import RxCocoa

class Scene: SKScene {
    let isSoundEnabled: BehaviorRelay<Bool>

    var scenePresented: Observable<Void> {
        scenePresentedSubject.asObservable()
    }

    private let scenePresentedSubject = PublishSubject<Void>()

    init(
        isSoundEnabled: BehaviorRelay<Bool>
    ) {
        self.isSoundEnabled = isSoundEnabled
        super.init(size: .zero)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func action(for soundEffect: SoundEffect) -> SKAction {
        let playSoundNode = SKAction.run {
            guard
                self.isSoundEnabled.value,
                soundEffect.sound != .none
            else { return }

            self.run(
                SKAction.sequence([
                    soundEffect.delayAction,
                    SKAction.playSoundFileNamed(soundEffect.soundFileName, waitForCompletion: false)
                ])
            )
        }

        return playSoundNode
    }

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        scenePresentedSubject.onNext(())
    }
}
