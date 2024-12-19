import UIKit

@resultBuilder
public enum LayoutBuilder {
    public static func buildBlock(_ components: ConstraintGroup...) -> [NSLayoutConstraint] {
        return components.flatMap { $0.constraints }
    }

    public static func buildOptional(_ component: [ConstraintGroup]?) -> [NSLayoutConstraint] {
        return component?.flatMap { $0.constraints } ?? []
    }

    public static func buildEither(first component: [ConstraintGroup]) -> [NSLayoutConstraint] {
        return component.flatMap { $0.constraints }
    }

    public static func buildEither(second component: [ConstraintGroup]) -> [NSLayoutConstraint] {
        return component.flatMap { $0.constraints }
    }
}

public protocol ConstraintGroup {
    var constraints: [NSLayoutConstraint] { get }
}

extension NSLayoutConstraint: ConstraintGroup {
    public var constraints: [NSLayoutConstraint] { [self] }
}

extension Array: ConstraintGroup where Element == NSLayoutConstraint {
    public var constraints: [NSLayoutConstraint] { self }
}
