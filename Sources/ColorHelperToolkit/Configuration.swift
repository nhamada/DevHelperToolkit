//
//  Configuration.swift
//  DevHelperToolkit
//
//  Created by Naohiro Hamada on 2016/09/05.
//
//

import Foundation

public struct ColorHelperToolkitConfiguration {
    public enum TargetPlatform: String {
        case ios
        case osx
        
        var className: String {
            switch self {
            case .ios:
                return "UIColor"
            case .osx:
                return "NSColor"
            }
        }
        
        var framework: String {
            switch self {
            case .ios:
                return "UIKit"
            case .osx:
                return "AppKit"
            }
        }
    }
    
    let editorTabSpacing: String
    let platform: TargetPlatform
    
    public static func configuration(platform: TargetPlatform) -> ColorHelperToolkitConfiguration {
        return ColorHelperToolkitConfiguration(editorTabSpacing: `default`.editorTabSpacing, platform: platform)
    }
}

internal let `default` = ColorHelperToolkitConfiguration(editorTabSpacing: "    ", platform: .ios)
