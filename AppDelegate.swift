//
//  Copyright 2022 Eigo Madaloja
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private var flowPresenter: RootFlowPresenter?

    func application(
        _: UIApplication,
        willFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        do {
            let wordLengthLimit = WordLengthLimit(
                playableAreaSize: (
                    width: Float(UIScreen.main.bounds.size.width),
                    height: Float(UIScreen.main.bounds.size.height)
                )
            )
            let wordProvider = try SQLite(
                wordLengthLimit: wordLengthLimit.maxWordLength
            )
            let settings = UserDefaultsSettings()
            let idleTimer = IdleTimerImpl()
            let purchaseService = PurchaseService(
                purchaseDeliverer: settings
            )
            let gamePlay = GamePlay(
                wordProvider: wordProvider,
                settings: settings
            )

            let gamePlayFlow = GamePlayFlow(
                gamePlay: gamePlay,
                settings: settings,
                idleTimer: idleTimer,
                purchaseService: purchaseService,
                wordLengthLimit: wordLengthLimit.maxWordLength,
                wordLengthProvider: wordProvider
            )

            flowPresenter = RootFlowPresenter()
            flowPresenter?.present(gamePlayFlow)
        } catch {
            print(error)
        }

        return true
    }
}
