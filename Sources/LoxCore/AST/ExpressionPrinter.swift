struct ExpressionPrinter: ExpressionVisitor {
    typealias Result = String

    func print(_ expression: Expression) throws -> String {
        try expression.accept(self)
    }

    func visitBinary(left: Expression, op: Token, right: Expression) throws -> String {
        try parenthesize(op.lexeme, left, right)
    }

    func visitGrouping(expression: Expression) throws -> String {
        try parenthesize("group", expression)
    }

    func visitLiteral(value: LoxValue) throws -> String {
        value.description
    }

    func visitUnary(op: Token, right: Expression) throws -> String {
        try parenthesize(op.lexeme, right)
    }

    private func parenthesize(_ name: String, _ expressions: Expression...) throws -> String {
        let inner = try expressions.map { try $0.accept(self) }.joined(separator: " ")
        return "(\(name) \(inner))"
    }
}
