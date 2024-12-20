import DI
import SceneKit

class Barrel: Component {
    enum Kind {
        case normal
    }

    private var barrelNode: SCNNode!

    let kind: Kind

    override var nodes: [SCNNode] {
        [barrelNode]
    }

    init(kind: Kind) {
        self.kind = kind

        super.init()

        let barrelGeometry = SCNCylinder(radius: 1, height: 3)

        barrelGeometry.firstMaterial?.diffuse.contents = XXColor.barrel
        barrelGeometry.firstMaterial?.transparency = 1.0

        barrelNode = SCNNode(geometry: barrelGeometry)
        barrelNode.name = "Barrel"

        barrelNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
    }
}

class BarrelGenerator {
    private(set) var barrels: [Barrel] = []

    @Injected(\.dataService) var dataService

    @Published public private(set) var falledBarrels: [Barrel.Kind: Int] = [:]

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        for barrel in barrels {
            guard let barrelPositionY = barrel.nodes.first?.presentation.position.y else { continue }
            if barrelPositionY < dataService.fallY {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) { barrel.removeAll() }
                falledBarrels[barrel.kind, default: 0] += dataService.normalBarrelFallScore
                barrels.removeAll { $0 === barrel }
            }
        }
    }

    func reset() {
        falledBarrels.removeAll()
    }

    func generate(amount: Int = 1) -> [Barrel] {
        barrels.removeAll()

        for _ in 0 ..< amount + 1 {
            let barrel = Barrel(kind: .normal)
            barrel.nodes.first?.position = randomPositionOnFloor()
            barrels.append(barrel)
        }

        return barrels
    }

    func randomPositionOnFloor() -> SCNVector3 {
        let randomX = CGFloat.random(in: -dataService.floorSize.width / 2 + 5 ... dataService.floorSize.width / 2 - 5)
        let randomZ = CGFloat.random(in: -dataService.floorSize.height / 2 + 5 ... dataService.floorSize.height / 2 - 5)
        return SCNVector3(randomX, 1, randomZ)
    }
}
