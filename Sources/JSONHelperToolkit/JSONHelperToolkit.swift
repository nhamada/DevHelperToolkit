//
//  Configuration.swift
//  DevHelperToolkit
//
//  Created by Naohiro Hamada on 2016/08/26.
//
//

import Foundation

public final class JSONHelperToolkit {
    public static let shared: JSONHelperToolkit = JSONHelperToolkit()
    
    private init() { }
    
    public func generate(from filepath: String,
                         to outputDirectory: String,
                         withConfiguration configuration: JSONHelperToolkitConfiguration = `default`) {
        let url = URL(fileURLWithPath: filepath)
        generate(from: url, to: outputDirectory, withConfiguration: configuration)
    }
    
    public func generate(from url: URL,
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
        
        generateProtocol(to: outputDirectoryUrl, withConfiguration: configuration)
        
        let hasDate = jsonModels.reduce(false) {
            return $0 || $1.hasDate()
        }
        if hasDate {
            generateDateExtension(to: outputDirectoryUrl, withConfiguration: configuration)
        }
        
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
    }
    
    func generateProtocol(to outputDirectoryUrl: URL,
                          withConfiguration configuration: JSONHelperToolkitConfiguration = `default`) {
        let lines = ["protocol JSONDecodable {",
                     "\(configuration.editorTabSpacing)static func decode(_ jsonObject: [String:Any]) -> Self",
                     "}"]
        let fileUrl = outputDirectoryUrl.appendingPathComponent("JSONDecodable.swift")
        write(contents: lines, to: fileUrl)
    }
    
    func generateDateExtension(to outputDirectoryUrl: URL,
                               withConfiguration configuration: JSONHelperToolkitConfiguration = `default`) {
        let lines = ["import Foundation",
                     "",
                     "extension DateFormatter {",
                     "\(configuration.editorTabSpacing)class var iso8601formatter: DateFormatter {",
                     "\(configuration.editorTabSpacing)\(configuration.editorTabSpacing)let formatter = DateFormatter()",
                     "\(configuration.editorTabSpacing)\(configuration.editorTabSpacing)formatter.dateFormat = \"yyyy-MM-dd'T'HH:mm:ssZ\"",
                     "\(configuration.editorTabSpacing)\(configuration.editorTabSpacing)return formatter",
                     "\(configuration.editorTabSpacing)}",
                     "}"
        ]
        let fileUrl = outputDirectoryUrl.appendingPathComponent("DateFormatter+ISO8601.swift")
        write(contents: lines, to: fileUrl)
    }
    
    private func write(contents: [String], to outputFileUrl: URL) {
        let contents = contents.reduce("") { $0 + $1 + "\n" }
        do {
            try contents.write(to: outputFileUrl, atomically: true, encoding: .utf8)
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
}
