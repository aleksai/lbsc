import Combine
import UIKit

class GameSceneViewController: SceneViewController {
    override func loadView() {
        let view = UIView()

        let controls = ControlsView(state: scene.state as? GameSceneState)

        view.addSubviews(scene, controls) {
            scene.constraintsForAnchoring(boundsTo: view)
            controls.constraintsForAnchoring(boundsTo: view)
        }

        self.view = view
    }
}

private extension GameSceneViewController {
    class ControlsView: UIView {
        private var cancellables: Set<AnyCancellable> = []

        private lazy var scoreLabel = UILabel().configure { label in
            label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            label.textColor = .red
            label.textAlignment = .center
            label.text = "Score: 0"
            label.translatesAutoresizingMaskIntoConstraints = false
        }

        private lazy var gameOverLabel = UILabel().configure { label in
            label.text = "GAME OVER"
            label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
            label.textColor = .red
            label.textAlignment = .center
            label.numberOfLines = 1
            label.translatesAutoresizingMaskIntoConstraints = false
            label.isHidden = true
        }

        private lazy var startOverButton = UIButton(type: .system).configure { button in
            button.setTitle("Start Over", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
            button.setTitleColor(.red, for: .normal)
            button.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
            button.layer.cornerRadius = 8
            button.translatesAutoresizingMaskIntoConstraints = false
            button.isHidden = true
            button.addTarget(self, action: #selector(didTapStartOver), for: .touchUpInside)
        }

        init(state: GameSceneState?) {
            super.init(frame: .zero)

            addSubviews(scoreLabel, gameOverLabel, startOverButton) {
                scoreLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
                scoreLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20)

                gameOverLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
                gameOverLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -30)

                startOverButton.centerXAnchor.constraint(equalTo: centerXAnchor)
                startOverButton.topAnchor.constraint(equalTo: gameOverLabel.bottomAnchor, constant: 20)
                startOverButton.widthAnchor.constraint(equalToConstant: 200)
                startOverButton.heightAnchor.constraint(equalToConstant: 50)
            }

            state?.$gameOver
                .receive(on: RunLoop.main)
                .sink { [weak self] gameOver in
                    self?.gameOverLabel.isHidden = !gameOver
                    self?.startOverButton.isHidden = !gameOver
                }
                .store(in: &cancellables)

//            state?.$score
//                .receive(on: RunLoop.main)
//                .sink { [weak self] newScore in
//                    self?.scoreLabel.text = "Score: \(newScore)"
//                }
//                .store(in: &cancellables)
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        @objc private func didTapStartOver() {}

        override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            let hitView = super.hitTest(point, with: event)
            if hitView == self { return nil }
            return hitView
        }
    }
}
