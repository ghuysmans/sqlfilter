open Sqlcond

let _ =
  read_line () |>
  Lexing.from_string |>
  With_parameters.main Lexer.tokenize |>
  Ast.select_to_sql |>
  print_endline
