import SceneKit

class FlyingTextEvent: Component {
    private var textNode: SCNNode!

    override var nodes: [SCNNode] {
        [textNode]
    }

    init(string: String, color: XXColor, position: SCNVector3) {
        super.init()

        let text = SCNText(string: string, extrusionDepth: 0)
        text.font = UIFont(name: "Helvetica-Bold", size: 1)
        text.flatness = 0.1

        text.firstMaterial?.diffuse.contents = color
        text.firstMaterial?.transparency = 1.0

        textNode = SCNNode(geometry: text)
        textNode.name = "EventText"
        textNode.eulerAngles.x = -Float.pi / 2
        textNode.position = position

        let min = text.boundingBox.min
        let max = text.boundingBox.max
        textNode.pivot = SCNMatrix4MakeTranslation((min.x + max.x) / 2, (min.y + max.y) / 2, (min.z + max.z) / 2)
    }

    override func addToScene(_ scene: SCNScene?) {
        super.addToScene(scene)

        let moveUpFadeOut = SCNAction.group([
            SCNAction.moveBy(x: 0, y: 3, z: 0, duration: 2.0),
            SCNAction.fadeOut(duration: 2.0)
        ])

        textNode.runAction(SCNAction.sequence([moveUpFadeOut, SCNAction.removeFromParentNode()]))
    }
}
