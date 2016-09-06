//
//  Dictionary+Extension.swift
//  DevHelperToolkit
//
//  Created by Naohiro Hamada on 2016/09/05.
//
//

import Foundation

extension Dictionary {
    var colodModels: [ColorDefinition] {
        let models:[ColorDefinition] = self.map {
            let name = String(describing: $0.key)
            switch $0.value {
            case is ColorValueConvertiable:
                guard let value = $0.value as? ColorValueConvertiable else {
                    fatalError("Failed to cast")
                }
                let color = value.colorValue
                return ColorDefinition.init(name: name, colorValue: color)
            default:
                print($0.value)
                fatalError("Invalid data type")
            }
        }
        return models
    }
}
