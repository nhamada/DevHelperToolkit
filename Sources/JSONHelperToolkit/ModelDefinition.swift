//
//  ModelDefinition.swift
//  DevHelperToolkit
//
//  Created by Naohiro Hamada on 2016/08/26.
//
//

import Foundation

indirect enum ModelType {
    case integer, unsigned, fraction, string, boolean
    case array(ModelType)
    case object(String)
    case optional(ModelType)
    case signedInteger(Int)
    case unsignedInteger(Int)
    case singlePrecisionFloating
    case dictionary(ModelType, ModelType)
    case url
    case date
    
    var swiftType: String {
        switch self {
        case .integer:
            return "Int"
        case .unsigned:
            return "UInt"
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
        case .optional(let model):
            return "\(model.swiftType)?"
        case .signedInteger(let bit):
            return "Int\(bit)"
        case .unsignedInteger(let bit):
            return "UInt\(bit)"
        case .singlePrecisionFloating:
            return "Float"
        case .dictionary(let key, let value):
            return "[\(key.swiftType):\(value.swiftType)]"
        case .url:
            return "URL"
        case .date:
            return "Date"
        }
    }
    
    static func generate(from string: String) -> ModelType {
        switch string {
        case "Int":
            return .integer
        case "UInt":
            return .unsigned
        case "Bool":
            return .boolean
        case "Float":
            return .singlePrecisionFloating
        case "Double":
            return .fraction
        case "String":
            return .string
        case let s where s.hasSuffix("?"):
            return .optional(ModelType.generate(from: s.replacingOccurrences(of: "?", with: "")))
        case "URL":
            return .url
        case "Date":
            return .date
        case let s where s.hasPrefix("Int"):
            guard let bit = Int(s.replacingOccurrences(of: "Int", with: "")) else {
                abort()
            }
            switch bit {
            case 8, 16, 32, 64:
                return .signedInteger(bit)
            default:
                fatalError("Invalid bitwide: \(bit)")
            }
        case let s where s.hasPrefix("UInt"):
            guard let bit = Int(s.replacingOccurrences(of: "UInt", with: "")) else {
                abort()
            }
            switch bit {
            case 8, 16, 32, 64:
                return .unsignedInteger(bit)
            default:
                fatalError("Invalid bitwide: \(bit)")
            }
        case let container where container.hasPrefix("[") && container.hasSuffix("]"):
            let element = container.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
            let numberOfColons = element.characters.reduce(0) {
                return $0 + ($1 == ":" ? 1 : 0)
            }
            switch numberOfColons {
            case 1:
                let comb = element.components(separatedBy: ":")
                return .dictionary(ModelType.generate(from: comb[0]), ModelType.generate(from: comb[1]))
            case 0:
                return .array(ModelType.generate(from: element))
            default:
                fatalError("Invalid format: \(container)")
            }
        default:
            return .object(string.upperCamelCased())
        }
    }
    
    static func ==(_ lhs: ModelType, _ rhs: ModelType) -> Bool {
        return lhs == rhs
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
        lines.append("extension \(name): JSONDecodable {")
        lines.append("\(tab)static func decode(_ jsonObject: [String:Any]) -> \(name) {")
        for property in properties {
            switch property.type {
            case .object(let typeName):
                lines.append("\(tab)\(tab)guard let \(property.name)Object = jsonObject[\"\(property.key)\"] as? [String:Any] else {")
                lines.append("\(tab)\(tab)\(tab)abort()")
                lines.append("\(tab)\(tab)}")
                lines.append("\(tab)\(tab)let \(property.name) = \(typeName).decode(\(property.name)Object)")
            case .array(let modelType):
                switch modelType {
                case .object(let name):
                    lines.append("\(tab)\(tab)guard let \(property.name)Object = jsonObject[\"\(property.key)\"] as? [[String:Any]] else {")
                    lines.append("\(tab)\(tab)\(tab)abort()")
                    lines.append("\(tab)\(tab)}")
                    lines.append("\(tab)\(tab)let \(property.name) = \(property.name)Object.map { \(name).decode($0) }")
                default:
                    lines.append("\(tab)\(tab)guard let \(property.name) = jsonObject[\"\(property.key)\"] as? \(property.type.swiftType) else {")
                    lines.append("\(tab)\(tab)\(tab)abort()")
                    lines.append("\(tab)\(tab)}")
                }
            case .optional(let model):
                lines.append("\(tab)\(tab)let \(property.name) = jsonObject[\"\(property.key)\"] as? \(model.swiftType)")
            case .url:
                lines.append("\(tab)\(tab)guard let \(property.name)String = jsonObject[\"\(property.key)\"] as? String, let \(property.name) = URL(string: \(property.name)String) else {")
                lines.append("\(tab)\(tab)\(tab)abort()")
                lines.append("\(tab)\(tab)}")
            case .date:
                lines.append("\(tab)\(tab)guard let \(property.name)String = jsonObject[\"\(property.key)\"] as? String, let \(property.name) = DateFormatter.iso8601formatter.date(from: \(property.name)String) else {")
                lines.append("\(tab)\(tab)\(tab)abort()")
                lines.append("\(tab)\(tab)}")
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
    
    func hasDate() -> Bool {
        return properties.reduce(false) {
            switch $1.type {
            case .url:
                return true
            default:
                return $0 || false
            }
            
        }
    }
}
