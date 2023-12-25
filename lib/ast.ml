type op =
  | Plus
  | Minus
  | Times
  | Float_div
  | Int_div
  | Mod
  | And
  | Or
  | Xor
  [@@deriving show {with_path = false}]

type cmp =
  | Ge
  | Gt
  | Eq
  | Is_not_distinct_from
  | Ne
  | Le
  | Lt
  | Like
  | Regexp
  [@@deriving show {with_path = false}]

type t =
  | Null
  | Bool of bool
  | Int of int
  | Str of string
  | Id of string
  | Bin of t * op * t
  | Cmp of t * cmp * t
  | Not of t
  | Is_null of t
  | Between of {e: t; low: t; high: t}
  | In of t * t list
  | App of string * t list
  [@@deriving show {with_path = false}]

type order =
  | Ascending
  | Descending

let arrow_of_order = function
  | Ascending -> "↑"
  | Descending -> "↓"

type ordering_term = t * order

type order_by = ordering_term list
