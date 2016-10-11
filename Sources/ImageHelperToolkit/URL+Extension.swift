//
//  URL+Extension.swift
//  DevHelperToolkit
//
//  Created by Naohiro Hamada on 2016/09/15.
//
//

import Foundation
import FoundationExtensions

extension URL {
    var propertyName: String {
        let name = lastPathComponent.replacingOccurrences(of: ".\(pathExtension)", with: "")
        return name.lowerCamelCased()
    }
    
    var enumName: String {
        let name = lastPathComponent.replacingOccurrences(of: ".\(pathExtension)", with: "")
        return name.lowerCamelCased()
    }
    
    var assetName: String {
        return lastPathComponent.replacingOccurrences(of: ".\(pathExtension)", with: "")
    }
}
