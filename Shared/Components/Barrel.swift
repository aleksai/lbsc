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

        let barrelGeometry = SCNCylinder(radius: 1, height: 3)

        barrelGeometry.firstMaterial?.diffuse.contents = XXColor.barrel[kind] ?? .black
        barrelGeometry.firstMaterial?.transparency = 1.0

        barrelNode = SCNNode(geometry: barrelGeometry)
        barrelNode.name = "Barrel"

        barrelNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)

        let symbolImage = UIImage(systemName: "checkmark.circle")!.withTintColor(.white, renderingMode: .alwaysOriginal)
        let material = SCNMaterial()
        material.diffuse.contents = symbolImage

        let plane = SCNPlane(width: 1, height: 1)
        plane.materials = [material]

        checkmarkNode = SCNNode(geometry: plane)
        checkmarkNode.name = "BarrelCheckmark"
        checkmarkNode.eulerAngles.x = -Float.pi / 2
        checkmarkNode.position = SCNVector3(0, 1.51, 0)
        checkmarkNode.opacity = 0

        barrelNode.addChildNode(checkmarkNode)
    }
    
    func showCheckmark() {
        checkmarkNode.opacity = 1
    }
}
