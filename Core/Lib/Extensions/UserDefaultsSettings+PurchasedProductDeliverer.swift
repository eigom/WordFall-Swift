//
//  Copyright 2022 Eigo Madaloja
//

extension UserDefaultsSettings: PurchasedProductDeliverer {
    public func deliverAutoSolving() {
        isAutoSolvingPurchased.accept(true)
    }

    public func revokeAutoSolving() {
        isAutoSolvingPurchased.accept(false)
    }
}
