import UIKit
import SceneKit

class SceneViewController: UIViewController {
    private let sceneView: SceneView
    
    init(sceneView: SceneView) {
        self.sceneView = sceneView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = sceneView
    }
}
