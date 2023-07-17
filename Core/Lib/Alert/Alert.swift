//
//  Copyright 2022 Eigo Madaloja
//

public struct Alert {
    let title: String?
    let message: String?
    let actions: [AlertAction]

    public static let defaultTitle = Strings.Alert.defaultTitle
}

public extension Alert {
    static func info(
        message: String,
        title: String? = Alert.defaultTitle
    ) -> Alert {
        return Alert(
            title: title,
            message: message,
            actions: [
                AlertAction(
                    title: Strings.Alert.Action.dismiss,
                    style: .default,
                    onSelected: {}
                )
            ]
        )
    }

    static func info(_ error: Error) -> Alert {
        return Alert.info(message: error.localizedDescription)
    }

    static func confirmation(
        title: String,
        message: String,
        actionTitle: String,
        onConfirmed: @escaping () -> Void
    ) -> Alert {
        return Alert(
            title: title,
            message: message,
            actions: [
                AlertAction(
                    title: actionTitle,
                    style: .default,
                    onSelected: { onConfirmed() }
                ),
                AlertAction(
                    title: Strings.Alert.Action.cancel,
                    style: .cancel,
                    onSelected: {}
                )
            ]
        )
    }
}

public struct AlertAction {
    public enum Style {
        case `default`
        case cancel
        case destructive
    }

    let title: String
    let style: Style
    let onSelected: () -> Void
}
