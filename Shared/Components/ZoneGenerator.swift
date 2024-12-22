import Combine
import DI
import SceneKit

class ZoneGenerator {
    private(set) var zones: [Zone] = []

    @Injected(\.dataService) private var dataService

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {}

    func regenerate() -> [Zone] {
        zones.forEach { $0.removeAll() }

        return generate()
    }
}

private extension ZoneGenerator {
    func generate() -> [Zone] {
        zones.removeAll()

        let zone = Zone(.multiplier, size: CGSize(width: 3, height: 3), position: SCNVector3Zero)
        zone.nodes.first?.position = SCNVector3Zero
        zones.append(zone)

        return zones
    }
}
