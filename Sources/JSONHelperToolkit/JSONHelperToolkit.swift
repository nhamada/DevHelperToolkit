//
//  Configuration.swift
//  DevHelperToolkit
//
//  Created by Naohiro Hamada on 2016/08/26.
//
//

import Foundation

public final class JSONHelperToolkit {
    static let shared: JSONHelperToolkit = JSONHelperToolkit()
    
    private init() {
    }
    
    func generate(from filepath: String,
                  to outputDirectory: String,
                  withConfiguration configuration: JSONHelperToolkitConfiguration = `default`) {
        let url = URL(fileURLWithPath: filepath)
        generate(from: url, to: outputDirectory, withConfiguration: configuration)
    }
    
    func generate(from url: URL,
                  to outputDirectory: String,
                  withConfiguration configuration: JSONHelperToolkitConfiguration = `default`) {
        guard let rawData = try? Data(contentsOf: url) else {
            fatalError("Failed to open \(url)")
        }
        guard let dic = try? JSONSerialization.jsonObject(with: rawData, options: []) as? [String:Any] else {
            fatalError("File may not JSON")
        }
        guard let jsonModels = dic?.jsonModels else {
            fatalError("Failed to convert")
        }
    }
}
