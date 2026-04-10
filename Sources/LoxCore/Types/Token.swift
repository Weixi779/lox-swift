public struct Token: CustomStringConvertible {
    let type: TokenType
    let lexeme: String
    let literal: LoxValue
    let line: Int

    public var description: String {
        "\(type) \(lexeme) \(literal)"
    }
}
