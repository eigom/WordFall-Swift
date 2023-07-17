//
//  Copyright 2022 Eigo Madaloja
//

import Foundation

public enum GamePlayDelay {
    case none
    case seconds(TimeInterval)
}

public enum GamePlayDuration {
    case immediate
    case seconds(TimeInterval)
}

public struct GamePlayTiming {
    public let duration: GamePlayDuration
    public let delay: GamePlayDelay

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

    public static let immediate = GamePlayTiming(duration: .immediate)

    init(
        duration: GamePlayDuration,
        delay: GamePlayDelay = .none
    ) {
        self.duration = duration
        self.delay = delay
    }

    public static func seconds(_ seconds: TimeInterval) -> GamePlayTiming {
        return .init(duration: .seconds(seconds))
    }

    public static func seconds(
        _ seconds: TimeInterval,
        delay: TimeInterval
    ) -> GamePlayTiming {
        return .init(duration: .seconds(seconds), delay: .seconds(delay))
    }
}
