//
//  Copyright 2022 Eigo Madaloja
//

import UIKit

extension UIColor {
    func darken(by amount: Float) -> UIColor {
        let coefficient = 1.0 - CGFloat( max(0.0, min(amount, 1.0)) )

        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return .init(
            red: red * coefficient,
            green: green * coefficient,
            blue: blue * coefficient,
            alpha: alpha
        )
    }
}
