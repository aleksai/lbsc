import Combine
import UIKit

class GameSceneViewController: SceneViewController {
    override func loadView() {
        let view = UIView()

        view.addSubview(scene)

        let controls = ControlsView(state: scene.state as? GameSceneState)
        view.addSubview(controls)

        self.view = view
    }
}

private extension GameSceneViewController {
    class ControlsView: UIView {
        private var cancellables: Set<AnyCancellable> = []

        init(state: GameSceneState?) {
            super.init(frame: .zero)

            state?.$gameOver.sink { gameOver in
                print("!!!", gameOver)
            }.store(in: &cancellables)
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
