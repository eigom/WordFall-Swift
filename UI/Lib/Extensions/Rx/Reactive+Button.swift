//
//  Copyright 2022 Eigo Madaloja
//

import RxSwift

extension Reactive where Base: Button {
    public var isLoadingActivityActive: Binder<Bool> {
        return Binder(base) { view, isActive in
            view.isLoadingActivityActive = isActive
        }
    }

    public var isVisible: Binder<(isVisible: Bool, animated: Bool)> {
        return Binder(base) { view, parameters in
            view.setIsVisible(parameters.isVisible, animated: parameters.animated)
        }
    }
}
