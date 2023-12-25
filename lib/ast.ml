type op =
  | Plus
  | Minus
  | Times
  | Div
  [@@deriving show {with_path = false}]

type cmp =
  | Ge
  | Gt
  | Eq
  | Ne
  | Le
  | Lt
  [@@deriving show {with_path = false}]

type t =
  | Int of int
  | Str of string
  | Id of string
  | Bin of t * op * t
  | Cmp of t * cmp * t
  [@@deriving show {with_path = false}]
