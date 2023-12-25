{
open Parser
}

rule tokenize = parse
| ['0'-'9']+ as n { INT (int_of_string n) }
| ['A''a'] ['N''n'] ['D''d'] { AND }
| ['O''o'] ['R''r'] { OR }
| ['X''x'] ['O''o'] ['R''r'] { XOR }
| ['N''n'] ['O''o'] ['T''t'] { NOT }
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
| '\'' { STR (Buffer.contents buf) }
