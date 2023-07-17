//
//  Copyright 2022 Eigo Madaloja
//

extension WordLengthSetting {
    init(_ option: WordLengthOption) {
        switch option {
        case .fixed(length: let length):
            self = .fixed(length: length)
        case .various:
            self = .various
        case .none:
            self = .none
        }
    }
}
