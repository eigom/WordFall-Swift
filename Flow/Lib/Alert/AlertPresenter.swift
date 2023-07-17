//
//  Copyright 2022 Eigo Madaloja
//

protocol AlertPresenter {
    func presentAlert(
        _ alert: Alert,
        with presenter: FlowPresenter
    )
}

extension AlertPresenter {
    func presentAlert(
        _ alert: Alert,
        with presenter: FlowPresenter
    ) {
        let alertFlow = AlertFlow(alert: alert)
        presenter.present(
            alertFlow,
            presentingStyle: .modal(animated: true)
        )
    }
}
