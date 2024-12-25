import DI
import SceneKit

class Floor: Component {
    struct Coords: Hashable {
        let x: Int
        let y: Int
    }

    private var floorNode: SCNNode!
    private var floorNodes: [Coords: SCNNode] = [:]

    override var nodes: [SCNNode] {
        [floorNode]
    }

    override init() {
        @Injected(\.dataService) var dataService

        floorNode = SCNNode()
        floorNode.name = "Floor"

        let width = Int(dataService.floorSize.width)
        let height = Int(dataService.floorSize.height)

        let halfWidth = width / 2
        let halfHeight = height / 2

        for x in -halfWidth ..< halfWidth {
            for y in -halfHeight ..< halfHeight {
                let plane = SCNPlane(width: 2, height: 2)
                plane.firstMaterial?.diffuse.contents = XXColor.floor
                plane.firstMaterial?.transparency = 1

                let planeNode = SCNNode(geometry: plane)
                planeNode.eulerAngles.x = -Float.pi / 2
                planeNode.position = SCNVector3(Float(x * 2), 0, Float(y * 2))

                planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)

                floorNode.addChildNode(planeNode)
                floorNodes[Coords(x: x, y: y)] = planeNode
            }
        }

        floorNode.position = SCNVector3Zero
    }

    // swiftlint:disable:next function_body_length
    func openShutters(position: Coords, size: CGSize, withClose: Bool = false) {
        let minX = position.x - Int(size.width) / 2
        let maxX = position.x + Int(size.width) / 2
        let minY = position.y - Int(size.height) / 2
        let maxY = position.y + Int(size.height) / 2

        for x in minX ... maxX {
            for y in minY ... maxY {
                floorNodes[Coords(x: x, y: y)]?.isHidden = true
            }
        }

        let doorWidth = CGFloat(maxX - minX + 1) * 2.0
        let doorHeight = doorWidth

        let centerX = Float(minX + maxX) / 2.0 * 2.0
        let centerZ = Float(minY + maxY) / 2.0 * 2.0

        let leftDoorPivotNode = SCNNode()
        leftDoorPivotNode.name = "LeftDoorPivot"

        let leftEdgeX = centerX - Float(doorWidth / 2)
        leftDoorPivotNode.position = SCNVector3(leftEdgeX, 0, centerZ)

        floorNode.addChildNode(leftDoorPivotNode)

        let leftDoorGeometry = SCNPlane(width: doorWidth / 2, height: doorHeight)
        leftDoorGeometry.firstMaterial?.diffuse.contents = XXColor.floor

        let leftDoorNode = SCNNode(geometry: leftDoorGeometry)
        leftDoorNode.name = "LeftDoor"

        leftDoorNode.eulerAngles.x = -Float.pi / 2
        leftDoorNode.position.x = Float(doorWidth / 4)

        leftDoorPivotNode.addChildNode(leftDoorNode)

        let rightDoorPivotNode = SCNNode()
        rightDoorPivotNode.name = "RightDoorPivot"

        let rightEdgeX = centerX + Float(doorWidth / 2)
        rightDoorPivotNode.position = SCNVector3(rightEdgeX, 0, centerZ)

        floorNode.addChildNode(rightDoorPivotNode)

        let rightDoorGeometry = SCNPlane(width: doorWidth / 2, height: doorHeight)
        rightDoorGeometry.firstMaterial?.diffuse.contents = XXColor.floor

        let rightDoorNode = SCNNode(geometry: rightDoorGeometry)
        rightDoorNode.name = "RightDoor"

        rightDoorNode.eulerAngles.x = -Float.pi / 2

        rightDoorNode.position.x = -Float(doorWidth / 4)

        rightDoorPivotNode.addChildNode(rightDoorNode)

        let rotateDuration = 1.0

        let openLeft = SCNAction.rotateBy(x: 0, y: 0, z: -CGFloat.pi / 2, duration: rotateDuration)
        let openRight = SCNAction.rotateBy(x: 0, y: 0, z: CGFloat.pi / 2, duration: rotateDuration)

        let openDoorsAction = SCNAction.run { _ in
            leftDoorPivotNode.runAction(openLeft)
            rightDoorPivotNode.runAction(openRight)
        }

        if withClose {
            let closeLeft = SCNAction.rotateBy(x: 0, y: 0, z: CGFloat.pi / 2, duration: rotateDuration)
            let closeRight = SCNAction.rotateBy(x: 0, y: 0, z: -CGFloat.pi / 2, duration: rotateDuration)

            let closeDoorsAction = SCNAction.run { _ in
                leftDoorPivotNode.runAction(closeLeft)
                rightDoorPivotNode.runAction(closeRight)
            }

            let showTilesAction = SCNAction.run { [weak self] _ in
                guard let self = self else { return }
                for x in minX ... maxX {
                    for y in minY ... maxY {
                        self.floorNodes[Coords(x: x, y: y)]?.isHidden = false
                    }
                }
            }

            let removeDoorsAction = SCNAction.run { _ in
                leftDoorPivotNode.removeFromParentNode()
                rightDoorPivotNode.removeFromParentNode()
            }

            floorNode.runAction(SCNAction.sequence([
                openDoorsAction,
                .wait(duration: rotateDuration),
                .wait(duration: 2.0),
                closeDoorsAction,
                .wait(duration: rotateDuration),
                showTilesAction,
                removeDoorsAction
            ]))
        } else {
            floorNode.runAction(SCNAction.sequence([
                openDoorsAction,
                .wait(duration: rotateDuration)
            ]))
        }
    }
}
