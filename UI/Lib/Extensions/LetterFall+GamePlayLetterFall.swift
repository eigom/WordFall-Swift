//
//  Copyright 2022 Eigo Madaloja
//

import UIKit

extension LetterFall {
    init(_ fall: GamePlayLetterFall) {
        self.init(
            letter: fall.letter,
            fallAmount: CGFloat(fall.fallAmount),
            startAccelerationTiming: .init(fall.startAccelerationTiming),
            fallTiming: .init(fall.fallTiming),
            fadeOutTiming: .init(fall.fadeOutTiming)
        )
    }
}
