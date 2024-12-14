import Foundation

/// `SharedConfiguration` is a class that facilitates managing a shared configuration object of type `T`.
///
/// This class ensures that the configuration object can be set only once to prevent unintended modifications.
/// The class also supports dynamic member lookup, allowing you to directly access the properties of the
/// shared configuration object using key paths.
///
/// Usage example:
/// ```
/// struct AppConfig {
///     let baseURL: URL
/// }
///
/// let sharedConfig = SharedConfiguration<AppConfig>()
///
/// // Set the shared configuration
/// sharedConfig.set(AppConfig(baseURL: URL(string: "https://example.com")!))
///
/// // Access the properties of the shared configuration using dynamic member lookup
/// let baseURL = sharedConfig.baseURL
/// ```
@dynamicMemberLookup
public class SharedConfiguration<T> {
    private var shared: T?

    /// Retrieves the shared configuration object.
    ///
    /// - Returns: The shared configuration object of type T.
    /// - Throws: If the configuration object has not been defined.
    public func get() -> T {
        guard let configuration = shared else {
            fatalError("\(String(describing: T.self)) must be defined")
        }

        return configuration
    }

    /// Sets the shared configuration object.
    ///
    /// - Parameter configuration: The shared configuration object of type T.
    /// - Throws: If the configuration object has already been set.
    public func set(_ configuration: T) {
        guard shared == nil else {
            fatalError("\(String(describing: T.self)) can be set only once")
        }

        shared = configuration
    }

    /// Initializes an empty `SharedConfiguration` object.
    public init() {}

    /// Accesses the properties of the shared configuration object using dynamic member lookup.
    ///
    /// - Parameter keyPath: The key path for the property to be accessed.
    /// - Returns: The value of the property at the specified key path.
    public subscript<Value>(dynamicMember keyPath: KeyPath<T, Value>) -> Value {
        self.get()[keyPath: keyPath]
    }
}
