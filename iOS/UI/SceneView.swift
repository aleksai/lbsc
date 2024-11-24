import SceneKit
import UIKit

class SceneView: SCNView {
    private var displayLink: CADisplayLink?

    override init(frame: CGRect, options: [String: Any]? = nil) {
        super.init(frame: frame, options: options)

        setupScene()
        setupGestureRecognizers()
        setupDisplayLink()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupScene()
        setupGestureRecognizers()
        setupDisplayLink()
    }

    deinit {
        displayLink?.invalidate()
        displayLink = nil
    }

    func setupScene() {
        let scene = SCNScene()
        self.scene = scene

        backgroundColor = .white

        allowsCameraControl = false
        showsStatistics = false
        autoenablesDefaultLighting = true
    }

    func setupGestureRecognizers() {}

    func setupDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateDisplay))
        displayLink?.add(to: .main, forMode: .default)
    }

    @objc func updateDisplay() {}
}
