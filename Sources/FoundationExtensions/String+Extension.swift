import Foundation

public extension String {
    func lowerCamelCased(skip: Bool = false) -> String {
        if skip {
            return self
        }
        if self.isEmpty {
            return ""
        }
        let comps = self.components(separatedBy: CharacterSet(charactersIn: " -_"))
        return comps.dropFirst().reduce(comps[0].lowercased(), { $0 + $1.capitalized })
    }
    
    func upperCamelCased() -> String {
        if self.isEmpty {
            return ""
        }
        let comps = self.components(separatedBy: CharacterSet(charactersIn: " -_"))
        return comps.reduce("", { $0 + $1.capitalized })
    }
}
