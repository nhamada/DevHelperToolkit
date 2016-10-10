import XCTest
@testable import StoryboardHelperToolkit

class StoryboardHelperToolkitTests: XCTestCase {
    
    func testParseSingleScene() {
        let filepath = "./Resources/Storyboards/SingleScene.storyboard"
        let storyboard = StoryboardParser.parse(filepath)
        
        XCTAssert(storyboard.scenes.count == 1)
        XCTAssert(storyboard.name == "SingleScene")
    }
    
    static var allTests : [(String, (StoryboardHelperToolkitTests) -> () throws -> Void)] {
        return [
            ("testParseSingleScene", testParseSingleScene),
        ]
    }
}
