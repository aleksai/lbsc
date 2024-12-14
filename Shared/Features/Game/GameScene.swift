import SceneKit

class GameScene: SceneView {
    private let characterWithCamera = CharacterWithCamera()
    private let floor = Floor()
    private let barrelGenerator = BarrelGenerator()

    override func setupScene() {
        super.setupScene()

        floor.addToScene(scene)

        barrelGenerator.generate(amount: 20)
        barrelGenerator.barrels.forEach { $0.addToScene(scene) }

        characterWithCamera.addToScene(scene)
    }

    override func setupGestureRecognizers() {
        characterWithCamera.setupGestureRecognizers(self)
    }

    override func updateDisplay() {
        characterWithCamera.updateDisplay()
    }
}
