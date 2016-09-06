//
//  ColorHelperToolkit.swift
//  DevHelperToolkit
//
//  Created by Naohiro Hamada on 2016/09/05.
//
//

import Foundation

public final class ColorHelperToolkit {
    public static let shared = ColorHelperToolkit()
    
    private init() { }
    
    public func generate(from filepath: String,
                         to outputDirectory: String,
                         withConfiguration configuration: ColorHelperToolkitConfiguration = `default`) {
        let url = URL(fileURLWithPath: filepath)
        generate(from: url, to: outputDirectory, withConfiguration: configuration)
    }
    
    public func generate(from url: URL,
                         to outputDirectory: String,
                         withConfiguration configuration: ColorHelperToolkitConfiguration = `default`) {
        guard let fileType = url.fileType else {
            fatalError("Invalid file type: \(url.absoluteString)")
        }
        let parser = fileType.parser()
        let models = parser.parse(url: url)
        let contents = makeContents(models, configuration)
        
        let outputDirUrl = URL(fileURLWithPath: outputDirectory)
        let destination = outputDirUrl.appendingPathComponent("\(configuration.platform.className)+Extension.swift")
        do {
            try contents.write(to: destination, atomically: true, encoding: .utf8)
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    private func makeContents(_ models: [ColorDefinition], _ configuration: ColorHelperToolkitConfiguration) -> String {
        let platform = configuration.platform
        let tab = configuration.editorTabSpacing
        var contents = [String]()
        
        contents.append("import \(platform.framework)")
        contents.append("")
        contents.append("extension \(platform.className) {")
        for m in models {
            contents.append("\(tab)class var \(m.propertyName): \(platform.className) {")
            contents.append("\(tab)\(tab)return \(m.initializeStatement(platform: platform))")
            contents.append("\(tab)}")
        }
        contents.append("}")
        
        return contents.reduce("") { $0 + $1 + "\n" }
    }
}
