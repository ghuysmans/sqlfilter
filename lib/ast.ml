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

type p = [`Parameterized]

type 'h t =
  | Parameter : p t
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

let compute ( *? ) z =
  let rec f : type h. h t -> int = function
    | Parameter | Null | Bool _ | Int _ | Str _ | Id _ -> z
    | Bin (l, _, r) | Cmp (l, _, r) -> 1 + f l *? f r
    | Not t | Is_null t -> 1 + f t
    | Between {e; low; high} -> 1 + f e *? f low *? f high
    | In (t, l) -> 1 + List.fold_left (fun acc t -> acc *? f t) 0 (t :: l)
    | App (_, l) -> 1 + List.fold_left (fun acc t -> acc *? f t) 0 l
  in
  f

let height t = compute max 0 t
let nodes t = compute (+) 1 t

let iter f =
  let rec g : type h. h t -> unit = function
    | Parameter | Null | Bool _ | Int _ | Str _ -> ()
    | Id x -> f (`Id (String.lowercase_ascii x))
    | Bin (l, _, r) | Cmp (l, _, r) -> g l; g r
    | Not t | Is_null t -> g t
    | Between {e; low; high} -> g e; g low; g high
    | In (t, l) -> List.iter g (t :: l)
    | App (fn, l) -> f (`Fun (String.lowercase_ascii fn)); List.iter g l
  in
  g

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
