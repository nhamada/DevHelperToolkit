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
    
    func testReadFromJsonSimple() {
        let filepath = "./Resources/test_simple.json"
        JSONHelperToolkit.shared.generate(from: filepath, to: "./Resources")
    }
    
    func testReadFromJsonUserData() {
        let filepath = "./Resources/test_userdata.json"
        JSONHelperToolkit.shared.generate(from: filepath, to: "./Resources")
    }
    
    func testReadFromJsonMultiUserData() {
        let filepath = "./Resources/test_multi_userdata.json"
        JSONHelperToolkit.shared.generate(from: filepath, to: "./Resources")
    }
    
    func testReadFromSimpleJsonModel() {
        let filepath = "./Resources/test_simple_json_model.json"
        JSONHelperToolkit.shared.generate(from: filepath, to: "./Resources")
    }
    
    func testReadFromSimpleUrlDate() {
        let filepath = "./Resources/test_simple_url_date.json"
        JSONHelperToolkit.shared.generate(from: filepath, to: "./Resources")
    }
    
    func testReadFromNestedSimpleUrlDate() {
        let filepath = "./Resources/test_nested_simple_url_date.json"
        JSONHelperToolkit.shared.generate(from: filepath, to: "./Resources")
    }
    
    func testReadFromSimpleUrlDateArray() {
        let filepath = "./Resources/test_simple_url_date_array.json"
        JSONHelperToolkit.shared.generate(from: filepath, to: "./Resources")
    }
    
    static var allTests : [(String, (JSONHelperToolkitTests) -> () throws -> Void)] {
        return [
            ("testDictionaryToModel", testDictionaryToModel),
            ("testDictionariesToModel", testDictionariesToModel),
            ("testReadFromJsonSimple", testReadFromJsonSimple),
            ("testReadFromJsonUserData", testReadFromJsonUserData),
            ("testReadFromJsonMultiUserData", testReadFromJsonMultiUserData),
            ("testReadFromSimpleJsonModel", testReadFromSimpleJsonModel),
            ("testReadFromSimpleUrlDate", testReadFromSimpleUrlDate),
            ("testReadFromNestedSimpleUrlDate", testReadFromNestedSimpleUrlDate),
            ("testReadFromSimpleUrlDateArray", testReadFromSimpleUrlDateArray),
        ]
    }
}
