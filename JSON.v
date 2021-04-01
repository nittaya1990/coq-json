From ExtLib Require Export
     Monad
     OptionMonad.
From Coq Require Export
     Basics
     List
     String
     ZArith.
Export
  MonadNotation
  IfNotations.
Open Scope monad_scope.
Open Scope program_scope.

Inductive json :=
  JSON__Object : list (string * json) -> json
| JSON__Array  : list json            -> json
| JSON__String : string               -> json
| JSON__Number : Z                    -> json
| JSON__True
| JSON__False
| JSON__Null.

Definition get_json (k : string) (j : json) : json :=
  if j is JSON__Object l
  then if find (eqb k ∘ fst) l is Some (_, v)
       then v
       else JSON__Null
  else JSON__Null.

Definition get_Z (k : string) (j : json) : option Z :=
  if get_json k j is JSON__Number z then Some z else None.

Definition get_N (k : string) (j : json) : option N :=
  z <- get_Z k j;;
  if z is Zneg _
  then None
  else Some (Z.to_N z).

Definition get_string (k : string) (j : json) : option string :=
  if get_json k j is JSON__String str then Some str else None.

Definition get_bool (k : string) (j : json) : option bool :=
  match get_json k j with
  | JSON__True  => Some true
  | JSON__False => Some false
  | _         => None
  end.
