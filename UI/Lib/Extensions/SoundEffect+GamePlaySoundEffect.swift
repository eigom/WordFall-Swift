//
//  Copyright 2022 Eigo Madaloja
//

extension SoundEffect {
    init(_ soundEffect: GamePlaySoundEffect) {
        self.init(
            sound: .init(soundEffect.sound),
            delay: .init(soundEffect.delay)
        )
    }
}

extension Sound {
    init(_ sound: GamePlaySound) {
        switch sound {
        case .none:
            self = .none
        case .fallStart, .revealLetter, .revealWord:
            self = .fromFile(fileName: sound.soundFileName)
        }
    }
}

extension SoundDelay {
    init(_ delay: GamePlayDelay) {
        switch delay {
        case .none:
            self = .none
        case .seconds(let seconds):
            self = .seconds(seconds)
        }
    }
}
