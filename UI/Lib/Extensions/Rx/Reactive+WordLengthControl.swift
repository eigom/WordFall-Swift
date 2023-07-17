//
//  Copyright 2022 Eigo Madaloja
//

import RxSwift
import RxCocoa

extension Reactive where Base: WordLengthControl {
    public var selectedOption: ControlProperty<WordLengthOption> {
        return base.rx.controlProperty(
            editingEvents: .valueChanged,
            getter: { $0.selectedOption },
            setter: { $0.selectedOption = $1 }
        )
    }
}
