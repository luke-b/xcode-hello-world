import XCTest

final class HelloWorldUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testAppLaunchesSuccessfully() throws {
        XCTAssertEqual(app.state, .runningForeground, "App should be running in the foreground")
    }

    func testHelloWorldTextIsVisible() throws {
        let label = app.staticTexts["helloWorldLabel"]
        XCTAssertTrue(label.waitForExistence(timeout: 5), "Hello, World! label should be visible")
        XCTAssertEqual(label.label, "Hello, World!")
    }

    func testAppLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
