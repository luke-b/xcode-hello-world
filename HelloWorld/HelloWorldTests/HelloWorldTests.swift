import XCTest
@testable import HelloWorld

final class HelloWorldTests: XCTestCase {

    func testExample() throws {
        // Baseline sanity test
        XCTAssertTrue(true, "Basic test passes")
    }

    func testArithmetic() throws {
        // Verify the test environment works correctly
        XCTAssertEqual(1 + 1, 2, "Basic arithmetic must work")
    }

    func testStringContents() throws {
        let greeting = "Hello, World!"
        XCTAssertFalse(greeting.isEmpty, "Greeting should not be empty")
        XCTAssertTrue(greeting.contains("Hello"), "Greeting should contain Hello")
        XCTAssertTrue(greeting.contains("World"), "Greeting should contain World")
    }
}
