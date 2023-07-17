//
//  Copyright 2022 Eigo Madaloja
//

import UIKit

extension SolveButtonState {
    var isButtonVisible: Bool {
        switch self {
        case .hidden:
            return false
        case .solve, .purchase, .trial:
            return true
        }
    }

    var buttonTitle: String? {
        switch self {
        case .hidden:
            return nil
        case .trial, .solve, .purchase:
            return Strings.GamePlay.SolveButton.title
        }
    }

    var buttonSubtitle: String? {
        switch self {
        case .hidden, .solve:
            return nil
        case .trial(freeUsesLeft: let freeUsesLeft):
            return Strings.GamePlay.SolveButton.RevealsLeft.subtitle(freeUsesLeft)
        case .purchase(_, let price):
            return Strings.GamePlay.SolveButton.Purchase.subtitle(price)
        }
    }
}
