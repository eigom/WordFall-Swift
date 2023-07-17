//
//  Copyright 2022 Eigo Madaloja
//

import UIKit

public enum ViewWrapping {
    case top
    case bottom
    case left
    case right
    case center
    case verticalCenter
    case horizontalCenter
}

extension UIView {
    public func wrapped(
        to wrapping: ViewWrapping,
        with insets: UIEdgeInsets = .zero
    ) -> UIView {
        switch wrapping {
        case .top:
            return topWrapped(insets: insets)
        case .bottom:
            return bottomWrapped(insets: insets)
        case .left:
            return leftWrapped(insets: insets)
        case .right:
            return rightWrapped(insets: insets)
        case .center:
            return centerWrapped(insets: insets)
        case .verticalCenter:
            return verticallyCenterWrapped(insets: insets)
        case .horizontalCenter:
            return horizontallyCenterWrapped(insets: insets)
        }
    }

    private func topWrapped(insets: UIEdgeInsets) -> UIView {
        let wrapper = UIView()
        wrapper.addSubview(self)
        autoPinEdgesToSuperviewEdges(with: insets, excludingEdge: .bottom)
        autoPinEdge(toSuperviewEdge: .bottom, withInset: insets.bottom, relation: .greaterThanOrEqual)
        return wrapper
    }

    private func bottomWrapped(insets: UIEdgeInsets) -> UIView {
        let wrapper = UIView()
        wrapper.addSubview(self)
        autoPinEdgesToSuperviewEdges(with: insets, excludingEdge: .top)
        autoPinEdge(toSuperviewEdge: .top, withInset: insets.top, relation: .greaterThanOrEqual)
        return wrapper
    }

    private func leftWrapped(insets: UIEdgeInsets) -> UIView {
        let wrapper = UIView()
        wrapper.addSubview(self)
        autoPinEdgesToSuperviewEdges(with: insets, excludingEdge: .right)
        autoPinEdge(toSuperviewEdge: .right, withInset: insets.right, relation: .greaterThanOrEqual)
        return wrapper
    }

    private func rightWrapped(insets: UIEdgeInsets) -> UIView {
        let wrapper = UIView()
        wrapper.addSubview(self)
        autoPinEdgesToSuperviewEdges(with: insets, excludingEdge: .left)
        autoPinEdge(toSuperviewEdge: .left, withInset: insets.left, relation: .greaterThanOrEqual)
        return wrapper
    }

    private func centerWrapped(insets: UIEdgeInsets) -> UIView {
        let wrapper = UIView()
        wrapper.addSubview(self)
        autoPinEdge(toSuperviewEdge: .left, withInset: insets.left, relation: .greaterThanOrEqual)
        autoPinEdge(toSuperviewEdge: .top, withInset: insets.top, relation: .greaterThanOrEqual)
        autoPinEdge(toSuperviewEdge: .right, withInset: insets.right, relation: .greaterThanOrEqual)
        autoPinEdge(toSuperviewEdge: .bottom, withInset: insets.bottom, relation: .greaterThanOrEqual)
        autoCenterInSuperview()
        return wrapper
    }

    private func horizontallyCenterWrapped(insets: UIEdgeInsets) -> UIView {
        let wrapper = UIView()
        wrapper.addSubview(self)
        autoPinEdge(toSuperviewEdge: .left, withInset: insets.left, relation: .greaterThanOrEqual)
        autoPinEdge(toSuperviewEdge: .top, withInset: insets.top)
        autoPinEdge(toSuperviewEdge: .right, withInset: insets.right, relation: .greaterThanOrEqual)
        autoPinEdge(toSuperviewEdge: .bottom, withInset: insets.bottom)
        autoAlignAxis(toSuperviewAxis: .vertical)
        return wrapper
    }

    private func verticallyCenterWrapped(insets: UIEdgeInsets) -> UIView {
        let wrapper = UIView()
        wrapper.addSubview(self)
        autoPinEdge(toSuperviewEdge: .left, withInset: insets.left)
        autoPinEdge(toSuperviewEdge: .top, withInset: insets.top, relation: .greaterThanOrEqual)
        autoPinEdge(toSuperviewEdge: .right, withInset: insets.right)
        autoPinEdge(toSuperviewEdge: .bottom, withInset: insets.bottom, relation: .greaterThanOrEqual)
        autoAlignAxis(toSuperviewAxis: .horizontal)
        return wrapper
    }
}
