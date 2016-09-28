//
//  Dictionary+Conversion.swift
//  DevHelperToolkit
//
//  Created by Naohiro Hamada on 2016/08/26.
//
//

import Foundation

private enum ModelDefinitionKey: String {
    case name
    case properties
}

private let requiredModelDefinitionKeys: [ModelDefinitionKey] = [
    .name,
    .properties,
]

extension Dictionary {
    internal var jsonModels: [ModelDefinition] {
        return isModelDefinition ? modelJsonModels : actualJsonModels
    }
    
    private var modelJsonModels: [ModelDefinition] {
        var modelName = ""
        var properties = [PropertyDefinition]()
        for (key, value) in self {
            guard let key = ModelDefinitionKey(rawValue: String(describing: key)) else {
                fatalError("Unknown key")
            }
            switch key {
            case .name:
                let value = String(describing: value)
                modelName = value.upperCamelCased()
            case .properties:
                guard let dic = value as? [String:String] else {
                    fatalError("Failed to convert properties")
                }
                for (propName, propValue) in dic {
                    properties.append(PropertyDefinition(name: propName.lowerCamelCased(), key: propName, type: ModelType.generate(from: propValue)))
                }
            }
        }
        return [ModelDefinition(name: modelName, properties: properties)]
    }
    
    private var actualJsonModels: [ModelDefinition] {
        var models = [ModelDefinition]()
        
        var properties = [PropertyDefinition]()
        for (key, value) in self {
            let key = String(describing: key)
            if value is NSNull {
                continue
            }
            guard let value = value as? JSONValueTypeAnnotetable else {
                fatalError("Failed to convert JSON value type")
            }
            switch value.swiftType {
            case .object:
                properties.append(PropertyDefinition(name: key.lowerCamelCased(), key: key, type: .object(key.upperCamelCased())))
            case .array(.object):
                properties.append(PropertyDefinition(name: key.lowerCamelCased(), key: key, type: .array(.object(key.upperCamelCased()))))
            default:
                properties.append(PropertyDefinition(name: key.lowerCamelCased(), key: key, type: value.swiftType))
            }
        }
        models.append(ModelDefinition(name: "", properties: properties))
        
        let submodels = subdictionaries
        for (key, value) in submodels {
            for subModel in value.jsonModels {
                if subModel.name.isEmpty {
                    subModel.name = String(describing: key.upperCamelCased())
                }
                models.append(subModel)
            }
        }
        return models
    }
    
    internal var subdictionaries: [String:Dictionary] {
        var dics = [String:Dictionary]()
        for (key, value) in self {
            let key = String(describing: key)
            switch value {
            case is Dictionary, is NSDictionary:
                guard let value = value as? Dictionary else {
                    fatalError("Failed to cast")
                }
                dics[key] = value
            case is [Dictionary]:
                guard let array = value as? [Dictionary], let first = array.first else {
                    fatalError("Failed to cast")
                }
                dics[key] = first
            case is [NSDictionary]:
                guard let array = value as? [NSDictionary], let first = array.first as? Dictionary else {
                    fatalError("Failed to cast")
                }
                dics[key] = first
            default:
                break
            }
        }
        return dics
    }
    
    private var isModelDefinition: Bool {
        let required = keys.reduce([ModelDefinitionKey:Int]()) {
            guard let keyName = $1 as? String, let key = ModelDefinitionKey(rawValue: keyName) else {
                return $0
            }
            var partial = $0
            partial[key] = (partial[key] ?? 0) + 1
            return partial
        }
        return required.keys.count == requiredModelDefinitionKeys.count && required.reduce(true) {
            return $0 && ($1.value == 1)
        }
    }
}
