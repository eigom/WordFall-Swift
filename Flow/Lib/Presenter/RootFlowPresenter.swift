//
//  Copyright 2022 Eigo Madaloja
//

import UIKit

final class RootFlowPresenter {
    private let window: UIWindow
    private var rootFlow: Flow?

    init(window: UIWindow = UIWindow()) {
        self.window = window
    }

    func present(
        _ flow: Flow,
        with options: UIView.AnimationOptions? = .transitionCrossDissolve,
        completion: (() -> Void)? = nil
    ) {
        rootFlow = flow

        let viewController = flow.start()

        if let options = options {
            UIView.transition(
                with: window,
                duration: 0.3,
                options: options,
                animations: { [unowned self] in
                    let animationsEnabled = UIView.areAnimationsEnabled
                    UIView.setAnimationsEnabled(false)
                    window.rootViewController = viewController
                    window.makeKeyAndVisible()
                    UIView.setAnimationsEnabled(animationsEnabled)
            }, completion: { _ in
                completion?()
            })
        } else {
            window.rootViewController = viewController
            window.makeKeyAndVisible()
            completion?()
        }
    }
}
