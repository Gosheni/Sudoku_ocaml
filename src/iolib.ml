open Board
open Core

let save_board_to_json filename data =
  Sudoku_board.serialize data |> Yojson.Safe.to_file filename

let delete_game filename =
  if
    String.contains filename '/' || String.is_substring ~substring:".." filename
  then ()
  else
    try Sys_unix.remove filename
    with Sys_error msg ->
      Stdio.eprintf "Error deleting file '%s': %s\n" filename msg

let load_board_from_json filename : Sudoku_board.t option =
  try Yojson.Safe.from_file filename |> Sudoku_board.deserialize
  with _ -> None

module Configuration = struct
  type highscore = { name : string; difficulty : int; total_time : float }
  [@@deriving equal, yojson]

  type game = {
    name : string;
    file_location : string;
    start_time : float;
    difficulty : int;
  }
  [@@deriving equal, yojson]

  type t = { highscores : highscore list; games : game list }
  [@@deriving equal, yojson]

  let empty = { highscores = []; games = [] }
  let location = "sudoku.config"

  let load_config _ : t =
    try
      let possible_config = Yojson.Safe.from_file location |> of_yojson in
      match possible_config with Ok a -> a | _ -> empty
    with _ -> empty

  let save_config (config : t) : unit =
    to_yojson config |> Yojson.Safe.to_file location

  let update = save_config

  let add_game (name : string) (difficulty : int) (board : Sudoku_board.t) :
      unit =
    let filename = (name |> String.filter ~f:Char.is_alphanum) ^ ".json" in
    save_board_to_json filename board;
    let config = load_config () in
    let g =
      {
        name;
        file_location = filename;
        start_time = Core_unix.time ();
        difficulty;
      }
    in
    save_config { highscores = config.highscores; games = g :: config.games }

  let get_game_with_name (name : string) : game option =
    let config = load_config () in
    List.find config.games ~f:(fun game -> String.(game.name = name))

  let update_game (name : string) (game : Sudoku_board.t) : unit =
    match get_game_with_name name with
    | None -> ()
    | Some game_data -> save_board_to_json game_data.file_location game

  let get_game (name : string) : Sudoku_board.t option =
    match get_game_with_name name with
    | None -> None
    | Some game_data -> load_board_from_json game_data.file_location

  let get_name _ =
    let config = load_config () in
    let current_game = List.hd_exn config.games in
    current_game.name

  let move_game_to_first filename =
    let config = load_config () in
    let game =
      List.find_exn config.games ~f:(fun game ->
          String.(game.file_location = filename))
    in
    let new_games_list =
      List.filter config.games ~f:(fun g ->
          String.(g.file_location <> filename))
    in
    save_config
      { highscores = config.highscores; games = game :: new_games_list }

  let finish_game (name : string) : (unit, string) result =
    let config = load_config () in
    match List.find config.games ~f:(fun game -> String.(game.name = name)) with
    | None -> Error "This game does not exist"
    | Some game ->
        let time_spent = Float.(Core_unix.time () - game.start_time) in
        let new_games_list =
          List.filter config.games ~f:(fun game -> String.(game.name <> name))
        in
        let new_highscore : highscore =
          {
            name = game.name;
            difficulty = game.difficulty;
            total_time = time_spent;
          }
        in
        let new_highscores_list = new_highscore :: config.highscores in
        save_config { highscores = new_highscores_list; games = new_games_list };
        delete_game game.file_location;
        Ok ()
end
