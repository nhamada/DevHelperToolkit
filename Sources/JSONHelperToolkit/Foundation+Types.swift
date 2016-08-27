//
//  Foundation+Types.swift
//  DevHelperToolkit
//
//  Created by Naohiro Hamada on 2016/08/26.
//
//

import Foundation

internal protocol JSONValueTypeAnnotetable {
    var swiftType: ModelType { get }
}

extension Int8: JSONValueTypeAnnotetable {
    internal var swiftType: ModelType {
        return .integer
    }
}

extension UInt8: JSONValueTypeAnnotetable {
    internal var swiftType: ModelType {
        return .integer
    }
}

extension Int16: JSONValueTypeAnnotetable {
    internal var swiftType: ModelType {
        return .integer
    }
}

extension UInt16: JSONValueTypeAnnotetable {
    internal var swiftType: ModelType {
        return .integer
    }
}

extension Int32: JSONValueTypeAnnotetable {
    internal var swiftType: ModelType {
        return .integer
    }
}

extension UInt32: JSONValueTypeAnnotetable {
    internal var swiftType: ModelType {
        return .integer
    }
}

extension Int64: JSONValueTypeAnnotetable {
    internal var swiftType: ModelType {
        return .integer
    }
}

extension UInt64: JSONValueTypeAnnotetable {
    internal var swiftType: ModelType {
        return .integer
    }
}

extension Int: JSONValueTypeAnnotetable {
    internal var swiftType: ModelType {
        return .integer
    }
}

extension UInt: JSONValueTypeAnnotetable {
    internal var swiftType: ModelType {
        return .integer
    }
}

extension Float: JSONValueTypeAnnotetable {
    internal var swiftType: ModelType {
        return .fraction
    }
}

extension Double: JSONValueTypeAnnotetable {
    internal var swiftType: ModelType {
        return .fraction
    }
}

extension String: JSONValueTypeAnnotetable {
    internal var swiftType: ModelType {
        return .string
    }
}

extension Bool: JSONValueTypeAnnotetable {
    internal var swiftType: ModelType {
        return .boolean
    }
}

extension Array: JSONValueTypeAnnotetable {
    internal var swiftType: ModelType {
        return .array(elementSwiftType)
    }
}

extension Dictionary: JSONValueTypeAnnotetable {
    internal var swiftType: ModelType {
        return .object("")
    }
}
