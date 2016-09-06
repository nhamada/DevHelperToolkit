//
//  Foundation+Color.swift
//  DevHelperToolkit
//
//  Created by Naohiro Hamada on 2016/09/05.
//
//

import Foundation

typealias ColorValue = (red: Double, green: Double, blue: Double, alpha: Double)

protocol ColorValueConvertiable {
    var colorValue: ColorValue { get }
}

extension String: ColorValueConvertiable {
    var colorValue: ColorValue {
        let values = self.characters.map {
            Int.init(String($0), radix: 16)
        }
        let results: ([Int], Bool) = values.reduce(([Int](), false)) {
            guard let value = $0.1 else {
                abort()
            }
            var temp = Array<Int>($0.0.0)
            if $0.0.1 {
                temp[temp.count - 1] += value
            } else {
                temp.append(value * 16)
            }
            return (temp, !$0.0.1)
        }
        let resultValue = results.0
        if resultValue.count == 3 {
            return (resultValue[0].bounded, resultValue[1].bounded, resultValue[2].bounded, 1.0)
        } else if resultValue.count == 4 {
            return (resultValue[0].bounded, resultValue[1].bounded, resultValue[2].bounded, resultValue[3].bounded)
        } else {
            fatalError("Ill-formatted")
        }
    }
}

extension NSString: ColorValueConvertiable {
    var colorValue: ColorValue {
        let string = self as String
        return string.colorValue
    }
}

extension Int: ColorValueConvertiable {
    var colorValue: ColorValue {
        let value = bounded
        return (value, value, value, 1.0)
    }
    
    var uint8: UInt8 {
        if self < Int(UInt8.min) {
            return UInt8.min
        } else if self > Int(UInt8.max) {
            return UInt8.max
        } else {
            return UInt8(self)
        }
    }
    
    var bounded: Double {
        return Double(uint8) / 255.0
    }
}

extension Double: ColorValueConvertiable {
    var colorValue: ColorValue {
        return (bounded, bounded, bounded, 1.0)
    }
    
    var bounded: Double {
        if self < 0.0 {
            return 0.0
        } else if self > 1.0 {
            return 1.0
        } else {
            return self
        }
    }
}

extension NSNumber: ColorValueConvertiable {
    var colorValue: ColorValue {
        let objcType = String(cString: objCType)
        switch objcType {
        case "c", "C", "B":
            fatalError("Type mismatch")
        case "i", "s", "l", "q", "I", "S", "L", "Q":
            return self.intValue.colorValue
        case "f", "d":
            return self.doubleValue.colorValue
        default:
            fatalError("Type mismatch")
        }
    }
}
