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
    @Published public private(set) var zonedBarrels: [Zone.Kind: Int] = [:]

    @Injected(\.dataService) private var dataService

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        for barrel in barrels {
            let position = barrel.main.presentation.position
            if position.y < dataService.fallY {
                fallEventSubject.send(FallEvent(position: position, barrelKind: barrel.kind))

                DispatchQueue.main.asyncAfter(deadline: .now() + 5) { barrel.removeAll() }
                falledBarrels[barrel.kind, default: 0] += 1
                barrels.removeAll { $0 === barrel }
            }
        }
    }

    func regenerate() -> [Barrel] {
        barrels.forEach { $0.removeAll() }
        falledBarrels.removeAll()

        return generate()
    }
}

private extension BarrelGenerator {
    func generate() -> [Barrel] {
        barrels.removeAll()

        append(10, of: .normal)
        append(10, of: .zone)

        return barrels
    }

    func append(_ amount: Int, of kind: Barrel.Kind) {
        for _ in 0 ..< amount {
            let barrel = Barrel(kind: kind)
            barrel.nodes.first?.position = randomPositionOnFloor()
            barrels.append(barrel)
        }
    }

    func randomPositionOnFloor() -> SCNVector3 {
        let randomX = CGFloat.random(in: -dataService.floorSize.width / 2 + 5 ... dataService.floorSize.width / 2 - 5)
        let randomZ = CGFloat.random(in: -dataService.floorSize.height / 2 + 5 ... dataService.floorSize.height / 2 - 5)
        return SCNVector3(randomX, 2.5, randomZ)
    }
}
