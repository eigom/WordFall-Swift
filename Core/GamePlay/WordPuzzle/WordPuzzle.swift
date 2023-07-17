//
//  Copyright 2022 Eigo Madaloja
//

import RxSwift

public class WordPuzzle {
    public struct Word {
        let word: String
        let definitions: [WordDefinition]

        init(
            word: String,
            definitions: [WordDefinition]
        ) {
            self.word = word.uppercased()
            self.definitions = definitions
        }
    }

    public struct WordDefinition {
        let type: String
        let definition: String
    }

    struct RevealedLetter {
        let letter: Character
        let puzzleIndex: Int
        let solutionIndex: Int
    }

    enum Event {
        case revealedLetter(
            RevealedLetter,
            isPuzzleSolved: Bool
        )
        case solvedAutomatically(
            revealed: [RevealedLetter]
        )
    }

    let word: Word
    let puzzleWord: String

    var letterCount: Int {
        word.word.count
    }

    var event: Observable<Event> {
        eventSubject.asObservable()
    }

    private let wordLetters: [Character]
    private var puzzleLetters: [Character]
    private var solutionLetters: [Character]
    private let emptyLetter = Character(" ")
    private let eventSubject = PublishSubject<Event>()

    private var isSolved: Bool {
        nextEmptySolutionLetterIndex == nil
    }

    private var nextEmptySolutionLetterIndex: Int? {
        solutionLetters
            .enumerated()
            .first(where: { $0.element == emptyLetter })?
            .offset
    }

    init(_ word: Word) {
        self.word = word
        wordLetters = Array(word.word)
        puzzleLetters = wordLetters.shuffled()
        puzzleWord = String(puzzleLetters)
        solutionLetters = Array(
            repeating: emptyLetter,
            count: word.word.count
        )
    }

    func tryNextLetter(at puzzleLetterIndex: Int) {
        guard
            let nextSolutionLetterIndex = nextEmptySolutionLetterIndex,
            let solutionLetterIndex = solutionLetterIndex(for: puzzleLetterIndex),
            nextSolutionLetterIndex == solutionLetterIndex
        else { return }

        revealLetter(
            puzzleLetterIndex: puzzleLetterIndex,
            solutionLetterIndex: solutionLetterIndex,
            notifyEvent: true
        )
    }

    func revealLetter(at puzzleLetterIndex: Int) {
        guard
            let solutionLetterIndex = solutionLetterIndex(for: puzzleLetterIndex)
        else { return }

        revealLetter(
            puzzleLetterIndex: puzzleLetterIndex,
            solutionLetterIndex: solutionLetterIndex,
            notifyEvent: true
        )
    }

    func solve() {
        guard !isSolved else { return }

        var revealedLetters = [RevealedLetter]()

        let emptySolutionLetterIndexes = solutionLetters
            .enumerated()
            .filter { $0.element == emptyLetter }
            .map { $0.offset }

        emptySolutionLetterIndexes
            .forEach { solutionLetterIndex in
                let solutionLetter = wordLetters[solutionLetterIndex]
                let puzzleLetterIndex = puzzleLetters
                    .enumerated()
                    .first(where: { $0.element == solutionLetter })?
                    .offset
                if let puzzleLetterIndex = puzzleLetterIndex {
                    let revealedLetter = RevealedLetter(
                        letter: solutionLetter,
                        puzzleIndex: puzzleLetterIndex,
                        solutionIndex: solutionLetterIndex
                    )
                    revealedLetters.append(revealedLetter)
                    revealLetter(
                        puzzleLetterIndex: puzzleLetterIndex,
                        solutionLetterIndex: solutionLetterIndex,
                        notifyEvent: false
                    )
                }
            }

        eventSubject.onNext(
            .solvedAutomatically(
                revealed: revealedLetters
            )
        )

        eventSubject.onCompleted()
    }

    private func solutionLetterIndex(for puzzleLetterIndex: Int) -> Int? {
        return solutionLetters
            .enumerated()
            .filter { $0.element == emptyLetter }
            .first(where: { wordLetters[$0.offset] == puzzleLetters[puzzleLetterIndex] })?
            .offset
    }

    private func revealLetter(
        puzzleLetterIndex: Int,
        solutionLetterIndex: Int,
        notifyEvent: Bool
    ) {
        solutionLetters[solutionLetterIndex] = puzzleLetters[puzzleLetterIndex]
        puzzleLetters[puzzleLetterIndex] = emptyLetter

        if notifyEvent {
            let revealedLetter = RevealedLetter(
                letter: solutionLetters[solutionLetterIndex],
                puzzleIndex: puzzleLetterIndex,
                solutionIndex: solutionLetterIndex
            )

            eventSubject.onNext(
                .revealedLetter(
                    revealedLetter,
                    isPuzzleSolved: isSolved
                )
            )

            if isSolved {
                eventSubject.onCompleted()
            }
        }
    }
}
