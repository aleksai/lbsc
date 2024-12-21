import Combine
import DI
import SceneKit

class BarrelGenerator {
    private(set) var barrels: [Barrel] = []

    struct FallEvent: Event {
        let position: SCNVector3
        let barrelKind: Barrel.Kind
    }

    private let fallEventSubject = PassthroughSubject<FallEvent, Never>()
    var onBarrelFalling: AnyPublisher<FallEvent, Never> {
        fallEventSubject.eraseToAnyPublisher()
    }

    @Published public private(set) var falledBarrels: [Barrel.Kind: Int] = [:]

    @Injected(\.dataService) private var dataService

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        for barrel in barrels {
            guard let barrelPosition = barrel.nodes.first?.presentation.position else { continue }
            if barrelPosition.y < dataService.fallY {
                fallEventSubject.send(FallEvent(position: barrelPosition, barrelKind: barrel.kind))

                DispatchQueue.main.asyncAfter(deadline: .now() + 5) { barrel.removeAll() }
                falledBarrels[barrel.kind, default: 0] += dataService.normalBarrelFallScore
                barrels.removeAll { $0 === barrel }
            }
        }
    }

    func resetAndRegenerate() -> [Barrel] {
        barrels.forEach { $0.removeAll() }
        falledBarrels.removeAll()

        return generate()
    }
}

private extension BarrelGenerator {
    func generate(amount: Int = 20) -> [Barrel] {
        barrels.removeAll()

        for _ in 0 ..< amount {
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
