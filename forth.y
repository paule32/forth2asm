%{
// --------------------------------------------------------------------------------
// MIT License
//
// Copyright (c) 2019 Jens Kallup
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// --------------------------------------------------------------------------------
#include <stdio.h>
#include <strings.h>
#include <stdlib.h>
#include <sys/types.h>

extern int yyparse();
extern int yylex();

extern int yyerror(const char*);

%}

//-- SYMBOL SEMANTIC VALUES -----------------------------
%token _IDS_
%token _NUMS_
%token _CHARS_
%token _STRINGS_
%token _LOGICALS_ _FALSE_ _TRUE_
%token _INTEGERS_ _ASSIGN_
%token _DOUBLES_
%token _REALS_
%token _COMPLEXS_
%token _DIMENS_
%token _PROGRAMS_ _ENDS_
%token _ROUTINES_
%token _PARAMETERS_
%token _GOTOS_

%start forth_parser

//-- GRAMMAR RULES ---------------------------------------
%%

forth_parser:
    { /* empty */ }
    | program forth_parser
    ;
program
    : _PROGRAMS_ _IDS_ optional_brace_open forth_prolog optional_brace_close forth_program _ENDS_
    | _ROUTINES_ _IDS_ optional_brace_open forth_prolog optional_brace_close forth_program _ENDS_
    ;

optional_brace_open : { /* empty */ } | '(' ;
optional_brace_close: { /* empty */ } | ')' ;

forth_prolog
    : { /* empty */ }
    | forth_program_inparameter
    ;
forth_program_inparameter
    : _IDS_
    | forth_program_inparameter ',' forth_program_inparameter
    ;
forth_program
    : { /* empty */ }
    | _PARAMETERS_  forth_parameters    forth_program
    | _DIMENS_      dimension_decl      forth_program
    | _INTEGERS_    integer_parameters  forth_program
    | _REALS_       real_parameters     forth_program
    | _DOUBLES_     double_parameters   forth_program
    | _COMPLEXS_    complex_parameters  forth_program
    | _LOGICALS_    logic_parameters    forth_program
    | _GOTOS_       handle_goto         forth_program
    | _IDS_         handle_assign1      forth_program
    ;

logic_parameters: id_logic_parameter;
id_logic_parameter
    : _IDS_
    | id_logic_parameter id_logic_assign ',' id_logic_parameter id_logic_assign
    ;
id_logic_assign
    : { /* empty */ }
    | '=' _FALSE_
    | '=' _TRUE_
    ;

integer_parameters : id_parameter ;
real_parameters    : id_parameter ;
double_parameters  : id_parameter ;
complex_parameters : id_parameter ;

dimension_decl
    : _IDS_ '(' id_parameter ')'
    | _IDS_ '(' ')'
    | dimension_decl ',' dimension_decl
    ;

handle_goto
    : _NUMS_
    ;

handle_assign1
    : '='     exp
    | '=' str_exp
    ;
str_exp
    : _STRINGS_
    | str_exp '+' str_exp
    ;

forth_parameters
    : '(' id_parameter ')'
    ;

id_parameter
    : _IDS_
    | id_parameter p_assign ',' id_parameter p_assign
    ;

p_assign
    : { /* empty */ }
    | '=' exp
    | '=' _STRINGS_
    ;

exp
    : _IDS_
    | _NUMS_
    | exp '+' exp
    | exp '-' exp
    | exp '*' exp
    | exp '/' exp
    | exp '%' exp
    | exp '^' exp
    | '(' exp ')'
    | '-' exp
    ;

%%

