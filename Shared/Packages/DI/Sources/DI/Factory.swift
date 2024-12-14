import Foundation

/// `Factory` is a generic struct that represents a factory pattern for creating instances
/// of type `T` with arguments of type `ARGS`.
///
/// Usage example:
/// ```
/// struct MyDependency {
///     let value: String
/// }
///
/// extension DI {
///     var myDependencyFactory: Factory<MyDependency, String> {
///         Factory { value in MyDependency(value: value) }
///     }
/// }
///
/// // Use the factory to create instances of MyDependency
/// let instance = Injected(\.myDependencyFactory)("Hello")
/// ```
public struct Factory<T, ARGS> {
    let instantiate: (ARGS) -> T

    /// Initializes the `Factory` struct with a closure that takes arguments of type `ARGS` and
    /// returns an instance of type `T`.
    ///
    /// - Parameter instantiate: The closure responsible for instantiating the object of type `T` with arguments of type `ARGS`.
    public init(instantiate: @escaping (ARGS) -> T) {
        self.instantiate = instantiate
    }

    public func callAsFunction(_ args: ARGS) -> T {
        instantiate(args)
    }
}
