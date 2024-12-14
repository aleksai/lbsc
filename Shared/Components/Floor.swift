import DI
import SceneKit

class Floor: Component {
    private var floorNode: SCNNode!

    override var nodes: [SCNNode] {
        [floorNode]
    }

    override init() {
        @Injected(\.dataService) var dataService

        let floorGeometry = SCNPlane(width: dataService.floorSize.width, height: dataService.floorSize.height)

        floorGeometry.firstMaterial?.diffuse.contents = XXColor.white

//        if let floorTexture = XXImage(named: "Art.scnassets/grass.jpg") {
//            floorGeometry.firstMaterial?.diffuse.contents = floorTexture
//
//            let textureScale: Float = 8.0
//            floorGeometry.firstMaterial?.diffuse.contentsTransform = SCNMatrix4MakeScale(textureScale, textureScale, 1)
//            floorGeometry.firstMaterial?.diffuse.wrapS = .repeat
//            floorGeometry.firstMaterial?.diffuse.wrapT = .repeat
//        } else {
//            print("Error: Could not load floor texture image.")
//        }

        floorGeometry.firstMaterial?.transparency = 1.0

        floorNode = SCNNode(geometry: floorGeometry)
        floorNode.eulerAngles.x = -Float.pi / 2
        floorNode.position = SCNVector3(x: 0, y: 0, z: 0)
        floorNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
    }
}
