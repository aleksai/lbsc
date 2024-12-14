import Foundation

/// `Injected` is a property wrapper that simplifies the process of injecting dependencies
/// from the `DI` container.
///
/// `Injected` allows you to access dependencies by key path, and supports
/// both direct access and factory-based instantiation with arguments.
///
/// Usage example:
/// ```
/// class MyClass {
///     @Injected(\.myService) private var myService
///     @Injected(\.myServiceFactory) private var myServiceFactory
///
///     func useService() {
///         myService.doSomething()
///         let anotherServiceInstance = myServiceFactory("argument")
///     }
/// }
/// ```
@propertyWrapper
public class Injected<T> {
    private let instance: () -> T
    public private(set) lazy var wrappedValue = instance()

    /// Initializes the property wrapper for a dependency available through a key path.
    ///
    /// - Parameter keyPath: The key path for the dependency in the `DI` container.
    public init(_ keyPath: KeyPath<DI, T>) {
        instance = { DI.shared[keyPath] }
    }

    /// Initializes the property wrapper for a dependency factory available through a key path.
    ///
    /// - Parameters:
    ///   - keyPath: The key path for the dependency factory in the `DI` container.
    ///   - args: The arguments to pass to the factory when creating the dependency instance.
    public init<ARGS>(_ keyPath: KeyPath<DI, Factory<T, ARGS>>, _ args: ARGS) {
        instance = { DI.shared[keyPath].instantiate(args) }
    }
}

public extension Injected {
    func callAsFunction<U, ARGS>(_ args: ARGS) -> U where T == Factory<U, ARGS> {
        wrappedValue(args)
    }
}
