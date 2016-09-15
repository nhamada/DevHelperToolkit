//
//  String+Extension.swift
//  DevHelperToolkit
//
//  Created by Naohiro Hamada on 2016/09/15.
//
//

import Foundation

extension String {
    var lowerCamelCased: String {
        let comps = self.components(separatedBy: CharacterSet(charactersIn: " -_"))
        return comps.dropFirst().reduce(comps[0].lowercased(), { $0 + $1.capitalized })
    }
    
    var upperCamelCased: String {
        let comps = self.components(separatedBy: CharacterSet(charactersIn: " -_"))
        return comps.dropFirst().reduce(comps[0].capitalized, { $0 + $1.capitalized })
    }
}
