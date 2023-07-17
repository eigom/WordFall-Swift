//
//  Copyright 2022 Eigo Madaloja
//

import UIKit

struct GamePlayFlowDelegate: FlowDelegate {}

final class GamePlayFlow: FlowCoordinator<GamePlayFlowDelegate>, AlertPresenter {
    private let gamePlay: GamePlay
    private let settings: Settings
    private let idleTimer: IdleTimer
    private let purchaseService: PurchaseService
    private let wordLengthLimit: Int
    private let wordLengthProvider: WordLengthProvider
    private let flowPresenter = FlowPresenter()

    init(
        gamePlay: GamePlay,
        settings: Settings,
        idleTimer: IdleTimer,
        purchaseService: PurchaseService,
        wordLengthLimit: Int,
        wordLengthProvider: WordLengthProvider
    ) {
        self.gamePlay = gamePlay
        self.settings = settings
        self.idleTimer = idleTimer
        self.purchaseService = purchaseService
        self.wordLengthLimit = wordLengthLimit
        self.wordLengthProvider = wordLengthProvider
    }

    override func start() -> UIViewController {
        let gamePlayViewController = makeGamePlayViewController()
        flowPresenter.defaultModalFlowPresenter = gamePlayViewController

        return gamePlayViewController
    }

    private func makeGamePlayViewController() -> GamePlayViewController {
        let viewModel = GamePlayViewModel(
            gamePlay: gamePlay,
            settings: settings,
            idleTimer: idleTimer,
            purchaseService: purchaseService,
            wordLengthLimit: wordLengthLimit
        )

        viewModel.delegate.settings
            .asDriver()
            .drive(onNext: { [unowned self] in self.presentSettingsFlow() })
            .disposed(by: disposeBag)

        viewModel.delegate.alert
            .asDriver()
            .drive(onNext: { [unowned self] confirmation in
                self.presentAlert(confirmation, with: flowPresenter)
            })
            .disposed(by: disposeBag)

        let imageProvider = ImageProviderImpl()

        let viewController = GamePlayViewController(
            viewModel: viewModel,
            imageProvider: imageProvider
        )

        return viewController
    }

    private func presentSettingsFlow() {
        let settingsFlow = SettingsFlow(
            settings: settings,
            wordLengthProvider: wordLengthProvider,
            purchaseService: purchaseService
        )
        flowPresenter.present(
            settingsFlow,
            presentingStyle: .modal(
                animated: true,
                presentationStyle: .overCurrentContext,
                transitionStyle: .crossDissolve
            )
        )
    }
}
