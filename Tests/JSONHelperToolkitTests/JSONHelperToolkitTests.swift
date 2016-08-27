import XCTest
@testable import JSONHelperToolkit

class JSONHelperToolkitTests: XCTestCase {
    
    func testDictionaryToModel() {
        let dic: [String:Any] = ["key": "value", "integer": 10, "bool": true]
        let model = dic.jsonModels
        XCTAssertEqual(model.count, 1)
        for p in model.first!.properties {
            print("\(p.name) = \(p.type)")
        }
    }
    
    func testDictionariesToModel() {
        let dic: [String:Any] = ["key": "value", "integer": 10, "bool": true, "dic": ["element1": "element1"]]
        let model = dic.jsonModels
        XCTAssertEqual(model.count, 2)
        for m in model {
            print("Model Name: \(m.name)")
            for p in m.properties {
                print("\(p.name) = \(p.type)")
            }
        }
    }
    
    static var allTests : [(String, (JSONHelperToolkitTests) -> () throws -> Void)] {
        return [
            ("testDictionaryToModel", testDictionaryToModel),
            ("testDictionariesToModel", testDictionariesToModel),
        ]
    }
}
