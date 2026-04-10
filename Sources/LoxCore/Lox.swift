import Foundation
import Darwin

public enum Lox {
    public static func runFile(_ path: String) throws {
        let source = try String(contentsOfFile: path, encoding: .utf8)
        run(source)
        if hadError { exit(65) }
    }

    public static func runPrompt() {
        while true {
            print("> ", terminator: "")
            guard let line = readLine() else { break }
            run(line)
            hadError = false
        }
    }

    static var hadError = false

    static func error(line: Int, message: String) {
        report(line: line, where: "", message: message)
    }

    static func error(token: Token, message: String) {
        if token.type == .eof {
            report(line: token.line, where: " at end", message: message)
        } else {
            report(line: token.line, where: " at '\(token.lexeme)'", message: message)
        }
    }

    private static func report(line: Int, where location: String, message: String) {
        fputs("[line \(line)] Error\(location): \(message)\n", stderr)
        hadError = true
    }

    static func run(_ source: String) {
        let scanner = LoxScanner(source: source)
        let tokens = scanner.scanTokens()

        for token in tokens {
            print(token)
        }
    }
}
