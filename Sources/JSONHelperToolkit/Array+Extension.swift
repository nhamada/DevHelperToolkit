//
//  Array+Extension.swift
//  DevHelperToolkit
//
//  Created by Naohiro Hamada on 2016/08/26.
//
//

import Foundation

extension Array {
    internal var validJsonArray: Bool {
        guard let types = try? self.map({ Mirror(reflecting: $0).description })
            .reduce([String:Int](), {
                var result = $0
                result[$1] =  $0.keys.contains($1) ? $0[$1]! + 1 : 0
                return result
            } ) else {
            fatalError("Failed to extract type in array")
        }
        return types.count == 1
    }
    
    internal var elementSwiftType: ModelType {
        guard validJsonArray else {
            fatalError("")
        }
        guard let value = first as? JSONValueTypeAnnotetable else {
            fatalError("Cannot annotate type")
        }
        return value.swiftType
    }
}
