//
//  Copyright 2022 Eigo Madaloja
//

import UIKit
import RxSwift

enum PresentingModalViewController {
    case defaultViewController
    case viewController(UIViewController)
}

enum PresentingNavigationViewController {
    case defaultNavigationViewController
    case navigationController(UINavigationController)
}

enum PresentingStyle {
    case modal(
        animated: Bool = true,
        fromViewController: PresentingModalViewController = .defaultViewController,
        presentationStyle: UIModalPresentationStyle = .automatic,
        transitionStyle: UIModalTransitionStyle = .coverVertical
    )
    case push(
        animated: Bool = true,
        toNavigationController: PresentingNavigationViewController = .defaultNavigationViewController
    )
}

enum DismissingStyle {
    case none
    case automatic(
        animated: Bool = true,
        onDismissed: (() -> Void)?
    )
}

final class FlowPresenter {
    private var presentedFlows = [String: (Flow, UIViewController)]()
    private let disposeBag = DisposeBag()

    var defaultModalFlowPresenter: UIViewController?
    var defaultNavigationFlowPresenter: UINavigationController?

    func present(
        _ flow: Flow,
        presentingStyle: PresentingStyle = .modal(
            animated: true,
            fromViewController: .defaultViewController,
            presentationStyle: .automatic,
            transitionStyle: .coverVertical
        ),
        dismissingStyle: DismissingStyle = .automatic(
            animated: true,
            onDismissed: nil
        )
    ) {
        flow.finished
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                self?.dismissFlow(
                    flow,
                    style: dismissingStyle,
                    presentingStyle: presentingStyle
                )
            })
            .disposed(by: disposeBag)

        present(flow, style: presentingStyle)
    }

    private func present(
        _ flow: Flow,
        style: PresentingStyle
    ) {
        switch style {
        case .modal(let animated, let fromViewController, let presentationStyle, let transitionStyle):
            guard let presentingViewController = viewController(for: fromViewController) else {
                print("WARNING: no presenting view controller")
                return
            }

            let viewController = flow.start()
            viewController.modalPresentationStyle = presentationStyle
            viewController.modalTransitionStyle = transitionStyle

            presentingViewController.present(
                viewController,
                animated: animated,
                completion: nil
            )

            presentedFlows[flow.identifier] = (flow, viewController)
        case .push(let animated, let toNavigationController):
            guard let presentingNavigationController = viewController(for: toNavigationController) else {
                print("WARNING: no presenting navigation controller")
                return
            }

            let viewController = flow.start()

            presentingNavigationController.pushViewController(
                viewController,
                animated: animated
            )

            presentedFlows[flow.identifier] = (flow, viewController)
        }
    }

    private func dismissFlow(
        _ flow: Flow,
        style: DismissingStyle,
        presentingStyle: PresentingStyle
    ) {
        guard let (flow, viewController) = presentedFlows[flow.identifier] else {
            print("WARNING: trying to dismiss unknown flow")
            return
        }

        switch style {
        case .none:
            break
        case .automatic(let animated, let onDismissed):
            switch presentingStyle {
            case .modal:
                viewController.dismiss(
                    animated: animated,
                    completion: onDismissed
                )
            case .push:
                break
            }
        }

        presentedFlows[flow.identifier] = nil
    }

    private func viewController(for presenting: PresentingModalViewController) -> UIViewController? {
        switch presenting {
        case .defaultViewController:
            return defaultModalFlowPresenter
        case .viewController(let viewController):
            return viewController
        }
    }

    private func viewController(for presenting: PresentingNavigationViewController) -> UINavigationController? {
        switch presenting {
        case .defaultNavigationViewController:
            return defaultNavigationFlowPresenter
        case .navigationController(let navigationController):
            return navigationController
        }
    }
}
