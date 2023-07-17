//
//  Copyright 2022 Eigo Madaloja
//

import UIKit

extension UIAlertAction {
    convenience init(_ action: AlertAction) {
        self.init(
            title: action.title,
            style: .init(action.style),
            handler: { _ in action.onSelected() }
        )
    }
}

extension UIAlertAction.Style {
    init(_ style: AlertAction.Style) {
        switch style {
        case .default:
            self = .default
        case .cancel:
            self = .cancel
        case .destructive:
            self = .destructive
        }
    }
}
