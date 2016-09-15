//
//  FileManager+Extension.swift
//  DevHelperToolkit
//
//  Created by Naohiro Hamada on 2016/09/13.
//
//

import Foundation

extension FileManager {
    func enumerateImageSet(atPath path: String) -> [URL] {
        guard isDirectory(atPath: path), let list = enumerator(atPath: path) else {
            return []
        }
        let parent = URL(fileURLWithPath: path)
        return list.reduce([URL]()) { (partialResults, current) in
            guard let path = current as? String else {
                return partialResults
            }
            let url = parent.appendingPathComponent(path)
            guard url.pathExtension == "imageset", isDirectory(atPath: url.path) else {
                return partialResults
            }
            return partialResults + [url]
        }
    }
    
    func enumerateImageSet(at url: URL) -> [URL] {
        return enumerateImageSet(atPath: url.path)
    }
    
    private func isDirectory(atPath path: String) -> Bool {
        var isDirectory:ObjCBool = false
        guard fileExists(atPath: path, isDirectory: &isDirectory) else {
            return false
        }
        return isDirectory.boolValue
    }
}
