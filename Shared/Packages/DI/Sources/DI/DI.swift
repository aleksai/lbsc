import Foundation

/// `DI` is a dead-simple dependency injection framework that allows you to define and manage dependencies
/// using extensions and key paths. By utilizing the `@Injected` property wrapper, you can efficiently
/// access dependencies within your application.
///
/// Usage example:
/// ```
/// // Define your service protocol
/// protocol MyService {
///     func doSomething()
/// }
///
/// // Implement your service
/// class MyServiceImpl: MyService {
///     func doSomething() {
///         print("Doing something")
///     }
/// }
///
/// // Extend DI to include your service
/// extension DI {
///     var myService: MyService {
///         MyServiceImpl()
///     }
/// }
///
/// // Use your service by injecting it with the `@Injected` property wrapper
/// class MyClass {
///     @Injected(\.myService) private var myService
///
///     func useService() {
///         myService.doSomething()
///     }
/// }
/// ```
public struct DI {}

extension DI {
    static let shared = Self()

    subscript<T>(instanceKeyPath: KeyPath<Self, T>) -> T {
        if DI.isTesting, let instance = DI.mocks[instanceKeyPath]?() as? T {
            return instance
        }

        return self[keyPath: instanceKeyPath]
    }
}
