import DI
import SceneKit

class Zone: Component {
    enum Kind {
        case multiplier
    }

    let id: String = UUID().uuidString
    let kind: Kind
    let position: SCNVector3
    let size: CGSize
    let required: Int

    private var standingBarrels: [Barrel] = [] {
        didSet {
            complete = standingBarrels.count == required
        }
    }

    private var zoneNode: SCNNode!
    private var textNode: SCNNode!

    override var nodes: [SCNNode] {
        [zoneNode]
    }

    @Published public private(set) var complete = false

    init(_ kind: Kind, position: SCNVector3, size: CGSize) {
        self.kind = kind
        self.position = position
        self.size = size

        required = Int(size.width * size.height)

        super.init()

        let zone = SCNPlane(width: size.width * 2, height: size.height * 2)
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

        textNode.pivot = .pivot(for: text.boundingBox)

        zoneNode.addChildNode(textNode)
    }

    func checkBarrel(_ barrel: Barrel) {
        let stands = barrel.main.stands(on: main)
        let zoned = stands && kind == .multiplier

        barrel.showCheckmark(zoned)

        if zoned {
            if !standingBarrels.contains(where: { $0.id == barrel.id }) {
                standingBarrels.append(barrel)
            }
        } else {
            if let index = standingBarrels.firstIndex(where: { $0.id == barrel.id }) {
                standingBarrels.remove(at: index)
            }
        }
    }

    func completeZone() {
        let fadeOut = SCNAction.fadeOut(duration: 1.0)
        fadeOut.timingMode = .easeInEaseOut

        let scaleDown = SCNAction.scale(to: 0.0, duration: 1.0)
        scaleDown.timingMode = .easeInEaseOut

        let group = SCNAction.group([fadeOut, scaleDown])

        let removeNode = SCNAction.removeFromParentNode()
        let sequence = SCNAction.sequence([group, removeNode])

        zoneNode.runAction(sequence)
    }
}

private extension Zone {
    func textForZoneWithSize(_ kind: Kind, size: CGSize) -> String {
        @Injected(\.dataService) var dataService
        let score = dataService.zoneScore[kind] ?? 0
        let maxScore = Int(size.width) * Int(size.height) * score
        return "\(maxScore > 0 ? "+" : "")\(maxScore)"
    }
}
