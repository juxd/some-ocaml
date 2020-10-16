open! Core
open Async

module State = struct
  type t = { mutable database : Part2.Database.t } [@@deriving fields]

  let create = Fields.create
end

let find_students_implementation ~server_state =
  Rpc.Rpc.implement Protocol.Find_students.rpc (fun () name ->
      Deferred.return (Part2.Database.find server_state.State.database ~name))
;;

let count_students_implementation ~server_state =
  Rpc.Rpc.implement Protocol.Count_students.rpc (fun () () ->
      Deferred.return (Part2.Database.count server_state.State.database))
;;

let add_student_implementation ~server_state =
  Rpc.Rpc.implement Protocol.Add_student.rpc (fun () student ->
      Deferred.return
        (server_state.State.database
          <- Part2.Database.insert server_state.State.database ~student))
;;

let make_implementations ~server_state =
  let implementations =
    List.map
      ~f:(fun impl -> impl ~server_state)
      [ find_students_implementation
      ; count_students_implementation
      ; add_student_implementation
      ]
  in
  Rpc.Implementations.create_exn ~implementations ~on_unknown_rpc:`Close_connection
;;

let serve_rpc ~server_state ~address ~port =
  let implementations = make_implementations ~server_state in
  let where_to_listen = Tcp.Where_to_listen.bind_to address port in
  let%bind.Deferred server =
    Rpc.Connection.serve
      ~implementations
      ~initial_connection_state:(fun _ _ -> ())
      ~where_to_listen
      ()
  in
  let host_and_port =
    Socket.Address.Inet.to_host_and_port (Tcp.Server.listening_on_address server)
  in
  printf !"server running on %{sexp:Host_and_port.t}\n" host_and_port;
  let%map.Deferred () = Tcp.Server.close_finished server in
  print_endline "server stopped running"
;;

let start_command =
  Command.async_or_error
    ~summary:"start the server"
    (let%map_open.Command sexp_path =
       flag "path" (required string) ~doc:"FILEPATH where database is stored"
     in
     fun () ->
       let open Deferred.Or_error.Let_syntax in
       let%bind database = Reader.load_sexp sexp_path Part2.Database.t_of_sexp in
       let server_state = State.create ~database in
       Deferred.ok
         (serve_rpc
            ~server_state
            ~address:Tcp.Bind_to_address.Localhost
            ~port:Tcp.Bind_to_port.On_port_chosen_by_os))
;;

let command = Command.group ~summary:"manage the server" [ "start", start_command ]
