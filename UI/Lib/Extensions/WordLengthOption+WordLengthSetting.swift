//
//  Copyright 2022 Eigo Madaloja
//

extension WordLengthOption {
    init(_ setting: WordLengthSetting) {
        switch setting {
        case .fixed(length: let length):
            self = .fixed(length: length)
        case .various:
            self = .various
        case .none:
            self = .none
        }
    }
}
