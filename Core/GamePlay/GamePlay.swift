//
//  Copyright 2022 Eigo Madaloja
//

import RxSwift
import RxCocoa
import Foundation

public class GamePlay {
    public struct Event {
        public let presentIntroduction: Observable<Void>
        public let nextPuzzle: Observable<Void>
        public let solvePuzzle: Observable<Void>
        public let tryNextLetter: Observable<Int>
        public let revealLetter: Observable<Int>
    }

    public enum Action {
        case setSolution(
            letters: [Character?],
            timing: GamePlayTiming
        )
        case revealSolutionLetter(
            Character,
            index: Int,
            timing: GamePlayTiming,
            soundEffect: GamePlaySoundEffect
        )
        case showDefinitions(
            [WordPuzzle.WordDefinition],
            timing: GamePlayTiming
        )
        case startFall(
            [GamePlayLetterFall],
            color: GamePlayColor,
            soundEffect: GamePlaySoundEffect
        )
        case retractAll(GamePlayLetterRetraction)
        case removeFallingLetter(
            index: Int,
            timing: GamePlayTiming
        )
    }

    var isGamePlayActive: Observable<Bool> {
        isGamePlayActiveRelay.asObservable()
    }

    private let wordProvider: WordProvider
    private let settings: Settings
    private let actionSubject = PublishSubject<Action>()
    private let isGamePlayActiveRelay = BehaviorRelay<Bool>(value: false)
    private let wordPuzzle = ReplaySubject<WordPuzzle>.create(bufferSize: 1)
    private var wordPuzzleDisposable: Disposable?
    private let disposeBag = DisposeBag()

    public init(
        wordProvider: WordProvider,
        settings: Settings
    ) {
        self.wordProvider = wordProvider
        self.settings = settings

        wordPuzzle
            .subscribe(onNext: { wordPuzzle in
                self.startNewWordPuzzle(wordPuzzle)
            })
            .disposed(by: disposeBag)
    }

    public func map(_ event: Event) -> Observable<Action> {
        event.presentIntroduction
            .subscribe(onNext: { _ in
                self.presentIntroduction()
            })
            .disposed(by: disposeBag)

        event.nextPuzzle
            .withLatestFrom(settings.wordLength)
            .compactMap(WordProviderWordLength.init)
            .flatMap { self.wordProvider.randomWord(length: $0) }
            .map { WordPuzzle.Word($0) }
            .map { WordPuzzle($0) }
            .bind(to: wordPuzzle)
            .disposed(by: disposeBag)

        event.solvePuzzle
            .withLatestFrom(wordPuzzle)
            .subscribe(onNext: { wordPuzzle in
                wordPuzzle.solve()
            })
            .disposed(by: disposeBag)

        event.tryNextLetter
            .withLatestFrom(wordPuzzle, resultSelector: { index, wordPuzzle in (wordPuzzle, index) })
            .subscribe(onNext: { wordPuzzle, index in
                wordPuzzle.tryNextLetter(at: index)
            })
            .disposed(by: disposeBag)

        event.revealLetter
            .withLatestFrom(wordPuzzle, resultSelector: { index, wordPuzzle in (wordPuzzle, index) })
            .subscribe(onNext: { wordPuzzle, index in
                wordPuzzle.revealLetter(at: index)
            })
            .disposed(by: disposeBag)

        return actionSubject.asObservable()
    }

    private func startNewWordPuzzle(_ wordPuzzle: WordPuzzle) {
        print(wordPuzzle.word.word)

        wordPuzzleDisposable?.dispose()
        wordPuzzleDisposable = wordPuzzle.event
            .subscribe(onNext: { event in
                self.handleWordPuzzleEvent(event)
            })

        actionSubject.onNext(
            .showDefinitions(
                wordPuzzle.word.definitions,
                timing: .seconds(1.0)
            )
        )
        actionSubject.onNext(
            .setSolution(
                letters: Array(
                    repeating: nil,
                    count: wordPuzzle.letterCount
                ),
                timing: .seconds(0.5)
            )
        )
        actionSubject.onNext(
            .retractAll(
                GamePlayLetterRetraction(
                    timing: .seconds(0.8)
                )
            )
        )

        let letterFalls = makeLetterFalls(for: wordPuzzle.puzzleWord)

        actionSubject.onNext(
            .startFall(
                letterFalls,
                color: GamePlayColor.randomColor,
                soundEffect: .sound(.fallStart, delay: .seconds(1.6))
            )
        )

        isGamePlayActiveRelay.accept(true)
    }

    private func handleWordPuzzleEvent(_ event: WordPuzzle.Event) {
        switch event {
        case .revealedLetter(
            let letter,
            let isPuzzleSolved
        ):
            revealLetter(
                letter,
                isPuzzleSolved: isPuzzleSolved
            )
        case .solvedAutomatically(
            revealed: let revealedLetters
        ):
            solvePuzzle(revealedLetters: revealedLetters)
        }
    }

    private func revealLetter(
        _ letter: WordPuzzle.RevealedLetter,
        isPuzzleSolved: Bool
    ) {
        actionSubject.onNext(
            .removeFallingLetter(
                index: letter.puzzleIndex,
                timing: .seconds(0.2)
            )
        )
        actionSubject.onNext(
            .revealSolutionLetter(
                letter.letter,
                index: letter.solutionIndex,
                timing: .seconds(0.3),
                soundEffect: .sound(isPuzzleSolved ? .revealWord : .revealLetter)
            )
        )

        if isPuzzleSolved {
            isGamePlayActiveRelay.accept(false)
        }
    }

    private func solvePuzzle(revealedLetters: [WordPuzzle.RevealedLetter]) {
        revealedLetters
            .enumerated()
            .forEach { letter in
                let revealDelay: GamePlayDelay = .seconds(0)
                let revealDuration: GamePlayDuration = .seconds(
                    0.3 + 0.1 * Double(letter.offset)
                )
                let revealSoundEffect: GamePlaySoundEffect = letter.offset == 0
                    ? .sound(.revealWord)
                    : .none

                actionSubject.onNext(
                    .removeFallingLetter(
                        index: letter.element.puzzleIndex,
                        timing: .seconds(0.4)
                    )
                )
                actionSubject.onNext(
                    .revealSolutionLetter(
                        letter.element.letter,
                        index: letter.element.solutionIndex,
                        timing: .init(duration: revealDuration, delay: revealDelay),
                        soundEffect: revealSoundEffect
                    )
                )
            }
        isGamePlayActiveRelay.accept(false)
    }

    private func makeLetterFalls(for word: String) -> [GamePlayLetterFall] {
        let fallDurationSeconds = Float(word.count * 10)
        let fallAmount = word.map { _ in 1.0 - Float.random(in: 0.0...0.4) }
        let maxFallAmount = fallAmount.max() ?? 1.0

        let letterFalls = zip(word, fallAmount)
            .map { letter, fallAmount in
                let fallDuration = TimeInterval(
                    fallAmount / maxFallAmount * fallDurationSeconds
                )
                return GamePlayLetterFall(
                    letter: letter,
                    fallAmount: fallAmount,
                    startAccelerationTiming: .seconds(0.5, delay: 1.2),
                    fallTiming: .seconds(fallDuration),
                    fadeOutTiming: .seconds(0.3)
                )
            }

        return letterFalls
    }
}

extension GamePlay {
    private func presentIntroduction() {
        let word = Strings.GamePlay.Intro.word
        let definitions = [
            WordPuzzle.WordDefinition(
                type: Strings.GamePlay.Intro.Definition.type,
                definition: Strings.GamePlay.Intro.Definition.text
            )
        ]
        let letterFalls = word.map { letter in
            return GamePlayLetterFall(
                letter: letter,
                fallAmount: 0.5,
                startAccelerationTiming: .immediate,
                fallTiming: .seconds(86400),
                fadeOutTiming: .immediate
            )
        }

        actionSubject.onNext(
            .showDefinitions(
                definitions,
                timing: .immediate
            )
        )
        actionSubject.onNext(
            .setSolution(
                letters: Array(word),
                timing: .immediate
            )
        )
        actionSubject.onNext(
            .startFall(
                letterFalls,
                color: .blue,
                soundEffect: .none
            )
        )
    }
}
