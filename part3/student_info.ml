open Core
open Part2

let students =
  [ ("John", "A12345", 2017)
  ; ("Adam", "A34567", 2017)
  ; ("Jack", "E12345", 2018)
  ; ("John", "E12456", 2018)
  ; ("Anna", "E01923", 2019)]
  |> List.map ~f:(fun (name, id, matriculated_year) ->
      Student.create ~name ~id ~matriculated_year)

let echo_command =
  Command.basic
    ~summary:"echoes what you give it"
    (let open Command.Let_syntax in
     let%map_open name = anon ("message" %: string) in
     fun () -> print_endline name)
;;

let hello_command =
  Command.basic
    ~summary:"says hello"
    (let open Command.Let_syntax in
     let%map_open () = return () in
     fun () -> print_endline "hello!!!!")
;;

let () =
  Command.run
    (Command.group
       ~summary:"some examples"
       [ "hello", hello_command ; "echo", echo_command ])
;;
