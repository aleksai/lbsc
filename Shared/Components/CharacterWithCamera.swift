import SceneKit

class CharacterWithCamera: Component {
    private var boxNode: SCNNode!
    private var cameraNode: SCNNode!

    private var initialTouchPoint: CGPoint?
    private var movementVector = SCNVector3Zero

    private var cameraFollowSpeed: Float = 0.2

    override var nodes: [SCNNode] {
        [boxNode, cameraNode]
    }

    override init() {
        // Camera Setup
        cameraNode = SCNNode()
        cameraNode.name = "camera"
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 15, z: 0)
        cameraNode.eulerAngles = SCNVector3(-Float.pi / 2, 0, 0)

        // Box Setup
        let box = SCNBox(width: 2, height: 2, length: 2, chamferRadius: 0)
        box.firstMaterial?.diffuse.contents = XXColor(red: 212 / 255, green: 122 / 255, blue: 1, alpha: 1)
        box.firstMaterial?.transparency = 1.0

        boxNode = SCNNode(geometry: box)
        boxNode.name = "box"
        boxNode.position = SCNVector3(x: 0, y: 1, z: 0)
        boxNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        boxNode.physicsBody?.mass = 1
        boxNode.physicsBody?.damping = 0.9
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

    @objc func updateDisplay() {
        let deltaTime: Float = 1.0 / 60.0
        let speed: Float = 10.0

        if movementVector.x != 0 || movementVector.y != 0 || movementVector.z != 0 {
            let deltaX = Float(movementVector.x) * speed * deltaTime
            let deltaZ = Float(movementVector.z) * speed * deltaTime

            boxNode.position.x += deltaX
            boxNode.position.z += deltaZ
        }

        let deltaX = boxNode.position.x - cameraNode.position.x
        let deltaZ = boxNode.position.z - cameraNode.position.z

        cameraNode.position.x += deltaX * cameraFollowSpeed
        cameraNode.position.z += deltaZ * cameraFollowSpeed
    }
}
