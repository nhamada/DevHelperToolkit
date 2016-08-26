import XCTest
@testable import DevHelperToolkit

class DevHelperToolkitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(DevHelperToolkit().text, "Hello, World!")
    }


    static var allTests : [(String, (DevHelperToolkitTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
