//
//  Copyright 2022 Eigo Madaloja
//

import Foundation

public enum GamePlaySound {
    case none
    case fallStart
    case revealLetter
    case revealWord

    public var soundFileName: String {
        switch self {
        case .none:
            return "-"
        case .fallStart:
            return "fall-start"
        case .revealLetter:
            return "reveal-letter"
        case .revealWord:
            return "reveal-word"
        }
    }
}

public struct GamePlaySoundEffect {
    public let sound: GamePlaySound
    public let delay: GamePlayDelay

    public static let none = GamePlaySoundEffect(sound: .none)

    init(
        sound: GamePlaySound,
        delay: GamePlayDelay = .none
    ) {
        self.sound = sound
        self.delay = delay
    }

    public static func sound(
        _ sound: GamePlaySound,
        delay: GamePlayDelay = .none
    ) -> GamePlaySoundEffect {
        return .init(sound: sound, delay: delay)
    }
}
