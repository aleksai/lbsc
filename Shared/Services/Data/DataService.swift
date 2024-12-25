import Foundation

public struct DataService {
    let floorSize: CGSize = .init(width: 12, height: 12)

    let ballSpeed: Float = 1.0
    let cameraFollowSpeed: Float = 0.2

    let fallY: Float = -0.3

    let fallScore: [Barrel.Kind: Int] = [
        .normal: 100,
        .zone: -100
    ]

    let zoneScore: [Zone.Kind: Int] = [
        .multiplier: 200
    ]
}
