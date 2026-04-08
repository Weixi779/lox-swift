import Testing
@testable import LoxCore

// MARK: - Helpers

private func scan(_ source: String) -> [Token] {
    LoxScanner(source: source).scanTokens()
}

private func tokenTypes(_ source: String) -> [TokenType] {
    scan(source).map(\.type)
}

// MARK: - Scanner tests

@Suite("Scanner", .tags(.scanner))
struct ScannerTests {
    
    // MARK: - Single-character tokens
    
    @Suite("Single-character tokens")
    struct SingleCharTokenTests {
        @Test(arguments: [
            ("(", TokenType.leftParen),
            (")", .rightParen),
            ("{", .leftBrace),
            ("}", .rightBrace),
            (",", .comma),
            (".", .dot),
            ("-", .minus),
            ("+", .plus),
            (";", .semicolon),
            ("*", .star),
            ("/", .slash),
        ])
        func singleChar(input: String, expected: TokenType) {
            #expect(tokenTypes(input) == [expected, .eof])
        }
    }
    
    // MARK: - Two-character tokens
    
    @Suite("Two-character tokens")
    struct TwoCharTokenTests {
        @Test(arguments: [
            ("!=", TokenType.bangEqual),
            ("!",  .bang),
            ("==", .equalEqual),
            ("=",  .equal),
            ("<=", .lessEqual),
            ("<",  .less),
            (">=", .greaterEqual),
            (">",  .greater),
        ])
        func twoChar(input: String, expected: TokenType) {
            #expect(tokenTypes(input) == [expected, .eof])
        }
    }
    
    // MARK: - Comments
    
    @Suite("Comments")
    struct CommentTests {
        @Test func lineCommentIsSkipped() {
            #expect(tokenTypes("// this is a comment") == [.eof])
        }
        
        @Test func slashAloneIsToken() {
            #expect(tokenTypes("/ ") == [.slash, .eof])
        }
        
        @Test func codeAfterCommentOnNextLine() {
            #expect(tokenTypes("// comment\nvar") == [.var, .eof])
        }
    }
    
    // MARK: - String literals
    
    @Suite("String literals")
    struct StringLiteralTests {
        @Test func value() throws {
            let token = try #require(scan(#""hello""#).first)
            #expect(token.type == .string)
            #expect(token.literal as? String == "hello")
            #expect(token.lexeme == #""hello""#)
        }
        
        @Test func multilineString() throws {
            let token = try #require(scan("\"line1\nline2\"").first)
            #expect(token.type == .string)
            #expect(token.literal as? String == "line1\nline2")
        }
    }
    
    // MARK: - Number literals
    
    @Suite("Number literals")
    struct NumberLiteralTests {
        @Test(arguments: [
            ("123",   123.0),
            ("12.34", 12.34),
            ("0",     0.0),
        ])
        func numberValue(input: String, expected: Double) throws {
            let token = try #require(scan(input).first)
            #expect(token.type == .number)
            #expect(token.literal as? Double == expected)
        }
        
        @Test func trailingDotIsNotPartOfNumber() {
            #expect(tokenTypes("123.") == [.number, .dot, .eof])
        }
    }
    
    // MARK: - Keywords and identifiers
    
    @Suite("Keywords and identifiers")
    struct KeywordTests {
        @Test(arguments: [
            ("and",    TokenType.and),
            ("class",  .class),
            ("else",   .else),
            ("false",  .false),
            ("for",    .for),
            ("fun",    .fun),
            ("if",     .if),
            ("nil",    .nil),
            ("or",     .or),
            ("print",  .print),
            ("return", .return),
            ("super",  .super),
            ("this",   .this),
            ("true",   .true),
            ("var",    .var),
            ("while",  .while),
        ])
        func keyword(input: String, expected: TokenType) {
            #expect(tokenTypes(input) == [expected, .eof])
        }
        
        @Test func identifierNotKeyword() {
            #expect(tokenTypes("orchid") == [.identifier, .eof])
        }
        
        @Test func identifierLexeme() throws {
            let token = try #require(scan("myVar").first)
            #expect(token.type == .identifier)
            #expect(token.lexeme == "myVar")
        }
    }
    
    // MARK: - Whitespace and line tracking
    
    @Suite("Whitespace and line tracking")
    struct WhitespaceTests {
        @Test func whitespaceIsSkipped() {
            #expect(tokenTypes("  \t\r") == [.eof])
        }
        
        @Test func newlineIncrementsLine() {
            let tokens = scan("var\nfoo")
            #expect(tokens[0].line == 1)
            #expect(tokens[1].line == 2)
        }
    }
    
}
