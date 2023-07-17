//
//  Copyright 2022 Eigo Madaloja
//

import UIKit
import RxSwift
import RxCocoa

// swiftlint:disable class_delegate_protocol
protocol FlowDelegate {
    init()
}

protocol Flow {
    var identifier: String { get }
    var finished: Observable<Void> { get }
    func start() -> UIViewController
}

class FlowCoordinator<Delegate: FlowDelegate>: Flow {
    let finishedSubject = PublishSubject<Void>()
    let identifier: String = UUID().uuidString
    let delegate: Delegate = Delegate()
    let disposeBag = DisposeBag()

    var finished: Observable<Void> {
        finishedSubject.asObservable()
    }

    @discardableResult
    func start() -> UIViewController {
        return UIViewController()
    }
}
