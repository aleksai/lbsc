@testable import DI
import XCTest

protocol Dependency: AnyObject {}

class RealDependency: Dependency {}
class MockedDependency: Dependency {}

extension DI {
    var dependency: Dependency {
        RealDependency()
    }

    var singletonDependency: Dependency {
        singleton { RealDependency() }
    }
}

class Foo {
    @Injected(\.dependency) var dependency
    @Injected(\.singletonDependency) var singletonDependency
}

final class DITests: XCTestCase {
    func testInjection() {
        let foo = Foo()

        XCTAssertTypeIsEqual(foo.dependency, RealDependency.self)
    }

    func testMock() {
        DI.test {
            DI.mock(\.dependency) { MockedDependency() }

            let foo = Foo()
            XCTAssertTypeIsEqual(foo.dependency, MockedDependency.self)
            XCTAssertTypeIsEqual(foo.singletonDependency, RealDependency.self)
        }
    }

    func testTwoMockWithSameType() {
        final class First: Dependency {}
        final class Second: Dependency {}

        DI.test {
            DI.mock(\.dependency) { First() }
            DI.mock(\.singletonDependency) { Second() }

            let foo = Foo()
            XCTAssertTypeIsEqual(foo.dependency, First.self)
            XCTAssertTypeIsEqual(foo.singletonDependency, Second.self)
        }
    }

    func testUnmock() {
        DI.test {
            DI.mock(\.dependency) { MockedDependency() }

            let foo = Foo()
            XCTAssertTypeIsEqual(foo.dependency, MockedDependency.self)

            DI.unmock(\.dependency)

            let anotherFoo = Foo()
            XCTAssertTypeIsEqual(anotherFoo.dependency, RealDependency.self)
        }
    }

    func testDependencyRetained() {
        let foo = Foo()

        let instanceOne = foo.dependency
        let instanceTwo = foo.dependency

        XCTAssertIdentical(instanceOne, instanceTwo)
    }

    func testDependencyUniqueness() {
        let fooOne = Foo()
        let fooTwo = Foo()

        XCTAssertNotIdentical(fooOne.dependency, fooTwo.dependency)
    }

    func testSingletonDependency() {
        let fooOne = Foo()
        let fooTwo = Foo()

        XCTAssertIdentical(fooOne.singletonDependency, fooTwo.singletonDependency)
    }

    func testSingletonsInvalidatedAcrossTests() {
        var singletonOne: Dependency!
        var singletonTwo: Dependency!

        DI.test { singletonOne = Foo().singletonDependency }
        DI.test { singletonTwo = Foo().singletonDependency }

        XCTAssertNotIdentical(singletonOne, singletonTwo)
    }
}

func XCTAssertTypeIsEqual(_ value: Any, _ type: Any.Type, file: StaticString = #filePath, line: UInt = #line) {
    XCTAssert(Swift.type(of: value) == type, "\(Swift.type(of: value)) is not equal to \(type)", file: file, line: line)
}
