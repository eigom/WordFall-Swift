//
//  Copyright 2022 Eigo Madaloja
//

import GRDB
import RxSwift
import Foundation

private struct Word: WordProviderWord {
    let word: String
    let definitions: [WordProviderWordDefinition]
}

private struct WordDefinition: WordProviderWordDefinition {
    let type: String
    let definition: String
}

class SQLite {
    enum Error: Swift.Error {
        case databaseMissing
        case fetchWord
        case fetchWordIDs
        case fetchLastWordID
    }

    private let dbQueue: DatabaseQueue
    private let wordLengthLimit: Int

    init(wordLengthLimit: Int) throws {
        self.wordLengthLimit = wordLengthLimit

        if let path = Bundle.main.path(forResource: "words", ofType: "sqlite") {
            dbQueue = try DatabaseQueue(path: path)
        } else {
            throw Error.databaseMissing
        }
    }

    func fetchWord(wordID: Int64) throws -> String {
        let row = try dbQueue.read { database in
            try Row.fetchOne(
                database,
                sql: "SELECT word FROM Word WHERE id = :wordID",
                arguments: ["wordID": wordID]
            )
        }

        guard let word = row?["word"] as? String else {
            throw Error.fetchWord
        }

        return word
    }

    func fetchDefinitions(wordID: Int64) throws -> [WordProviderWordDefinition] {
        let rows = try dbQueue.read { database in
            try Row.fetchAll(
                database,
                sql: """
                    SELECT * from definition
                    INNER JOIN word_definition ON definition.id = word_definition.definition_id
                    WHERE word_definition.word_id = :wordID
                    """,
                arguments: ["wordID": wordID]
            )
        }

        return rows.compactMap { row in
            guard
                let type = row["type"] as? String,
                let definition = row["definition"] as? String
            else { return nil }

            return WordDefinition(
                type: type,
                definition: definition
            )
        }
    }

    func wordLengths(lengthLimit: Int) throws -> [Int64] {
        let rows = try self.dbQueue.read { database in
            try Row.fetchAll(
                database,
                sql: """
                    SELECT length FROM word_length_ids
                    WHERE length <= :lengthLimit ORDER BY length
                    """,
                arguments: ["lengthLimit": lengthLimit]
            )
        }

        return rows.compactMap { $0["length"] as? Int64 }
    }

    func fetchWordIDs(wordLength: Int) throws -> (firstWordID: Int64, lastWordID: Int64) {
        let row = try dbQueue.read { database in
            try Row.fetchOne(
                database,
                sql: "SELECT * FROM word_length_ids WHERE length = :length",
                arguments: ["length": wordLength]
            )
        }

        guard
            let firstWordID = row?["first_word_id"] as? Int64,
            let lastWordID = row?["last_word_id"] as? Int64
        else {
            throw Error.fetchWordIDs
        }

        return (firstWordID: firstWordID, lastWordID: lastWordID)
    }

    func fetchWordIDs(lengthLimit: Int) throws -> (firstWordID: Int64, lastWordID: Int64) {
        let firstWordIDRow = try dbQueue.read { database in
            try Row.fetchOne(
                database,
                sql: """
                    SELECT first_word_id FROM word_length_ids
                    WHERE length = (SELECT MIN(length) FROM word_length_ids)
                    """)
        }

        let lastWordIDRow = try dbQueue.read { database in
            try Row.fetchOne(
                database,
                sql: """
                    SELECT last_word_id FROM word_length_ids
                    WHERE length = (SELECT MAX(length) FROM word_length_ids WHERE length <= :lengthLimit)
                    """,
                arguments: ["lengthLimit": lengthLimit]
            )
        }

        guard
            let firstWordID = firstWordIDRow?["first_word_id"] as? Int64,
            let lastWordID = lastWordIDRow?["last_word_id"] as? Int64
        else {
            throw Error.fetchLastWordID
        }

        return (firstWordID: firstWordID, lastWordID: lastWordID)
    }

    func fetchWordIDs(
        wordLength: WordProviderWordLength
    ) throws -> (firstWordID: Int64, lastWordID: Int64) {
        switch wordLength {
        case .fixed(length: let length):
            return try fetchWordIDs(wordLength: length)
        case .various:
            return try fetchWordIDs(lengthLimit: wordLengthLimit)
        }
    }
}

extension SQLite: WordProvider {
    func randomWord(length: WordProviderWordLength) -> Single<WordProviderWord> {
        return Single<WordProviderWord>.create { single in
            do {
                let (firstWordID, lastWordID) = try self.fetchWordIDs(wordLength: length)
                let randomWordID = Int64.random(in: firstWordID...lastWordID)
                let word = try self.fetchWord(wordID: randomWordID)
                let definitions = try self.fetchDefinitions(wordID: randomWordID)
                let randomWord = Word(
                    word: word,
                    definitions: definitions
                )
                single(.success(randomWord))
            } catch {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }
}

extension SQLite: WordLengthProvider {
    var availableWordLengths: Single<[Int]> {
        return Single<[Int]>.create { single in
            do {
                let lengths = try self.wordLengths(lengthLimit: self.wordLengthLimit)
                    .compactMap(Int.init(exactly:))
                single(.success(lengths))
            } catch {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }
}
