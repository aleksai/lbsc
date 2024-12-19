import UIKit

public protocol ClosureConfigurable: AnyObject {
    // Workaround to bypass Swift compiler check for protocol conformance with 'Self' in declarations
    associatedtype ObjectType = Self where ObjectType: AnyObject

    func configure(_ block: (ObjectType) -> Void) -> ObjectType
}

public extension ClosureConfigurable {
    func configure(_ block: (Self) -> Void) -> Self {
        block(self)

        return self
    }
}

extension UIView: ClosureConfigurable {}
