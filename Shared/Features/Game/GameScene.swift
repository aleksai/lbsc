import Combine
import SceneKit

class GameSceneState: SceneState {
    @Published var gameOver: Bool = false
}

class GameScene: Scene {
    private let characterWithCamera = CharacterWithCamera()
    private let floor = Floor()
    private let barrelGenerator = BarrelGenerator()

    override func setupScene() {
        super.setupScene()

        rendersContinuously = true

        floor.addToScene(scene)

        barrelGenerator.generate(amount: 20)
        barrelGenerator.barrels.forEach { $0.addToScene(scene) }

        characterWithCamera.addToScene(scene)

        if let state = state as? GameSceneState {
            characterWithCamera.$gameOver.assign(to: &state.$gameOver)
        }
    }

    override func setupGestureRecognizers() {
        characterWithCamera.setupGestureRecognizers(self)
    }

    override func renderer(_ renderer: any SCNSceneRenderer, updateAtTime time: TimeInterval) {
        characterWithCamera.renderer(renderer, updateAtTime: time)
    }
}
