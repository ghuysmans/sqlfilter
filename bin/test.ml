open Sqlcond

let _ =
  read_line () |>
  Lexing.from_string |>
  With_parameters.main Lexer.tokenize
