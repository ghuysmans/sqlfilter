open Sqlcond

let parse s =
  try
    Ok (Parser.main Lexer.tokenize (Lexing.from_string s))
  with _ ->
    Error ()

let test ~expected s =
  if parse s <> expected then (
    prerr_endline s;
    exit 1
  )

let () =
  List.iter (fun (input, expected) -> test ~expected input) [
    (* string literals from the MySQL manual *)
    {|'a' ' ' 'string'|}, Ok (Str "a string");
    {|'hello'|}, Ok (Str "hello");
    {|'"hello"'|}, Ok (Str {|"hello"|});
    {|'""hello""'|}, Ok (Str {|""hello""|});
    {|'hel''lo'|}, Ok (Str "hel'lo");
    {|'\'hello'|}, Ok (Str "'hello");
    {|'This\nIs\nFour\nLines'|}, Ok (Str "This\nIs\nFour\nLines");
    {|'disappearing\ backslash'|}, Ok (Str "disappearing backslash");

    (* left associativity *)
    "0 BETWEEN 0 AND 0 AND 0", Ok (Bin (
      Between {e = Int 0; low = Int 0; high = Int 0},
      And,
      Int 0
    ));
    (* inconsistent behavior between MySQL and SQLite *)
    "1 BETWEEN 0 AND 2 BETWEEN 0 AND 1", Error ();
  ]
