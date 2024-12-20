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

    private var cancellables: Set<AnyCancellable> = []

    override func setupScene() {
        super.setupScene()

        antialiasingMode = .multisampling4X
        rendersContinuously = true

        floor.addToScene(scene)
        barrelGenerator.reset().forEach { $0.addToScene(scene) }
        characterWithCamera.addToScene(scene)
    }

    override func setupState() {
        super.setupState()

        let state = GameSceneState(
            reset: reset
        )

        self.state = state

        characterWithCamera.$gameOver.assign(to: &state.$gameOver)

        Publishers.CombineLatest(
            barrelGenerator.$falledBarrels,
            characterWithCamera.$scoreMultiplier
        )
        .sink { [weak self] falledBarrels, scoreMultiplier in
            self?.estimateScore(
                falledBarrels: falledBarrels,
                scoreMultiplier: scoreMultiplier
            )
        }
        .store(in: &cancellables)
    }

    override func setupGestureRecognizers() {
        super.setupGestureRecognizers()

        characterWithCamera.setupGestureRecognizers(self)
    }

    override func renderer(_ renderer: any SCNSceneRenderer, updateAtTime time: TimeInterval) {
        super.renderer(renderer, updateAtTime: time)

        characterWithCamera.renderer(renderer, updateAtTime: time)
        barrelGenerator.renderer(renderer, updateAtTime: time)
    }

    private func reset() {
        characterWithCamera.reset()
        barrelGenerator.reset().forEach { $0.addToScene(scene) }
    }

    private func estimateScore(falledBarrels: [Barrel.Kind: Int], scoreMultiplier: Int) {
        guard let state = state as? GameSceneState else { return }
        state.score = scoreMultiplier * falledBarrels.reduce(0) { $0 + $1.value }
    }
}
