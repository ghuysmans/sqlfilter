open Sqlcond

let parse s =
  try
    Ok (Parser.where Lexer.tokenize (Lexing.from_string s))
  with _ ->
    Error ()

let test ~expected s =
  if parse s <> expected then (
    prerr_endline s;
    exit 1
  );
  match expected with
  | Error () -> ()
  | Ok t ->
    let sql = Ast.to_sql t in
    if parse sql <> expected then (
      prerr_endline s;
      exit 2
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

    {|'\\'|}, Ok (Str {|\|});
    {|'\_'|}, Ok (Str {|\_|});

    (* left associativity *)
    "0 BETWEEN 0 AND 0 AND 0", Ok (Bin (
      Between {e = Int 0; low = Int 0; high = Int 0},
      And,
      Int 0
    ));
    (* inconsistent behavior between MySQL and SQLite *)
    "1 BETWEEN 0 AND 2 BETWEEN 0 AND 1", Error ();

    (* see https://valentin.willscher.de/posts/sql-api/ *)
    "(material = 'steel' AND weight BETWEEN 10 AND 20) OR (material = 'carbon' AND weight BETWEEN 5 AND 10)", Ok (Bin (
      Bin (
        Cmp (Id "material", Eq, Str "steel"),
        And,
        Between {e = Id "weight"; low = Int 10; high = Int 20}
      ),
      Or,
      Bin (
        Cmp (Id "material", Eq, Str "carbon"),
        And,
        Between {e = Id "weight"; low = Int 5; high = Int 10}
      )
    ));
  ]
