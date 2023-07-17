//
//  Copyright 2022 Eigo Madaloja
//

import UIKit

extension GamePlayColor {
    var color: UIColor {
        switch self {
        case .red:
            return Assets.Colors.GamePlay.red.color
        case .green:
            return Assets.Colors.GamePlay.green.color
        case .blue:
            return Assets.Colors.GamePlay.blue.color
        }
    }
}
