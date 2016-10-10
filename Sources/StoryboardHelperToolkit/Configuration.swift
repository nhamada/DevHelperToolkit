import Foundation

public struct StoryboardHelperToolkitConfiguration {
    public enum TargetPlatform: String {
        case ios
        case osx
        
        var className: String {
            switch self {
            case .ios:
                return "UIStoryboard"
            case .osx:
                return "NSStoryboard"
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
        
        var viewController: String {
            switch self {
            case .ios:
                return "UIViewController"
            case .osx:
                return "NSViewController"
            }
        }
    }
    
    let editorTabSpacing: String
    let platform: TargetPlatform
    
    public static func configuration(platform: TargetPlatform) -> StoryboardHelperToolkitConfiguration {
        return StoryboardHelperToolkitConfiguration(editorTabSpacing: `default`.editorTabSpacing, platform: platform)
    }
}

internal let `default` = StoryboardHelperToolkitConfiguration(editorTabSpacing: "    ", platform: .ios)
