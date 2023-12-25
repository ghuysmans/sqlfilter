%token <int> INT
%token <string> ID STR
%token PLUS MINUS TIMES DIV
%token GE GT EQ NE LE LT
%token AND OR XOR NOT TRUE FALSE
%token LPAR RPAR
%token IS LIKE REGEXP NULL
%token SELECT EXISTS
%nonassoc NOT
%left OR XOR
%left AND
%left GE GT EQ NE LE LT IS LIKE REGEXP
%left PLUS MINUS
%left TIMES DIV
%nonassoc UMINUS
%token EOF
%start <Ast.t> main
%%

%inline bin:
| PLUS { Ast.Plus }
| MINUS { Ast.Minus }
| TIMES { Ast.Times }
| DIV { Ast.Div }
| AND { Ast.And }
| OR { Ast.Or }
| XOR { Ast.Xor }

%inline cmp:
| GE { Ast.Ge }
| GT { Ast.Gt }
| EQ { Ast.Eq }
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

main: e=expr EOF { e }
