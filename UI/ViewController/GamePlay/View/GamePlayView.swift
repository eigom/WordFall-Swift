//
//  Copyright 2022 Eigo Madaloja
//

import UIKit
import SpriteKit

final class GamePlayView: View {
    let fallingLettersView = SceneView()
    let solutionLettersView = SceneView()
    let definitionView = DefinitionTextView()
    let solveButton = Button()
    let nextButton = Button()
    let settingsButton = Button()

    private let backgroundImageView = UIImageView()
    private let topArea = UIView()
    private let bottomArea = UIView()
    private let bottomStackView = UIStackView()
    private let bottomGradientView = GradientView()
    private let separatorView = SeparatorView()

    override init() {
        super.init()
        setup()
        layout()
    }

    private func setup() {
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.image = Assets.GamePlay.background.image
        backgroundImageView.alpha = 0.9

        bottomGradientView.gradient = .init(colors: [
            .black.withAlphaComponent(0.0),
            .black.withAlphaComponent(0.1)
        ])

        bottomStackView.axis = .horizontal
        bottomStackView.spacing = 10

        settingsButton.borderStyle = .circular
        settingsButton.title = Strings.GamePlay.SettingsButton.title

        solveButton.title = Strings.GamePlay.SolveButton.title
        solveButton.backgroundColor = Assets.Colors.Button.Solve.background.color

        nextButton.title = Strings.GamePlay.NextButton.title
        nextButton.backgroundColor = Assets.Colors.Button.Next.background.color
    }

    private func layout() {
        addSubview(backgroundImageView)
        backgroundImageView.autoPinEdgesToSuperviewEdges()

        addSubview(topArea)
        topArea.autoPinEdgesToSuperviewSafeArea(with: .zero, excludingEdge: .bottom)
        topArea.autoMatch(.height, to: .height, of: self, withMultiplier: 0.5)

        topArea.addSubview(fallingLettersView)
        fallingLettersView.autoPinEdgesToSuperviewEdges()

        addSubview(bottomArea)
        bottomArea.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
        bottomArea.autoPinEdge(.top, to: .bottom, of: topArea)

        bottomArea.addSubview(bottomGradientView)
        bottomGradientView.autoPinEdgesToSuperviewEdges()

        bottomArea.addSubview(bottomStackView)
        bottomStackView.autoPinEdgesToSuperviewSafeArea(
            with: UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20),
            excludingEdge: .top
        )

        solutionLettersView.autoSetDimension(.height, toSize: 50)

        bottomStackView.addArrangedSubviews([
            solveButton.wrapped(to: .verticalCenter),
            solutionLettersView,
            nextButton.wrapped(to: .verticalCenter)
        ])

        bottomArea.addSubview(definitionView)
        definitionView.autoPinEdge(toSuperviewEdge: .top, withInset: 5)
        definitionView.autoPinEdge(.bottom, to: .top, of: bottomStackView, withOffset: -10)
        definitionView.autoAlignAxis(toSuperviewAxis: .vertical)
        definitionView.autoMatch(.width, to: .width, of: bottomArea, withMultiplier: 0.6)

        addSubview(settingsButton)
        settingsButton.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
        settingsButton.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
        settingsButton.autoMatch(.width, to: .height, of: settingsButton)

        addSubview(separatorView)
        separatorView.autoPinEdge(toSuperviewEdge: .left)
        separatorView.autoPinEdge(toSuperviewEdge: .right)
        separatorView.autoPinEdge(.bottom, to: .bottom, of: topArea, withOffset: 7.0)
    }
}
