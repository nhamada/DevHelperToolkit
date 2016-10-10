struct Storyboard {
    let name: String
    let scenes: [StoryboardScene]
}

struct StoryboardScene {
    let identifier: String
    let initial: Bool
}
