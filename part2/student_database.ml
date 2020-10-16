open Core
module StudentName = Comparable.Make (String)

type t = Student.t list StudentName.Map.t [@@deriving sexp]

let empty = StudentName.Map.empty
let count t = Map.fold t ~init:0 ~f:(fun ~key:_ ~data acc -> acc + List.length data)
let insert t ~student = Map.add_multi t ~key:(Student.name student) ~data:student
let find _t ~name:_ = raise_s [%message "to be implemented"]
let average_years_matriculated _t = raise_s [%message "to be implemented"]
let oldest_students _t ~n:_ = raise_s [%message "to be implemented"]

let%expect_test _ =
  let students =
    [ "John", "A12345", 2017
    ; "Adam", "A34567", 2018
    ; "Jack", "E12345", 2018
    ; "John", "E12456", 2017
    ; "Anna", "E01923", 2019
    ; "Wein", "A56789", 2017
    ]
    |> List.map ~f:(fun (name, id, matriculated_year) ->
           Student.create ~name ~id ~matriculated_year)
  in
  let db = List.fold students ~init:empty ~f:(fun db student -> insert db ~student) in
  let johns = find db ~name:"John" in
  print_s ([%sexp_of: Student.t list] johns);
  [%expect
    {|
    (((name John) (id E12456) (matriculated_year 2018))
     ((name John) (id A12345) (matriculated_year 2017))) |}];
  let average_matric = average_years_matriculated db in
  print_s [%message (average_matric : int)];
  [%expect {| (average_matric 2) |}];
  let three_oldest_students = oldest_students db ~n:3 in
  print_s ([%sexp_of: Student.t list] three_oldest_students);
  [%expect
    {|
    (((name John) (id E12456) (matriculated_year 2017))
     ((name John) (id A12345) (matriculated_year 2017))
     ((name Wein) (id A56789) (matriculated_year 2017))) |}]
;;
