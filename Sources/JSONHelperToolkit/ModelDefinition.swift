//
//  ModelDefinition.swift
//  DevHelperToolkit
//
//  Created by Naohiro Hamada on 2016/08/26.
//
//

indirect enum ModelType {
    case integer, fraction, string, boolean
    case array(ModelType)
    case object(String)
    
    var swiftType: String {
        switch self {
        case .integer:
            return "Int"
        case .fraction:
            return "Double"
        case .string:
            return "String"
        case .boolean:
            return "Bool"
        case .array(let element):
            return "[\(element.swiftType)]"
        case .object(let customClassName):
            return customClassName
        }
    }
}

class PropertyDefinition {
    let name: String
    let type: ModelType
    
    init(name: String, type: ModelType) {
        self.name = name
        self.type = type
    }
}

class ModelDefinition {
    var name: String
    var properties: [PropertyDefinition]
    
    init(name: String = "", properties: [PropertyDefinition] = []) {
        self.name = name
        self.properties = properties
    }
}
