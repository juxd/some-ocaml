open Core

(* When dealing with sequences of information, we typically use lists *)

let some_primes = [2; 3; 5; 7; 11] (* one way of constructing lists *)

let some_names = "Donald" :: "Jeff" :: "John" :: "Julius" :: [] (* another way *)

(* With lists, we can iterate with pattern matching *)

let rec has_even_number ls =
  match ls with
  | x :: tl -> if x % 2 = 0 then true else has_even_number tl
  | [] -> false
;;

(* As this is a common pattern, the [function] keyword is a terser way to create
   match functions *)
let is_empty = function
  | _ :: _ -> false
  | [] -> true
;;

let my_iter _ls ~f:_ =
  if true then raise_s [%message "to be implemented"] else ()
;;

let my_length _ls =
  raise_s [%message "to be implemented"]
;;

let%expect_test "testing our list functions" =
  (* of course, we can define anonymous functions with [fun x -> ...] *)
  my_iter some_names ~f:(fun name -> print_endline (Hello.introduction_for name));
  [%expect{|
    my name is Donald
    my name is Jeff
    my name is John
    my name is Julius
  |}];
  let long_list = List.init 1000000 ~f:(Fn.id) in
  print_s ([%sexp_of: int] (my_length some_primes));
  [%expect {| 5 |}];
  print_s ([%sexp_of: int] (my_length long_list));
  [%expect {| 1000000 |}]
;;

let some_numbers =
  [ (50., 10.)
  ; (30., 15.)
  ; (20., 60.)
  ; (40., 15.)
  ]
;;

let weighted_average ls =
  let weighted_sums =
    List.map ls ~f:(fun (value, weight) -> value *. weight, weight)
  in
  let sum, weights =
    List.fold
      weighted_sums
      ~f:(fun (acc_value, acc_weight) (value, weight) ->
          acc_value +. value, acc_weight +. weight)
      ~init:(0., 0.)
  in
  sum /. weights
;;

let weighted_average' ls =
  ls
  |> List.map ~f:(fun (value, weight) -> value *. weight, weight)
  |> List.fold
    ~f:(fun (acc_value, acc_weight) (value, weight) ->
        acc_value +. value, acc_weight +. weight)
    ~init:(0., 0.)
  |> fun (x, y) -> x /. y
;;

let highest_average_below_threshhold ~threshhold:_ ~names_and_scores:_ =
  raise_s [%message "to be implemented"]
;;

let%expect_test "highest_average_below_threshhold" =
  let donald's_scores = [ 30. ; 40. ; 50. ] in
  let jeff's_scores = [ 27. ; 15.; 22.5 ] in
  let john's_scores = [ 25. ; 26. ] in
  let julius's_scores = [ 0. ; 5. ] in
  print_s
    ([%sexp_of: string option]
       (highest_average_below_threshhold
          ~threshhold:30.
          ~names_and_scores:(
            List.zip_exn
              some_names
              [donald's_scores; jeff's_scores; john's_scores; julius's_scores])));
  [%expect {| (John) |}]
;;
