# lox-swift

A Swift implementation of Lox from [Crafting Interpreters](https://craftinginterpreters.com/), built with Swift Package Manager.

## Project Structure

```
lox-swift/
├── Package.swift
├── Sources/
│   ├── lox/                   # Executable target (CLI entry point)
│   │   └── main.swift
│   └── LoxCore/               # Library target (all interpreter logic)
│       ├── Lox.swift           # Top-level coordinator: run(), error reporting
│       ├── Scanner/            # Ch.4  — TokenType, Token, Scanner
│       ├── AST/                # Ch.5  — Expression nodes
│       ├── Parser/             # Ch.6  — Recursive descent parser
│       └── Interpreter/        # Ch.7+ — Tree-walk interpreter
└── Tests/
    └── LoxCoreTests/           # Unit tests per component
```

## Progress

| Chapter | Title | Status |
|---------|-------|--------|
| 4 | Scanning | In progress |
| 5 | Representing Code | - |
| 6 | Parsing Expressions | - |
| 7 | Evaluating Expressions | - |
| 8 | Statements and State | - |
| 9 | Control Flow | - |
| 10 | Functions | - |
| 11 | Resolving and Binding | - |
| 12 | Classes | - |
| 13 | Inheritance | - |

## Reference

- [Book (Chinese)](https://github.com/GuoYaxiang/craftinginterpreters_zh)
- [Book (English)](https://craftinginterpreters.com/)
