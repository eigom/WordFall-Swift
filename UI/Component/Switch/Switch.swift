//
//  Copyright 2022 Eigo Madaloja
//

import UIKit

public final class Switch: OptionControl {
    public var isOn: Bool {
        get { optionsControl.selectedOptionIndex == 0 }
        set { optionsControl.selectedOptionIndex = newValue ? 0 : 1 }
    }

    public init(
        title: String?,
        onTitle: String,
        offTitle: String
    ) {
        super.init()
        setup(
            title: title,
            onTitle: onTitle,
            offTitle: offTitle
        )
        layout()
    }

    private override init() {}

    private func setup(
        title: String?,
        onTitle: String,
        offTitle: String
    ) {
        isOn = false

        self.title = title
        optionsControl.titles = [
            onTitle,
            offTitle
        ]
        titlePosition = .right

        optionsControl.addTarget(
            self,
            action: #selector(optionSelected),
            for: .valueChanged
        )
    }

    private func layout() {}

    @objc
    private func optionSelected() {
        sendActions(for: .valueChanged)
    }
}
