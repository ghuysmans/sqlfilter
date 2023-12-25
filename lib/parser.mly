%token <int> INT
%token <string> ID STR
%token PLUS MINUS TIMES DIV
%token LPAR RPAR
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

expr:
| i=INT { Ast.Int i }
| s=STR { Ast.Str s }
| x=ID { Ast.Id x }
| LPAR e=expr RPAR { e }
| e1=expr op=bin e2=expr { Ast.Bin (e1, op, e2) }
| MINUS e=expr %prec UMINUS { Ast.(Bin (Int 0, Minus, e)) }

main: e=expr EOF { e }
