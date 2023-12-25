open Sqlcond

let () =
  read_line () |>
  Lexing.from_string |>
  Parser.order_by Lexer.tokenize |>
  List.iter (fun (e, o) ->
    print_endline Ast.(arrow_of_order o ^ " " ^ show e)
  )
