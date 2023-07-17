//
//  Copyright 2022 Eigo Madaloja
//

import UIKit

final class SettingsView: View {
    let wordLengthControl = WordLengthControl(
        title: Strings.Settings.WordLength.title,
        allTitle: Strings.Settings.WordLength.all
    )
    let soundSwitch = Switch(
        title: Strings.Settings.Sound.title,
        onTitle: Strings.Settings.Sound.on,
        offTitle: Strings.Settings.Sound.off
    )
    let restorePurchasesButton = Button(
        title: Strings.Settings.RestorePurchasesButton.title
    )

    let tapGestureRecognizer = UITapGestureRecognizer()

    override init() {
        super.init()
        setup()
        layout()
    }

    private func setup() {
        backgroundColor = .black.withAlphaComponent(0.5)

        addGestureRecognizer(tapGestureRecognizer)

        restorePurchasesButton.borderStyle = .circular
        restorePurchasesButton.backgroundColor = Assets.Colors.Button.Restore.background.color
        restorePurchasesButton.alpha = 0.6
    }

    private func layout() {
        addSubview(wordLengthControl)
        wordLengthControl.autoPinEdge(toSuperviewSafeArea: .left, withInset: 10)
        wordLengthControl.autoPinEdge(toSuperviewSafeArea: .top, withInset: 10, relation: .greaterThanOrEqual)
        wordLengthControl.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 10, relation: .greaterThanOrEqual)
        wordLengthControl.autoAlignAxis(toSuperviewAxis: .horizontal)

        addSubview(soundSwitch)
        soundSwitch.autoPinEdge(toSuperviewSafeArea: .right, withInset: 10)
        soundSwitch.autoPinEdge(toSuperviewSafeArea: .top, withInset: 10, relation: .greaterThanOrEqual)
        soundSwitch.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 10, relation: .greaterThanOrEqual)
        soundSwitch.autoAlignAxis(toSuperviewAxis: .horizontal)

        addSubview(restorePurchasesButton)
        restorePurchasesButton.autoPinEdge(toSuperviewSafeArea: .top, withInset: 20)
        restorePurchasesButton.autoAlignAxis(toSuperviewAxis: .vertical)
    }
}
