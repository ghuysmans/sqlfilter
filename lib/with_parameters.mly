%start <[`Parameterized] Ast.t> main
%start <[`Parameterized] Ast.order_by> order_by
%%
%public expr2:
| PARAM { Ast.Parameter }
main: e=expr EOF { e }
order_by: s=sort EOF { s }
