import Combine
import DI
import SceneKit

class ZoneGenerator {
    private(set) var zones: [Zone] = []

    private var cancellables: Set<AnyCancellable> = []

    struct ZoneCompleteEvent: Event {
        let position: SCNVector3
        let zone: Zone
    }

    private let zoneCompleteEventSubject = PassthroughSubject<ZoneCompleteEvent, Never>()
    var onZoneComplete: AnyPublisher<ZoneCompleteEvent, Never> {
        zoneCompleteEventSubject.eraseToAnyPublisher()
    }

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

        let zone = Zone(.multiplier, position: SCNVector3Zero, size: CGSize(width: 3, height: 3))
        zones.append(zone)

        zone.$complete.sink { [weak self] isComplete in
            guard isComplete else { return }
            self?.zoneCompleteEventSubject.send(ZoneCompleteEvent(position: zone.position, zone: zone))
        }.store(in: &cancellables)

        return zones
    }
}
