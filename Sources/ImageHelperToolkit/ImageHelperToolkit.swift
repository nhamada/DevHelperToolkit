//
//  ImageHelperToolkit
//  DevHelperToolkit
//
//  Created by Naohiro Hamada on 2016/09/13.
//
//

import Foundation

public final class ImageHelperToolkit {
    public static let shared = ImageHelperToolkit()
    
    private init() { }
    
    public func generate(from filepath: String,
                         to outputDirectory: String,
                         withConfiguration configuration: ImageHelperToolkitConfiguration = `default`) {
        let url = URL(fileURLWithPath: filepath)
        generate(from: url, to: outputDirectory, withConfiguration: configuration)
    }
    
    public func generate(from url: URL,
                         to outputDirectory: String,
                         withConfiguration configuration: ImageHelperToolkitConfiguration = `default`) {
        let fileManager = FileManager.default
        let imageSetUrls = fileManager.enumerateImageSet(at: url)
        let contents = makeContents(imageSetUrls, configuration)
        
        let outputDirUrl = URL(fileURLWithPath: outputDirectory)
        let destination = outputDirUrl.appendingPathComponent("\(configuration.platform.className)+Extension.swift")
        do {
            try contents.write(to: destination, atomically: true, encoding: .utf8)
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    private func makeContents(_ imageSetUrls: [URL], _ configuration: ImageHelperToolkitConfiguration) -> String {
        let platform = configuration.platform
        let tab = configuration.editorTabSpacing
        var contents = [String]()
        
        contents.append("import \(platform.framework)")
        contents.append("")
        contents.append("extension \(platform.className) {")
        contents.append("\(tab)enum Asset {")
        for url in imageSetUrls {
            contents.append("\(tab)\(tab)case \(url.enumName)")
        }
        contents.append("")
        contents.append("\(tab)\(tab)var name: String {")
        contents.append("\(tab)\(tab)\(tab)switch self {")
        for url in imageSetUrls {
            contents.append("\(tab)\(tab)\(tab)case .\(url.enumName):")
            contents.append("\(tab)\(tab)\(tab)\(tab)return \"\(url.assetName)\"")
        }
        contents.append("\(tab)\(tab)\(tab)}")
        contents.append("\(tab)\(tab)}")
        contents.append("")
        contents.append("\(tab)\(tab)var image: \(platform.className) {")
        contents.append("\(tab)\(tab)\(tab)return \(platform.className)(asset: self)")
        contents.append("\(tab)\(tab)}")
        contents.append("\(tab)}")
        contents.append("")
        contents.append("\(tab)convenience init(asset: Asset) {")
        contents.append("\(tab)\(tab)self.init(named: asset.name)!")
        contents.append("\(tab)}")
        contents.append("}")
        
        return contents.reduce("") { $0 + $1 + "\n" }
    }
}
