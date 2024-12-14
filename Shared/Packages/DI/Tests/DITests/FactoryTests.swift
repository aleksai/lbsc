import DI
import XCTest

protocol DependencyWithValue {
    var value: Int { get }
}

struct RealDependencyWithValue: DependencyWithValue {
    let value: Int
}

struct MockedDependencyWithValue: DependencyWithValue {
    let value: Int
}

extension DI {
    var dependencyWithValue: Factory<DependencyWithValue, Int> {
        Factory { value in
            RealDependencyWithValue(value: value)
        }
    }
}

class Baz {
    let value: Int

    @Injected(\.dependencyWithValue, 42) var dependency
    lazy var dynamicValueDependency = Injected(\.dependencyWithValue)(value)

    init(value: Int = 0) {
        self.value = value
    }
}

final class FactoryTests: XCTestCase {
    func testInjectedWithStaticArg() {
        let baz = Baz()

        XCTAssertTypeIsEqual(baz.dependency, RealDependencyWithValue.self)
        XCTAssertEqual(baz.dependency.value, 42)
    }

    func testInjectedWithDynamicArg() {
        let baz = Baz(value: 43)

        XCTAssertEqual(baz.dynamicValueDependency.value, 43)
    }

    func testMock() {
        DI.test {
            DI.mock(\.dependencyWithValue) {
                Factory { _ in
                    MockedDependencyWithValue(value: 45)
                }
            }

            let baz = Baz(value: 43)

            XCTAssertTypeIsEqual(baz.dependency, MockedDependencyWithValue.self)
            XCTAssertEqual(baz.dependency.value, 45)
            XCTAssertEqual(baz.dynamicValueDependency.value, 45)
        }
    }
}
