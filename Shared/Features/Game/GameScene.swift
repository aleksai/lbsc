import Combine
import DI
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
    private let zoneGenerator = ZoneGenerator()

    private var cancellables: Set<AnyCancellable> = []

    @Injected(\.dataService) private var dataService

    override func setupScene() {
        super.setupScene()

        rendersContinuously = true

        scene?.fogColor = UIColor.black
        scene?.fogStartDistance = 1.0
        scene?.fogEndDistance = 100.0
        scene?.fogDensityExponent = 10.0

        floor.addToScene(scene)

        zoneGenerator.regenerate().forEach { $0.addToScene(scene) }
        barrelGenerator.regenerate().forEach { $0.addToScene(scene) }

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

        barrelGenerator.onBarrelFalling.sink { [weak self] fallEvent in
            self?.showFlyingTextEvent(fallEvent)
        }
        .store(in: &cancellables)

        zoneGenerator.onZoneComplete.sink { [weak self] zoneCompleteEvent in
            let zone = zoneCompleteEvent.zone
            zone.completeZone()

            self?.floor.openShutters(position: Floor.Coords(x: Int(zone.position.x), y: Int(zone.position.z)), size: zone.size)
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
        zoneGenerator.renderer(renderer, updateAtTime: time)

        for zone in zoneGenerator.zones {
            for barrel in barrelGenerator.barrels.filter({ $0.kind == .zone }) {
                zone.checkBarrel(barrel)
            }
        }
    }

    private func reset() {
        characterWithCamera.reset()

        barrelGenerator.regenerate().forEach { $0.addToScene(scene) }
        zoneGenerator.regenerate().forEach { $0.addToScene(scene) }
    }

    private func estimateScore(falledBarrels: [Barrel.Kind: Int], scoreMultiplier: Int) {
        guard let state = state as? GameSceneState else { return }

        var score = 0
        for kind in Barrel.Kind.allCases {
            score += (dataService.fallScore[kind] ?? 0) * (falledBarrels[kind] ?? 0)
        }
        state.score = scoreMultiplier * score
    }

    private func showFlyingTextEvent(_ event: Event) {
        if let fallEvent = event as? BarrelGenerator.FallEvent {
            let score = dataService.fallScore[fallEvent.barrelKind] ?? 0
            FlyingTextEvent(
                string: "\(score > 0 ? "+" : "")\(score)",
                color: score > 0 ? .systemGreen : .systemRed,
                position: fallEvent.position
            ).addToScene(scene)
        }
    }
}
