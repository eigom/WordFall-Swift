//
//  Copyright 2022 Eigo Madaloja
//

import UIKit

public class IdleTimerImpl: IdleTimer {
    private var disablingObjects = [AnyObject]()

    public func enable(for object: AnyObject) {
        disablingObjects.removeAll(where: { $0 === object })

        if disablingObjects.isEmpty {
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }

    public func disable(for object: AnyObject) {
        guard !disablingObjects.contains(where: { $0 === object }) else { return }

        disablingObjects.append(object)
        UIApplication.shared.isIdleTimerDisabled = true
    }
}
