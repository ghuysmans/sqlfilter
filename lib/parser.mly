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

expr:
| i=INT { Ast.Int i }
| s=STR { Ast.Str s }
| x=ID { Ast.Id x }
| LPAR e=expr RPAR { e }
| e1=expr PLUS e2=expr { Ast.(Bin (e1, Plus, e2)) }
| e1=expr MINUS e2=expr { Ast.(Bin (e1, Minus, e2)) }
| e1=expr TIMES e2=expr { Ast.(Bin (e1, Times, e2)) }
| e1=expr DIV e2=expr { Ast.(Bin (e1, Div, e2)) }
| MINUS e=expr %prec UMINUS { Ast.(Bin (Int 0, Minus, e)) }

main: e=expr EOF { e }
