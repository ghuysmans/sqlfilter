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

type 'h t =
  | Parameter : [`Parameterized] t
  | Null
  | Bool of bool
  | Int of int
  | Str of string
  | Id of string
  | Bin of 'h t * op * 'h t
  | Cmp of 'h t * cmp * 'h t
  | Not of 'h t
  | Is_null of 'h t
  | Between of {e: 'h t; low: 'h t; high: 'h t}
  | In of 'h t * 'h t list
  | App of string * 'h t list

type order =
  | Ascending
  | Descending

let arrow_of_order = function
  | Ascending -> "↑"
  | Descending -> "↓"

type 'h ordering_term = 'h t * order

type 'h order_by = 'h ordering_term list
