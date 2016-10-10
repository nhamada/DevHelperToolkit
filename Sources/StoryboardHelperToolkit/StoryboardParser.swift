import Foundation

struct StoryboardParser {
    
    
    static func parse(_ filepath: String) -> Storyboard {
        let url = URL(fileURLWithPath: filepath)
        return parse(url)
    }
    
    static func parse(_ url: URL) -> Storyboard {
        guard let parser = XMLParser(contentsOf: url) else {
            fatalError("Cannot instantiate parser")
        }
        let delegate = StoryboardParserDelegate()
        parser.delegate = delegate
        parser.parse()
        let name = url.lastPathComponent.replacingOccurrences(of: "." + url.pathExtension, with: "")
        return Storyboard(name: name, scenes: delegate.scenes)
    }
}

fileprivate class StoryboardParserDelegate: NSObject, XMLParserDelegate {
    override init() {
        super.init()
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        guard let element = Element(rawValue: elementName) else {
            return
        }
        switch element {
        case .document:
            guard let initial = attributeDict[Attribute.initialViewController] else {
                return
            }
            initialStoryboardIdentifier = initial
        case .viewController:
            guard let id = attributeDict[Attribute.id], let identifier = attributeDict[Attribute.storyboardIdentifier] else {
                return
            }
            scenes.append(StoryboardScene(identifier: identifier, initial: id == initialStoryboardIdentifier))
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
    }
    
    var scenes: [StoryboardScene] = []
    var initialStoryboardIdentifier: String = ""
    
    enum Element: String {
        case document = "document"
        case viewController = "viewController"
    }
    
    struct Attribute {
        static let initialViewController = "initialViewController"
        static let id = "id"
        static let storyboardIdentifier = "storyboardIdentifier"
    }
}
