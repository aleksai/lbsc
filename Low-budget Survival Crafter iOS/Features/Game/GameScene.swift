import UIKit
import SceneKit

class GameScene: SceneView {
    
    private let characterWithCamera = CharacterWithCamera()
    private let floor = Floor()
    
    override func setupScene() {
        super.setupScene()
        
        characterWithCamera.addToScene(scene)
        floor.addToScene(scene)
    }
    
    override func setupGestureRecognizers() {
        characterWithCamera.setupGestureRecognizers(self)
    }
    
    override func updateDisplay() {
        characterWithCamera.updateDisplay()
    }

}
