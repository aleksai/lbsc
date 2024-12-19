import SceneKit

class SceneState: ObservableObject {}

class Scene: SCNView {
    @Published public var state: SceneState?

    override init(frame: CGRect, options: [String: Any]? = nil) {
        super.init(frame: frame, options: options)

        setupScene()
        setupGestureRecognizers()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupScene()
        setupGestureRecognizers()
    }

    func setupScene() {
        scene = SCNScene()

        delegate = self

        backgroundColor = .black

        allowsCameraControl = false
        showsStatistics = false
        autoenablesDefaultLighting = true
    }

    func setupGestureRecognizers() {}
}

extension Scene: SCNSceneRendererDelegate {
    func renderer(_ renderer: any SCNSceneRenderer, updateAtTime time: TimeInterval) {}
}
