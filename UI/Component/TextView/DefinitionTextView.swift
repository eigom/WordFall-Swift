//
//  Copyright 2022 Eigo Madaloja
//

import UIKit

public final class DefinitionTextView: UIView {
    public var attributedText: NSAttributedString {
        get { textView.attributedText }
        set {
            setAttributedText(
                newValue,
                delay: 0.0,
                duration: 0.0
            )
        }
    }

    private let textView = UITextView()

    public init() {
        super.init(frame: .zero)
        setup()
        layout()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setAttributedText(
        _ text: NSAttributedString,
        delay: TimeInterval,
        duration: TimeInterval
    ) {
        UIView.animate(
            withDuration: duration / 2.0,
            delay: delay
        ) { [weak self] in
            self?.alpha = 0.0
        } completion: { [weak self] _ in
            self?.textView.attributedText = text
            self?.textView.contentOffset = .zero

            UIView.animate(
                withDuration: duration / 2.0,
                delay: 0.0) {
                    self?.alpha = 1.0
                } completion: { _ in
                    self?.textView.flashScrollIndicators()
                }
        }
    }

    private func setup() {
        clipsToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 0.1

        textView.isEditable = false
        textView.isSelectable = false
        textView.showsHorizontalScrollIndicator = false
        textView.showsVerticalScrollIndicator = true
        textView.backgroundColor = .clear
    }

    private func layout() {
        addSubview(textView)
        textView.autoPinEdgesToSuperviewEdges()
    }
}
