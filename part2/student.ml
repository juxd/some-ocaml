open Core

module Student_id = struct
  include String

  include Identifiable.Make (struct
    include String

    let module_name = "Student_id"
  end)
end

type t =
  { name : string
  ; id : Student_id.t
  ; matriculated_year : int
  }
[@@deriving bin_io, fields, sexp]

let create ~name ~id ~matriculated_year : t =
  { name; id = Student_id.of_string id; matriculated_year }
;;

let years_since_matriculated t = 2020 - matriculated_year t
