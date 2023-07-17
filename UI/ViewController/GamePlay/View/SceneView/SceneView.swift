//
//  Copyright 2022 Eigo Madaloja
//

import SpriteKit

final class SceneView: SKView {
    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        allowsTransparency = true
        backgroundColor = .clear
    }

}
