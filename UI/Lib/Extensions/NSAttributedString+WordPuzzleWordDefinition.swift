//
//  Copyright 2022 Eigo Madaloja
//

import UIKit

extension NSAttributedString {
    convenience init(_ definitions: [WordPuzzle.WordDefinition]) {
        let string = NSMutableAttributedString()

        definitions.forEach { definition in
            string.append(
                NSAttributedString(definition)
            )
            string.append(
                NSAttributedString(string: "\n")
            )
        }

        self.init(attributedString: string)
    }

    convenience init(_ definition: WordPuzzle.WordDefinition) {
        let string = NSMutableAttributedString()

        let typeString = NSAttributedString(
            string: "(\(definition.type)) ",
            attributes: Attributes.WordDefinition.type
        )
        let definitionString = NSAttributedString(
            string: definition.definition,
            attributes: Attributes.WordDefinition.text
        )

        string.append(typeString)
        string.append(definitionString)

        self.init(attributedString: string)
    }
}
