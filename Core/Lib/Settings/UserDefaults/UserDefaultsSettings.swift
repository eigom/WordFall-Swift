//
//  Copyright 2022 Eigo Madaloja
//

import Foundation
import RxSwift
import RxCocoa

private enum SettingKey: String {
    case wordLength
    case soundOn
    case autoSolvingPurchased
    case freeAutoSolvingUsesLeft
}

public final class UserDefaultsSettings: Settings {
    public let isSoundEnabled: BehaviorRelay<Bool>
    public let isAutoSolvingPurchased: BehaviorRelay<Bool>
    public let freeAutoSolvingUsesLeft: BehaviorRelay<Int>
    public let wordLength: BehaviorRelay<WordLengthSetting>

    private let userDefaults = UserDefaults.standard
    private let disposeBag = DisposeBag()

    public init() {
        let isSoundOnValue = userDefaults.object(
            forKey: SettingKey.soundOn.rawValue
        ) as? Bool ?? true
        isSoundEnabled = BehaviorRelay<Bool>(value: isSoundOnValue)

        let isAutoSolvingPurchasedValue = userDefaults.object(
            forKey: SettingKey.autoSolvingPurchased.rawValue
        ) as? Bool ?? false
        isAutoSolvingPurchased = BehaviorRelay<Bool>(value: isAutoSolvingPurchasedValue)

        let freeAutoSolvingUsesLeftValue = userDefaults.object(
            forKey: SettingKey.freeAutoSolvingUsesLeft.rawValue
        ) as? Int ?? 10
        freeAutoSolvingUsesLeft = BehaviorRelay<Int>(value: freeAutoSolvingUsesLeftValue)

        let wordLengthString = userDefaults.object(
            forKey: SettingKey.wordLength.rawValue
        ) as? String
        let wordLengthValue = WordLengthSetting(wordLengthString) ?? .various
        wordLength = BehaviorRelay<WordLengthSetting>(value: wordLengthValue)

        isSoundEnabled
            .distinctUntilChanged()
            .subscribe { [weak self] isOn in
                self?.storeIsSoundOn(isOn)
            }
            .disposed(by: disposeBag)

        isAutoSolvingPurchased
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isPurchased in
                self?.storeIsAutoSolvingPurchased(isPurchased)
            })
            .disposed(by: disposeBag)

        freeAutoSolvingUsesLeft
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] usesLeft in
                self?.storeFreeAutoSolvingUsesLeft(usesLeft)
            })
            .disposed(by: disposeBag)

        wordLength
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] wordLength in
                self?.storeWordLength(wordLength)
            })
            .disposed(by: disposeBag)
    }

    private func storeIsSoundOn(_ isOn: Bool) {
        userDefaults.set(
            isOn,
            forKey: SettingKey.soundOn.rawValue
        )
    }

    private func storeIsAutoSolvingPurchased(_ isPurchased: Bool) {
        userDefaults.set(
            isPurchased,
            forKey: SettingKey.autoSolvingPurchased.rawValue
        )
    }

    private func storeFreeAutoSolvingUsesLeft(_ usesLeft: Int) {
        userDefaults.set(
            usesLeft,
            forKey: SettingKey.freeAutoSolvingUsesLeft.rawValue
        )
    }

    private func storeWordLength(_ wordLength: WordLengthSetting) {
        userDefaults.set(
            wordLength.description,
            forKey: SettingKey.wordLength.rawValue
        )
    }
}
