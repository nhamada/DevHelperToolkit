//
//  JSONParser.swift
//  DevHelperToolkit
//
//  Created by Naohiro Hamada on 2016/09/05.
//
//

import Foundation

final class JSONParser: Parser {
    func parse(url: URL) -> [ColorDefinition] {
        guard let data = try? Data(contentsOf: url) else {
            abort()
        }
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
            let dic = jsonObject as? [String:Any] else {
            abort()
        }
        return dic.colodModels
    }
}
