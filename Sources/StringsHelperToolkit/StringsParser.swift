import Foundation

internal struct StringsParser {
    static func parse(at filepath: String) -> [String:String] {
        let tokens = StringsTokenizer.tokenize(at: filepath)
        return parse(tokens)
    }
    
    static func parse(_ url: URL) -> [String:String] {
        let tokens = StringsTokenizer.tokenize(url)
        return parse(tokens)
    }
    
    static func parse(_ string: String) -> [String:String] {
        let tokens = StringsTokenizer.tokenize(string)
        return parse(tokens)
    }
    
    private static func parse(_ tokens: [StringsToken]) -> [String:String] {
        let dic = makeDictionary(from: tokens)
        return dic
    }
    
    private static func makeDictionary(from tokens: [StringsToken]) -> [String:String] {
        var dic = [String:String]()
        var queue = [StringsToken]()
        for token in tokens {
            switch token.type {
            case .value:
                queue.append(token)
            case .deliminator:
                let key = queue.removeFirst()
                let value = queue.removeFirst()
                dic[key.value] = value.value
            default:
                break
            }
        }
        return dic
    }
}
