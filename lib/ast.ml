type op =
  | Plus
  | Minus
  | Times
  | Div
  | And
  | Or
  | Xor
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
  | Null
  | Int of int
  | Str of string
  | Id of string
  | Bin of t * op * t
  | Cmp of t * cmp * t
  | Not of t
  | Is_null of t
  [@@deriving show {with_path = false}]
