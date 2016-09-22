//
//  FileType.swift
//  DevHelperToolkit
//
//  Created by Naohiro Hamada on 2016/09/05.
//
//

enum FileType: String {
    case json
    case csv
    
    func parser() -> Parser {
        switch self {
        case .json:
            return JSONParser()
        case .csv:
            return CSVParser()
        }
    }
}
