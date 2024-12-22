import DI
import SceneKit

class FloorZone: Component {
    private var zoneNode: SCNNode!
    private var textNode: SCNNode!

    override var nodes: [SCNNode] {
        [zoneNode, textNode]
    }

    init(text: String, width: CGFloat, height: CGFloat, color: XXColor, position: SCNVector3) {
        super.init()

        let zone = SCNPlane(width: width, height: height)
        zone.firstMaterial?.diffuse.contents = color
        zone.firstMaterial?.transparency = 1.0

        zoneNode = SCNNode(geometry: zone)
        zoneNode.name = "Zone"
        zoneNode.eulerAngles.x = -Float.pi / 2
        zoneNode.position = position

        let text = SCNText(string: text, extrusionDepth: 0.1)
        text.font = UIFont(name: "Helvetica-Bold", size: 1.75)
        text.flatness = 0.01

        textNode = SCNNode(geometry: text)
        textNode.name = "ZoneText"
        textNode.eulerAngles.x = -Float.pi / 2
        textNode.position = position

        let min = text.boundingBox.min
        let max = text.boundingBox.max
        textNode.pivot = SCNMatrix4MakeTranslation((min.x + max.x) / 2, (min.y + max.y) / 2, (min.z + max.z) / 2)
    }
}
