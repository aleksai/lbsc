import SceneKit

extension SCNNode {
    func stands(on plane: SCNNode) -> Bool {
        let position = presentation.position
        let planePosition = plane.presentation.boundingBox

        return
            position.x >= planePosition.min.x && position.x <= planePosition.max.x &&
            position.z >= planePosition.min.y && position.z <= planePosition.max.y
    }
}
