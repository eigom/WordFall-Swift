//
//  Copyright 2022 Eigo Madaloja
//

extension WordPuzzle.WordDefinition {
    init(_ definition: WordProviderWordDefinition) {
        self.init(
            type: definition.type,
            definition: definition.definition
        )
    }
}
