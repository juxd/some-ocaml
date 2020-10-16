open! Core
open Async
open Part2

module Find_students : sig
  val rpc : (string, Student.t list) Rpc.Rpc.t
end

module Count_students : sig
  val rpc : (unit, int) Rpc.Rpc.t
end

module Add_student : sig
  val rpc : (Student.t, unit) Rpc.Rpc.t
end
