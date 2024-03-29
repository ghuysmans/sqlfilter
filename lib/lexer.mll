{
open Tokens
}

rule tokenize = parse
| ['0'-'9']+ as n { INT (int_of_string n) }
| ['S''s'] ['E''e'] ['L''l'] ['E''e'] ['C''c'] ['T''t'] { SELECT }
| ['A''a'] ['S''s'] { AS }
| ['F''f'] ['R''r'] ['O''o'] ['M''m'] { FROM }
| ['W''w'] ['H''h'] ['E''e'] ['R''r'] ['E''e'] { WHERE }
| ['O''o'] ['R''r'] ['D''d'] ['E''e'] ['R''r'] { ORDER }
| ['B''b'] ['Y''y'] { BY }
| ['E''e'] ['X''x'] ['I''i'] ['S''s'] ['T''t'] ['S''s'] { EXISTS }
| ['D''d'] ['I''i'] ['V''v'] { DIV }
| '%' | ['M''m'] ['O''o'] ['D''d'] { MOD }
| ['A''a'] ['N''n'] ['D''d'] { AND }
| ['O''o'] ['R''r'] { OR }
| ['X''x'] ['O''o'] ['R''r'] { XOR }
| ['N''n'] ['O''o'] ['T''t'] { NOT }
| ['I''i'] ['S''s'] { IS }
| ['L''l'] ['I''i'] ['K''k'] ['E''e'] { LIKE }
| ['R''r'] ['E''e'] ['G''g'] ['E''e'] ['X''x'] ['P''p'] { REGEXP }
| ['I''i'] ['N''n'] { IN }
| ['B''b'] ['E''e'] ['T''t'] ['W''w'] ['E''e'] ['E''e'] ['N''n'] { BETWEEN }
| ['N''n'] ['U''u'] ['L''l'] ['L''l'] { NULL }
| ['T''t'] ['R''r'] ['U''u'] ['E''e'] { TRUE }
| ['F''f'] ['A''a'] ['L''l'] ['S''s'] ['E''e'] { FALSE }
| ['A''a'] ['S''s'] ['C''c'] { ASC }
| ['D''d'] ['E''e'] ['S''s'] ['C''c'] { DESC }
| ['A'-'Z' 'a'-'z' '_']+ as x { ID x }
| '\'' { string (Buffer.create 50) lexbuf }
| '(' { LPAR }
| ')' { RPAR }
| '+' { PLUS }
| '-' { MINUS }
| '*' { TIMES }
| '/' { SLASH }
| ">=" { GE }
| '>' { GT }
| '=' { EQ }
| "<>" | "!=" { NE }
| "<=>" { DOUBLE_ARROW }
| "<=" { LE }
| '<' { LT }
| ',' { COMMA }
| ';' { SEMI }
| '?' { PARAM }
| ['\t' ' ']+ { tokenize lexbuf }
| '\n' { Lexing.new_line lexbuf; tokenize lexbuf }
| eof { EOF }

and string buf = parse
| "''" { Buffer.add_char buf '\''; string buf lexbuf }
| "\\0" { Buffer.add_char buf '\000'; string buf lexbuf }
| "\\'" { Buffer.add_char buf '\''; string buf lexbuf }
| "\\b" { Buffer.add_char buf '\b'; string buf lexbuf }
| "\\n" { Buffer.add_char buf '\n'; string buf lexbuf }
| "\\r" { Buffer.add_char buf '\r'; string buf lexbuf }
| "\\t" { Buffer.add_char buf '\t'; string buf lexbuf }
| "\\Z" { Buffer.add_char buf '\026'; string buf lexbuf }
| "\\\\" { Buffer.add_char buf '\\'; string buf lexbuf }
| "\\%" { Buffer.add_string buf "\\%"; string buf lexbuf }
| "\\_" { Buffer.add_string buf "\\_"; string buf lexbuf }
| '\\' (_ as c) { Buffer.add_char buf c; string buf lexbuf }
| '\'' { STR (Buffer.contents buf) }
| _ as c { Buffer.add_char buf c; string buf lexbuf }

and quote buf = parse
| '\'' { Buffer.add_string buf "''"; quote buf lexbuf }
| '\000' { Buffer.add_string buf "\\0"; quote buf lexbuf }
| '\b' { Buffer.add_string buf "\\b"; quote buf lexbuf }
| '\n' { Buffer.add_string buf "\\n"; quote buf lexbuf }
| '\r' { Buffer.add_string buf "\\r"; quote buf lexbuf }
| '\t' { Buffer.add_string buf "\\t"; quote buf lexbuf }
| '\026' { Buffer.add_string buf "\\Z"; quote buf lexbuf }
| "\\%" { Buffer.add_string buf "\\%"; quote buf lexbuf }
| "\\_" { Buffer.add_string buf "\\_"; quote buf lexbuf }
| '\\' { Buffer.add_string buf "\\\\"; quote buf lexbuf }
| _ as c { Buffer.add_char buf c; quote buf lexbuf }
| eof { Buffer.add_char buf '\''; Buffer.contents buf }

{
let quote ?(size=50) s =
  let buf = Buffer.create size in
  Buffer.add_char buf '\'';
  quote buf (Lexing.from_string s)
}
