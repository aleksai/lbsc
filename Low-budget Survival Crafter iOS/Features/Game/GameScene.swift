import UIKit
import SceneKit

class GameScene: SceneView {
    
    private let characterWithCamera = CharacterWithCamera()
    private let floor = Floor()
    
    override func setupScene() {
        super.setupScene()
        
        scene?.rootNode.addChildNode(characterWithCamera.cameraNode)
        scene?.rootNode.addChildNode(characterWithCamera.boxNode)
        
        scene?.rootNode.addChildNode(floor.floorNode)
    }
    
    override func setupGestureRecognizers() {
        super.setupGestureRecognizers()
        
        let panGesture = UIPanGestureRecognizer(target: characterWithCamera, action: #selector(characterWithCamera.handlePan(_:)))
        self.addGestureRecognizer(panGesture)
    }
    
    override func updateDisplay() {
        super.updateDisplay()
        
        characterWithCamera.updateBoxPosition()
    }

}
