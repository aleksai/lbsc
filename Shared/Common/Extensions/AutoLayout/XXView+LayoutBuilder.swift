public extension XXView {
    @discardableResult
    func addSubview(_ view: XXView, @LayoutBuilder layout: () -> [XXLayoutConstraint]) -> [XXLayoutConstraint] {
        return addSubviews(view, layout: layout)
    }

    @discardableResult
    func addSubviews(_ views: XXView..., @LayoutBuilder layout: () -> [XXLayoutConstraint]) -> [XXLayoutConstraint] {
        addSubviews(views, layout: layout)
    }

    @discardableResult
    func addSubviews(_ views: [XXView], @LayoutBuilder layout: () -> [XXLayoutConstraint]) -> [XXLayoutConstraint] {
        for view in views {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        return XXLayoutConstraint.activate(layout: layout)
    }

    @discardableResult
    func addLayoutGuide(_ guide: XXLayoutGuide, @LayoutBuilder layout: () -> [XXLayoutConstraint]) -> [XXLayoutConstraint] {
        addLayoutGuide(guide)

        return XXLayoutConstraint.activate(layout: layout)
    }
}

public extension XXView {
    func addSubviews(_ subviews: [XXView]) {
        subviews.forEach { addSubview($0) }
    }

    func addSubviews(_ subviews: XXView...) {
        subviews.forEach { addSubview($0) }
    }
}
