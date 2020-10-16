open! Core
open Async

let () =
  Command.run
    (Command.group
       ~summary:"student database client-server app"
       [ "server", Server.command; "client", Client.command ])
;;
