//
//  Copyright 2022 Eigo Madaloja
//

public enum GamePlayColor: CaseIterable {
    case red
    case green
    case blue

    static var randomColor: GamePlayColor {
        GamePlayColor.allCases.randomElement() ?? .red
    }
}
