public class LoxParser {
    private let tokens: [Token]
    private var current = 0

    public init(tokens: [Token]) {
        self.tokens = tokens
    }

    // MARK: - Public API

    public func parse() -> Expression? {
        do {
            return try expression()
        } catch {
            return nil
        }
    }

    // MARK: - Grammar rules

    private func expression() throws -> Expression {
        try equality()
    }

    private func equality() throws -> Expression {
        var expression = try comparison()

        while match(.bangEqual, .equalEqual) {
            let op = previous()
            let right = try comparison()
            expression = .binary(left: expression, op: op, right: right)
        }

        return expression
    }

    private func comparison() throws -> Expression {
        var expression = try term()

        while match(.greater, .greaterEqual, .less, .lessEqual) {
            let op = previous()
            let right = try term()
            expression = .binary(left: expression, op: op, right: right)
        }

        return expression
    }

    private func term() throws -> Expression {
        var expression = try factor()

        while match(.minus, .plus) {
            let op = previous()
            let right = try factor()
            expression = .binary(left: expression, op: op, right: right)
        }

        return expression
    }

    private func factor() throws -> Expression {
        var expression = try unary()

        while match(.slash, .star) {
            let op = previous()
            let right = try unary()
            expression = .binary(left: expression, op: op, right: right)
        }

        return expression
    }

    private func unary() throws -> Expression {
        if match(.bang, .minus) {
            let op = previous()
            let right = try unary()
            return .unary(op: op, right: right)
        }

        return try primary()
    }

    private func primary() throws -> Expression {
        if match(.false) { return .literal(value: .bool(false)) }
        if match(.true)  { return .literal(value: .bool(true)) }
        if match(.nil)   { return .literal(value: .nil) }

        if match(.number, .string) {
            return .literal(value: previous().literal)
        }

        if match(.leftParen) {
            let expression = try expression()
            try consume(.rightParen, message: "Expect ')' after expression.")
            return .grouping(expression: expression)
        }

        throw error(peek(), message: "Expect expression.")
    }

    // MARK: - Error handling

    private enum ParseError: Error {
        case error(Token, String)
    }

    @discardableResult
    private func consume(_ type: TokenType, message: String) throws -> Token {
        if check(type) { return advance() }
        throw error(peek(), message: message)
    }

    private func error(_ token: Token, message: String) -> ParseError {
        Lox.error(token: token, message: message)
        return .error(token, message)
    }

    private func synchronize() {
        advance()

        while !isAtEnd {
            if previous().type == .semicolon { return }

            switch peek().type {
            case .class, .fun, .var, .for, .if, .while, .print, .return:
                return
            default:
                break
            }

            advance()
        }
    }

    // MARK: - Primitives

    private func match(_ types: TokenType...) -> Bool {
        for type in types {
            if check(type) {
                advance()
                return true
            }
        }
        return false
    }

    @discardableResult
    private func advance() -> Token {
        if !isAtEnd { current += 1 }
        return previous()
    }

    private func check(_ type: TokenType) -> Bool {
        guard !isAtEnd else { return false }
        return peek().type == type
    }

    private func peek() -> Token {
        tokens[current]
    }

    private func previous() -> Token {
        tokens[current - 1]
    }

    private var isAtEnd: Bool {
        peek().type == .eof
    }
}
