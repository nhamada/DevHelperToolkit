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
    
    private init() { }
    
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
        let topModelName = url.lastPathComponent.replacingOccurrences(of: ".\(url.pathExtension)", with: "").upperCamelCased()
        let outputDirectoryUrl = URL(fileURLWithPath: outputDirectory)
        for model in jsonModels {
            if model.name.isEmpty {
                model.name = topModelName
            }
            let contents = model.swiftContents(configuration: configuration)
            let outputUrl = outputDirectoryUrl.appendingPathComponent("\(model.name).swift")
            do {
                try contents.write(to: outputUrl, atomically: true, encoding: .utf8)
            } catch let error {
                fatalError(error.localizedDescription)
            }
        }
        
        generateProtocol(to: outputDirectoryUrl, withConfiguration: configuration)
    }
    
    func generateProtocol(to outputDirectoryUrl: URL,
                          withConfiguration configuration: JSONHelperToolkitConfiguration = `default`) {
        let lines = ["protocol JSONDecodable {",
                     "\(configuration.editorTabSpacing)static func decode(_ jsonObject: [String:Any]) -> Self",
                     "}"]
        let contents = lines.reduce("") { $0 + $1 + "\n" }
        let outputUrl = outputDirectoryUrl.appendingPathComponent("JSONDecodable.swift")
        do {
            try contents.write(to: outputUrl, atomically: true, encoding: .utf8)
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
}
