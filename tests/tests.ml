(*
  Put the tests for lib.ml functions here
*)

open Core
open OUnit2
open Board

(* open Hint *)
open Game
(*open Grid*)

let force_unwrap (optional : 'a option) : 'a =
  match optional with
  | None -> failwith "force_unwrap only accepts 'Some' values"
  | Some a -> a

let test_pretty_printer _ =
  let expected_empty =
    "    1 2 3   4 5 6   7 8 9\n\
    \  -------------------------\n\
     1 |       |       |       |\n\
     2 |       |       |       |\n\
     3 |       |       |       |\n\
    \  -------------------------\n\
     4 |       |       |       |\n\
     5 |       |       |       |\n\
     6 |       |       |       |\n\
    \  -------------------------\n\
     7 |       |       |       |\n\
     8 |       |       |       |\n\
     9 |       |       |       |\n\
    \  -------------------------\n"
  in
  assert_equal expected_empty @@ Sudoku_board.(pretty_print empty)

let create_board elems_list =
  let rec loop_board i acc_board =
    if i >= 81 then acc_board
    else
      let row = i / 9 in
      let col = i mod 9 in
      let elem_int = List.nth_exn elems_list row |> Fn.flip List.nth_exn col in
      if elem_int = 0 then
        Sudoku_board.set acc_board row col Empty |> loop_board (i + 1)
      else
        Sudoku_board.set acc_board row col (Fixed elem_int) |> loop_board (i + 1)
  in
  loop_board 0 Sudoku_board.empty

let example_board_ints_1 =
  [
    [ 1; 2; 3; 6; 7; 8; 9; 4; 5 ];
    [ 5; 8; 4; 2; 3; 9; 7; 6; 1 ];
    [ 9; 6; 7; 1; 4; 5; 3; 2; 8 ];
    [ 3; 7; 2; 4; 6; 1; 5; 8; 9 ];
    [ 6; 9; 1; 5; 8; 3; 2; 7; 4 ];
    [ 4; 5; 8; 7; 9; 2; 6; 1; 3 ];
    [ 8; 3; 6; 9; 2; 4; 1; 5; 7 ];
    [ 2; 1; 9; 8; 5; 7; 4; 3; 6 ];
    [ 7; 4; 5; 3; 1; 6; 8; 9; 2 ];
  ]

let example_board_1 = create_board example_board_ints_1

let example_board_ints_2 =
  [
    [ 5; 3; 4; 6; 7; 8; 9; 1; 2 ];
    [ 6; 7; 2; 1; 9; 5; 3; 4; 8 ];
    [ 1; 9; 8; 3; 4; 2; 5; 6; 7 ];
    [ 8; 5; 9; 7; 6; 1; 4; 2; 3 ];
    [ 4; 2; 6; 8; 5; 3; 7; 9; 1 ];
    [ 7; 1; 3; 9; 2; 4; 8; 5; 6 ];
    [ 9; 6; 1; 5; 3; 7; 2; 8; 4 ];
    [ 2; 8; 7; 4; 1; 9; 6; 3; 5 ];
    [ 3; 4; 5; 2; 8; 6; 1; 7; 9 ];
  ]

let example_board_2 = create_board example_board_ints_2

let example_invalid_board_ints =
  [
    [ 5; 3; 4; 6; 7; 8; 9; 1; 2 ];
    [ 6; 7; 2; 1; 9; 5; 3; 4; 8 ];
    [ 1; 9; 8; 3; 4; 2; 5; 6; 7 ];
    [ 8; 5; 9; 7; 6; 1; 4; 2; 3 ];
    [ 4; 2; 6; 8; 5; 3; 7; 9; 1 ];
    [ 7; 1; 3; 9; 4; 2; 8; 5; 6 ];
    [ 9; 6; 1; 5; 3; 7; 2; 8; 4 ];
    [ 2; 8; 7; 4; 1; 9; 6; 3; 5 ];
    [ 3; 4; 5; 2; 8; 6; 1; 7; 9 ];
  ]

let example_invalid = create_board example_invalid_board_ints

let example_board_ints_3 =
  [
    [ 0; 0; 6; 0; 0; 0; 0; 0; 1 ];
    [ 0; 7; 0; 0; 6; 0; 0; 5; 0 ];
    [ 8; 0; 0; 1; 0; 3; 2; 0; 0 ];
    [ 0; 0; 5; 0; 4; 0; 8; 0; 0 ];
    [ 0; 4; 0; 7; 0; 2; 0; 9; 0 ];
    [ 0; 0; 8; 0; 1; 0; 7; 0; 0 ];
    [ 0; 0; 1; 2; 0; 5; 0; 0; 3 ];
    [ 0; 6; 0; 0; 7; 0; 0; 8; 0 ];
    [ 2; 0; 0; 0; 0; 0; 4; 0; 0 ];
  ]

let example_board_3 = create_board example_board_ints_3

(* this + above can probably be used to test a solve function once we implement that *)
let example_board_ints_3_solved =
  [
    [ 5; 3; 6; 8; 2; 7; 9; 4; 1 ];
    [ 1; 7; 2; 9; 6; 4; 3; 5; 8 ];
    [ 8; 9; 4; 1; 5; 3; 2; 6; 7 ];
    [ 7; 1; 5; 3; 4; 9; 8; 2; 6 ];
    [ 6; 4; 3; 7; 8; 2; 1; 9; 5 ];
    [ 9; 2; 8; 5; 1; 6; 7; 3; 4 ];
    [ 4; 8; 1; 2; 9; 5; 6; 7; 3 ];
    [ 3; 6; 9; 4; 7; 1; 5; 8; 2 ];
    [ 2; 5; 7; 6; 3; 8; 4; 1; 9 ];
  ]

let example_board_3_solved = create_board example_board_ints_3_solved

let example_board_ints_4 =
  [
    [ 3; 0; 6; 5; 0; 8; 4; 0; 0 ];
    [ 5; 2; 0; 0; 0; 0; 0; 0; 0 ];
    [ 0; 8; 7; 0; 0; 0; 0; 3; 1 ];
    [ 0; 0; 3; 0; 1; 0; 0; 8; 0 ];
    [ 9; 0; 0; 8; 6; 3; 0; 0; 5 ];
    [ 0; 5; 0; 0; 9; 0; 6; 0; 0 ];
    [ 1; 3; 0; 0; 0; 0; 2; 5; 0 ];
    [ 0; 0; 0; 0; 0; 0; 0; 7; 4 ];
    [ 0; 0; 5; 2; 0; 6; 3; 0; 0 ];
  ]

let example_board_4 = create_board example_board_ints_4

let test_is_solved _ =
  assert_equal true @@ Sudoku_board.is_solved example_board_1;
  assert_equal false @@ Sudoku_board.is_solved Sudoku_board.empty;
  assert_equal true @@ Sudoku_board.is_solved example_board_2;
  assert_equal false @@ Sudoku_board.is_solved example_invalid;
  assert_equal false @@ Sudoku_board.is_solved example_board_4

let test_is_valid _ =
  assert_equal true @@ Sudoku_board.is_valid example_board_1;
  assert_equal true @@ Sudoku_board.is_valid example_board_2;
  assert_equal false @@ Sudoku_board.is_valid example_invalid;
  assert_equal true @@ Sudoku_board.is_valid example_board_3;
  assert_equal true @@ Sudoku_board.is_valid example_board_3_solved;
  assert_equal true @@ Sudoku_board.is_valid example_board_4

let test_deserialize_valid_json _ =
  let json =
    `Assoc
      [
        ( "0",
          `Assoc
            [
              ("0", `List [ `String "Fixed"; `Int 1 ]);
              ("1", `List [ `String "Fixed"; `Int 2 ]);
              ("2", `List [ `String "Fixed"; `Int 3 ]);
              ("3", `List [ `String "Fixed"; `Int 6 ]);
              ("4", `List [ `String "Fixed"; `Int 7 ]);
              ("5", `List [ `String "Fixed"; `Int 8 ]);
              ("6", `List [ `String "Fixed"; `Int 9 ]);
              ("7", `List [ `String "Fixed"; `Int 4 ]);
              ("8", `List [ `String "Fixed"; `Int 5 ]);
            ] );
        ( "1",
          `Assoc
            [
              ("0", `List [ `String "Fixed"; `Int 5 ]);
              ("1", `List [ `String "Fixed"; `Int 8 ]);
              ("2", `List [ `String "Fixed"; `Int 4 ]);
              ("3", `List [ `String "Fixed"; `Int 2 ]);
              ("4", `List [ `String "Fixed"; `Int 3 ]);
              ("5", `List [ `String "Fixed"; `Int 9 ]);
              ("6", `List [ `String "Fixed"; `Int 7 ]);
              ("7", `List [ `String "Fixed"; `Int 6 ]);
              ("8", `List [ `String "Fixed"; `Int 1 ]);
            ] );
        ( "2",
          `Assoc
            [
              ("0", `List [ `String "Fixed"; `Int 9 ]);
              ("1", `List [ `String "Fixed"; `Int 6 ]);
              ("2", `List [ `String "Fixed"; `Int 7 ]);
              ("3", `List [ `String "Fixed"; `Int 1 ]);
              ("4", `List [ `String "Fixed"; `Int 4 ]);
              ("5", `List [ `String "Fixed"; `Int 5 ]);
              ("6", `List [ `String "Fixed"; `Int 3 ]);
              ("7", `List [ `String "Fixed"; `Int 2 ]);
              ("8", `List [ `String "Fixed"; `Int 8 ]);
            ] );
        ( "3",
          `Assoc
            [
              ("0", `List [ `String "Fixed"; `Int 3 ]);
              ("1", `List [ `String "Fixed"; `Int 7 ]);
              ("2", `List [ `String "Fixed"; `Int 2 ]);
              ("3", `List [ `String "Fixed"; `Int 4 ]);
              ("4", `List [ `String "Fixed"; `Int 6 ]);
              ("5", `List [ `String "Fixed"; `Int 1 ]);
              ("6", `List [ `String "Fixed"; `Int 5 ]);
              ("7", `List [ `String "Fixed"; `Int 8 ]);
              ("8", `List [ `String "Fixed"; `Int 9 ]);
            ] );
        ( "4",
          `Assoc
            [
              ("0", `List [ `String "Fixed"; `Int 6 ]);
              ("1", `List [ `String "Fixed"; `Int 9 ]);
              ("2", `List [ `String "Fixed"; `Int 1 ]);
              ("3", `List [ `String "Fixed"; `Int 5 ]);
              ("4", `List [ `String "Fixed"; `Int 8 ]);
              ("5", `List [ `String "Fixed"; `Int 3 ]);
              ("6", `List [ `String "Fixed"; `Int 2 ]);
              ("7", `List [ `String "Fixed"; `Int 7 ]);
              ("8", `List [ `String "Fixed"; `Int 4 ]);
            ] );
        ( "5",
          `Assoc
            [
              ("0", `List [ `String "Fixed"; `Int 4 ]);
              ("1", `List [ `String "Fixed"; `Int 5 ]);
              ("2", `List [ `String "Fixed"; `Int 8 ]);
              ("3", `List [ `String "Fixed"; `Int 7 ]);
              ("4", `List [ `String "Fixed"; `Int 9 ]);
              ("5", `List [ `String "Fixed"; `Int 2 ]);
              ("6", `List [ `String "Fixed"; `Int 6 ]);
              ("7", `List [ `String "Fixed"; `Int 1 ]);
              ("8", `List [ `String "Fixed"; `Int 3 ]);
            ] );
        ( "6",
          `Assoc
            [
              ("0", `List [ `String "Fixed"; `Int 8 ]);
              ("1", `List [ `String "Fixed"; `Int 3 ]);
              ("2", `List [ `String "Fixed"; `Int 6 ]);
              ("3", `List [ `String "Fixed"; `Int 9 ]);
              ("4", `List [ `String "Fixed"; `Int 2 ]);
              ("5", `List [ `String "Fixed"; `Int 4 ]);
              ("6", `List [ `String "Fixed"; `Int 1 ]);
              ("7", `List [ `String "Fixed"; `Int 5 ]);
              ("8", `List [ `String "Fixed"; `Int 7 ]);
            ] );
        ( "7",
          `Assoc
            [
              ("0", `List [ `String "Fixed"; `Int 2 ]);
              ("1", `List [ `String "Fixed"; `Int 1 ]);
              ("2", `List [ `String "Fixed"; `Int 9 ]);
              ("3", `List [ `String "Fixed"; `Int 8 ]);
              ("4", `List [ `String "Fixed"; `Int 5 ]);
              ("5", `List [ `String "Fixed"; `Int 7 ]);
              ("6", `List [ `String "Fixed"; `Int 4 ]);
              ("7", `List [ `String "Fixed"; `Int 3 ]);
              ("8", `List [ `String "Fixed"; `Int 6 ]);
            ] );
        ( "8",
          `Assoc
            [
              ("0", `List [ `String "Fixed"; `Int 7 ]);
              ("1", `List [ `String "Fixed"; `Int 4 ]);
              ("2", `List [ `String "Fixed"; `Int 5 ]);
              ("3", `List [ `String "Fixed"; `Int 3 ]);
              ("4", `List [ `String "Fixed"; `Int 1 ]);
              ("5", `List [ `String "Fixed"; `Int 6 ]);
              ("6", `List [ `String "Fixed"; `Int 8 ]);
              ("7", `List [ `String "Fixed"; `Int 9 ]);
              ("8", `List [ `String "Fixed"; `Int 2 ]);
            ] );
      ]
  in
  Sudoku_board.deserialize json
  |> Option.map ~f:(Sudoku_board.equal example_board_1)
  |> Option.value_or_thunk ~default:(fun _ -> false)
  |> assert_bool ""

let test_seed : test =
  test_list
    [
      ( "test seed with quickcheck" >:: fun _ ->
        Quickcheck.test ~sexp_of:[%sexp_of: int] Int.quickcheck_generator
          ~f:(fun i ->
            i |> Sudoku_board.seed_to_list
            |> List.sort ~compare:Int.compare
            |> assert_equal (List.range 1 10)) );
      ( "test that a seed of 0 is [1 2 3 4 5 6 7 8 9]" >:: fun _ ->
        assert_equal (Sudoku_board.seed_to_list 0) (List.range 1 10) );
    ]

let test_solve _ =
  let open Sudoku_board in
  (let solved = solve_with_backtracking empty 0 is_valid in
   match solved with
   | None -> assert_failure ""
   | Some sudoku ->
       assert_bool "" @@ is_solved sudoku;
       let solve_solved =
         solve_with_backtracking sudoku 0 is_valid |> force_unwrap
       in
       assert_bool "" @@ equal sudoku solve_solved);
  let invalid =
    set empty 0 0 (Volatile 1) |> fun board -> set board 0 1 (Volatile 1)
  in
  assert_equal None @@ solve_with_backtracking invalid 0 is_valid

let test_solve_uniquely _ =
  let open Sudoku_board in
  assert_equal None @@ solve_with_unique_solution empty;
  let solved = solve_with_backtracking empty 0 is_valid |> force_unwrap in
  let missing_one = set solved 0 0 Empty in
  assert_bool ""
  @@ equal solved (solve_with_unique_solution missing_one |> force_unwrap)

let test_generate_solved : test =
  List.init 10 ~f:(fun _ ->
      "test generate_solved" >:: fun _ ->
      assert_bool "" (Sudoku_board.is_solved @@ Sudoku_board.generate_random ()))
  |> test_list

let number_of_empty (board : Sudoku_board.t) =
  Sudoku_board.get_all board |> List.count ~f:(Sudoku_board.equal_element Empty)

let test_generate_unsolved : test =
  let test_generate_single_unsolved _ : test =
    let board = Sudoku_board.generate_random () in
    81 :: List.range 1 20
    |> List.map ~f:(fun to_remove ->
           "test generate_single_unsolved" >:: fun _ ->
           let unsolved = Sudoku_board.generate_degenerate board to_remove in
           assert_equal false @@ Sudoku_board.is_solved unsolved;
           assert_bool ""
             (Sudoku_board.solve_with_unique_solution unsolved |> Option.is_some);
           if to_remove <= 3 then
             assert_equal to_remove @@ number_of_empty unsolved
             (* If you remove 3 elements from a solved sudoku it is guaranteed to still be solvable *)
           else assert_bool "" @@ (number_of_empty unsolved <= to_remove))
    |> test_list
  in

  List.init 10 ~f:test_generate_single_unsolved |> test_list

let example_board_1_incomplete = Sudoku_board.set example_board_1 0 0 Empty
let example_move = Sudoku_game.{ x = 0; y = 0; value = Some 1 }
let example_hint = Sudoku_game.Suggested_move example_move

let test_hint_forced_moves _ =
  assert_equal Sudoku_game.Already_solved
  @@ Sudoku_game.generate_hint example_board_1;
  assert_equal example_hint
  @@ Sudoku_game.generate_hint example_board_1_incomplete
(* let rec check_board_3 n acc =
     if n < 0 then acc else
     match Sudoku_game.generate_hint example_board_3 with
       | Sudoku_game.Already_solved -> false
       | Sudoku_game.Incorrect_cell _ -> false
       | Sudoku_game.Suggested_move new_move ->
         match Sudoku_board.get example_board_3_solved new_move.x new_move.y with
           | None -> false
           | Some Empty -> false
           | Some Fixed actual | Some Volatile actual ->
               let new_val = new_move.value |> Option.value_exn in
               actual = new_val
               |> ( && ) acc
               |> check_board_3 (n - 1) in
   assert (check_board_3 1 true) *)

let series =
  "Tests"
  >::: [
         "test pretty print" >:: test_pretty_printer;
         "test is_solved" >:: test_is_solved;
         "test is_valid" >:: test_is_valid;
         "test deserialize_valid" >:: test_deserialize_valid_json;
         test_seed;
         "test solve" >:: test_solve;
         "test solve uniquely" >:: test_solve_uniquely;
         test_generate_solved;
         test_generate_unsolved;
         "test hint forced moves" >:: test_hint_forced_moves;
       ]

let () = run_test_tt_main series
