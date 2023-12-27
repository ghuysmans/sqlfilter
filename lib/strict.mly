%start <unit Ast.t> where
%start <unit Ast.order_by> order_by
%start <unit Ast.col list * string * unit Ast.t option * unit Ast.order_by> main
%%
where: e=expr EOF { e }
order_by: s=sort EOF { s }
main: s=select EOF { s }
