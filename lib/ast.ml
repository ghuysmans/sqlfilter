type op =
  | Plus
  | Minus
  | Times
  | Div

type cmp =
  | Ge
  | Gt
  | Eq
  | Ne
  | Le
  | Lt

type t =
  | Int of int
  | Str of string
  | Id of string
  | Bin of t * op * t
  | Cmp of t * cmp * t
