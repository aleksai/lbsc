import DI
import SceneKit

class Barrel: Component {
    enum Kind: CaseIterable {
        case normal
        case zone
    }

    let kind: Kind

    private var barrelNode: SCNNode!
    private var checkmarkNode: SCNNode!

    override var nodes: [SCNNode] {
        [barrelNode]
    }

    init(kind: Kind) {
        self.kind = kind

        super.init()

        let barrel = SCNCylinder(radius: 1, height: 3)

        barrel.firstMaterial?.diffuse.contents = XXColor.barrel[kind] ?? .black
        barrel.firstMaterial?.transparency = 1.0

        barrelNode = SCNNode(geometry: barrel)
        barrelNode.name = "Barrel"

        barrelNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)

        let checkmarkMaterial = SCNMaterial()
        checkmarkMaterial.diffuse.contents = UIImage(systemName: "checkmark")!

        let checkmark = SCNPlane(width: 0.6, height: 0.6)
        checkmark.materials = [checkmarkMaterial]

        checkmarkNode = SCNNode(geometry: checkmark)
        checkmarkNode.name = "BarrelCheckmark"
        checkmarkNode.eulerAngles.x = -Float.pi / 2
        checkmarkNode.position = SCNVector3(0, 1.501, 0)
        checkmarkNode.opacity = 0

        barrelNode.addChildNode(checkmarkNode)
    }

    func showCheckmark(_ show: Bool) {
        checkmarkNode.opacity = show ? 1 : 0
    }
}
