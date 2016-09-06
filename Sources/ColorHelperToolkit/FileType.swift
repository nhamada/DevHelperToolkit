//
//  FileType.swift
//  DevHelperToolkit
//
//  Created by Naohiro Hamada on 2016/09/05.
//
//

enum FileType: String {
    case json
    case cvs
    
    func parser() -> Parser {
        switch self {
        case .json:
            return JSONParser()
        case .cvs:
            return CVSParser()
        }
    }
}
