import Foundation

public extension DI {
    /// Creates a singleton instance of a given type `T`
    ///
    /// This method ensures that only a single instance of a given type `T` is created and returned across the entire application.
    ///
    /// - Parameters:
    ///   - instantiator: A closure that creates a new instance of the type `T`.
    /// - Returns: The singleton instance of the given type `T`.
    ///
    /// Usage example:
    /// ```
    /// class MySingleton {
    ///     func doSomething() {
    ///         print("Singleton instance")
    ///     }
    /// }
    ///
    /// extension DI {
    ///     var mySingleton: MySingleton {
    ///         singleton { MySingleton() }
    ///     }
    /// }
    ///
    /// @Injected(\.mySingleton) var singletonInstance
    /// singletonInstance.doSomething()
    /// ```
    func singleton<T>(
        _ file: StaticString = #filePath,
        _ line: UInt = #line,
        _ column: UInt = #column,
        _ instantiator: () -> T
    ) -> T {
        let identifier = "\(file)-\(line)-\(column)"

        return Self.singletons.sync { accessor in
            if let instance = accessor[identifier] as? T {
                return instance
            }

            let instance = instantiator()
            accessor[identifier] = instance

            return instance
        }
    }
}

extension DI {
    static let singletons = AtomicStore<String, Any>(identifier: "singletons")

    static func invalidateSingletons() {
        singletons.removeAll()
    }
}
