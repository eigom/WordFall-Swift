//
//  Copyright 2022 Eigo Madaloja
//

import UIKit

public final class SeparatorView: View {
    public var color: UIColor {
        get { label.textColor }
        set { label.textColor = newValue }
    }

    private let label = UILabel()
    private let separatorText = "∙"
    private var separatorTextWidth = 1.0

    override public init() {
        super.init()
        setup()
        layout()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        fillLabel()
    }

    private func setup() {
        label.font = FontStyle.separator.font
        label.textAlignment = .center
        label.textColor = Assets.Colors.separator.color
        label.text = separatorText
        label.sizeToFit()
        separatorTextWidth = label.frame.size.width
    }

    private func layout() {
        addSubview(label)
        label.autoPinEdgesToSuperviewEdges()
    }

    private func fillLabel() {
        let separatorTextCount = Int(frame.size.width / separatorTextWidth)
        label.text = String(
            repeating: separatorText,
            count: separatorTextCount
        )
    }
}
