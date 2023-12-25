open Sqlcond

let () =
  try
    while true do
      match Parser.main Lexer.tokenize (Lexing.from_string (read_line ())) with
      | Ast.Str s -> print_endline s
      | t -> prerr_endline (Ast.show t)
    done
  with End_of_file ->
    ()
