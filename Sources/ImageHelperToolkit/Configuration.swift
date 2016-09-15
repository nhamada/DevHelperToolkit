//
//  Configuration.swift
//  DevHelperToolkit
//
//  Created by Naohiro Hamada on 2016/09/13.
//
//

import Foundation

public struct ImageHelperToolkitConfiguration {
    public enum TargetPlatform: String {
        case ios
        case osx
        
        var className: String {
            switch self {
            case .ios:
                return "UIImage"
            case .osx:
                return "NSImage"
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
    
    public static func configuration(platform: TargetPlatform) -> ImageHelperToolkitConfiguration {
        return ImageHelperToolkitConfiguration(editorTabSpacing: `default`.editorTabSpacing, platform: platform)
    }
}

internal let `default` = ImageHelperToolkitConfiguration(editorTabSpacing: "    ", platform: .ios)
