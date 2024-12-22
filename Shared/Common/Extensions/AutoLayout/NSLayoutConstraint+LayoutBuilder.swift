public extension XXLayoutConstraint {
    @discardableResult
    static func activate(@LayoutBuilder layout: () -> [XXLayoutConstraint]) -> [XXLayoutConstraint] {
        let constraints = layout()
        activate(constraints)

        return constraints
    }
}
