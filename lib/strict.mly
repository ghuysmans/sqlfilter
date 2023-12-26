%start <unit Ast.t> where
%start <unit Ast.order_by> order_by
%%
where: e=expr EOF { e }
order_by: s=sort EOF { s }
