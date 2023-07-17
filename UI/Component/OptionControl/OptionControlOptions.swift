//
//  Copyright 2022 Eigo Madaloja
//

import UIKit

public final class OptionControlOptions: Control {
    public var axis: NSLayoutConstraint.Axis {
        get { stackView.axis }
        set { stackView.axis = newValue }
    }

    public var selectedOptionFont: UIFont = FontStyle.selectedOption.font {
        didSet { updateStateAppearances() }
    }

    public var selectedOptionColor: UIColor = Assets.Colors.Option.selected.color {
        didSet { updateStateAppearances() }
    }

    public var unselectedOptionFont: UIFont = FontStyle.unselectedOption.font {
        didSet { updateStateAppearances() }
    }

    public var unselectedOptionColor: UIColor = Assets.Colors.Option.unselected.color {
        didSet { updateStateAppearances() }
    }

    public var selectedOptionIndex: Int? {
        get { selectedIndex }
        set { setSelectedOption(index: newValue) }
    }

    public var titles: [String] = [] {
        didSet { createButtons() }
    }

    private var buttons: [UIButton] {
        stackView.arrangedSubviews.compactMap { $0 as? UIButton }
    }

    private let stackView = UIStackView()
    private var selectedIndex: Int?

    public override init() {
        super.init()
        setup()
        layout()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.width / 2
    }

    private func setup() {
        backgroundColor = .black.withAlphaComponent(0.6)

        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
    }

    private func layout() {
        addSubview(stackView)
        stackView.autoPinEdgesToSuperviewEdges(
            with: UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        )

        stackView.autoCenterInSuperview()
    }

    private func createButtons() {
        let buttons = titles.enumerated().map {
            makeButton(
                title: $0.element,
                index: $0.offset
            )
        }

        stackView.replaceArrangedSubviews(buttons)
    }

    private func updateStateAppearances() {
        buttons.forEach { button in
            if button.tag == selectedIndex {
                button.alpha = 1.0
                button.titleLabel?.font = selectedOptionFont
                button.setTitleColor(selectedOptionColor, for: .normal)
            } else {
                button.alpha = 0.5
                button.titleLabel?.font = unselectedOptionFont
                button.setTitleColor(unselectedOptionColor, for: .normal)
            }
        }
    }

    private func setSelectedOption(index: Int?) {
        selectedIndex = index
        updateStateAppearances()
    }

    private func makeButton(title: String, index: Int) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.tag = index
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }

    @objc
    private func buttonTapped(_ button: UIButton) {
        guard selectedIndex != button.tag else { return }

        setSelectedOption(index: button.tag)
        sendActions(for: .valueChanged)
    }
}
