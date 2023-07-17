//
//  Copyright 2022 Eigo Madaloja
//

import Foundation
import RxSwift
import RxCocoa

public protocol Settings {
    var isSoundEnabled: BehaviorRelay<Bool> { get }
    var isAutoSolvingPurchased: BehaviorRelay<Bool> { get }
    var freeAutoSolvingUsesLeft: BehaviorRelay<Int> { get }
    var wordLength: BehaviorRelay<WordLengthSetting> { get }
}
