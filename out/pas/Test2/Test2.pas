(* ============================================================== *)
(* Fortran to Pascal transpiller.                                 *)
(*                                                                *)
(* (c) 2019 by Jens Kallup - non-profit Software                  *)
(* all rights reserved.                                           *)
(* ============================================================== *)
(* ======== PROGRAM ========== *)
program Test2;
(* -------- VARIABLE: int ---- *)
var
a,b,c,c,cc: Integer;
(* -------- LABEL's ---------- *)
label
Label10,Label20,Label30;
begin
(* -------- CODE ------------- *)
a := 42;
b := 21;
c := a;
goto Label10;
Label10:
goto Label20;
Label20:
goto Label30;
Label30:
end.
