%start <[`Parameterized] Ast.t> where
%start <[`Parameterized] Ast.order_by> order_by
%%
%public expr2:
| PARAM { Ast.Parameter }
where: e=expr EOF { e }
order_by: s=sort EOF { s }
