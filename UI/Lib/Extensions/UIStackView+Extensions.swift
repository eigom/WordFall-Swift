//
//  Copyright 2022 Eigo Madaloja
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach(addArrangedSubview)
    }

    func removeArrangedSubviews() {
        arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    func replaceArrangedSubviews(_ views: [UIView]) {
        removeArrangedSubviews()
        addArrangedSubviews(views)
    }
}
