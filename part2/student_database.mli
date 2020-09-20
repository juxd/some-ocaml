type t

val empty : t
val insert : t -> name:string -> student:Student.t -> t
val find : t -> name:string -> Student.t list
val average_years_matriculated : t -> int
