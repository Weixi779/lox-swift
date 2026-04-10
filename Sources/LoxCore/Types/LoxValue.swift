public enum LoxValue {
    case `nil`
    case bool(Bool)
    case number(Double)
    case string(String)
}

extension LoxValue: CustomStringConvertible {
    public var description: String {
        switch self {
        case .nil:           return "nil"
        case .bool(let b):   return b ? "true" : "false"
        case .number(let n):
            return n.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(n)) : String(n)
        case .string(let s): return s
        }
    }
}

extension LoxValue: Equatable {}
