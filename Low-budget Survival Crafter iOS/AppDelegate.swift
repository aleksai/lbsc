import UIKit
import SceneKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()

        let sceneView = GameScene(frame: .zero)
        let sceneViewController = SceneViewController(sceneView: sceneView)

        window?.rootViewController = sceneViewController
        window?.makeKeyAndVisible()

        return true
    }
}
