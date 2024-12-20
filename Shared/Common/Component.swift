import SceneKit

class Component {
    var nodes: [SCNNode] { [] }

    func addToScene(_ scene: SCNScene?) {
        for node in nodes {
            scene?.rootNode.addChildNode(node)
        }
    }

    func removeAll() {
        for node in nodes {
            node.removeFromParentNode()
        }
    }
}
