//
//  Copyright 2022 Eigo Madaloja
//

import UIKit

struct AlertFlowDelegate: FlowDelegate {}

final class AlertFlow: FlowCoordinator<AlertFlowDelegate> {
    private let alert: Alert

    init(alert: Alert) {
        self.alert = alert
    }

    override func start() -> UIViewController {
        let alertController = UIAlertController(
            title: alert.title,
            message: alert.message,
            preferredStyle: .alert
        )
        alert.actions.forEach { action in
            alertController.addAction(.init(action))
        }

        return alertController
    }
}
