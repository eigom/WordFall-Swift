//
//  Copyright 2022 Eigo Madaloja
//

extension WordProviderWordLength {
    init?(_ setting: WordLengthSetting) {
        switch setting {
        case .fixed(let length):
            self = .fixed(length: length)
        case .various:
            self = .various
        case .none:
            return nil
        }
    }
}
