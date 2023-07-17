//
//  Copyright 2022 Eigo Madaloja
//

import RxSwift

extension Observable {
    func mapVoid() -> Observable<Void> {
        return map { _ in }
    }
}
