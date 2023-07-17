//
//  Copyright 2022 Eigo Madaloja
//

public enum WordLengthSetting: CustomStringConvertible, Equatable {
    case fixed(length: Int)
    case various
    case none

    public var description: String {
        switch self {
        case .fixed(length: let length):
            return String(length)
        case .various:
            return "various"
        case .none:
            return "none"
        }
    }

    public init?(_ string: String?) {
        if let string = string, let length = Int(string) {
            self = .fixed(length: length)
        } else if string == WordLengthSetting.various.description {
            self = .various
        } else if string == WordLengthSetting.none.description {
            self = .none
        } else {
            return nil
        }
    }
}
