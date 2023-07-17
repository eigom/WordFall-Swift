//
//  Copyright 2022 Eigo Madaloja
//

import UIKit

protocol ImageProvider {
    func solutionNodeImage(
        size: CGSize,
        color: UIColor
    ) -> UIImage
    func fallingNodeImage(
        size: CGSize,
        color: UIColor
    ) -> UIImage
}
