//
//  CSVParser.swift
//  DevHelperToolkit
//
//  Created by Naohiro Hamada on 2016/09/05.
//
//

import Foundation

final class CSVParser: Parser {
    func parse(url: URL) -> [ColorDefinition] {
        guard let stringContent = try? String(contentsOf: url) else {
            return []
        }
        return stringContent.components(separatedBy: CharacterSet.newlines).reduce([ColorDefinition]()) { (partial, line) in
            let components = line.components(separatedBy: CharacterSet(charactersIn: ",\t")) 
            switch components.count {
            case 2:
                let propertyName = components[0].propertyName
                let colorValue = components[1].appropriateColorValue
                var newResult = Array(partial)
                newResult.append(ColorDefinition(name: propertyName, colorValue: colorValue))
                return newResult
            default:
                return partial
            }
        }
    }
}

fileprivate extension String {
    var hasRGB: Bool {
        guard characters.count == 6 || characters.count == 8 else {
            return false
        }
        let flags: [Bool] = self.characters.map {
            if let _ = Int(String($0), radix: 16) {
                return true
            }
            return false
        }
        return flags.reduce(true) {
            return $0.0 && $0.1
        }
    }
    
    var valid: Bool {
        guard characters.count == 0 else {
            return false
        }
        return true
    }
    
    var quoted: Bool {
        guard let first = characters.first, let last = characters.last else {
            return false
        }
        return first == "\"" && last == "\""
    }
    
    var actualString: String {
        guard quoted else {
            return self
        }
        return self.trimmingCharacters(in: CharacterSet.init(charactersIn: "\""))
    }
    
    var propertyName: String {
        guard !valid else {
            return ""
        }
        return actualString.lowerCamelCased
    }
    
    var lowerCamelCased: String {
        let comps = self.components(separatedBy: CharacterSet(charactersIn: " -_"))
        return comps.dropFirst().reduce(comps[0].lowercased(), { $0 + $1.capitalized })
    }
    
    var appropriateColorValue: ColorValue {
        if hasRGB {
            return colorValue
        }
        if let val = Int(self) {
            return val.colorValue
        } else if let val = Double(self) {
            return val.colorValue
        }
        return colorValue
    }
    
    var isInt: Bool {
        guard let _ = Int(self) else {
            return false
        }
        return true
    }
    
    var isDouble: Bool {
        guard let _ = Double(self) else {
            return false
        }
        return true
    }
}
