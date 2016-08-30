//
//  ModelDefinition.swift
//  DevHelperToolkit
//
//  Created by Naohiro Hamada on 2016/08/26.
//
//

import Foundation

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

final class PropertyDefinition {
    let name: String
    let key: String
    let type: ModelType
    
    init(name: String, key: String, type: ModelType) {
        self.name = name
        self.key = key
        self.type = type
    }
}

final class ModelDefinition {
    var name: String
    var properties: [PropertyDefinition]
    
    init(name: String = "", properties: [PropertyDefinition] = []) {
        self.name = name
        self.properties = properties
    }
}

extension ModelDefinition {
    func swiftContents(configuration: JSONHelperToolkitConfiguration) -> String {
        let tab = configuration.editorTabSpacing
        
        var lines = [String]()
        lines.append("import Foundation")
        lines.append("")
        
        lines.append("struct \(name) {")
        for property in properties {
            lines.append("\(tab)let \(property.name): \(property.type.swiftType)")
        }
        lines.append("}")
        lines.append("")
        lines.append("extension \(name) {")
        lines.append("\(tab)static func decode(_ jsonObject: [String:Any]) -> \(name) {")
        for property in properties {
            switch property.type {
            case .object(let typeName):
                lines.append("\(tab)\(tab)guard let \(property.name)Object = jsonObject[\"\(property.key)\"] as? \(typeName) else {")
                lines.append("\(tab)\(tab)\(tab)abort()")
                lines.append("\(tab)\(tab)}")
                lines.append("\(tab)\(tab)let \(property.name) = \(typeName).decode(\(property.name)Object)")
                break
            default:
                lines.append("\(tab)\(tab)guard let \(property.name) = jsonObject[\"\(property.key)\"] as? \(property.type.swiftType) else {")
                lines.append("\(tab)\(tab)\(tab)abort()")
                lines.append("\(tab)\(tab)}")
            }
        }
        lines.append("\(tab)\(tab)return \(name)(")
        for property in properties.dropLast() {
            lines.append("\(tab)\(tab)\(tab)\(property.name): \(property.name),")
        }
        guard let last = properties.last else {
            abort()
        }
        lines.append("\(tab)\(tab)\(tab)\(last.name): \(last.name)")
        lines.append("\(tab)\(tab))")
        lines.append("\(tab)}")
        lines.append("}")
        
        return lines.reduce("") { $0 + $1 + "\n" }
    }
}
