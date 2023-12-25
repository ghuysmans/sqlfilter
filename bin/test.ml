open Sqlcond

let () =
  read_line () |>
  Lexing.from_string |>
  Parser.main Lexer.tokenize |>
  Ast.show |>
  print_endline
