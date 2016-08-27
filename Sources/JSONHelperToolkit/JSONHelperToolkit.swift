//
//  Configuration.swift
//  DevHelperToolkit
//
//  Created by Naohiro Hamada on 2016/08/26.
//
//

import Foundation

public class JSONHelperToolkit {
    func generate(withFilepath filepath: String,
                  toDirectory outputDirectory: String,
                  withConfiguration configuration: JSONHelperToolkitConfiguration = `default`) {
        let url = URL(fileURLWithPath: filepath)
        generate(withUrl: url, toDirectory: outputDirectory, withConfiguration: configuration)
    }
    
    func generate(withUrl url: URL,
                  toDirectory outputDirectory: String,
                  withConfiguration configuration: JSONHelperToolkitConfiguration = `default`) {
        guard let rawData = try? Data(contentsOf: url) else {
            fatalError("Failed to open \(url)")
        }
        guard let dic = try? JSONSerialization.jsonObject(with: rawData, options: []) as? [String:Any] else {
            fatalError("File may not JSON")
        }
    }
}
