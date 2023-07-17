//
//  Copyright 2022 Eigo Madaloja
//

import UIKit

public enum OptionControlTitlePosition {
    case left
    case right
}

public class OptionControl: Control {
    public let optionsControl = OptionControlOptions()

    public var title: String? {
        get {
            titleLabel.text?.replacingOccurrences(of: "\n", with: "")
        }
        set {
            titleLabel.numberOfLines = newValue?.count ?? 0
            titleLabel.text = newValue?
                .map({ String($0) })
                .joined(separator: "\n")
        }
    }

    public var titleFont: UIFont = FontStyle.optionsTitle.font {
        didSet { titleLabel.font = titleFont }
    }

    public var titleColor: UIColor = Assets.Colors.Option.title.color {
        didSet { titleLabel.textColor = titleColor }
    }

    public var titlePosition: OptionControlTitlePosition = .left {
        didSet { updateTitleLabelPosition() }
    }

    private let stackView = UIStackView()
    private let titleLabel = UILabel()

    public override init() {
        super.init()
        setup()
        layout()
    }

    private func setup() {
        backgroundColor = .clear

        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 5

        titleLabel.backgroundColor = .clear
        titleLabel.textColor = titleColor
        titleLabel.shadowColor = .black
        titleLabel.shadowOffset = CGSize(width: 0.0, height: 1.0)
        titleLabel.textAlignment = .center
        titleLabel.font = titleFont
        titleLabel.alpha = 0.7

        optionsControl.axis = .vertical
    }

    private func layout() {
        addSubview(stackView)
        stackView.autoPinEdgesToSuperviewEdges()

        updateTitleLabelPosition()
    }

    private func updateTitleLabelPosition() {
        stackView.removeArrangedSubviews()

        switch titlePosition {
        case .left:
            stackView.addArrangedSubviews([
                titleLabel,
                optionsControl
            ])
        case .right:
            stackView.addArrangedSubviews([
                optionsControl,
                titleLabel
            ])
        }
    }
}
