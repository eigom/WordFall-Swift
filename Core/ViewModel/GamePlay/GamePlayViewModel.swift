//
//  Copyright 2022 Eigo Madaloja
//

import RxSwift
import RxCocoa
import StoreKit

public final class GamePlayViewModel: ViewModel {
    public struct Event {
        public let viewDidAppear: Observable<Void>
        public let scenesPresented: Observable<Void>
        public let settingsTapped: Observable<Void>
        public let nextTapped: Observable<Void>
        public let solveTapped: Observable<Void>
        public let letterTapped: Observable<Int>
        public let letterFinishedFalling: Observable<Int>
    }

    public struct Action {
        public let presentGameScenes: Observable<(Int, Observable<GamePlay.Action>)>
        public let isSoundEnabled: BehaviorRelay<Bool>
        public let solveButtonState: Observable<SolveButtonState>
        public let isPurchasingAutoSolvingActivityActive: Observable<Bool>
    }

    public struct Delegate {
        public var settings: Observable<Void> { settingsSubject }
        public var alert: Observable<Alert> { alertSubject }
        fileprivate let settingsSubject = PublishSubject<Void>()
        fileprivate let alertSubject = PublishSubject<Alert>()
    }

    public var delegate = Delegate()

    private let gamePlay: GamePlay
    private let settings: Settings
    private let idleTimer: IdleTimer
    private let purchaseService: PurchaseService
    private let wordLengthLimit: Int
    private let disposeBag = DisposeBag()

    public init(
        gamePlay: GamePlay,
        settings: Settings,
        idleTimer: IdleTimer,
        purchaseService: PurchaseService,
        wordLengthLimit: Int
    ) {
        self.gamePlay = gamePlay
        self.settings = settings
        self.idleTimer = idleTimer
        self.purchaseService = purchaseService
        self.wordLengthLimit = wordLengthLimit

        settings.isAutoSolvingPurchased
            .subscribe { isPurchased in
                if !isPurchased {
                    purchaseService.loadProducts()
                }
            }
            .disposed(by: disposeBag)

        gamePlay.isGamePlayActive
            .subscribe { isActive in
                if isActive {
                    idleTimer.disable(for: self)
                } else {
                    idleTimer.enable(for: self)
                }
            }
            .disposed(by: disposeBag)
    }

    public func map(_ event: Event) -> Action {
        bindPurchasing(event: event)

        event.settingsTapped
            .bind(to: delegate.settingsSubject)
            .disposed(by: disposeBag)

        let gamePlayAction = bindGamePlay(gamePlay, event: event)

        let presentGameScenes = event.viewDidAppear
            .take(1)
            .map { (self.wordLengthLimit, gamePlayAction) }

        let solveButtonState = event.viewDidAppear
            .take(1)
            .flatMapLatest {
                Observable.combineLatest(
                    self.settings.freeAutoSolvingUsesLeft,
                    self.settings.isAutoSolvingPurchased,
                    self.purchaseService.autoSolvingProduct
                ).map { (freeAutoSolvingUsesLeft, autoSolvingPurchased, autoSolvingProduct) -> SolveButtonState in
                    return SolveButtonState(
                        freeSolvingUsesLeft: freeAutoSolvingUsesLeft,
                        solvingPurchased: autoSolvingPurchased,
                        solvingProduct: autoSolvingProduct
                    )
                }
            }
            .startWith(.hidden)

        return Action(
            presentGameScenes: presentGameScenes,
            isSoundEnabled: settings.isSoundEnabled,
            solveButtonState: solveButtonState,
            isPurchasingAutoSolvingActivityActive: purchaseService.isPurchasingAutoSolving
        )
    }

    private func bindGamePlay(
        _ gamePlay: GamePlay,
        event: Event
    ) -> Observable<GamePlay.Action> {
        let presentIntroduction = event.scenesPresented
        let solvePuzzle = event.solveTapped
            .withLatestFrom(
                Observable.combineLatest(
                    settings.isAutoSolvingPurchased,
                    settings.freeAutoSolvingUsesLeft,
                    gamePlay.isGamePlayActive
                )
            )
            .map { solvingPurchased, freeUsesLeft, gamePlayActive -> Bool in
                if solvingPurchased {
                    return true
                } else if freeUsesLeft > 0, gamePlayActive {
                    self.settings.freeAutoSolvingUsesLeft.accept(freeUsesLeft - 1)
                    return true
                }

                return false
            }
            .filter { $0 }
            .mapVoid()

        let gamePlayEvent = GamePlay.Event(
            presentIntroduction: presentIntroduction,
            nextPuzzle: event.nextTapped,
            solvePuzzle: solvePuzzle,
            tryNextLetter: event.letterTapped,
            revealLetter: event.letterFinishedFalling
        )

        let gamePlayAction = gamePlay.map(gamePlayEvent)

        return gamePlayAction
    }

    private func bindPurchasing(event: Event) {
        let purchaseConfirmationAlert = event.solveTapped
            .withLatestFrom(settings.freeAutoSolvingUsesLeft)
            .filter { $0 == 0 }
            .withLatestFrom(settings.isAutoSolvingPurchased)
            .filter { !$0 }
            .withLatestFrom(purchaseService.autoSolvingProduct)
            .compactMap { $0 }
            .map { [weak self] product in
                Alert.confirmation(
                    title: Strings.GamePlay.PurchaseAlert.title(product.displayName),
                    message: product.description,
                    actionTitle: Strings.GamePlay.PurchaseAlert.PurchaseAction.title(product.displayPrice),
                    onConfirmed: {
                        self?.purchaseService.purchaseAutoSolving()
                    }
                )
            }

        let purchaseFailureAlert = Observable.merge(
            purchaseService.purchaseAutoSolvingFailure,
            purchaseService.restorePurchasesFailure
        )
        .map(Alert.info)

        Observable.merge(purchaseConfirmationAlert, purchaseFailureAlert)
            .bind(to: delegate.alertSubject)
            .disposed(by: disposeBag)
    }
}
