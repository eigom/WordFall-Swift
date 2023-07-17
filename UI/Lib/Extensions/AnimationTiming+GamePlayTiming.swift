//
//  Copyright 2022 Eigo Madaloja
//

extension AnimationDelay {
    init(_ timing: GamePlayDelay) {
        switch timing {
        case .none:
            self = .none
        case .seconds(let seconds):
            self = .seconds(seconds)
        }
    }
}

extension AnimationDuration {
    init(_ duration: GamePlayDuration) {
        switch duration {
        case .immediate:
            self = .immediate
        case .seconds(let seconds):
            self = .seconds(seconds)
        }
    }
}

extension AnimationTiming {
    init(_ timing: GamePlayTiming) {
        self.init(
            duration: .init(timing.duration),
            delay: .init(timing.delay)
        )
    }
}
