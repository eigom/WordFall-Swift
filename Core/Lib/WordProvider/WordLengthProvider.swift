//
//  Copyright 2022 Eigo Madaloja
//

import RxSwift

public protocol WordLengthProvider {
    var availableWordLengths: Single<[Int]> { get }
}
