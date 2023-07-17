//
//  Copyright 2022 Eigo Madaloja
//

import RxSwift
import RxCocoa

public final class SettingsViewModel: ViewModel {
    public struct Event {
        public let viewDidAppear: Observable<Void>
        public let isSoundOnSelected: Observable<Bool>
        public let wordLengthSelected: Observable<WordLengthSetting>
        public let restorePurchasesTapped: Observable<Void>
        public let viewTapped: Observable<Void>
    }

    public struct Action {
        public let isSoundOn: Observable<Bool>
        public let availableWordLengths: Observable<[WordLengthSetting]>
        public let wordLength: Observable<WordLengthSetting>
        public let isRestorePurchasesActivityActive: Observable<Bool>
    }

    public struct Delegate {
        public var finished: Observable<Void> { finishedSubject }
        public var alert: Observable<Alert> { alertSubject }
        fileprivate let finishedSubject = PublishSubject<Void>()
        fileprivate let alertSubject = PublishSubject<Alert>()
    }

    public var delegate = Delegate()

    private let settings: Settings
    private let wordLengthProvider: WordLengthProvider
    private let purchaseService: PurchaseService
    private let disposeBag = DisposeBag()

    private var availableWordLengths: Observable<[WordLengthSetting]> {
        wordLengthProvider.availableWordLengths
            .map {
                let settings = $0.map { WordLengthSetting.fixed(length: $0) }
                return settings.isEmpty
                    ? settings
                    : settings + [.various]
            }
            .asObservable()
    }

    public init(
        settings: Settings,
        wordLengthProvider: WordLengthProvider,
        purchaseService: PurchaseService
    ) {
        self.settings = settings
        self.wordLengthProvider = wordLengthProvider
        self.purchaseService = purchaseService
    }

    public func map(_ event: Event) -> Action {
        event.viewDidAppear
            .take(1)
            .withLatestFrom(purchaseService.restorePurchasesFailure)
            .map(Alert.info)
            .bind(to: delegate.alertSubject)
            .disposed(by: disposeBag)

        event.isSoundOnSelected
            .bind(to: settings.isSoundEnabled)
            .disposed(by: disposeBag)

        event.wordLengthSelected
            .bind(to: settings.wordLength)
            .disposed(by: disposeBag)

        event.restorePurchasesTapped
            .subscribe { [weak self] _ in
                self?.purchaseService.restorePurchases()
            }
            .disposed(by: disposeBag)

        event.viewTapped
            .bind(to: delegate.finishedSubject)
            .disposed(by: disposeBag)

        return Action(
            isSoundOn: settings.isSoundEnabled.asObservable(),
            availableWordLengths: availableWordLengths,
            wordLength: settings.wordLength.asObservable(),
            isRestorePurchasesActivityActive: purchaseService.isRestoringPurchases
        )
    }
}
