//
//  Copyright 2022 Eigo Madaloja
//

import UIKit
import PureLayout

public enum WordLengthOption: Equatable {
    case fixed(length: Int)
    case various
    case none
}

public final class WordLengthControl: OptionControl {
    public var options: [WordLengthOption] = [] {
        didSet {
            optionsControl.titles = options.map({ option in
                switch option {
                case .fixed(length: let length):
                    return String(length)
                case .various:
                    return allTitle
                case .none:
                    return ""
                }
            })
        }
    }

    public var selectedOption: WordLengthOption {
        get {
            if let index = optionsControl.selectedOptionIndex {
                return options[index]
            } else {
                return .none
            }
        }
        set {
            let selectedIndex = options
                .enumerated()
                .first { $0.element == newValue }?
                .offset
            optionsControl.selectedOptionIndex = selectedIndex
        }
    }

    public var onOptionSelected: ((WordLengthOption?) -> Void)?

    private let allTitle: String

    public init(
        title: String?,
        allTitle: String
    ) {
        self.allTitle = allTitle
        super.init()
        setup(title: title)
        layout()
    }

    private override init() {
        allTitle = ""
    }

    private func setup(title: String?) {
        self.title = title

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
