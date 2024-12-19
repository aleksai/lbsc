import SceneKit
import UIKit

class SceneViewController: UIViewController {
    let scene: Scene

    init(scene: Scene) {
        self.scene = scene
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = scene
    }
}
