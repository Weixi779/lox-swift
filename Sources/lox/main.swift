import Darwin
import LoxCore

let args = CommandLine.arguments.dropFirst() // drop the executable path

if args.count > 1 {
    print("Usage: lox [script]")
    exit(64)
} else if args.count == 1 {
    try Lox.runFile(args.first!)
} else {
    Lox.runPrompt()
}
