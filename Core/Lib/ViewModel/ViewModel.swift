//
//  Copyright 2022 Eigo Madaloja
//

public protocol ViewModel {
    associatedtype Event
    associatedtype Action
    associatedtype Delegate

    var delegate: Delegate { get }

    func map(_ event: Event) -> Action
}
