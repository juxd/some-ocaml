open Core

type t [@@deriving sexp_of]

module Student_id : Identifiable.S

val create : name:string -> id:string -> matriculated_year:int -> t
val name : t -> string
val id : t -> Student_id.t
val years_since_matriculated : t -> int
