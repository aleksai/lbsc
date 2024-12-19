#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public protocol XXLayoutAnchorProvider {
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
}

extension XXView: XXLayoutAnchorProvider {}
extension XXLayoutGuide: XXLayoutAnchorProvider {}

public extension XXLayoutAnchorProvider {
    func constraintsForAnchoring(boundsTo view: XXLayoutAnchorProvider, inset: NSDirectionalEdgeInsets = .zero) -> [NSLayoutConstraint] {
        return [
            topAnchor.constraint(equalTo: view.topAnchor, constant: inset.top),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset.leading),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset.bottom),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset.trailing)
        ]
    }

    func constraintsForAnchoring(centerTo view: XXLayoutAnchorProvider, offset: CGPoint = .zero) -> [NSLayoutConstraint] {
        return [
            centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: offset.x),
            centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offset.y)
        ]
    }

    func constraintsForAnchoring(horizontallyTo view: XXLayoutAnchorProvider, inset: CGFloat = 0) -> [NSLayoutConstraint] {
        return [
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset)
        ]
    }

    func constraintsForAnchoring(verticallyTo view: XXLayoutAnchorProvider, inset: CGFloat = 0) -> [NSLayoutConstraint] {
        return [
            topAnchor.constraint(equalTo: view.topAnchor, constant: inset),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset)
        ]
    }

    func constraintsForAnchoring(sizeToConstant size: CGSize) -> [NSLayoutConstraint] {
        return [
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height)
        ]
    }

    func constraintsForAnchoring(sizeGreaterThanOrEqualToConstant size: CGSize) -> [NSLayoutConstraint] {
        return [
            widthAnchor.constraint(greaterThanOrEqualToConstant: size.width),
            heightAnchor.constraint(greaterThanOrEqualToConstant: size.height)
        ]
    }
}

public extension NSDirectionalEdgeInsets {
    #if os(macOS)
    static let zero = NSDirectionalEdgeInsetsZero
    #endif

    static func all(_ value: CGFloat) -> NSDirectionalEdgeInsets {
        return NSDirectionalEdgeInsets(top: value, leading: value, bottom: value, trailing: value)
    }

    init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }
}
