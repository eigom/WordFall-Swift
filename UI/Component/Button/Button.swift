//
//  Copyright 2022 Eigo Madaloja
//

import UIKit

public final class Button: UIButton {
    public enum BorderStyle {
        case rectangular
        case circular
    }

    public var borderStyle: BorderStyle = .rectangular {
        didSet { updateBorder() }
    }

    public var title: String? {
        didSet { updateTitles() }
    }

    public var subtitle: String? {
        didSet { updateTitles() }
    }

    public var titleAttributes: StringAttributes = Attributes.Button.title {
        didSet { updateTitles() }
    }

    public var smallTitleAttributes: StringAttributes = Attributes.Button.smallTitle {
        didSet { updateTitles() }
    }

    public var subtitleAttributes: StringAttributes = Attributes.Button.subtitle {
        didSet { updateTitles() }
    }

    public var gradientColor: UIColor = .clear {
        didSet {
            gradientView.gradient = .init(colors: [
                gradientColor,
                gradientColor.darken(by: 0.1)
            ])
        }
    }

    public var isLoadingActivityActive: Bool = false {
        didSet {
            isLoadingActivityActive
                ? startLoadingActivity()
                : stopLoadingActivity()
        }
    }

    private let titlesStackView = UIStackView()
    private let gradientView = GradientView()
    private let mainTitleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let loadingActivityIndicator = UIActivityIndicatorView(style: .medium)
    private var titlesStackViewTopConstraint: NSLayoutConstraint?
    private var titlesStackViewBottomConstraint: NSLayoutConstraint?

    public init(title: String? = nil) {
        super.init(frame: .zero)
        setup(title: title)
        layout()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        updateBorder()
    }

    public func setIsVisible(_ isVisible: Bool, animated: Bool) {
        guard animated else {
            isHidden = !isVisible
            alpha = isVisible ? 1.0 : 0.0
            return
        }

        UIView.animate(withDuration: 0.4) {
            self.isHidden = !isVisible
            self.alpha = isVisible ? 1.0 : 0.0
        }
    }

    private func setup(title: String?) {
        self.title = title

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 2
        updateBorder()

        titlesStackView.axis = .vertical
        titlesStackView.isUserInteractionEnabled = false

        gradientView.layer.borderWidth = 0.5
        gradientView.layer.borderColor = UIColor.black.cgColor
        gradientView.isUserInteractionEnabled = false

        mainTitleLabel.textAlignment = .center
        mainTitleLabel.font = FontStyle.buttonTitle.font

        subTitleLabel.textAlignment = .center
        subTitleLabel.font = FontStyle.buttonSubtitle.font

        loadingActivityIndicator.color = .white
    }

    private func layout() {
        addSubview(gradientView)
        gradientView.autoPinEdgesToSuperviewEdges()

        titlesStackView.addArrangedSubviews([
            mainTitleLabel,
            subTitleLabel
        ])

        addSubview(titlesStackView)
        titlesStackView.autoPinEdge(toSuperviewEdge: .left, withInset: 15, relation: .greaterThanOrEqual)
        titlesStackView.autoPinEdge(toSuperviewEdge: .right, withInset: 15, relation: .greaterThanOrEqual)
        titlesStackViewTopConstraint = titlesStackView.autoPinEdge(
            toSuperviewEdge: .top,
            withInset: 10,
            relation: .greaterThanOrEqual
        )
        titlesStackViewBottomConstraint = titlesStackView.autoPinEdge(
            toSuperviewEdge: .bottom,
            withInset: 10,
            relation: .greaterThanOrEqual
        )
        titlesStackView.autoCenterInSuperview()

        addSubview(loadingActivityIndicator)
        loadingActivityIndicator.autoCenterInSuperview()
    }

    private func updateBorder() {
        switch borderStyle {
        case .rectangular:
            layer.cornerRadius = 3.0
        case .circular:
            layer.cornerRadius = frame.size.height / 2.0
        }

        gradientView.layer.cornerRadius = layer.cornerRadius
    }

    private func updateTitlesSpacing() {
        titlesStackViewTopConstraint?.constant = subtitle == nil ? 10 : 5
        titlesStackViewBottomConstraint?.constant = subtitle == nil ? 10 : 5
    }

    private func updateTitles() {
        let titleAttributes = subtitle == nil
            ? titleAttributes
            : smallTitleAttributes

        mainTitleLabel.attributedText = title.map({ title in
            NSAttributedString(
                string: title,
                attributes: titleAttributes
            )
        })

        subTitleLabel.attributedText = subtitle.map({ subtitle in
            NSAttributedString(
                string: subtitle,
                attributes: subtitleAttributes
            )
        })

        updateTitlesSpacing()
    }

    private func startLoadingActivity() {
        isUserInteractionEnabled = false
        titlesStackView.alpha = 0.0
        loadingActivityIndicator.isHidden = false
        loadingActivityIndicator.startAnimating()
    }

    private func stopLoadingActivity() {
        isUserInteractionEnabled = true
        titlesStackView.alpha = 1.0
        loadingActivityIndicator.isHidden = false
        loadingActivityIndicator.stopAnimating()
    }
}
