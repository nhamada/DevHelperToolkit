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

extension NSNumber: JSONValueTypeAnnotetable {
    internal var swiftType: ModelType {
        let objcType = String(cString: objCType)
        switch objcType {
        case "c", "C", "B":
            return .boolean
        case "i", "s", "l", "q", "I", "S", "L", "Q":
            return .integer
        case "f", "d":
            return .fraction
        default:
            fatalError("Type mismatch")
        }
    }
}

extension String: JSONValueTypeAnnotetable {
    internal var swiftType: ModelType {
        return .string
    }
}

extension NSString: JSONValueTypeAnnotetable {
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

extension NSArray: JSONValueTypeAnnotetable {
    internal var swiftType: ModelType {
        let array = self as Array<AnyObject>
        return array.swiftType
    }
}

extension Dictionary: JSONValueTypeAnnotetable {
    internal var swiftType: ModelType {
        return .object("")
    }
}

extension NSDictionary: JSONValueTypeAnnotetable {
    internal var swiftType: ModelType {
        return .object("")
    }
}
