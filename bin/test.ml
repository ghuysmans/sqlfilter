open Sqlcond

let _ =
  Parser.main Lexer.tokenize (Lexing.from_channel stdin)
