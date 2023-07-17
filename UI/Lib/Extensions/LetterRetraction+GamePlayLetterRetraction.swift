//
//  Copyright 2022 Eigo Madaloja
//

extension LetterRetraction {
    init(_ retraction: GamePlayLetterRetraction) {
        self.init(timing: .init(retraction.timing))
    }
}
