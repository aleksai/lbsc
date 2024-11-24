import SceneKit
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow()

        let sceneView = GameScene(frame: .zero)
        let sceneViewController = SceneViewController(sceneView: sceneView)

        window?.rootViewController = sceneViewController
        window?.makeKeyAndVisible()

        return true
    }
}
