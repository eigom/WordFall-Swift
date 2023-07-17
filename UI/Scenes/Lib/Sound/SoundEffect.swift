//
//  Copyright 2022 Eigo Madaloja
//

import SpriteKit
import Foundation

enum Sound: Equatable {
    case none
    case fromFile(fileName: String)
}

enum SoundDelay {
    case none
    case seconds(TimeInterval)
}

struct SoundEffect {
    let sound: Sound
    let delay: SoundDelay

    public var soundFileName: String {
        switch sound {
        case .none:
            return "-"
        case .fromFile(fileName: let fileName):
            return fileName
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
        sound: Sound,
        delay: SoundDelay = .none
    ) {
        self.sound = sound
        self.delay = delay
    }
}
