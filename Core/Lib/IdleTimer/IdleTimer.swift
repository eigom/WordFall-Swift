//
//  Copyright 2022 Eigo Madaloja
//

public protocol IdleTimer {
    func enable(for object: AnyObject)
    func disable(for object: AnyObject)
}
