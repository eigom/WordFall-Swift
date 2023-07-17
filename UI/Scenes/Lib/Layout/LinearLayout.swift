//
//  Copyright 2022 Eigo Madaloja
//

import Foundation

struct LinearLayout {
    enum Axis {
        case vertical
        case horizontal
    }

    let areaSize: CGSize
    let minimumItemSpacing: CGFloat
    let layoutAxis: Axis

    func itemSize(
        itemCount: Int
    ) -> CGSize {
        let totalMinimumSpacing = minimumItemSpacing * CGFloat(itemCount - 1)
        let (size, otherSize) = layoutAxis == .horizontal
            ? (areaSize.width, areaSize.height)
            : (areaSize.height, areaSize.width)
        let maximumItemSize = (size - totalMinimumSpacing) / CGFloat(itemCount)
        let itemSize = min(otherSize, maximumItemSize)

        return CGSize(
            width: itemSize,
            height: itemSize
        )
    }

    func itemSpacing(itemCount: Int) -> CGFloat {
        let size = layoutAxis == .horizontal
            ? areaSize.width
            : areaSize.height

        return size / CGFloat(itemCount + 1)
    }
}
