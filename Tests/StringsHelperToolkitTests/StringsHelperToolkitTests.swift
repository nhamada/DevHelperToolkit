import XCTest
@testable import StringsHelperToolkit

class StringsHelperToolkitTests: XCTestCase {
    
    func testParsser() {
        let filepath = "./Resources/Base.lproj/Localizable.strings"
        let stringsDictionary = StringsParser.parse(at: filepath)
        
        XCTAssert(stringsDictionary.count == 3)
    }
    
    func testToolkit() {
        let filepath = "./Resources"
        let stringsDictionary = StringsHelperToolkit.shared.generate(from: filepath, to: "./Resources")
    }
    
    static var allTests : [(String, (StringsHelperToolkitTests) -> () throws -> Void)] {
        return [
            ("testParsser", testParsser),
        ]
    }
}
