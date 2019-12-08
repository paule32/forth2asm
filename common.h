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
#ifndef COMMON_H
#define COMMON_H
#pragma once

#include <iostream>     // std::cout
#include <vector>

#include <string>       // std::string
#include <sstream>      // std::stringstream
#include <iomanip>      // std::setw
#include <regex>
#include <cstring>

extern int  yyerror(const char*);
extern int  yylex();

extern void yyset_in (FILE*);
extern void yyset_out(FILE*);
extern void yyset_lineno(int);
extern int  yyget_lineno();

// my own namespace: non-standard !!
namespace ext {
    const int CVT_NONE   = 0;
    const int CVT_ASM    = 2;
    const int CVT_PASCAL = 1;   // default ?

    enum  forth_flags {
        e_forth_unknown = 0,
        e_forth_bool,
        e_forth_char,
        e_forth_real,
        e_forth_double,
        e_forth_integer,
        e_forth_program,
        e_forth_routine,
        e_forth_goto,
        e_forth_end
    };

    struct forth_base {
        forth_base() {}
        forth_base(std::string &data)
            : id_data(data)      { }
        forth_base(const forth_base &o)
            : id_type(o.id_type)
            , id_name(o.id_name)
            , id_data(o.id_data) { }

        int         id_type = e_forth_unknown;
        std::string id_name = std::string("");
        std::string id_data = std::string("");

        std::stringstream id_stream;
    };

    struct forth_vars : forth_base { };

    struct forth_vars_bool   : forth_base { };
    struct forth_vars_char   : forth_base { };
    struct forth_vars_real   : forth_base { };
    struct forth_vars_int    : forth_base { };
    struct forth_vars_double : forth_base { };

    struct forth_proc : forth_base { };
    struct forth_func : forth_base { };

    struct forth_lbls : forth_base {
        forth_lbls() {}
        forth_lbls & operator=(const ext::forth_lbls & o) {
            id_type = o.id_type;
            id_name = o.id_name;
            id_data = o.id_data;
            return *this;
        }
    };
    struct forth_cods : forth_base { };

    struct forth_prgs : forth_base {
        forth_prgs() {}

        std::vector<forth_vars_bool  > vars_bool;
        std::vector<forth_vars_char  > vars_char;
        std::vector<forth_vars_real  > vars_real;
        std::vector<forth_vars_int   > vars_int ;
        std::vector<forth_vars_double> vars_double;

        std::vector<forth_lbls> lbls;
        std::vector<forth_cods> cods;

        std::vector<forth_proc> proc;
        std::vector<forth_func> func;
    };

    std::vector<forth_prgs> forth_pascal;

    FILE * file_pile[2000];

    int         convert_mode = CVT_PASCAL;
    int         current_flag = forth_flags::e_forth_unknown;
    std::string current_var  = "";
    std::string current_prg  = "";
    
    int yyget_line_gap = 0;
    int yymet_line_gap = 0;

    // keep it here, because yylex will double it !
    extern size_t strlen(const char * _str);

    extern ::std::string yypadding(::std::string c);
    extern ::std::string string2upper(::std::string s);
    extern ::std::string string2lower(::std::string s);

    extern ::std::vector<::std::string> split(const ::std::string& s, char delimiter);

    extern void removeCharsFromString(::std::string &str, char* charsToRemove);
    extern void replaceStr(::std::string &data, ::std::string toSearch, ::std::string replaceStr);
}

#endif
