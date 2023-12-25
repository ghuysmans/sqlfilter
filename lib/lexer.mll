{
open Parser
}

rule tokenize = parse
| ['0'-'9']+ as n { INT (int_of_string n) }
| ['S''s'] ['E''e'] ['L''l'] ['E''e'] ['C''c'] ['T''t'] { SELECT }
| ['E''e'] ['X''x'] ['I''i'] ['S''s'] ['T''t'] ['S''s'] { EXISTS }
| ['A''a'] ['N''n'] ['D''d'] { AND }
| ['O''o'] ['R''r'] { OR }
| ['X''x'] ['O''o'] ['R''r'] { XOR }
| ['N''n'] ['O''o'] ['T''t'] { NOT }
| ['I''i'] ['S''s'] { IS }
| ['L''l'] ['I''i'] ['K''k'] ['E''e'] { LIKE }
| ['R''r'] ['E''e'] ['G''g'] ['E''e'] ['X''x'] ['P''p'] { REGEXP }
| ['N''n'] ['U''u'] ['L''l'] ['L''l'] { NULL }
| ['T''t'] ['R''r'] ['U''u'] ['E''e'] { TRUE }
| ['F''f'] ['A''a'] ['L''l'] ['S''s'] ['E''e'] { FALSE }
| ['A'-'Z' 'a'-'z' '_']+ as x { ID x }
| '\'' { string (Buffer.create 50) lexbuf }
| '(' { LPAR }
| ')' { RPAR }
| '+' { PLUS }
| '-' { MINUS }
| '*' { TIMES }
| '/' { DIV }
| ">=" { GE }
| '>' { GT }
| '=' { EQ }
| "<>" { NE }
| "<=" { LE }
| '<' { LT }
| ['\t' ' ']+ { tokenize lexbuf }
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
