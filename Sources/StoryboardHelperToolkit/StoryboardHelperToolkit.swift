import Foundation
import FoundationExtensions

public final class StoryboardHelperToolkit {
    public static let shared = StoryboardHelperToolkit()
    
    private init() { }
    
    public func generate(from filepath: String,
                         to outputDirectory: String,
                         withConfiguration configuration: StoryboardHelperToolkitConfiguration = `default`) {
        let url = URL(fileURLWithPath: filepath)
        generate(from: url, to: outputDirectory, withConfiguration: configuration)
    }
    
    public func generate(from url: URL,
                         to outputDirectory: String,
                         withConfiguration configuration: StoryboardHelperToolkitConfiguration = `default`) {
        let fileManager = FileManager.default
        let storyboards = fileManager.enumerateStoryboard(at: url).map {
            return StoryboardParser.parse($0)
        }
        let contents = makeContents(storyboards, configuration)
        
        let outputDirUrl = URL(fileURLWithPath: outputDirectory)
        let destination = outputDirUrl.appendingPathComponent("\(configuration.platform.className)+Extension.swift")
        do {
            try contents.write(to: destination, atomically: true, encoding: .utf8)
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    private func makeContents(_ storyboards: [Storyboard], _ configuration: StoryboardHelperToolkitConfiguration) -> String {
        let platform = configuration.platform
        let tab = configuration.editorTabSpacing
        var contents = [String]()
        
        contents.append("import \(platform.framework)")
        contents.append("")
        contents.append("extension \(platform.className) {")
        for storyboard in storyboards {
            if storyboard.scenes.isEmpty {
                continue
            }
            
            let name = storyboard.name
            contents.append("\(tab)enum \(name.upperCamelCased()) {")
            for scene in storyboard.scenes {
                contents.append("\(tab)\(tab)case \(scene.identifier.lowerCamelCased())")
            }
            contents.append("")
            contents.append("\(tab)\(tab)private var identifier: String {")
            contents.append("\(tab)\(tab)\(tab)switch self {")
            for scene in storyboard.scenes {
                contents.append("\(tab)\(tab)\(tab)case .\(scene.identifier.lowerCamelCased()):")
                contents.append("\(tab)\(tab)\(tab)\(tab)return \"\(scene.identifier)\"")
            }
            contents.append("\(tab)\(tab)\(tab)}")
            contents.append("\(tab)\(tab)}")
            contents.append("")
            contents.append("\(tab)\(tab)var viewController: \(platform.viewController) {")
            contents.append("\(tab)\(tab)\(tab)let storyboard = \(platform.className)(name: \"\(name)\", bundle: nil)")
            contents.append("\(tab)\(tab)\(tab)return storyboard.instantiateViewController(withIdentifier: self.identifier)")
            contents.append("\(tab)\(tab)}")
            contents.append("\(tab)}")
            
            if let last = storyboards.last, last.name != storyboard.name {
                contents.append("")
            }
        }
        contents.append("}")
        
        return contents.reduce("") { $0 + $1 + "\n" }
    }
}
