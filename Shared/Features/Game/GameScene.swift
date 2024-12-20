import Combine
import SceneKit

class GameSceneState: SceneState {
    @Published fileprivate(set) var gameOver: Bool = false
    @Published fileprivate(set) var score: Int = 0

    let reset: () -> Void

    init(reset: @escaping () -> Void) {
        self.reset = reset
    }
}

class GameScene: Scene {
    private let characterWithCamera = CharacterWithCamera()
    private let floor = Floor()
    private let barrelGenerator = BarrelGenerator()

    override func setupScene() {
        super.setupScene()

        rendersContinuously = true

        floor.addToScene(scene)

        barrelGenerator.generate(amount: 20).forEach { $0.addToScene(scene) }

        characterWithCamera.addToScene(scene)
    }

    override func setupState() {
        super.setupState()

        let state = GameSceneState(
            reset: { [weak self] in self?.reset() }
        )

        self.state = state

        characterWithCamera.$gameOver.assign(to: &state.$gameOver)
    }

    override func setupGestureRecognizers() {
        super.setupGestureRecognizers()

        characterWithCamera.setupGestureRecognizers(self)
    }

    override func renderer(_ renderer: any SCNSceneRenderer, updateAtTime time: TimeInterval) {
        super.renderer(renderer, updateAtTime: time)

        characterWithCamera.renderer(renderer, updateAtTime: time)
    }

    private func reset() {
        barrelGenerator.barrels.forEach { $0.removeAll() }
        barrelGenerator.generate(amount: 20).forEach { $0.addToScene(scene) }

        characterWithCamera.reset()
    }
}
