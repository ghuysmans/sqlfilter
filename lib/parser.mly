%token <int> INT
%token <string> ID STR
%token PLUS MINUS TIMES SLASH DIV MOD
%token GE GT EQ DOUBLE_ARROW NE LE LT BETWEEN
%token AND OR XOR NOT TRUE FALSE
%token LPAR RPAR
%token IS LIKE REGEXP NULL
%token SELECT EXISTS
%nonassoc NOT
%left OR XOR
%left AND
%left GE GT EQ DOUBLE_ARROW NE LE LT IS LIKE REGEXP
%left BETWEEN
%left PLUS MINUS
%left TIMES SLASH DIV MOD
%nonassoc UMINUS
%token EOF
%start <Ast.t> main
%%

%inline bin:
| PLUS { Ast.Plus }
| MINUS { Ast.Minus }
| TIMES { Ast.Times }
| SLASH { Ast.Float_div }
| DIV { Ast.Int_div }
| MOD { Ast.Mod }
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

expr:
| NULL { Ast.Null }
| TRUE { Ast.Bool true }
| FALSE { Ast.Bool false }
| i=INT { Ast.Int i }
| parts=nonempty_list(STR) { Ast.Str (String.concat "" parts) }
| x=ID { Ast.Id x }
| LPAR e=expr RPAR { e }
| e1=expr op=bin e2=expr { Ast.Bin (e1, op, e2) }
| e1=expr op=cmp e2=expr { Ast.Cmp (e1, op, e2) }
| MINUS e=expr %prec UMINUS { Ast.(Bin (Int 0, Minus, e)) }
| NOT e=expr { Ast.Not e }
| e=expr IS NULL { Ast.Is_null e }
| e=expr IS NOT NULL { Ast.(Not (Is_null e)) }
| e=expr IS TRUE { Ast.(Cmp (e, Eq, Bool true)) }
| e=expr IS FALSE { Ast.(Cmp (e, Eq, Bool false)) }
| e=expr BETWEEN low=expr AND high=expr { Ast.Between {e; low; high} }
| e=expr NOT BETWEEN low=expr AND high=expr { Ast.(Not (Between {e; low; high})) }

main: e=expr EOF { e }
