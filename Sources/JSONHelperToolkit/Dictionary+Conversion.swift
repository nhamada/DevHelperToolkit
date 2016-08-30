//
//  Dictionary+Conversion.swift
//  DevHelperToolkit
//
//  Created by Naohiro Hamada on 2016/08/26.
//
//

import Foundation

extension Dictionary {
    internal var jsonModels: [ModelDefinition] {
        var models = [ModelDefinition]()
        
        var properties = [PropertyDefinition]()
        for (key, value) in self {
            let key = String(describing: key)
            guard let value = value as? JSONValueTypeAnnotetable else {
                fatalError("Failed to convert JSON value type")
            }
            switch value.swiftType {
            case .object(let _):
                properties.append(PropertyDefinition(name: key.lowerCamelCased(), key: key, type: .object(key.upperCamelCased())))
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
            case is Dictionary:
                guard let value = value as? Dictionary else {
                    fatalError("Failed to cast")
                }
                dics[key] = value
            case is NSDictionary:
                guard let value = value as? Dictionary else {
                    fatalError("Failed to cast")
                }
                dics[key] = value
            default:
                break
            }
        }
        return dics
    }
}
