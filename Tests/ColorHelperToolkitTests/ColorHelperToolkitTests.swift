import XCTest
@testable import ColorHelperToolkit

class ColorHelperToolkitTests: XCTestCase {
    
    func testReadFromJson() {
        let filepath = "./Resources/test_color.json"
        ColorHelperToolkit.shared.generate(from: filepath, to: "./Resources")
    }
    
    static var allTests : [(String, (ColorHelperToolkitTests) -> () throws -> Void)] {
        return [
            ("testReadFromJson", testReadFromJson),
        ]
    }
}
