//
//  ToolkitOptions.swift
//  DevHelperToolkit
//
//  Created by Naohiro Hamada on 2016/09/02.
//
//

import Foundation

enum ToolkitModeOption: String {
    case json
    case color
    case image
}

protocol ParameterType { }

enum JsonToolkitParameterType: ParameterType {
    case inputFile(source: String)
    case outputDirectory(name: String)
}

enum ColorToolkitParameterType: ParameterType {
    case inputFile(source: String)
    case outputDirectory(name: String)
    case targetPlatform(name: String)
}

enum ImageToolkitParameterType: ParameterType {
    case inputAssetDirectory(source: String)
    case outputDirectory(name: String)
    case targetPlatform(name: String)
}

protocol ToolkitParameter {
    var shortName: String { get }
    var longName: String { get }
    
    func match(_ option: String) -> Bool
}

extension ToolkitParameter {
    func match(_ option: String) -> Bool {
        return option == shortName || option == longName
    }
}

struct JsonToolkitParameter: ToolkitParameter {
    let shortName: String
    let longName: String
    let type: JsonToolkitParameterType
}

struct ColorToolkitParameter: ToolkitParameter {
    let shortName: String
    let longName: String
    let type: ColorToolkitParameterType
}

struct ImageToolkitParameter: ToolkitParameter {
    let shortName: String
    let longName: String
    let type: ImageToolkitParameterType
}

struct ToolkitOption {
    let mode: ToolkitModeOption
    let parameters: [ToolkitParameter]
}

func parseCommandLineArguments() -> ToolkitOption {
    let args = CommandLine.arguments.dropFirst()
    guard !args.isEmpty else {
        exit(0)
    }
    
    guard let first = args.first,
        let modeOption = ToolkitModeOption(rawValue: first) else {
        exit(0)
    }
    switch modeOption {
    case .json:
        let parser = JsonParameterParser()
        let parameters = parser.parse(parameters: Array(args.dropFirst()))
        return ToolkitOption(mode: modeOption, parameters: parameters)
    case .color:
        let parser = ColorParameterParer()
        let parameters = parser.parse(parameters: Array(args.dropFirst()))
        return ToolkitOption(mode: modeOption, parameters: parameters)
    case .image:
        let parser = ImageParameterParer()
        let parameters = parser.parse(parameters: Array(args.dropFirst()))
        return ToolkitOption(mode: modeOption, parameters: parameters)
    }
}

private final class JsonParameterParser {
    private let paramDefinition: [JsonToolkitParameter] = [
        JsonToolkitParameter(shortName: "", longName: "", type: .inputFile(source: "")),
        JsonToolkitParameter(shortName: "-o", longName: "--output-directory", type: .outputDirectory(name: "")),
    ]

    internal func parse(parameters: [String]) -> [ToolkitParameter] {
        guard let first = parameters.first else {
            return []
        }
        var current = [ToolkitParameter]()
        var rest = [ToolkitParameter]()
        if first.hasSuffix(".json") {
            current.append(JsonToolkitParameter(shortName: "", longName: "", type: .inputFile(source: first)))
            rest = parse(parameters: Array(parameters.dropFirst()))
        } else {
            for param in paramDefinition {
                if param.match(first) {
                    switch param.type {
                    case .outputDirectory(name: _):
                        guard parameters.count > 1 else {
                            return []
                        }
                        current.append(JsonToolkitParameter(shortName: param.shortName, longName: param.longName, type: .outputDirectory(name: parameters[1])))
                        rest = parse(parameters: Array(parameters.dropFirst(2)))
                    case .inputFile(source: _):
                        return []
                    }
                }
            }
        }
        current.append(contentsOf: rest)
        return current
    }
}

private final class ColorParameterParer {
    private let paramDefinition: [ColorToolkitParameter] = [
        ColorToolkitParameter(shortName: "", longName: "", type: .inputFile(source: "")),
        ColorToolkitParameter(shortName: "-o", longName: "--output-directory", type: .outputDirectory(name: "")),
        ColorToolkitParameter(shortName: "-p", longName: "--platform", type: .targetPlatform(name: "")),
    ]
    
    internal func parse(parameters: [String]) -> [ToolkitParameter] {
        guard let first = parameters.first else {
            return []
        }
        var current = [ToolkitParameter]()
        var rest = [ToolkitParameter]()
        if first.hasSuffix(".json") {
            current.append(ColorToolkitParameter(shortName: "", longName: "", type: .inputFile(source: first)))
            rest = parse(parameters: Array(parameters.dropFirst()))
        } else {
            for param in paramDefinition {
                if param.match(first) {
                    switch param.type {
                    case .outputDirectory(name: _):
                        guard parameters.count > 1 else {
                            return []
                        }
                        current.append(ColorToolkitParameter(shortName: param.shortName, longName: param.longName, type: .outputDirectory(name: parameters[1])))
                        rest = parse(parameters: Array(parameters.dropFirst(2)))
                    case .targetPlatform(name: _):
                        guard parameters.count > 1 else {
                            return []
                        }
                        current.append(ColorToolkitParameter(shortName: param.shortName, longName: param.longName, type: .targetPlatform(name: parameters[1])))
                        rest = parse(parameters: Array(parameters.dropFirst(2)))
                    case .inputFile(source: _):
                        return []
                    }
                }
            }
        }
        current.append(contentsOf: rest)
        return current
    }
}

private final class ImageParameterParer {
    private let paramDefinition: [ImageToolkitParameter] = [
        ImageToolkitParameter(shortName: "", longName: "", type: .inputAssetDirectory(source: "")),
        ImageToolkitParameter(shortName: "-o", longName: "--output-directory", type: .outputDirectory(name: "")),
        ImageToolkitParameter(shortName: "-p", longName: "--platform", type: .targetPlatform(name: "")),
        ]
    
    internal func parse(parameters: [String]) -> [ToolkitParameter] {
        guard let first = parameters.first else {
            return []
        }
        var current = [ToolkitParameter]()
        var rest = [ToolkitParameter]()
        if first.hasSuffix(".xcassets") {
            current.append(ImageToolkitParameter(shortName: "", longName: "", type: .inputAssetDirectory(source: first)))
            rest = parse(parameters: Array(parameters.dropFirst()))
        } else {
            for param in paramDefinition {
                if param.match(first) {
                    switch param.type {
                    case .outputDirectory(name: _):
                        guard parameters.count > 1 else {
                            return []
                        }
                        current.append(ImageToolkitParameter(shortName: param.shortName, longName: param.longName, type: .outputDirectory(name: parameters[1])))
                        rest = parse(parameters: Array(parameters.dropFirst(2)))
                    case .targetPlatform(name: _):
                        guard parameters.count > 1 else {
                            return []
                        }
                        current.append(ImageToolkitParameter(shortName: param.shortName, longName: param.longName, type: .targetPlatform(name: parameters[1])))
                        rest = parse(parameters: Array(parameters.dropFirst(2)))
                    case .inputAssetDirectory(source: _):
                        return []
                    }
                }
            }
        }
        current.append(contentsOf: rest)
        return current
    }
}
