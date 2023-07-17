//
//  Copyright 2022 Eigo Madaloja
//

import SpriteKit
import Foundation

enum AnimationDelay {
    case none
    case seconds(TimeInterval)
}

enum AnimationDuration {
    case immediate
    case seconds(TimeInterval)
}

struct AnimationTiming {
    let duration: AnimationDuration
    let delay: AnimationDelay

    var durationSeconds: TimeInterval {
        switch duration {
        case .immediate:
            return 0.0
        case .seconds(let seconds):
            return seconds
        }
    }

    var delaySeconds: TimeInterval {
        switch delay {
        case .none:
            return 0.0
        case .seconds(let seconds):
            return seconds
        }
    }

    var delayAction: SKAction {
        SKAction.wait(forDuration: delaySeconds)
    }

    init(
        duration: AnimationDuration,
        delay: AnimationDelay = .none
    ) {
        self.duration = duration
        self.delay = delay
    }

    func secondsPerAction(actionCount: Int) -> TimeInterval {
        return durationSeconds / TimeInterval(actionCount)
    }
}
