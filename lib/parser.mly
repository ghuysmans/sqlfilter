%token <int> INT
%token <string> ID STR
%token PLUS MINUS TIMES DIV
%token GE GT EQ NE LE LT
%token AND OR XOR NOT
%token LPAR RPAR
%token SELECT EXISTS
%nonassoc NOT
%left OR XOR
%left AND
%left GE GT EQ NE LE LT
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

expr:
| i=INT { Ast.Int i }
| s=STR { Ast.Str s }
| x=ID { Ast.Id x }
| LPAR e=expr RPAR { e }
| e1=expr op=bin e2=expr { Ast.Bin (e1, op, e2) }
| e1=expr op=cmp e2=expr { Ast.Cmp (e1, op, e2) }
| MINUS e=expr %prec UMINUS { Ast.(Bin (Int 0, Minus, e)) }
| NOT e=expr { Ast.Not e }

main: e=expr EOF { e }
