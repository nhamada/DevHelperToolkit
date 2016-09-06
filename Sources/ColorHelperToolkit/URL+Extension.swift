//
//  URL+Extension.swift
//  DevHelperToolkit
//
//  Created by Naohiro Hamada on 2016/09/05.
//
//

import Foundation

extension URL {
    internal var fileType: FileType? {
        return FileType(rawValue: self.pathExtension.lowercased())
    }
}
