{
open Parser
}

rule tokenize = parse
| ['0'-'9']+ as n { INT (int_of_string n) }
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
| eof { EOF }

and string buf = parse
| "''" { Buffer.add_char buf '\''; string buf lexbuf }
| '\'' { STR (Buffer.contents buf) }
