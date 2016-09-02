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
}

protocol ParameterType { }

enum JsonToolkitParameterType: ParameterType {
    case inputFile(source: String)
    case outputDirectory(name: String)
}

protocol ToolkitParameter { }

struct JsonToolkitParameter: ToolkitParameter {
    let shortName: String
    let longName: String
    let type: JsonToolkitParameterType
    
    func match(_ option: String) -> Bool {
        return option == shortName || option == longName
    }
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
