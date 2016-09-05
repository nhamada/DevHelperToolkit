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
        for m in models {
            print(m)
        }
    }
}
