import SceneKit

extension SCNMatrix4 {
    static func pivot(for box: (min: SCNVector3, max: SCNVector3)) -> SCNMatrix4 {
        SCNMatrix4MakeTranslation((box.min.x + box.max.x) / 2, (box.min.y + box.max.y) / 2, (box.min.z + box.max.z) / 2)
    }

    static func pivot(for height: Float) -> SCNMatrix4 {
        SCNMatrix4MakeTranslation(0, -height / 2, 0)
    }
}
