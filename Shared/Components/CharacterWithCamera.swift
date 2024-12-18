import SceneKit

class CharacterWithCamera: Component {
    private var ballNode: SCNNode!
    private var cameraNode: SCNNode!

    private var initialTouchPoint: CGPoint?
    private var movementVector = SCNVector3Zero

    private var cameraFollowSpeed: Float = 0.2
    private var gameOver = false

    override var nodes: [SCNNode] {
        [ballNode, cameraNode]
    }

    override init() {
        cameraNode = SCNNode()
        cameraNode.name = "camera"
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 15, z: 0)
        cameraNode.eulerAngles = SCNVector3(-Float.pi / 2, 0, 0)

        let sphere = SCNSphere(radius: 1.0)
        sphere.firstMaterial?.diffuse.contents = UIColor(red: 212 / 255, green: 122 / 255, blue: 1, alpha: 1)
        sphere.firstMaterial?.transparency = 1.0

        ballNode = SCNNode(geometry: sphere)
        ballNode.name = "ball"
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

        let speed: Float = 1

        if movementVector.x != 0 || movementVector.z != 0 {
            let forceX = movementVector.x * speed
            let forceZ = movementVector.z * speed
            let force = SCNVector3(forceX, 0, forceZ)
            ballNode.physicsBody?.applyForce(force, asImpulse: true)
        }

        let ballPosition = ballNode.presentation.position
        let deltaX = ballPosition.x - cameraNode.position.x
        let deltaZ = ballPosition.z - cameraNode.position.z
        cameraNode.position.x += deltaX * cameraFollowSpeed
        cameraNode.position.z += deltaZ * cameraFollowSpeed

        if ballPosition.y < -0.3 {
            gameOver = true
        }
    }
}
