import SceneKit

class FlyingEvent: Component {
    private var eventNode: SCNNode!

    override var nodes: [SCNNode] {
        [eventNode]
    }

    init(string: String, color: XXColor, position: SCNVector3) {
        super.init()

        let event = SCNText(string: string, extrusionDepth: 0)
        event.font = .systemFont(ofSize: 1, weight: .heavy)

        event.firstMaterial?.diffuse.contents = color
        event.firstMaterial?.transparency = 1.0

        eventNode = SCNNode(geometry: event)
        eventNode.name = "Event"
        eventNode.eulerAngles.x = -Float.pi / 2
        eventNode.position = position
    }

    override func addToScene(_ scene: SCNScene?) {
        super.addToScene(scene)

        let moveUp = SCNAction.moveBy(x: 0, y: 3, z: 0, duration: 2.0)
        let fadeOut = SCNAction.fadeOut(duration: 2.0)

        let groupAction = SCNAction.group([moveUp, fadeOut])
        let removeAction = SCNAction.removeFromParentNode()
        let sequence = SCNAction.sequence([groupAction, removeAction])

        eventNode.runAction(sequence)
    }
}
