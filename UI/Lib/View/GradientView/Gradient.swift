//
//  Copyright 2022 Eigo Madaloja
//

import UIKit

public struct Gradient {
    public let colors: [UIColor]
    public let locations: [NSNumber]?
    public let startPoint: CGPoint
    public let endPoint: CGPoint

    public init(
        colors: [UIColor] = [],
        locations: [NSNumber]? = nil,
        startPoint: CGPoint = CGPoint(x: 0.5, y: 1.0),
        endPoint: CGPoint = CGPoint(x: 0.5, y: 0.0)
    ) {
        self.colors = colors
        self.locations = locations
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
}
