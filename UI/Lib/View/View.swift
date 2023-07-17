//
//  Copyright 2022 Eigo Madaloja
//

import UIKit

public class View: UIView {
    public init() {
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
