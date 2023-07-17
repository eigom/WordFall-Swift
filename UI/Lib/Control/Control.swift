//
//  Copyright 2022 Eigo Madaloja
//

import UIKit

public class Control: UIControl {

    init() {
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
