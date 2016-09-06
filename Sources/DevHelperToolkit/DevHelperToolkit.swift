//
//  DevHelperToolkit.swift
//  DevHelperToolkit
//
//  Created by Naohiro Hamada on 2016/09/02.
//
//

import Foundation
import JSONHelperToolkit
import ColorHelperToolkit

public final class DevHelperToolkit {
    let args: [String]
    
    init(args: [String]) {
        self.args = args
    }
    
    public func run() {
        let option = parseCommandLineArguments()
        switch option.mode {
        case .json:
            let inputFile = option.inputFile
            let outputDirectory = option.outputDirectory
            JSONHelperToolkit.shared.generate(from: inputFile, to: outputDirectory)
        case .color:
            let inputFile = option.inputFile
            let outputDirectory = option.outputDirectory
            let configuration = ColorHelperToolkitConfiguration.configuration(platform: option.targetPlatform)
            ColorHelperToolkit.shared.generate(from: inputFile, to: outputDirectory, withConfiguration: configuration)
        }
    }
}

extension ToolkitOption {
    var inputFile: String {
        switch self.mode {
        case .json:
            for param in self.parameters {
                guard let param = param as? JsonToolkitParameter else {
                    return ""
                }
                if case .inputFile(source: let source) = param.type {
                    return source
                }
            }
            return ""
        case .color:
            for param in self.parameters {
                guard let param = param as? ColorToolkitParameter else {
                    return ""
                }
                if case .inputFile(source: let source) = param.type {
                    return source
                }
            }
            return ""
        }
    }
    
    var outputDirectory: String {
        switch self.mode {
        case .json:
            for param in self.parameters {
                guard let param = param as? JsonToolkitParameter else {
                    return "."
                }
                if case .outputDirectory(name: let directory) = param.type {
                    return directory
                }
            }
            return "."
        case .color:
            for param in self.parameters {
                guard let param = param as? ColorToolkitParameter else {
                    return "."
                }
                if case .outputDirectory(name: let directory) = param.type {
                    return directory
                }
            }
            return "."
        }
    }
    
    var targetPlatform: ColorHelperToolkitConfiguration.TargetPlatform {
        switch self.mode {
        case .color:
            for param in self.parameters {
                guard let param = param as? ColorToolkitParameter else {
                    fatalError("Invalid parameter")
                }
                if case .targetPlatform(name: let platformName) = param.type {
                    guard let platform = ColorHelperToolkitConfiguration.TargetPlatform(rawValue: platformName) else {
                        fatalError("Invalid platform")
                    }
                    return platform
                }
            }
            return .ios
        default:
            fatalError("Invalid option")
        }
    }
}
