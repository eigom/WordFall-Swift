//
//  Copyright 2022 Eigo Madaloja
//

import StoreKit

public enum SolveButtonState {
    case hidden
    case solve
    case trial(freeUsesLeft: Int)
    case purchase(
        productName: String,
        price: String
    )

    init(
        freeSolvingUsesLeft: Int,
        solvingPurchased: Bool,
        solvingProduct: Product?
    ) {
        switch (solvingPurchased, solvingProduct, freeSolvingUsesLeft) {
        case (true, _, _):
            self = .solve
        case (false, .none, _):
            self = .hidden
        case let (false, .some(product), freeUsesLeft):
            if freeUsesLeft > 0 {
                self = .trial(freeUsesLeft: freeUsesLeft)
            } else {
                self = .purchase(
                    productName: product.displayName,
                    price: product.displayPrice
                )
            }
        }
    }
}
