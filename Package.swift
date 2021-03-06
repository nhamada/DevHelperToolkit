import PackageDescription

let package = Package(
    name: "DevHelperToolkit",
    targets: [
        Target(name: "DevHelperToolkit",
               dependencies: ["JSONHelperToolkit", "ColorHelperToolkit", "ImageHelperToolkit", "StoryboardHelperToolkit", "StringsHelperToolkit"]),
        Target(name: "JSONHelperToolkit", dependencies: ["FoundationExtensions"]),
        Target(name: "ImageHelperToolkit", dependencies: ["FoundationExtensions"]),
        Target(name: "StoryboardHelperToolkit", dependencies: ["FoundationExtensions"]),
        Target(name: "StringsHelperToolkit", dependencies: ["FoundationExtensions"]),
        Target(name: "FoundationExtensions")
    ],
    exclude: ["Resources"]
)
