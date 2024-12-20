import DI
import SceneKit

class CharacterWithCamera: Component {
    private var ballNode: SCNNode!
    private var cameraNode: SCNNode!

    private var initialTouchPoint: CGPoint?
    private var movementVector = SCNVector3Zero

    @Published public private(set) var gameOver = false

    override var nodes: [SCNNode] {
        [ballNode, cameraNode]
    }

    @Injected(\.dataService) private var dataService

    override init() {
        cameraNode = SCNNode()
        cameraNode.name = "Camera"
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 15, z: 0)
        cameraNode.eulerAngles = SCNVector3(-Float.pi / 2, 0, 0)

        let ball = SCNSphere(radius: 1.0)

        ball.firstMaterial?.diffuse.contents = XXColor.ball
        ball.firstMaterial?.transparency = 1.0

        ballNode = SCNNode(geometry: ball)
        ballNode.name = "Ball"
        ballNode.position = SCNVector3(x: 0, y: 1, z: 0)
        ballNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        ballNode.physicsBody?.mass = 1
        ballNode.physicsBody?.damping = 0.9

        super.init()
    }

    func setupGestureRecognizers(_ view: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGesture)
    }

    @objc
    func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view else { return }

        let location = gesture.location(in: view)

        switch gesture.state {
        case .began:
            initialTouchPoint = location
        case .changed:
            guard let initialPoint = initialTouchPoint else { return }

            let deltaX = Float(location.x - initialPoint.x)
            let deltaY = Float(location.y - initialPoint.y)

            let invertedDeltaY = -deltaY

            let maxDistance = Float(min(view.bounds.width, view.bounds.height) / 2)
            let distance = sqrt(deltaX * deltaX + invertedDeltaY * invertedDeltaY)
            let normalizedDistance = min(distance / maxDistance, 1.0)
            let angle = atan2(invertedDeltaY, deltaX)

            movementVector = SCNVector3(
                x: cos(angle) * normalizedDistance,
                y: 0,
                z: sin(angle) * normalizedDistance
            )
            movementVector.z = -movementVector.z
        case .cancelled, .ended, .failed:
            movementVector = SCNVector3Zero
            initialTouchPoint = nil
        default:
            break
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard !gameOver else { return }

        if movementVector.x != 0 || movementVector.z != 0 {
            let forceX = movementVector.x * dataService.ballSpeed
            let forceZ = movementVector.z * dataService.ballSpeed
            let force = SCNVector3(forceX, 0, forceZ)
            ballNode.physicsBody?.applyForce(force, asImpulse: true)
        }

        let ballPosition = ballNode.presentation.position
        let deltaX = ballPosition.x - cameraNode.position.x
        let deltaZ = ballPosition.z - cameraNode.position.z
        cameraNode.position.x += deltaX * dataService.cameraFollowSpeed
        cameraNode.position.z += deltaZ * dataService.cameraFollowSpeed

        if ballPosition.y < dataService.fallY { gameOver = true }
    }

    func reset() {
        ballNode.position = SCNVector3(x: 0, y: 1.1, z: 0)
        ballNode.physicsBody?.velocity = SCNVector3(x: 0, y: 0, z: 0)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) { [weak self] in
            self?.gameOver = false
        }
    }
}
