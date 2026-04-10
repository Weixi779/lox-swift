indirect enum Expression {
    case binary(left: Expression, op: Token, right: Expression)
    case grouping(expression: Expression)
    case literal(value: LoxValue)
    case unary(op: Token, right: Expression)
}

// MARK: - Visitor

protocol ExpressionVisitor {
    associatedtype Result
    func visitBinary(left: Expression, op: Token, right: Expression) throws -> Result
    func visitGrouping(expression: Expression) throws -> Result
    func visitLiteral(value: LoxValue) throws -> Result
    func visitUnary(op: Token, right: Expression) throws -> Result
}

extension Expression {
    func accept<Visitor: ExpressionVisitor>(_ visitor: Visitor) throws -> Visitor.Result {
        switch self {
        case .binary(let left, let op, let right):
            return try visitor.visitBinary(left: left, op: op, right: right)
        case .grouping(let expression):
            return try visitor.visitGrouping(expression: expression)
        case .literal(let value):
            return try visitor.visitLiteral(value: value)
        case .unary(let op, let right):
            return try visitor.visitUnary(op: op, right: right)
        }
    }
}
