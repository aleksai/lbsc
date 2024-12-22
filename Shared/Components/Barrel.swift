import DI
import SceneKit

class Barrel: Component {
    enum Kind: CaseIterable {
        case normal
        case zone
    }

    let kind: Kind

    private var barrelNode: SCNNode!

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
    }
}
