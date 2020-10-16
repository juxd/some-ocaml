open Core
open Async
open Part2

module Find_students = struct
  type query = string [@@deriving bin_io]
  type response = Student.t list [@@deriving bin_io]

  let rpc = Rpc.Rpc.create ~name:"find" ~version:1 ~bin_query ~bin_response
end

module Count_students = struct
  type query = unit [@@deriving bin_io]
  type response = int [@@deriving bin_io]

  let rpc = Rpc.Rpc.create ~name:"count" ~version:1 ~bin_query ~bin_response
end

module Add_student = struct
  type query = Student.t [@@deriving bin_io]
  type response = unit [@@deriving bin_io]

  let rpc = Rpc.Rpc.create ~name:"add" ~version:1 ~bin_query ~bin_response
end
