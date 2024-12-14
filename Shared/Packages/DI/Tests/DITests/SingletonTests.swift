@testable import DI
import XCTest

private class TestObject: NSObject {}

private extension DI {
    var firstSingleton: TestObject {
        singleton { TestObject() }
    }

    var secondSingleton: TestObject {
        singleton { TestObject() }
    }

    var barWithSingleton: BarWithSingleton {
        singleton { BarWithSingleton() }
    }
}

private class Bar {
    @Injected(\.firstSingleton) var singleton
    @Injected(\.secondSingleton) var anotherSingleton
}

private class BarWithSingleton {
    @Injected(\.firstSingleton) var singleton

    init() {
        _ = singleton
    }
}

final class SingletonTests: XCTestCase {
    func testCreateSingleton() {
        let bar = Bar()
        let anotherBar = Bar()

        XCTAssertIdentical(bar.singleton, anotherBar.singleton)
    }

    func testCreateAnotherSingletonWithSameType() {
        let bar = Bar()
        let anotherBar = Bar()

        XCTAssertNotIdentical(bar.singleton, bar.anotherSingleton)
        XCTAssertIdentical(bar.anotherSingleton, anotherBar.anotherSingleton)
    }

    func testDefineTwoSingletonsAtSameLine() {
        let singletons = (DI.shared.singleton { TestObject() }, DI.shared.singleton { TestObject() })
        XCTAssertNotIdentical(singletons.0, singletons.1)
    }

    func testMultithreadAccess() {
        var accessCount = 0
        let singleton = {
            DI.shared.singleton {
                accessCount += 1
                return TestObject()
            }
        }

        DispatchQueue.concurrentPerform(iterations: 500) { _ in
            _ = singleton()
        }

        XCTAssertEqual(accessCount, 1)
    }

    // Should not throw Thread 1: EXC_BREAKPOINT
    func testSingletonWithSingletonProperty() {
        _ = Injected(\.barWithSingleton).wrappedValue
    }
}
