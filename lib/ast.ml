type op =
  | Plus
  | Minus
  | Times
  | Div

type t =
  | Int of int
  | Str of string
  | Id of string
  | Bin of t * op * t
