(* ============================================================== *)
(* Fortran to Pascal transpiller.                                 *)
(*                                                                *)
(* (c) 2019 by Jens Kallup - non-profit Software                  *)
(* all rights reserved.                                           *)
(* ============================================================== *)
(* ======== PROGRAM ========== *)
program HelloWorld;
(* -------- VARIABLE: int ---- *)
var
sdss,cc,aa: Integer;
(* -------- VARIABLE: real --- *)
var
vv,aa: Real;
(* -------- VARIABLE: double - *)
var
vv,aa: Double;
(* -------- VARIABLE: char --- *)
var
str: String;
(* -------- LABEL's ---------- *)
label
Label10,Label30;
begin
(* -------- CODE ------------- *)
goto Label30;
str := 'sdsdsd';
Label10:
Label30:
end.
