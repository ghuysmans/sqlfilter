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

let string_of_op = function
  | Plus -> "+"
  | Minus -> "-"
  | Times -> "*"
  | Float_div -> "/"
  | Int_div -> "DIV"
  | Mod -> "MOD"
  | And -> "AND"
  | Or -> "OR"
  | Xor -> "XOR"

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

let string_of_cmp = function
  | Ge -> ">="
  | Gt -> ">"
  | Eq -> "="
  | Is_not_distinct_from -> "<=>"
  | Ne -> "<>"
  | Le -> "<="
  | Lt -> "<"
  | Like -> "LIKE"
  | Regexp -> "REGEXP"

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

(* TODO benchmark, then fill a Buffer.t? *)
let rec to_sql : type h. h t -> string = function
  | Parameter -> "?"
  | Null -> "NULL"
  | Bool true -> "TRUE"
  | Bool false -> "FALSE"
  | Int i -> string_of_int i
  | Str s -> Lexer.quote s
  | Id id -> id
  | Bin (t, op, t') ->
    "(" ^ to_sql t ^ " " ^ string_of_op op ^ " " ^ to_sql t' ^ ")"
  | Cmp (t, op, t') ->
    "(" ^ to_sql t ^ " " ^ string_of_cmp op ^ " " ^ to_sql t' ^ ")"
  | Not t ->
    "(NOT " ^ to_sql t ^ ")"
  | Is_null t ->
    "(" ^ to_sql t ^ " IS NULL)"
  | Between {e; low=l; high=h} ->
    "(" ^ to_sql e ^ " BETWEEN " ^ to_sql l ^ " AND " ^ to_sql h ^ ")"
  | In (t, l) ->
    "(" ^ to_sql t ^ " IN (" ^ String.concat ", " (List.map to_sql l) ^ "))"
  | App (f, args) ->
    f ^ "(" ^ String.concat ", " (List.map to_sql args) ^ ")"

type order =
  | Ascending
  | Descending

let string_of_order = function
  | Ascending -> "ASC"
  | Descending -> "DESC"

let arrow_of_order = function
  | Ascending -> "↑"
  | Descending -> "↓"

type 'h ordering_term = 'h t * order

type 'h order_by = 'h ordering_term list

let to_sql_order_by l =
  List.map (fun (t, o) -> to_sql t ^ " " ^ string_of_order o) l |>
  String.concat ", "
