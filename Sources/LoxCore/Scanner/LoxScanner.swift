public class LoxScanner {
    private let characters: [Character]
    private var tokens: [Token] = []

    private var start = 0
    private var current = 0
    private var line = 1

    public init(source: String) {
        self.characters = Array(source)
    }

    // MARK: - Public API

    public func scanTokens() -> [Token] {
        while !isAtEnd {
            start = current
            scanToken()
        }
        tokens.append(Token(type: .eof, lexeme: "", literal: .nil, line: line))
        return tokens
    }

    // MARK: - Scan methods

    private func scanToken() {
        let c = advance()
        switch c {
        case "(": addToken(.leftParen)
        case ")": addToken(.rightParen)
        case "{": addToken(.leftBrace)
        case "}": addToken(.rightBrace)
        case ",": addToken(.comma)
        case ".": addToken(.dot)
        case "-": addToken(.minus)
        case "+": addToken(.plus)
        case ";": addToken(.semicolon)
        case "*": addToken(.star)
        case "!": addToken(match("=") ? .bangEqual : .bang)
        case "=": addToken(match("=") ? .equalEqual : .equal)
        case "<": addToken(match("=") ? .lessEqual : .less)
        case ">": addToken(match("=") ? .greaterEqual : .greater)
        case "/":
            if match("/") {
                while peek() != "\n" && !isAtEnd { advance() }
            } else {
                addToken(.slash)
            }
        case " ", "\r", "\t":
            break
        case "\n":
            line += 1
        case "\"":
            scanString()
        default:
            if c.isWholeNumber {
                scanNumber()
            } else if c.isLetter || c == "_" {
                scanIdentifier()
            } else {
                Lox.error(line: line, message: "Unexpected character.")
            }
        }
    }

    private func scanString() {
        while peek() != "\"" && !isAtEnd {
            if peek() == "\n" { line += 1 }
            advance()
        }

        if isAtEnd {
            Lox.error(line: line, message: "Unterminated string.")
            return
        }

        advance() // closing "

        let value = String(characters[start + 1 ..< current - 1])
        addToken(.string, literal: .string(value))
    }

    private func scanNumber() {
        while peek().isWholeNumber { advance() }

        if peek() == "." && peekNext().isWholeNumber {
            advance() // consume the "."
            while peek().isWholeNumber { advance() }
        }

        addToken(.number, literal: .number(Double(String(characters[start..<current]))!))
    }

    private func scanIdentifier() {
        while isIdentifierChar(peek()) { advance() }

        let text = String(characters[start..<current])
        addToken(LoxScanner.keywords[text] ?? .identifier)
    }

    // MARK: - Primitives

    @discardableResult
    private func advance() -> Character {
        let c = characters[current]
        current += 1
        return c
    }

    private func peek() -> Character {
        guard !isAtEnd else { return "\0" }
        return characters[current]
    }

    private func peekNext() -> Character {
        guard current + 1 < characters.count else { return "\0" }
        return characters[current + 1]
    }

    private func match(_ expected: Character) -> Bool {
        guard !isAtEnd, characters[current] == expected else { return false }
        current += 1
        return true
    }

    private func addToken(_ type: TokenType, literal: LoxValue = .nil) {
        let lexeme = String(characters[start..<current])
        tokens.append(Token(type: type, lexeme: lexeme, literal: literal, line: line))
    }

    private var isAtEnd: Bool { current >= characters.count }

    private func isIdentifierChar(_ c: Character) -> Bool {
        c.isLetter || c.isWholeNumber || c == "_"
    }

    // MARK: - Static data

    private static let keywords: [String: TokenType] = [
        "and":    .and,
        "class":  .class,
        "else":   .else,
        "false":  .false,
        "for":    .for,
        "fun":    .fun,
        "if":     .if,
        "nil":    .nil,
        "or":     .or,
        "print":  .print,
        "return": .return,
        "super":  .super,
        "this":   .this,
        "true":   .true,
        "var":    .var,
        "while":  .while,
    ]
}
