//
//  Copyright 2022 Eigo Madaloja
//

extension WordPuzzle.Word {
    init(_ word: WordProviderWord) {
        self.init(
            word: word.word,
            definitions: word.definitions
                .map(WordPuzzle.WordDefinition.init)
        )
    }
}
