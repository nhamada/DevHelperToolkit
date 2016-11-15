import Foundation
import FoundationExtensions

public final class StringsHelperToolkit {
    public static let shared = StringsHelperToolkit()
    
    private init() { }
    
    public func generate(from filepath: String,
                         to outputDirectory: String,
                         withConfiguration configuration: StringsToolkitConfiguration = `default`) {
        let url = URL(fileURLWithPath: filepath)
        generate(from: url, to: outputDirectory, withConfiguration: configuration)
    }
    
    public func generate(from url: URL,
                         to outputDirectory: String,
                         withConfiguration configuration: StringsToolkitConfiguration = `default`) {
        let fileManager = FileManager.default
        let stringsFiles = fileManager.enumerateStrings(at: url)
        let dic: [String:[URL]] = stringsFiles.reduce([:]) {
            var partial = $0
            let filename = $1.lastPathComponent.replacingOccurrences(of: ".\($1.pathExtension)", with: "")
            if partial.contains(where: { $0.key == filename } ) {
                partial[filename]?.append($1)
            } else {
                partial[filename] = [$1]
            }
            return partial
        }
        
        let strings = dic.map {
            generateStrings(table: $0.key, urls: $0.value)
        }
        
        let contents = makeContents(strings, configuration)
        
        let outputDirUrl = URL(fileURLWithPath: outputDirectory)
        let destination = outputDirUrl.appendingPathComponent("String+Localizable.swift")
        do {
            try contents.write(to: destination, atomically: true, encoding: .utf8)
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    private func makeContents(_ strings: [Strings], _ configuration: StringsToolkitConfiguration) -> String {
        let tab = configuration.editorTabSpacing
        var contents = [String]()
        
        let localizable = "Localizable"
        
        contents.append("import Foundation")
        contents.append("")
        contents.append("extension String {")
        contents.append("\(tab)enum \(localizable) {")
        for localize in strings {
            if localize.table == localizable {
                continue
            }
            contents.append("\(tab)\(tab)enum \(localize.table) {")
            for key in localize.keys {
                contents.append("\(tab)\(tab)\(tab)case \(key.removing().lowerCamelCased())")
            }
            contents.append("")
            contents.append("\(tab)\(tab)\(tab)private static var tableName: String {")
            contents.append("\(tab)\(tab)\(tab)\(tab)return \"\(localize.table)\"")
            contents.append("\(tab)\(tab)\(tab)}")
            contents.append("")
            contents.append("\(tab)\(tab)\(tab)private var key: String {")
            contents.append("\(tab)\(tab)\(tab)\(tab)switch self {")
            for key in localize.keys {
                contents.append("\(tab)\(tab)\(tab)\(tab)case .\(key.removing().lowerCamelCased()):")
                contents.append("\(tab)\(tab)\(tab)\(tab)\(tab)return \"\(key)\"")
            }
            contents.append("\(tab)\(tab)\(tab)\(tab)}")
            contents.append("\(tab)\(tab)\(tab)}")
            contents.append("")
            contents.append("\(tab)\(tab)\(tab)func localizedString() -> String {")
            contents.append("\(tab)\(tab)\(tab)\(tab)return String.localizedString(key: self.key, table: String.\(localizable).\(localize.table).tableName)")
            contents.append("\(tab)\(tab)\(tab)}")
            contents.append("\(tab)\(tab)}")
            contents.append("")
        }
        for localize in strings {
            if localize.table != localizable {
                continue
            }
            for key in localize.keys {
                contents.append("\(tab)\(tab)case \(key.removing().lowerCamelCased())")
            }
            contents.append("")
            contents.append("\(tab)\(tab)private static var tableName: String {")
            contents.append("\(tab)\(tab)\(tab)return \"\(localize.table)\"")
            contents.append("\(tab)\(tab)}")
            contents.append("")
            contents.append("\(tab)\(tab)private var key: String {")
            contents.append("\(tab)\(tab)\(tab)switch self {")
            for key in localize.keys {
                contents.append("\(tab)\(tab)\(tab)case .\(key.removing().lowerCamelCased()):")
                contents.append("\(tab)\(tab)\(tab)\(tab)return \"\(key)\"")
            }
            contents.append("\(tab)\(tab)\(tab)}")
            contents.append("\(tab)\(tab)}")
            contents.append("")
            contents.append("\(tab)\(tab)func localizedString() -> String {")
            contents.append("\(tab)\(tab)\(tab)return String.localizedString(key: self.key, table: String.\(localize.table).tableName)")
            contents.append("\(tab)\(tab)}")
        }
        contents.append("\(tab)}")
        contents.append("")
        contents.append("\(tab)private static func localizedString(key: String, table: String) -> String {")
        contents.append("\(tab)\(tab)return NSLocalizedString(key, tableName: table, bundle: Bundle.main, value: \"\", comment: key)")
        contents.append("\(tab)}")
        contents.append("}")
        
        return contents.reduce("") { $0 + $1 + "\n" }
    }
    
    private func generateStrings(table: String, urls: [URL]) -> Strings {
        let tokens = urls.map {
            StringsTokenizer.tokenize($0).filter {
                $0.type == .value
            }
        }
        var keyArray = [String]()
        for tokens in tokens {
            for i in 0..<tokens.count {
                let rawValue = tokens[i].value
                let value = rawValue.substring(with: Range(uncheckedBounds: (rawValue.index(rawValue.startIndex, offsetBy: 1), rawValue.index(rawValue.endIndex, offsetBy: -1))))
                if i % 2 == 0 && !keyArray.contains(value) {
                    keyArray.append(value)
                }
            }
        }
        return Strings(table: table, keys: keyArray)
    }
}

private extension String {
    func removing() -> String {
        return self.removingFormattedCharacters().removingEscapedCharacters()
    }
    
    func removingFormattedCharacters() -> String {
        let exp = try? NSRegularExpression(pattern: "(%)(@|[0-9]*d|([0-9]*\\.[0-9]+)?(l)?f|g)", options: .allowCommentsAndWhitespace)
        let string = NSMutableString(string: self)
        exp?.replaceMatches(in: string, options: .withoutAnchoringBounds, range: NSRange(location: 0, length: string.length), withTemplate: " arg ")
        return String(string)
    }
    func removingEscapedCharacters() -> String {
        let exp = try? NSRegularExpression(pattern: "(\\t)|(\\\")|(\\n)|(\\r)|(\\\')|(\\\\)", options: .allowCommentsAndWhitespace)
        let string = NSMutableString(string: self)
        exp?.replaceMatches(in: string, options: .withoutAnchoringBounds, range: NSRange(location: 0, length: string.length), withTemplate: " ")
        return String(string)
    }
}
