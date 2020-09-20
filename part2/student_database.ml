open Core

module StudentName = Comparable.Make(String)

type t = (Student.t list) StudentName.Map.t

let empty : t = StudentName.Map.empty

let insert t ~name ~student =
  Map.add_multi t ~key:name ~data:student
;;

let find _t ~name:_ =
  raise_s [%message "to be implemented"]
;;

let average_years_matriculated _t =
  raise_s [%message "to be implemented"]
;;

let%expect_test _ =
  let students =
    [ ("John", "A12345", 2017)
    ; ("Adam", "A34567", 2017)
    ; ("Jack", "E12345", 2018)
    ; ("John", "E12456", 2018)
    ; ("Anna", "E01923", 2019)]
    |> List.map ~f:(fun (name, id, matriculated_year) ->
        Student.create ~name ~id ~matriculated_year)
  in
  let db =
    List.fold students ~init:empty ~f:(fun db student ->
        insert db ~name:(Student.name student) ~student:student)
  in
  let johns = find db ~name:"John" in
  print_s ([%sexp_of : Student.t list] johns);
  [%expect{|
    (((name John) (id E12456) (matriculated_year 2018))
     ((name John) (id A12345) (matriculated_year 2017))) |}];
  let average_matric = average_years_matriculated db in
  print_s [%message (average_matric : int)];
  [%expect{| (average_matric 2) |}]
;;
