import Foundation

public extension XXLayoutConstraint {
    /// Sets the priority of the `NSLayoutConstraint` and returns the modified constraint.
    /// This method is useful for chaining when creating or modifying constraints.
    ///
    /// - Parameter priority: The `XXLayoutPriority` to be set for the constraint.
    /// - Returns: The modified `NSLayoutConstraint` with the updated priority.
    ///
    /// Usage:
    /// ```
    /// let constraint = NSLayoutConstraint(item: view1, attribute: .top, relatedBy: .equal, toItem: view2, attribute: .bottom, multiplier:
    /// 1, constant: 0).withPriority(.required)
    /// ```
    func withPriority(_ priority: XXLayoutPriority) -> XXLayoutConstraint {
        self.priority = priority
        return self
    }

    /// Creates a new `NSLayoutConstraint` with the specified multiplier, copying the other properties from the original constraint.
    ///
    /// - Parameter multiplier: The new multiplier value to be applied to the constraint.
    /// - Returns: A new `NSLayoutConstraint` instance with the updated multiplier.
    func withMultiplier(_ multiplier: CGFloat) -> XXLayoutConstraint {
        XXLayoutConstraint.deactivate([self])

        let newConstraint = XXLayoutConstraint(
            item: firstItem as Any,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant
        )

        newConstraint.shouldBeArchived = shouldBeArchived
        newConstraint.identifier = identifier
        newConstraint.priority = priority

        XXLayoutConstraint.activate([newConstraint])

        return newConstraint
    }
}
