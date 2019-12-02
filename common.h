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

#include "identity.h"
#include "misc.h"

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

    enum forth_flags {
        FLAG_NULL = 0,      // empty
        FLAG_SUBROUTINE,    // subroutine
        FLAG_PARAMETER,     // parameter
        FLAG_PROGRAM,       // program
        FLAG_VARIABLE       // variable
    };

    std::vector<forth_data_t> forth_current_data;

    int convert_mode = CVT_PASCAL;
    int current_flag = ForthFlags::FLAG_NULL;
    
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
