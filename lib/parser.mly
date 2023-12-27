%left OR
%left XOR
%left AND
%nonassoc NOT
%nonassoc GE GT EQ DOUBLE_ARROW NE LE LT IS LIKE REGEXP IN
%left PLUS MINUS
%left TIMES SLASH DIV MOD
%nonassoc UMINUS
%%

%inline bin:
| PLUS { Ast.Plus }
| MINUS { Ast.Minus }
| TIMES { Ast.Times }
| SLASH { Ast.Float_div }
| DIV { Ast.Int_div }
| MOD { Ast.Mod }

%inline logical:
| AND { Ast.And }
| OR { Ast.Or }
| XOR { Ast.Xor }

%inline cmp:
| GE { Ast.Ge }
| GT { Ast.Gt }
| EQ { Ast.Eq }
| DOUBLE_ARROW { Ast.Is_not_distinct_from }
| NE { Ast.Ne }
| LE { Ast.Le }
| LT { Ast.Lt }
| LIKE { Ast.Like }
| REGEXP { Ast.Regexp }

%inline parseq(x): LPAR l=separated_nonempty_list(COMMA, x) RPAR { l }

%public expr2:
| NULL { Ast.Null }
| TRUE { Ast.Bool true }
| FALSE { Ast.Bool false }
| i=INT { Ast.Int i }
| parts=nonempty_list(STR) { Ast.Str (String.concat "" parts) }
| x=ID { Ast.Id x }
| LPAR e=expr RPAR { e }
| e1=expr2 op=bin e2=expr2 { Ast.Bin (e1, op, e2) }
| e1=expr2 op=cmp e2=expr2 { Ast.Cmp (e1, op, e2) }
| e=expr2 IN s=parseq(expr) { Ast.In (e, s) }
| MINUS e=expr2 %prec UMINUS { Ast.(Bin (Int 0, Minus, e)) }
| NOT e=expr2 { Ast.Not e }
| e=expr2 IS NULL { Ast.Is_null e }
| e=expr2 IS NOT NULL { Ast.(Not (Is_null e)) }
| e=expr2 IS TRUE { Ast.(Cmp (e, Eq, Bool true)) }
| e=expr2 IS FALSE { Ast.(Cmp (e, Eq, Bool false)) }
| f=ID args=parseq(expr) { Ast.App (f, args) }

%public expr:
| e1=expr op=logical e2=expr { Ast.Bin (e1, op, e2) }
| e=expr2 BETWEEN low=expr2 AND high=expr2 { Ast.Between {e; low; high} }
| e=expr2 NOT BETWEEN low=expr2 AND high=expr2 { Ast.(Not (Between {e; low; high})) }
| e=expr2 { e }

ordering_term:
| e=expr ASC? { e, Ast.Ascending }
| e=expr DESC { e, Ast.Descending }

%public sort: l=separated_nonempty_list(COMMA, ordering_term) { l }

col:
| e=expr a=preceded(AS?, ID)? { Ast.Column (e, a) }
| TIMES { Ast.Star }
cond: WHERE c=expr { c }
ord: ORDER BY o=sort { o } | { [] }

%public select:
| SELECT p=separated_nonempty_list(COMMA, col)
  FROM t=ID
  c=cond?
  o=ord
  SEMI? { p, t, c, o }
