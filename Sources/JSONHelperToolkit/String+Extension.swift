//
//  String+Extension.swift
//  DevHelperToolkit
//
//  Created by Naohiro Hamada on 2016/08/30.
//
//

import Foundation

extension String {
    func lowerCamelCased() -> String {
        if self.isEmpty {
            return ""
        }
        let comps = self.components(separatedBy: CharacterSet(charactersIn: " -_"))
        return comps.dropFirst().reduce(comps[0].lowercased(), { $0 + $1.capitalized })
    }
    
    func upperCamelCased() -> String {
        if self.isEmpty {
            return ""
        }
        let comps = self.components(separatedBy: CharacterSet(charactersIn: " -_"))
        return comps.reduce("", { $0 + $1.capitalized })
    }
}
