open Core

(* Expect tests are a nice way to test your programs in a literate manner. They
   behave like cram tests, and it's a nice way to visually verify and debug when
   your tests go wrong.

   To get them going, you can run this command in command line:

   $ dune build @@runtest

   or in Emacs:

   M-x dune-runtest-and-promote *)

let hello_world = "hello world!"

let%expect_test "hello world" =
  print_endline hello_world;
  [%expect {| hello world! |}]
;;

let introduction_for name = sprintf "my name is %s" name
let _i_am_from country = sprintf "and I am from %s" country
let introduce_to_world _name _country = raise_s [%message "To be implemented"]

let%expect_test "self introduction" =
  print_endline (introduce_to_world "Joel" "Singapore");
  [%expect {| hello world! my name is Joel and I am from Singapore |}]
;;

(* Recursive functions *)

let rec fac x = if x = 0 then 1 else x * fac (x - 1)

let%expect_test "factorials" =
  print_s ([%sexp_of: int] (fac 3));
  [%expect {| 6 |}];
  print_s ([%sexp_of: int] (fac 4));
  [%expect {| 24 |}];
  print_s ([%sexp_of: int] (fac 5));
  [%expect {| 120 |}]
;;

let rec is_odd x = is_even (x - 1)
and is_even x = if x <= 0 then x = 0 else is_odd (x - 1)

let rec adder x n = if n = 0 then x else 1 + adder x (n - 1)

let%expect_test "adder" =
  print_s ([%sexp_of: bool] (is_odd 3));
  [%expect {| true |}];
  print_s ([%sexp_of: bool] (is_even 4));
  [%expect {| true |}];
  print_s ([%sexp_of: int] (adder 0 3));
  [%expect {| 3 |}];
  print_s ([%sexp_of: int] (adder 0 1000000));
  [%expect {| 1000000 |}]
;;

(* Other ways of defining functions in ocaml *)

let divide ~numerator ~denominator = numerator / denominator

let appropriate_intro ~name ?(pronoun = "they") () =
  sprintf "This is %s (%s)" name pronoun
;;

let%expect_test "labelled functions" =
  printf
    "%d = %d\n"
    (divide ~numerator:6 ~denominator:2)
    (divide ~denominator:2 ~numerator:6);
  [%expect {| 3 = 3 |}];
  print_endline (appropriate_intro ~name:"Julius" ());
  [%expect {| This is Julius (they) |}];
  let name = "Vignesh" in
  print_endline (appropriate_intro ~name ~pronoun:"he" ());
  [%expect {| This is Vignesh (he) |}]
;;

let plus (x : float) (y : float) = x +. y

let%expect_test "float adding" =
  print_s ([%sexp_of: float] (plus 3. 2.));
  [%expect {| 5. |}]
;;
