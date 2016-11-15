internal enum StringsTokenType {
    case value
    case assign
    case space
    case deliminator
    case comment
}

internal struct StringsToken {
    let type: StringsTokenType
    let value: String
    let startIndex: Int
    let endIndex: Int
}
