import Foundation

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
        contents.append("\(tab)enum Name {")
        for storyboard in storyboards {
            contents.append("\(tab)\(tab)case \(storyboard.name.lowerCamelCased) = \"\(storyboard.name)\"")
        }
        contents.append("\(tab)}")
        contents.append("")
        contents.append("\(tab)enum Identifier {")
        for storyboard in storyboards {
            for scene in storyboard.scenes {
                contents.append("\(tab)\(tab)case \(scene.identifier.lowerCamelCased) = \"\(scene.identifier)\"")
            }
        }
        contents.append("\(tab)}")
        contents.append("")
        contents.append("\(tab)static func instantiateViewController(name: Name, withIdentifier identifier: Identifier) -> \(platform.viewController) {")
        contents.append("\(tab)\(tab)let storyboard = \(platform.className)(name: name.rawValue, bundle: nil)")
        contents.append("\(tab)\(tab)return storyboard.instantiateViewController(withIdentifier: identifier.rawValue)")
        contents.append("\(tab)}")
        contents.append("}")
        
        return contents.reduce("") { $0 + $1 + "\n" }
    }
}
