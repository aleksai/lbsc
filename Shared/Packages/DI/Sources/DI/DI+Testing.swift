import Foundation

public extension DI {
    /// Executes a test block of code, allowing you to use mocks for dependencies.
    ///
    /// After the block is executed, it invalidates all singletons and removes all registered mocks.
    ///
    /// - Parameter block: The test block of code to execute.
    ///
    /// Usage example:
    /// ```
    /// DI.test {
    ///     DI.mock(\.myService) { MyMockService() }
    ///     // Run your tests that depend on the mocked service
    /// }
    /// ```
    static func test(_ block: () throws -> Void) rethrows {
        isTesting = true
        try block()

        // Invalidate all singletons so nothing depends on mocked objects
        invalidateSingletons()

        unmockAll()

        isTesting = false
    }

    /// Registers a mock object for a given key path, to be used during testing.
    ///
    /// - Parameters:
    ///   - keyPath: The key path for the dependency to be mocked.
    ///   - handler: A closure that returns the mock instance.
    static func mock<T>(_ keyPath: KeyPath<DI, T>, handler: @escaping () -> T) {
        precondition(isTesting, "Mocks only available in tests")

        mocks[keyPath] = handler
    }

    /// Unregisters a mock object for a given key path.
    ///
    /// - Parameter keyPath: The key path for the dependency whose mock should be removed.
    static func unmock<T>(_ keyPath: KeyPath<DI, T>) {
        precondition(isTesting, "Mocks only available in tests")

        mocks[keyPath] = nil
    }

    /// Unregisters all mock objects.
    static func unmockAll() {
        precondition(isTesting, "Mocks only available in tests")

        mocks.removeAll()
    }
}

extension DI {
    static var isTesting = false
    static let mocks = AtomicStore<AnyKeyPath, () -> Any>(identifier: "mocks")
}
