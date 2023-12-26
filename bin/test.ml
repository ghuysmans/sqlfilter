open Sqlcond

let () =
  read_line () |>
  Lexing.from_string |>
  With_parameters.order_by Lexer.tokenize |>
  List.iter (fun (_e, o) ->
    print_endline Ast.(arrow_of_order o)
  )
