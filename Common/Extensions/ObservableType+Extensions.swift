//
//  Copyright 2022 Eigo Madaloja
//

import RxSwift
import RxCocoa

internal extension ObservableType {
    func asDriver() -> Driver<Element> {
        return asDriver(onErrorRecover: { _ in
            fatalError("UnsafeDriver unhandled error.")
        })
    }
}
