import DI
import SceneKit

class Barrel: Component {
    private var barrelNode: SCNNode!

    override var nodes: [SCNNode] {
        [barrelNode]
    }

    override init() {
        let barrelGeometry = SCNCylinder(radius: 1, height: 3)

        barrelGeometry.firstMaterial?.diffuse.contents = XXColor.systemBlue
        barrelGeometry.firstMaterial?.transparency = 1.0

        barrelNode = SCNNode(geometry: barrelGeometry)
        barrelNode.name = "barrel"

        barrelNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
    }
}

class BarrelGenerator {
    private(set) var barrels: [Barrel] = []

    @Injected(\.dataService) var dataService

    func generate(amount: Int = 1) {
        for _ in 0 ..< amount + 1 {
            let barrel = Barrel()
            barrel.nodes.first?.position = randomPositionOnFloor()
            barrels.append(barrel)
        }
    }

    func randomPositionOnFloor() -> SCNVector3 {
        let randomX = CGFloat.random(in: -dataService.floorSize.width / 2 + 5 ... dataService.floorSize.width / 2 - 5)
        let randomZ = CGFloat.random(in: -dataService.floorSize.height / 2 + 5 ... dataService.floorSize.height / 2 - 5)
        return SCNVector3(randomX, 1, randomZ)
    }
}
