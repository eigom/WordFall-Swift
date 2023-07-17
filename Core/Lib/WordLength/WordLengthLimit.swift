//
//  Copyright 2022 Eigo Madaloja
//

public struct WordLengthLimit {
    let maxWordLength: Int

    public init(playableAreaSize: (width: Float, height: Float)) {
        maxWordLength = Int( min(playableAreaSize.width / 70.0, 16) )
    }
}
