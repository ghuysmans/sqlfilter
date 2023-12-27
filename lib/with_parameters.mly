%start <Ast.p Ast.t> where
%start <Ast.p Ast.order_by> order_by
%start <Ast.p Ast.col list * string * Ast.p Ast.t option * Ast.p Ast.order_by> main
%%
%public expr2:
| PARAM { Ast.Parameter }
where: e=expr EOF { e }
order_by: s=sort EOF { s }
main: s=select EOF { s }
