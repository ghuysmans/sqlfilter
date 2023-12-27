open Sqlcond

let () =
  let lexbuf = Lexing.from_channel stdin in
  try
    With_parameters.main Lexer.tokenize lexbuf |>
    Ast.select_to_sql |>
    print_endline
  with Parser.Error ->
    Printf.eprintf "parse error at line %d\n" lexbuf.lex_start_p.pos_lnum
