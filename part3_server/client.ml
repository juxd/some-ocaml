open! Core
open Async

let address_flag =
  let open Command.Param in
  flag "address" (required host_and_port) ~doc:"the address of the server to connect to"
;;

let dispatch_rpc rpc host_and_port query =
  let where_to_connect = Tcp.Where_to_connect.of_host_and_port host_and_port in
  Rpc.Connection.with_client where_to_connect (fun connection ->
      Rpc.Rpc.dispatch rpc connection query)
  |> Deferred.map ~f:Result.ok_exn
;;

let find_students_command =
  Command.async_or_error
    ~summary:"finds all students with the name"
    (let open Command.Let_syntax in
    let%map_open name = flag "name" (required string) ~doc:"the name to look up"
    and host_and_port = address_flag in
    fun () ->
      let%map.Deferred.Or_error students =
        dispatch_rpc Protocol.Find_students.rpc host_and_port name
      in
      print_s [%message (students : Part2.Student.t list)])
;;

let count_students_command =
  Command.async_or_error
    ~summary:"counts all students in the database"
    (let open Command.Let_syntax in
    let%map_open host_and_port = address_flag in
    fun () ->
      let%map.Deferred.Or_error count =
        dispatch_rpc Protocol.Count_students.rpc host_and_port ()
      in
      printf "There are %d students in the database\n" count)
;;

let add_student_command =
  Command.async_or_error
    ~summary:"counts all students in the database"
    (let open Command.Let_syntax in
    let%map_open name = flag "name" (required string) ~doc:"the student's name"
    and id = flag "id" (required string) ~doc:"the student's id"
    and matriculated_year =
      flag "year" (required int) ~doc:"the year the student matriculated"
    and host_and_port = address_flag in
    fun () ->
      let new_student = Part2.Student.create ~name ~id ~matriculated_year in
      dispatch_rpc Protocol.Add_student.rpc host_and_port new_student)
;;

let command =
  Command.group
    ~summary:"commands for server queries"
    [ "find", find_students_command
    ; "count", count_students_command
    ; "add", add_student_command
    ]
;;
