// --------------------------------------------------------------------------------
// MIT License
//
// Copyright (c) 2018 Jens Kallup
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
#ifndef DATA_T_H
#define DATA_T_H
#pragma once

#ifdef WINDOWS
# define DIR_SEPERATOR "\\\\"    // windows
#else
# define DIR_SEPERATOR "/"       // Linux
#endif

// supported language's ...
#define LOCALES_EN 1    // english: default
#define LOCALES_DE 2    // german

#ifndef LOCALES_LANG
# define LOCALES_LANG LOCALES_EN
#else
# define LOCALES_LANG LOCALES_DE
#endif

extern const char yyerror_str1[LOCALES_LANG][100];
extern const char yyerror_str2[LOCALES_LANG][100];
extern const char yyerror_str3[LOCALES_LANG][100];
extern const char yyerror_str4[LOCALES_LANG][100];

extern int  yyerror(const char*);
extern int  yyparse();
extern int  yylex();

extern void yyset_in (FILE*);
extern void yyset_out(FILE*);
extern void yyset_lineno(int);
extern int  yyget_lineno();

extern std::string banner();

extern void add_prg(std::string);
extern void add_lbl(std::string);
extern void add_cod(std::string);

extern void add_var_bool  (std::string);
extern void add_var_int   (std::string);
extern void add_var_char  (std::string);
extern void add_var_real  (std::string);
extern void add_var_double(std::string);
extern void add_const     (std::string);

extern void add_proc(std::string);
extern void add_func(std::string);

extern void add_cnst(std::string,std::string);
#endif
