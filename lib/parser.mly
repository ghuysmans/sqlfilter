%token <int> INT
%token <string> ID STR
%token PLUS MINUS TIMES SLASH DIV MOD
%token GE GT EQ DOUBLE_ARROW NE LE LT BETWEEN
%token AND OR XOR NOT TRUE FALSE
%token LPAR COMMA RPAR
%token IS LIKE REGEXP IN NULL
%token ASC DESC
%token SELECT EXISTS
%left OR
%left XOR
%left AND
%nonassoc NOT
%nonassoc GE GT EQ DOUBLE_ARROW NE LE LT IS LIKE REGEXP IN
%left PLUS MINUS
%left TIMES SLASH DIV MOD
%nonassoc UMINUS
%token EOF
%start <Ast.t> main
%start <Ast.order_by> order_by
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

%inline sequence(x): LPAR l=separated_nonempty_list(COMMA, x) RPAR { l }

expr2:
| NULL { Ast.Null }
| TRUE { Ast.Bool true }
| FALSE { Ast.Bool false }
| i=INT { Ast.Int i }
| parts=nonempty_list(STR) { Ast.Str (String.concat "" parts) }
| x=ID { Ast.Id x }
| LPAR e=expr RPAR { e }
| e1=expr2 op=bin e2=expr2 { Ast.Bin (e1, op, e2) }
| e1=expr2 op=cmp e2=expr2 { Ast.Cmp (e1, op, e2) }
| e=expr2 IN s=sequence(expr) { Ast.In (e, s) }
| MINUS e=expr2 %prec UMINUS { Ast.(Bin (Int 0, Minus, e)) }
| NOT e=expr2 { Ast.Not e }
| e=expr2 IS NULL { Ast.Is_null e }
| e=expr2 IS NOT NULL { Ast.(Not (Is_null e)) }
| e=expr2 IS TRUE { Ast.(Cmp (e, Eq, Bool true)) }
| e=expr2 IS FALSE { Ast.(Cmp (e, Eq, Bool false)) }
| f=ID args=sequence(expr) { Ast.App (f, args) }

expr:
| e1=expr op=logical e2=expr { Ast.Bin (e1, op, e2) }
| e=expr2 BETWEEN low=expr2 AND high=expr2 { Ast.Between {e; low; high} }
| e=expr2 NOT BETWEEN low=expr2 AND high=expr2 { Ast.(Not (Between {e; low; high})) }
| e=expr2 { e }

ordering_term:
| e=expr ASC? { e, Ast.Ascending }
| e=expr DESC { e, Ast.Descending }

sort: l=separated_nonempty_list(COMMA, ordering_term) { l }

main: e=expr EOF { e }
order_by: s=sort EOF { s }
