//
//  Copyright 2022 Eigo Madaloja
//

import UIKit
import RxSwift

final class SettingsViewController: ViewController {
    override var prefersStatusBarHidden: Bool {
        return true
    }

    private let viewModel: SettingsViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override public func loadView() {
        let view = SettingsView()
        self.view = view
        bind(to: view)
    }

    private func bind(to view: SettingsView) {
        let event = SettingsViewModel.Event(
            viewDidAppear: rx.viewDidAppear.asObservable().mapVoid(),
            isSoundOnSelected: view.soundSwitch.rx.isOn
                .skip(1)
                .asObservable(),
            wordLengthSelected: view.wordLengthControl.rx.selectedOption
                .skip(1)
                .map(WordLengthSetting.init)
                .asObservable(),
            restorePurchasesTapped: view.restorePurchasesButton.rx.tap.asObservable(),
            viewTapped: view.tapGestureRecognizer.rx.event
                .asObservable()
                .mapVoid()
        )

        let action = viewModel.map(event)

        action.isSoundOn
            .bind(to: view.soundSwitch.rx.isOn)
            .disposed(by: disposeBag)

        action.availableWordLengths
            .map({ $0.compactMap(WordLengthOption.init) })
            .bind(to: view.wordLengthControl.rx.options)
            .disposed(by: disposeBag)

        action.wordLength
            .map(WordLengthOption.init)
            .bind(to: view.wordLengthControl.rx.selectedOption)
            .disposed(by: disposeBag)

        action.isRestorePurchasesActivityActive
            .bind(to: view.restorePurchasesButton.rx.isLoadingActivityActive)
            .disposed(by: disposeBag)
    }
}
