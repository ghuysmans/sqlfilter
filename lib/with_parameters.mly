%start <Ast.p Ast.t> where
%start <Ast.p Ast.order_by> order_by
%%
%public expr2:
| PARAM { Ast.Parameter }
where: e=expr EOF { e }
order_by: s=sort EOF { s }
