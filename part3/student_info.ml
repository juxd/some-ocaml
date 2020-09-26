open Core
open Part2

let students =
  List.map
    ~f:(fun (name, id, matriculated_year) -> Student.create ~name ~id ~matriculated_year)
    [ "John", "A12345", 2017
    ; "Adam", "A34567", 2017
    ; "Jack", "E12345", 2018
    ; "John", "E12456", 2018
    ; "Anna", "E01923", 2019
    ]
;;

(* Command is a nice library that lets you parse command line arguments in a
   functional manner. Here are some examples of how to use it, To see it in
   action, build this subtree and navigate to the [_build/default] folder to
   find the [student_info.exe] executable, then run it. *)

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

(* Let's replace [hello] and [echo] with the following commands:

   1. [list] - prints out all the students. An expected output for this:

   {[
     $ student_info.exe list
       (
         ((name John) (student_id A12345) (matriculated_year 2017))
         ((name Adam) (student_id A34567) (matriculated_year 2017))
         ((name Jack) (student_id E12345) (matriculated_year 2018))
         ((name John) (student_id E12456) (matriculated_year 2018))
         ((name Anna) (student_id E01923) (matriculated_year 2019))
       )
   ]}

   2. [find name] - prints out all the students of a given name. An expected
      output:

   {[
     $ student_info.exe find John
       (
         ((name John) (student_id A12345) (matriculated_year 2017))
         ((name John) (student_id E12456) (matriculated_year 2018))
       )
   ]}
*)

let () =
  Command.run
    (Command.group
       ~summary:"some examples"
       [ "hello", hello_command; "echo", echo_command ])
;;
