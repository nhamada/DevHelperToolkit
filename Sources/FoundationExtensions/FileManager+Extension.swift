import Foundation

public extension FileManager {
    func enumerateImageSet(atPath path: String) -> [URL] {
        return enumerate(at: path, pathExtension: "imageset", isDir: true)
    }
    
    func enumerateImageSet(at url: URL) -> [URL] {
        return enumerateImageSet(atPath: url.path)
    }
    
    func enumerateStoryboard(atPath path: String) -> [URL] {
        return enumerate(at: path, pathExtension: "storyboard")
    }
    
    func enumerateStoryboard(at url: URL) -> [URL] {
        return enumerateStoryboard(atPath: url.path)
    }
    
    func enumerateStrings(atPath path: String) -> [URL] {
        return enumerate(at: path, pathExtension: "strings")
    }
    
    func enumerateStrings(at url: URL) -> [URL] {
        return enumerateStrings(atPath: url.path)
    }
    
    private func enumerate(at path:String, pathExtension: String, isDir: Bool = false) -> [URL] {
        guard isDirectory(path), let list = enumerator(atPath: path) else {
            return []
        }
        let parent = URL(fileURLWithPath: path)
        return list.reduce([URL]()) { (partialResults, current) in
            guard let path = current as? String else {
                return partialResults
            }
            let url = parent.appendingPathComponent(path)
            guard url.pathExtension == pathExtension, isDirectory(url.path) == isDir else {
                return partialResults
            }
            return partialResults + [url]
        }
    }
    
    private func isDirectory(_ path: String) -> Bool {
        var isDirectory:ObjCBool = false
        guard fileExists(atPath: path, isDirectory: &isDirectory) else {
            return false
        }
        return isDirectory.boolValue
    }
}
