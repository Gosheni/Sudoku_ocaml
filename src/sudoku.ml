open Core

module SBoard = Sudoku_board

let () =
  Command.basic
    ~summary:"sudoku.exe - Generate Sudoku Game from a command line"
    (let open Command.Let_syntax in
      let%map_open.Command command_string =
        flag "--command" (required string) ~doc:"Command (init, hint, solve, save, move)"
      and command_args =
        anon (maybe (sequence ("arg" %: string)))
      in
    fun () ->
      match String.lowercase command_string with
      | "init" ->
        Stdio.print_endline "Initialized a new game!";
      | "move" ->
        (match command_args with
        | Some args ->
          let args_list = List.map ~f:int_of_string args in
          (match args_list with
          | [row; col; value] ->
            Stdio.printf "Made a move: Add value %d to row %d col %d\n" value row col;
          | _ ->
            failwith "Invalid arguments for move command")
        | None ->
          Stdio.print_endline "No arguments provided for move command";
        );
      | "hint" ->
        Stdio.print_endline "Possible move is 8 at 2, 9";
      | "solve" ->
        Stdio.print_endline "Solved the Sudoku game!";
      | "save" ->
        (match command_args with
        | Some args ->
          if List.length args = 1 && List.for_all args ~f:(fun arg -> String.is_suffix arg ~suffix:".json") then
            Stdio.printf "Current board saved with args: %s\n" (List.hd_exn args)
          else
            Stdio.print_endline "Invalid arguments for save command. Expected a single JSON file.";
        | None ->
          Stdio.print_endline "No arguments provided for save command";
        );
      | _ ->
        Stdio.print_endline "Invalid command";
    ) 
  |> Command_unix.run