//
//  Copyright 2022 Eigo Madaloja
//

import UIKit
import RxSwift
import RxCocoa

struct SettingsFlowDelegate: FlowDelegate {}

final class SettingsFlow: FlowCoordinator<SettingsFlowDelegate>, AlertPresenter {
    private let settings: Settings
    private let wordLengthProvider: WordLengthProvider
    private let purchaseService: PurchaseService
    private let flowPresenter = FlowPresenter()

    init(
        settings: Settings,
        wordLengthProvider: WordLengthProvider,
        purchaseService: PurchaseService
    ) {
        self.settings = settings
        self.wordLengthProvider = wordLengthProvider
        self.purchaseService = purchaseService
    }

    override func start() -> UIViewController {
        let viewModel = SettingsViewModel(
            settings: settings,
            wordLengthProvider: wordLengthProvider,
            purchaseService: purchaseService
        )

        viewModel.delegate.alert
            .asDriver()
            .drive(onNext: { [unowned self] confirmation in
                self.presentAlert(confirmation, with: flowPresenter)
            })
            .disposed(by: disposeBag)

        viewModel.delegate.finished
            .bind(to: finishedSubject)
            .disposed(by: disposeBag)

        let viewController = SettingsViewController(viewModel: viewModel)
        flowPresenter.defaultModalFlowPresenter = viewController

        return viewController
    }
}
