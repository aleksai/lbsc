import DI
import SceneKit

class FloorZone: Component {
    enum Kind: CaseIterable {
        case multiplier
    }

    private var zoneNode: SCNNode!
    private var textNode: SCNNode!

    override var nodes: [SCNNode] {
        [zoneNode, textNode]
    }

    init(_ kind: Kind, size: CGSize, position: SCNVector3) {
        super.init()

        let zone = SCNPlane(width: size.width, height: size.height)
        zone.firstMaterial?.diffuse.contents = XXColor.zone[kind] ?? XXColor.white
        zone.firstMaterial?.transparency = 1.0

        zoneNode = SCNNode(geometry: zone)
        zoneNode.name = "Zone"
        zoneNode.eulerAngles.x = -Float.pi / 2
        zoneNode.position = position

        let text = SCNText(string: textForZoneWithSize(kind, size: size), extrusionDepth: 0.1)
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

private extension FloorZone {
    func textForZoneWithSize(_ kind: Kind, size: CGSize) -> String {
        @Injected(\.dataService) var dataService
        let score = dataService.zoneScore[kind] ?? 0
        let maxScore = Int(size.width) / 2 * Int(size.height) / 2 * score
        return "\(maxScore > 0 ? "+" : "")\(maxScore)"
    }
}
