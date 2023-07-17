//
//  Copyright 2022 Eigo Madaloja
//

import UIKit
import RxSwift
import RxCocoa

final class GamePlayViewController: ViewController {
    override var prefersStatusBarHidden: Bool {
        return true
    }

    private let viewModel: GamePlayViewModel
    private let imageProvider: ImageProvider
    private let scenesPresentedSubject = PublishSubject<Void>()
    private let letterTapSubject = PublishSubject<Int>()
    private let letterFinishedFallingSubject = PublishSubject<Int>()
    private let disposeBag = DisposeBag()

    init(
        viewModel: GamePlayViewModel,
        imageProvider: ImageProvider
    ) {
        self.viewModel = viewModel
        self.imageProvider = imageProvider
        super.init()
    }

    override public func loadView() {
        let view = GamePlayView()
        self.view = view
        bind(to: view)
    }

    private func bind(to view: GamePlayView) {
        let event = GamePlayViewModel.Event(
            viewDidAppear: rx.viewDidAppear.asObservable().mapVoid(),
            scenesPresented: scenesPresentedSubject.asObservable(),
            settingsTapped: view.settingsButton.rx.tap.asObservable(),
            nextTapped: view.nextButton.rx.tap.asObservable(),
            solveTapped: view.solveButton.rx.tap.asObservable(),
            letterTapped: letterTapSubject.asObservable(),
            letterFinishedFalling: letterFinishedFallingSubject.asObservable()
        )

        let action = viewModel.map(event)

        action.presentGameScenes
            .subscribe(onNext: { (letterCount, gamePlayAction) in
                self.presentGameScenes(
                    in: view,
                    isSoundEnabled: action.isSoundEnabled,
                    letterCount: letterCount,
                    gamePlayAction: gamePlayAction
                )
            })
            .disposed(by: disposeBag)

        action.solveButtonState
            .subscribe(onNext: { state in
                view.solveButton.title = state.buttonTitle
                view.solveButton.subtitle = state.buttonSubtitle
                view.solveButton.setIsVisible(state.isButtonVisible, animated: true)
            })
            .disposed(by: disposeBag)

        action.isPurchasingAutoSolvingActivityActive
            .bind(to: view.solveButton.rx.isLoadingActivityActive)
            .disposed(by: disposeBag)
    }

    private func presentGameScenes(
        in view: GamePlayView,
        isSoundEnabled: BehaviorRelay<Bool>,
        letterCount: Int,
        gamePlayAction: Observable<GamePlay.Action>
    ) {
        let fallingLettersScene = FallingLettersScene(
            isSoundEnabled: isSoundEnabled,
            letterCount: letterCount,
            imageProvider: imageProvider
        )
        let solutionLettersScene = SolutionLettersScene(
            isSoundEnabled: isSoundEnabled,
            letterCount: letterCount,
            imageProvider: imageProvider
        )

        fallingLettersScene.letterTap
            .bind(to: letterTapSubject)
            .disposed(by: disposeBag)
        fallingLettersScene.letterFinishedFalling
            .bind(to: letterFinishedFallingSubject)
            .disposed(by: disposeBag)

        gamePlayAction
            .subscribe(onNext: { action in
                self.handleGamePlayAction(
                    action,
                    gamePlayView: view,
                    fallingLettersScene: fallingLettersScene,
                    solutionLettersScene: solutionLettersScene
                )
            })
            .disposed(by: disposeBag)

        Observable.combineLatest(
            fallingLettersScene.scenePresented,
            solutionLettersScene.scenePresented
        )
        .mapVoid()
        .bind(to: scenesPresentedSubject)
        .disposed(by: disposeBag)

        // NB! Changing scene presentation order can result in non-transparent scene
        // (at least in some simulator)
        view.fallingLettersView.presentScene(fallingLettersScene)
        view.solutionLettersView.presentScene(solutionLettersScene)
    }

    // swiftlint:disable function_body_length
    private func handleGamePlayAction(
        _ action: GamePlay.Action,
        gamePlayView: GamePlayView,
        fallingLettersScene: FallingLettersScene,
        solutionLettersScene: SolutionLettersScene
    ) {
        switch action {
        case .setSolution(
            let letters,
            let timing
        ):
            solutionLettersScene.setActiveLetters(
                letters,
                timing: .init(timing)
            )
        case .revealSolutionLetter(
            let letter,
            let index,
            let timing,
            let soundEffect
        ):
            solutionLettersScene.revealLetter(
                letter,
                at: index,
                timing: .init(timing),
                soundEffect: .init(soundEffect)
            )
        case .showDefinitions(
            let definitions,
            let timing
        ):
            let definitionsText = NSAttributedString(definitions)
            gamePlayView.definitionView.setAttributedText(
                definitionsText,
                delay: timing.delaySeconds,
                duration: timing.durationSeconds
            )
        case .startFall(
            let falls,
            let gamePlayColor,
            let soundEffect
        ):
            fallingLettersScene.letterNodeColor = gamePlayColor.color
            fallingLettersScene.startFall(
                with: falls.map { LetterFall($0) },
                soundEffect: .init(soundEffect)
            )
        case .retractAll(let letterRetraction):
            fallingLettersScene.retractAll(
                with: LetterRetraction(letterRetraction)
            )
        case .removeFallingLetter(
            let index,
            let timing
        ):
            fallingLettersScene.removeLetter(
                at: index,
                timing: .init(timing)
            )
        }
    }
}
