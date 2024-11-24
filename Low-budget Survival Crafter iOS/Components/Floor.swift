import UIKit
import SceneKit

class Floor {
    var floorNode: SCNNode!

    init() {
        // Floor Setup
        let floorGeometry = SCNPlane(width: 100, height: 100)

        // Load the texture image
        if let floorTexture = UIImage(named: "Art.scnassets/grass.jpg") {
            // Apply the texture to the floor's diffuse material
            floorGeometry.firstMaterial?.diffuse.contents = floorTexture

            // Repeat the texture across the floor
            let textureScale: CGFloat = 10.0
            floorGeometry.firstMaterial?.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(textureScale), Float(textureScale), 1)
            floorGeometry.firstMaterial?.diffuse.wrapS = .repeat
            floorGeometry.firstMaterial?.diffuse.wrapT = .repeat
        } else {
            print("Error: Could not load floor texture image.")
            floorGeometry.firstMaterial?.diffuse.contents = UIColor.systemPink
        }

        floorGeometry.firstMaterial?.transparency = 1.0

        floorNode = SCNNode(geometry: floorGeometry)
        floorNode.eulerAngles.x = -Float.pi / 2
        floorNode.position = SCNVector3(x: 0, y: 0, z: 0)
    }
}
