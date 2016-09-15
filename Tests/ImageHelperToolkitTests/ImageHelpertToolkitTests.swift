import XCTest
@testable import ImageHelperToolkit

class ImageHelperToolkitTests: XCTestCase {
    
    func testImageAssets() {
        let filepath = "./Resources/Assets.xcassets"
        ImageHelperToolkit.shared.generate(from: filepath, to: "./Resources")
    }
    
    static var allTests : [(String, (ImageHelperToolkitTests) -> () throws -> Void)] {
        return [
            ("testImageAssets", testImageAssets),
        ]
    }
}
