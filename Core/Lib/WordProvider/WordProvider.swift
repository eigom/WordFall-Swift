//
//  Copyright 2022 Eigo Madaloja
//

import RxSwift

public protocol WordProviderWord {
    var word: String { get }
    var definitions: [WordProviderWordDefinition] {get}
}

public protocol WordProviderWordDefinition {
    var type: String { get }
    var definition: String { get }
}

public enum WordProviderWordLength {
    case fixed(length: Int)
    case various
}

public protocol WordProvider {
    func randomWord(length: WordProviderWordLength) -> Single<WordProviderWord>
}
