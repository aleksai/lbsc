import SceneKit

// import UIKit

class Floor: Component {
    private var floorNode: SCNNode!

    override var nodes: [SCNNode] {
        [floorNode]
    }

    override init() {
        let floorGeometry = SCNPlane(width: 100, height: 100)

        if let floorTexture = XXImage(named: "Art.scnassets/grass.jpg") {
            floorGeometry.firstMaterial?.diffuse.contents = floorTexture

            let textureScale: Float = 8.0
            floorGeometry.firstMaterial?.diffuse.contentsTransform = SCNMatrix4MakeScale(textureScale, textureScale, 1)
            floorGeometry.firstMaterial?.diffuse.wrapS = .repeat
            floorGeometry.firstMaterial?.diffuse.wrapT = .repeat
        } else {
            print("Error: Could not load floor texture image.")
            floorGeometry.firstMaterial?.diffuse.contents = XXColor.systemPink
        }

        floorGeometry.firstMaterial?.transparency = 1.0

        floorNode = SCNNode(geometry: floorGeometry)
        floorNode.eulerAngles.x = -Float.pi / 2
        floorNode.position = SCNVector3(x: 0, y: 0, z: 0)
    }
}
