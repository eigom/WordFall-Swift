//
//  Copyright 2022 Eigo Madaloja
//

import RxSwift
import RxCocoa

extension Reactive where Base: Switch {
    public var isOn: ControlProperty<Bool> {
        return base.rx.controlProperty(
            editingEvents: .valueChanged,
            getter: { $0.isOn },
            setter: { $0.isOn = $1 }
        )
    }
}
