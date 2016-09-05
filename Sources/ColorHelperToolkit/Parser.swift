//
//  Parser.swift
//  DevHelperToolkit
//
//  Created by Naohiro Hamada on 2016/09/05.
//
//

import Foundation

protocol Parser {
    func parse(filepath: String) -> [ColorDefinition]
    
    func parse(url: URL) -> [ColorDefinition]
}

extension Parser {
    func parse(filepath: String) -> [ColorDefinition] {
        let url = URL(fileURLWithPath: filepath)
        return parse(url: url)
    }
}
