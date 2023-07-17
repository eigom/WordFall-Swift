//
//  Copyright 2022 Eigo Madaloja
//

import UIKit

public class GradientView: UIView {
    public var gradient = Gradient(colors: []) {
        didSet {
            gradientLayer?.colors = gradient.colors.map { $0.cgColor }
            gradientLayer?.locations = gradient.locations
            gradientLayer?.startPoint = gradient.startPoint
            gradientLayer?.endPoint = gradient.endPoint
        }
    }

    override public class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    private var gradientLayer: CAGradientLayer? {
        return layer as? CAGradientLayer
    }
}
