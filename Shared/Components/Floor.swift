import DI
import SceneKit

class Floor: Component {
    private var floorNode: SCNNode!

    override var nodes: [SCNNode] {
        [floorNode]
    }

    override init() {
        @Injected(\.dataService) var dataService

        let floor = SCNPlane(width: dataService.floorSize.width, height: dataService.floorSize.height)

        floor.firstMaterial?.diffuse.contents = XXColor.floor
        floor.firstMaterial?.transparency = 1.0

        floorNode = SCNNode(geometry: floor)
        floorNode.name = "Floor"
        floorNode.eulerAngles.x = -Float.pi / 2
        floorNode.position = SCNVector3Zero
        floorNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
    }
}
